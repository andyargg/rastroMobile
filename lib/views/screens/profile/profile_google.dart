import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/profile/widgets/profile_menu_item.dart';

// profile for users logged in with google
class ProfileGoogle extends StatelessWidget {
  const ProfileGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final authService = GetIt.instance<AuthService>();

    final userName = authService.currentUser?.userMetadata?['full_name'];
    final userEmail = authService.currentUser?.email;
    final userAvatarUrl = authService.currentUser?.userMetadata?['avatar_url'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: router.pop,
        ),
        centerTitle: true,
        title: const Text(
          "Perfil",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          // google avatar
          Center(
            child: CircleAvatar(
              radius: 62.5,
              backgroundColor: AppColors.primary,
              backgroundImage: userAvatarUrl != null
                ? NetworkImage(userAvatarUrl)
                : null,
              child: userAvatarUrl == null
                ? const Icon(LucideIcons.user, size: 50, color: AppColors.white)
                : null,
            ),
          ),
          const SizedBox(height: 20),

          // name
          Text(
            userName ?? 'Usuario',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),

          // email
          if (userEmail != null)
            Text(
              userEmail,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Roboto',
                color: AppColors.tertiary,
              ),
            ),
          const SizedBox(height: 50),

          const ProfileDivider(),
          ProfileMenuItem(
            icon: LucideIcons.clock,
            label: 'Historial de pedidos',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: LucideIcons.messageCircle,
            label: 'Contactar a soporte',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: LucideIcons.logOut,
            label: 'Cerrar sesión',
            onTap: () async {
              await authService.signOut();
              router.reevaluateGuards();
            },
          ),
        ],
      ),
    );
  }
}
