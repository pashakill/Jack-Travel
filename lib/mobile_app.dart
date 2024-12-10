import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:travelappui/components/package_localization_helper.dart';
import 'package:travelappui/exceptions/custom_exception.dart';
import 'package:travelappui/provider/auth_provider.dart';
import 'package:travelappui/routes/navigator_provider.dart';
import 'package:travelappui/utils/themes.dart';
import 'components/color_collections.dart';
import 'components/font_size.dart';
import 'routes/app_router.dart' as app_router;
import 'utils/app_localization_helper.dart';


class MobileApp extends StatefulWidget {
  const MobileApp({super.key, required this.appLanguage});
  final AppLanguage appLanguage;

  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> with WidgetsBindingObserver {
  Locale _selectedLocale = const Locale('id');
  // ConnectivityResult connectionStatus = ConnectivityResult.none;
  // final Connectivity _connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> connectivitySubscription;

  void switchLanguage() async {
    String? lang; // = await common_user_view.UserPreference.getUserLanguage();
    if (lang == null) {
      setState(() {
        if (mounted) {
          _selectedLocale = const Locale('id');
        }
      });
    } else {
      setState(() {
        if (mounted) {
          _selectedLocale = Locale(lang, '');
        }
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Intl.defaultLocale = _selectedLocale.languageCode;
    });
    // initConnectivity();
    // connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void dispose() {
    // connectivitySubscription.cancel();
    super.dispose();
  }

  void prepareCallback(BuildContext context) {
    // set generic error message callback
    Provider.of<NavigatorProvider>(context, listen: false)
            .genericErrorMessageCallback =
        (context, data,
            {String? title, String? description, VoidCallback? onClose}) async {
      String? title;
      String? description;

      if (data is CustomException) {
        title = data.backendMessage;
        description = data.backendDescription;
      } else {
        title = title;
        description = description;
      }


    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (__) => widget.appLanguage,
                  lazy: false,
                ),
                ChangeNotifierProvider(
                    create: (__) => NavigatorProvider(),
                    lazy: false),
                ChangeNotifierProvider(
                    create: (__) => AuthProvider()
                ),

              ],
              child: Consumer<AppLanguage>(
                  builder: (context, model, child) {
                    prepareCallback(context);

                    return MaterialApp.router(
                      title: 'Jack Travel',
                      darkTheme: darkThemeData,
                      theme: lightThemeData,
                      themeMode: EasyDynamicTheme.of(context).themeMode,
                      debugShowCheckedModeBanner: false,
                      debugShowMaterialGrid: false,
                      routerDelegate: GetIt.I<app_router.AppRouter>().delegate(),
                      routeInformationParser:
                      GetIt.I<app_router.AppRouter>().defaultRouteParser(),
                      locale: _selectedLocale,
                      supportedLocales: const [
                        // Locale('en'),
                        Locale('id'),
                      ],
                      localizationsDelegates: const [
                        PackageLocalizations.delegate,
                        FormBuilderLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                      ],
                      builder: (context, child) {
                        return Scaffold(
                            body: SafeArea(
                              child: child!
                            )
                        );
                      },
                    );
                  }),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }


}
