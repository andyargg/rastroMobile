import 'package:auto_route/auto_route.dart';
import 'package:rastro/views/screens/home/home.dart';
import 'package:rastro/views/screens/profile/profile.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: ProfileRoute.page),
  ];
}