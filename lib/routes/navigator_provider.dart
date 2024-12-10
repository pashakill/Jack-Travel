import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart';
import 'package:travelappui/utils/network_helper.dart';

class NavigatorProvider extends ChangeNotifier {
  Map<String, dynamic>? _navigatorParams;
  Future<void> Function(BuildContext, Exception?,
      {String? title,
      String? description,
      VoidCallback? onClose})? _genericErrorMessageCallback;
  bool _allowNavigateToHomePage = false;

  String? _navigateToPageName;

  /* 
    Prepare page navigation at first route from its child
    Set pageName and pageParams
   */
  void prepareRootNavigate({required String pageName, dynamic pageParams}) {
    _navigateToPageName = pageName;
    setPageParam(pageName, pageParams);
    notifyListeners();
  }

  /*
    Perform page navigator at first route
    it will route the the page if the _navigateToPageName is available
    it will do nothing if the _navigateToPageName is empty / null
  */
  void performRootNavigate(BuildContext context) async {
    if (_navigateToPageName == null) {
      return;
    }

    var pageParams =
        getPageParam(_navigateToPageName!, removeParam: false);
    // await Future.delayed(const Duration(milliseconds: 2000));
    navigateToPage(context,
        isRouteReplace: true,
        pageName: _navigateToPageName!,
        pageParams: pageParams);
    _navigateToPageName = null;
    notifyListeners();
  }

  Future<void> Function(BuildContext,
      {bool isRouteReplace,
      required String pageName,
      dynamic pageParams})? _rootPageNavigatorCallback;

  set setRootPageNavigatorCallback(
      Future<void> Function(BuildContext,
              {bool? isRouteReplace,
              required String pageName,
              dynamic pageParams})
          cb) {
    _rootPageNavigatorCallback = cb;
  }

  get rootPageNavigator {
    return _rootPageNavigatorCallback;
  }

  Future<dynamic> navigateToPage(BuildContext context,
      {bool isRouteReplace = false,
      required String pageName,
      dynamic pageParams}) async {
    if (kDebugMode) {
      print('navigateToPage: $pageName, $isRouteReplace');
    }
    if (pageParams != null) {
      setPageParam(pageName, pageParams);
    }

    final activePage = context.router.current.path;
    if (activePage == pageName) {
      return;
    }

    if (isRouteReplace) {
      return context.router.replaceNamed(pageName);
    } else {
      return context.router.pushNamed(pageName);
    }
  }

  void setPageParam(String pageName, dynamic pageParams) {
    _navigatorParams = {pageName: pageParams};
  }

  dynamic getPageParam(String pageName, {bool removeParam = true}) {
    var result = _navigatorParams == null ? null : _navigatorParams![pageName];

    if (_navigatorParams != null && removeParam) {
      _navigatorParams?.remove(pageName);
    }
    return result;
  }

  set genericErrorMessageCallback(
      Future<void> Function(BuildContext, Exception?,
              {String? title, String? description, VoidCallback? onClose})
          callback) {
    _genericErrorMessageCallback = callback;
  }

  void goToHomePage(BuildContext context) {
    if (_allowNavigateToHomePage) {
      _allowNavigateToHomePage = false;
      AutoRouter.of(context);
      context.router.replaceNamed(PagePathCollections.homePage);
    }
  }

  @Deprecated('User showErrorMessage instead')
  void showGenericErrorMessage(
      BuildContext context, NavigationCallbackEnum callbackType,
      {dynamic customData}) {
    switch (callbackType) {
      case NavigationCallbackEnum.genericError:
        if (_genericErrorMessageCallback == null) {
          break;
        }
        _genericErrorMessageCallback!(context, customData);
        break;
      default:
    }
  }

  Future<void> showErrorMessage(
    BuildContext context, {
    String? title,
    String? description,
    dynamic customData,
    VoidCallback? onClose
  }) async {
    if (_genericErrorMessageCallback == null) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 100));
    await _genericErrorMessageCallback!(context, customData,
        title: title, description: description, onClose: onClose);
  }
}

mixin NavigatiorProviderMixin {
  void networkHandlerMixin(BuildContext context, {VoidCallback? onRefreshed, required String Function(String) translator}) {
    // define no network hanlder
    GetIt.I<NetworkHelper>().setNoNetworkCallback = () async {
      if (kDebugMode) {
        print('no network hanlder');
      }
      AutoRouter.of(context);
      // show no network page
      // await context.router.pushNamed(PagePathCollections.pinPage);
      // Provider.of<fello_widget.LoadingScreenProvider>(context, listen: false)
      //     .show(translator: translator);
      // if (onRefreshed != null) {
      //   onRefreshed();
      // }
    };

    // network timeout hanlder
    GetIt.I<NetworkHelper>().setNetworkTimeOutCallback = () async {
      if (kDebugMode) {
        print('network timeout hanlder');
      }
      AutoRouter.of(context);
      // show network timeout page
      // await context.router.pushNamed(PagePathCollections.pinPage);
      // if (onRefreshed != null) {
      //   onRefreshed();
      // }
    };
  }
}

enum NavigationCallbackEnum {
  // noNetwork,
  // connectionTimeout,
  homePage,
  loginPage,
  genericError
}

class PagePathCollections {
  static const initialPage = '/';
  static const homePage = '/home';
  static const userOnboarding = '/onboarding';
  static const details = '$homePage/view';

  // user service pages
  static const authPage = '/auth';
  static const loginPage = '$authPage/login';
}
