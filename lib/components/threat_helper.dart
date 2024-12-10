import 'package:freerasp/freerasp.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:travelappui/utils/security_helper.dart';

class ThreatHelper {

  Function? threatCallback;
  final bool isProd = kReleaseMode;
  String d9f1f9b8ad7a5a25a951de6af79f1ef9 = '';
  String eab21a911ccb4a0f0e0faeae5efe60da = '';
  String e14b1967d882dabf76b92e5cdbbccf65e = '';

  set setThreatCallback(Function cb) {
    threatCallback = cb;
  }

  void init() async {
    d9f1f9b8ad7a5a25a951de6af79f1ef9 = SecurityHelper.openString(
        const String.fromEnvironment('bfca3867679c692bb81b4b8886982baf'));
    eab21a911ccb4a0f0e0faeae5efe60da = SecurityHelper.openString(
        const String.fromEnvironment('5d45824f923d206c5301c6b865e105fc'));
    e14b1967d882dabf76b92e5cdbbccf65e = SecurityHelper.openString(
        const String.fromEnvironment('14b1967d882dabf76b92e5cdbbccf65e'));

    final config = TalsecConfig(
      androidConfig: AndroidConfig(
        packageName:'com.mup.mobile',
        signingCertHashes:[d9f1f9b8ad7a5a25a951de6af79f1ef9],
      ),
      iosConfig: IOSConfig(
        bundleIds:['id.co.jatelindo.ios.fello'],
        teamId: eab21a911ccb4a0f0e0faeae5efe60da,
      ),
      watcherMail: e14b1967d882dabf76b92e5cdbbccf65e,
      // ignore: avoid_redundant_argument_values
      isProd: isProd, // use kReleaseMode for automatic switch
    );
    final callback = ThreatCallback(
        onAppIntegrity: () {
          print('======== onAppIntegrity =======');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onObfuscationIssues: () {
          print('======== onObfuscationIssues ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onDebug: () {
          print('======== onDebug ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onDeviceBinding: () {
          print('======== onDeviceBinding ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onDeviceID: () {
          print('======== onDeviceID ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onHooks: () {
          print('======== onHooks ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onPasscode: () {
          print('======== onPasscode ========');
          if (threatCallback != null) {
            //threatCallback!();
          }
        },
        onPrivilegedAccess: () {
          print('======== onPrivilegedAccess ========');
          if (threatCallback != null) {
            threatCallback!();
          }
        },
        onSecureHardwareNotAvailable: () {
          print('======== onSecureHardwareNotAvailable ========');
          if (threatCallback != null) {
            //threatCallback!();
          }
        },
        onSimulator: () {
          print('======== onSimulator ========');
          if (threatCallback != null) {
            //threatCallback!();
          }
        },
        onUnofficialStore: () {
          print('======== onUnofficialStore ========');
          if (threatCallback != null) {
            //threatCallback!();
          }
        },
    );
    Talsec.instance.attachListener(callback);
    await Talsec.instance.start(config);
  }

}