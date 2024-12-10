import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travelappui/mobile_app.dart';
import 'package:travelappui/utils/app_localization_helper.dart';
import 'package:travelappui/utils/network_helper.dart';
import 'routes/app_router.dart' as app_router;
import 'package:url_strategy/url_strategy.dart' as url_strategy;

bool isFlutterLocalNotificationsInitialized = false;
const fatalError = true;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  url_strategy.setPathUrlStrategy();
  String appFile = 'assets/.app.env';
  if (kDebugMode && kIsWeb) {
    appFile = '.app.env';
  }
  await dotenv.load(fileName: appFile);
  String environment = 'prod';
  String environmentFile = 'assets/.$environment.env';
  if (kDebugMode && kIsWeb) {
    environmentFile = '.$environment.env';
  }

  final appEnv = dotenv.env;

  await dotenv.load(fileName: environmentFile, mergeWith: {
    'environment': environment,
    'httpconnectiontimeoutms': appEnv['httpconnectiontimeoutms']!,
    'httpreceivetimeoutms': appEnv['httpreceivetimeoutms']!,
  });

  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  await registerService();

  runApp(RestartWidget(
      child: EasyDynamicThemeWidget(
        child: MobileApp(
          appLanguage: appLanguage,
        )),
      ));
}

Future<void> registerService() async {

  GetIt.I.registerLazySingleton(() => NetworkHelper(
      appVersion: '1',
      apiVersion: '1',
      apiKey: '',
      hmacKey: '',
      baseUrl: ''));
  GetIt.I.registerSingleton<app_router.AppRouter>(app_router.AppRouter());
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    if (mounted) {
      setState(() {
        key = UniqueKey();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
