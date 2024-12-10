import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repo/auth_repo.dart';

class UserPreference {
  static const userOnboardingDisplayStatus = 'userOnboardingDisplayStatus';
  static const prepareLoginData = '7dcc9a903b1de40358e16e992bb94997';
  static const userData = '56491f2e1c74898e18bb6e47d2425b19';
  static const displayBalanceStatus = 'displayBalanceStatus';
  static const userLanguage = 'userLanguage';
  static const qrisAsDefaultPayment = 'qrisAsDefaultPayment';
  static const qrisTutorialOpened = 'qrisTutorialOpened';

  static const String userBiometricKey = 'fd8455a542555d9a2a9034f76202a2b2';

  static Future<bool> getUserOnboardingDisplayStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserPreference.userOnboardingDisplayStatus) ?? false;
  }

  static Future<void> saveUserOnboardingDisplayStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserPreference.userOnboardingDisplayStatus, true);
  }

  static Future<bool> removeUserOnboardingDisplayStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool(UserPreference.userOnboardingDisplayStatus, false);
  }

  static Future<bool> getDisplayBalanceStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserPreference.displayBalanceStatus) ?? true;
  }

  static Future<void> saveDisplayBalanceStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserPreference.displayBalanceStatus, status);
  }

  static Future<PrepareLoginModel> getPrepareLoginData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    try {
      var data = await storage.read(key: UserPreference.prepareLoginData);
      if (data != null) {
        var decodedData = jsonDecode(data);
        return PrepareLoginModel.fromJson(decodedData);
      }
    } on Exception catch (e) {
      print('error');
    }
    return PrepareLoginModel();
  }

  static Future<void> savePrepareLoginData(
      PrepareLoginModel data) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    var encodedData = jsonEncode(data);
    await storage.write(
        key: UserPreference.prepareLoginData, value: encodedData);
  }

  static Future<void> removePrepareLoginData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: UserPreference.prepareLoginData);
  }

  static Future<UserModel> getUserData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    try {
      var data = await storage.read(key: UserPreference.userData);
      if (data != null) {
        var decodedData = jsonDecode(data);
        return UserModel.fromJson(decodedData);
      }
    } on Exception catch (e) {
      storage.delete(key: UserPreference.userData);
    }
    return UserModel();
  }

  static Future<void> saveUserData(UserModel data) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    var encodedData = jsonEncode(data);
    await storage.write(key: UserPreference.userData, value: encodedData);
  }

  static Future<void> removeUserData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: UserPreference.userData);
  }

  static Future<String> getUserLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(UserPreference.userLanguage) ?? 'id';
  }

  static Future<void> saveUserLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(UserPreference.userLanguage, language);
  }

  static Future<bool> removeUserLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(UserPreference.userLanguage, '');
  }

  static Future<String?> getUserBiometricCredential() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    try {
      return await storage.read(key: UserPreference.userBiometricKey);
    } on Exception catch (e) {
      return null;
    }
  }

  static Future<void> saveUserBiometricCredential(String plainPIN) async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.write(key: UserPreference.userBiometricKey, value: plainPIN);
  }

  static Future<bool> hasUserBiometricCredential() async {
    var cred = await getUserBiometricCredential();
    return cred != null;
  }

  static Future<void> removeUserBiometricCredential() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.delete(key: UserPreference.userBiometricKey);
  }

  static Future<bool> getQrisAsDefaultPayment() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserPreference.qrisAsDefaultPayment) ?? false;
  }

  static Future<void> setQrisAsDefaultPayment(bool state) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserPreference.qrisAsDefaultPayment, state);
  }

  static Future<bool> getQrisTutorialOpened() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(UserPreference.qrisTutorialOpened) ?? false;
  }

  static Future<void> setQrisTutorialOpened() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(UserPreference.qrisTutorialOpened, true);
  }

}
