import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart' as crypto;

class PlatformHelper {
  // ignore: constant_identifier_names
  static const String STORAGE_DEVICEID = 'd-e-v-i-c-e-i-d-s-t-o-r-a-g-e';

  Future<String> deviceOS() async {
    var deviceInfo = await PlatformHelper().deviceInfo();
    return deviceInfo['deviceType'] ?? 'android';
  }

  Future<Map<String, dynamic>> deviceInfo() async {
    var deviceData = <String, dynamic>{};
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (kIsWeb) {
        deviceData =
            await _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
      } else {
        if (Platform.isAndroid) {
          deviceData =
              await _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          deviceData = await _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else {
          print('Unsupport Device');
        }
      }
    } catch (pe) {
      deviceData = <String, dynamic>{
        'Platform Error:': 'Failed to get platform version $pe.'
      };
    }

    return deviceData;
  }

  Future<Map<String, dynamic>> _readAndroidBuildData(
      AndroidDeviceInfo build) async {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      // 'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
      'deviceId': build.id,
      'deviceType': 'android',
      'clientName': '(FelloAndroid)'
    };
  }

  Future<Map<String, dynamic>> _readIosDeviceInfo(IosDeviceInfo data) async {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
      'deviceId': data.identifierForVendor,
      'deviceType': 'ios',
      'clientName': '(FelloiOS)'
    };
  }

  Future<Map<String, dynamic>> _readWebBrowserInfo(WebBrowserInfo data) async {
    String deviceType = 'unknown';
    if (data.userAgent.toString().toLowerCase().contains('android')) {
      deviceType = 'android';
    } else if (data.userAgent.toString().toLowerCase().contains('iphone')) {
      deviceType = 'ios';
    }

    return <String, dynamic>{
      'browserName': data.browserName.name,
      'appCodeName': data.appCodeName,
      'appName': data.appName,
      'appVersion': data.appVersion,
      'deviceMemory': data.deviceMemory,
      'language': data.language,
      'languages': data.languages,
      'platform': data.platform,
      'product': data.product,
      'productSub': data.productSub,
      'userAgent': data.userAgent,
      'vendor': data.vendor,
      'vendorSub': data.vendorSub,
      'hardwareConcurrency': data.hardwareConcurrency,
      'maxTouchPoints': data.maxTouchPoints,
      'deviceId': await _deviceId(),
      'deviceType': deviceType,
      'clientName': 'FelloUnknown'
    };
  }

  void _setDeviceId(String? id) {
    if (kIsWeb) {
      return;
    }
    late FlutterSecureStorage storage;
    if (Platform.isAndroid) {
      storage = const FlutterSecureStorage(
          // aOptions: AndroidOptions(encryptedSharedPreferences: true),
          // iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
          );
    } else if (Platform.isIOS) {
      storage = const FlutterSecureStorage(
          // aOptions: AndroidOptions(encryptedSharedPreferences: true),
          // iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
          );
    }
    storage
        .write(key: STORAGE_DEVICEID, value: id)
        .onError((error, stackTrace) {
      if (kDebugMode) {
        print('_setDeviceId onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        print('_setDeviceId Completed');
      }
    });
  }

  Future<String?> _getDeviceId() async {
    String? retValue;
    FlutterSecureStorage storage = const FlutterSecureStorage(
        // aOptions: AndroidOptions(encryptedSharedPreferences: true),
        // iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
        );
    await storage.read(key: STORAGE_DEVICEID).then((value) {
      if (kDebugMode) {
        // print('_getDeviceId value = $value');
      }
      retValue = value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        // print('_getDeviceId onError = $error');
      }
    }).whenComplete(() {
      if (kDebugMode) {
        // print('_getDeviceId Completed');
      }
    });

    return retValue;
  }

  Future<String?> _deviceId() async {
    String? retValue;

    retValue = await _getDeviceId();
    if (retValue == null) {
      if (kIsWeb) {
        Random random = Random();
        DateTime date = DateTime.now();
        var key = utf8.encode(random.nextInt(99999).toRadixString(16));
        var bytes = utf8.encode(date.toIso8601String());
        var hmacSha256 = crypto.Hmac(crypto.sha256, key); // HMAC-SHA256
        var digest = hmacSha256.convert(bytes);
        retValue = digest.toString();
      } else {
        Map<String, dynamic> info = await PlatformHelper().deviceInfo();
        retValue = info['deviceId'];
        _setDeviceId(retValue);
      }
    }

    return retValue;
  }
}
