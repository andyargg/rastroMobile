import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/views/screens/profile/profile_google.dart';
import 'package:rastro/views/screens/profile/profile_phone.dart';

@RoutePage()
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = GetIt.instance<AuthService>();
    final user = authService.currentUser;

    // phone users have phone field set
    final isPhoneUser = user?.phone != null && user!.phone!.isNotEmpty;
    debugPrint(user.toString());
    debugPrint(isPhoneUser.toString());
    if (isPhoneUser) {
      return const ProfilePhone();
    } else {
      return const ProfileGoogle();
    }
  }
}
