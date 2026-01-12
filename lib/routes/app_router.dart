import 'package:auto_route/auto_route.dart';
import 'package:rastro/routes/guards/auth_guard.dart';
import 'package:rastro/views/screens/auth/login.dart';
import 'package:rastro/views/screens/home/home.dart';
import 'package:rastro/views/screens/profile/profile.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true, guards: [AuthGuard()]),
    AutoRoute(page: ProfileRoute.page, guards: [AuthGuard()]),
    AutoRoute(page: LoginRoute.page),
  ];
}