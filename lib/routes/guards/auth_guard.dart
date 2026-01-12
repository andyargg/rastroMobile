import 'package:auto_route/auto_route.dart';
import 'package:rastro/main.dart';
import 'package:rastro/routes/app_router.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    AuthService authService = getIt.get<AuthService>();
    User? user = authService.currentUser;

    if (user != null) {
      resolver.next(true);
    } else {
      // Redirigir al login si no hay usuario autenticado
      router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}
