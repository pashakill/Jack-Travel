// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travelappui/utils/platform_helper.dart';
import 'dio_adapter_skeleton.dart';

class DioAdapter extends DioAdapterSkeleton {
  final Map<String, String>? headers;
  static const String cookieStorage = 'cookieHeader';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  DioAdapter({this.headers});

  @override
  Future<Dio> dio() async {
    headers!['Accept-Encoding'] = 'application/json';
    String? cookie = await _getCookie();
    if (cookie != null) {
      headers!['Cookie'] = cookie;
    }
    headers!['Language'] = await getUserLanguage();

    Map<String, dynamic>? deviceInfo;
    deviceInfo = await PlatformHelper().deviceInfo();
    headers!['User-Agent'] = '${deviceInfo["userAgent"]}||${deviceInfo["deviceId"]} '
        '${deviceInfo["clientName"]}';
    headers!['Channel'] = Platform.isAndroid
        ? "android"
        : Platform.isIOS
            ? "ios"
            : "web";

    int connectionTimeout =  int.tryParse(dotenv.env['httpconnectiontimeoutms'] ?? '30000') ?? 30000 ;
    int receiveTimeout =  int.tryParse(dotenv.env['httpreceivetimeoutms'] ?? '30000') ?? 30000 ;

    BaseOptions options = BaseOptions(
        connectTimeout: Duration(milliseconds: connectionTimeout),
        receiveTimeout: Duration(milliseconds: receiveTimeout),
        headers: headers);

    // var _dio = Dio(options);
    // _dio.interceptors.add(
    //     RetryInterceptor(dio: _dio, logPrint: print, retries: 3, retryDelays: [
    //   const Duration(seconds: 1),
    //   const Duration(seconds: 1),
    //   const Duration(seconds: 1),
    // ]));
    return Dio(options);
  }

  @override
  void setCookie(String? cookie) {
    if (cookie == null) {
      return;
    }
    String? parsedCookie = _parseCookie(cookie);
    if (parsedCookie != null) {
      storage
          .write(key: cookieStorage, value: parsedCookie)
          .onError((error, stackTrace) {
        if (kDebugMode) {
          print('_setCookie onError = $error');
        }
      });
    }
  }

  static String? _parseCookie(String? plainCookie) {
    if (plainCookie != null && plainCookie.contains('TANAMDUITSESSIONID')) {
      List<String> arrCookie = plainCookie.split(',');
      for (String item in arrCookie) {
        Cookie c = Cookie.fromSetCookieValue(item);
        if (c.name.contains('TANAMDUITSESSIONID')) {
          return '${c.name}=${c.value}';
        }
      }
    }
    return null;
  }

  Future<String?> _getCookie() async {
    String? retValue;
    await storage.read(key: cookieStorage).then((value) {
      retValue = value;
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print('_getCookie onError = $error');
      }
    });

    return retValue;
  }

  // Future<String> getUserLanguage() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? language;
  //   try {
  //     language = pref.getString('languageUser');
  //   } catch (e) {
  //     // return 'id';
  //   }
  //   return language ?? 'id';
  // }
}
