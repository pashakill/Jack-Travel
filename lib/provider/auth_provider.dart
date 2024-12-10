import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:travelappui/components/user_preference.dart';
import 'package:travelappui/repo/login/prepare_login_model.dart';
import 'package:travelappui/routes/navigator_provider.dart';
import 'package:travelappui/utils/network_helper.dart';

import '../repo/auth_repo.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _userData;
  PrepareLoginModel? _prepareLoginData;

  set setUserData(UserModel userModel) {
    _userData = userModel;
    UserPreference.saveUserData(userModel);
  }

  bool get isAutoLogout {
    if (_userData == null || _userData!.autoLogoutAt == null) {
      return true;
    }
    var now = DateTime.now();
    var logoutAt =
        DateTime.fromMillisecondsSinceEpoch(_userData!.autoLogoutAt!);
    return now.isAfter(logoutAt);
  }

  // void sessionExpiredNavigator(BuildContext context) {
  //   removeUserData();
  //   context.router
  //       .replaceNamed(fello_widget.PagePathCollections.userOnboarding);
  // }

  Future<UserModel> get getUserData async {
    _userData ??= await UserPreference.getUserData();
    // _userData = await UserPreference.getUserData();
    return _userData!;
  }

  UserModel? get getUserDataFromMemory {
    // _userData ??= await UserPreference.getUserData();
    return _userData!;
  }

  void removeUserData() {
    _userData = null;
    UserPreference.removeUserData();
    // UserPreference.removeUserBiometricCredential();
  }

  set setLoginDataTemporary(PrepareLoginModel prepareLoginData) {
    _prepareLoginData = prepareLoginData;
  }

  set setLoginData(PrepareLoginModel prepareLoginData) {
    // _prepareLoginData = prepareLoginData;
    // remove password before save to secure storage
    _prepareLoginData = PrepareLoginModel(
        fcmId: prepareLoginData.fcmId, userName: prepareLoginData.userName);
    UserPreference.savePrepareLoginData(_prepareLoginData!);
  }

  Future<PrepareLoginModel> get getLoginData async {
    _prepareLoginData ??= await UserPreference.getPrepareLoginData();
    return _prepareLoginData!;
  }

  void removeLoginData() {
    _prepareLoginData = null;
    UserPreference.removePrepareLoginData();
  }
}

mixin AuthProviderMixin {
  void userSessionExpireHandlerMixin(BuildContext context) {
    // define session expired handler
    GetIt.I<NetworkHelper>().setSessionExpiredCallback = () async {
      if (kDebugMode) {
        print('session expired  handler');
      }
      AutoRouter.of(context);
      goToOnboarding(context);
    };
  }

  void goToOnboarding(BuildContext context) {
    // remove user data when expired
    Provider.of<AuthProvider>(context, listen: false).removeUserData();

    // route to user onboarding if session is expired
    Provider.of<NavigatorProvider>(context, listen: false)
        .navigateToPage(context,
            isRouteReplace: true,
            pageName: PagePathCollections.userOnboarding);
  }

  Future<UserModel?> getUserDataMixin(BuildContext context) async {
    var userData =
        await Provider.of<AuthProvider>(context, listen: false).getUserData;

    // // define session expired handler
    // GetIt.I<fello_helper.NetworkHelper>().setSessionExpiredCallback = () async {
    //   if (kDebugMode) {
    //     print('session expired  handler');
    //   }
    //   AutoRouter.of(context);

    //   // remove user data when expired
    //   Provider.of<AuthProvider>(context,
    //           listen: false)
    //       .removeUserData();

    //   // route to user onboarding if session is expired
    //   await context.router.replaceNamed(fello_widget.PagePathCollections.userOnboarding);
    // };

    if (userData.token == null) {
      Provider.of<AuthProvider>(context, listen: false).removeUserData();
      // route to user onboarding if session is expired
      await context.router
          .replaceNamed(PagePathCollections.userOnboarding);
      return null;
    }
    return userData;
  }
}
