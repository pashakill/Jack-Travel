import 'package:auto_route/auto_route.dart';
import 'package:travelappui/routes/navigator_provider.dart';
import 'package:travelappui/views/HomePage/homepage.dart';
import 'package:travelappui/views/SplashScreen/splashscreen.dart';
import 'package:travelappui/views/ViewDetails/viewDetails.dart';
part 'app_router.gr.dart';

/**
run " dart run build_runner build "
    for generate new route
**/

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
      AutoRoute(
          path: PagePathCollections.initialPage,
          initial: true,
          page: HomeRoute.page,
          usesPathAsKey: true),
      AutoRoute(
          path: PagePathCollections.homePage,
          page: SplashScreen.page,
          usesPathAsKey: true),
      ];
}
