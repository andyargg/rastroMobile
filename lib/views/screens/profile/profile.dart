import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/profile/widgets/change_email_modal.dart';
import 'package:rastro/views/screens/profile/widgets/profile_menu_item.dart';
import 'package:rastro/views/widgets/responsive_center.dart';

// unified profile page for both email and google users
@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final userName = _authService.currentUser?.userMetadata?['full_name'];
    final userEmail = _authService.currentUser?.email;
    final userAvatarUrl = _authService.currentUser?.userMetadata?['avatar_url'];
    final isGoogleUser = _authService.isGoogleUser;

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
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.only(top: 20),
          children: [
            // avatar
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
        
            // name (only for google users)
            if (userName != null)
              Text(
                userName,
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
        
            // change email option (only for email users)
            if (!isGoogleUser)
              ProfileMenuItem(
                icon: LucideIcons.mail,
                label: 'Cambiar email',
                onTap: () => _showChangeEmailModal(context),
              ),
        
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
              onTap: () => _showLogoutConfirmation(context, router),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, StackRouter router) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogCtx, _, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            alignment: Alignment.center,
            child: AlertDialog(
              title: const Text('Confirmar'),
              content:
                  const Text('¿Estás seguro de que querés cerrar sesión?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogCtx);
                    await _authService.signOut();
                    router.reevaluateGuards();
                  },
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showChangeEmailModal(BuildContext context) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const ChangeEmailModal(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }
}
