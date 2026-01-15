import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/profile/widgets/profile_menu_item.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    final authService = GetIt.instance<AuthService>();

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
          const Center(
            child: CircleAvatar(
              radius: 62.5,
              backgroundColor: AppColors.primary,
              backgroundImage: AssetImage('assets/profilePhoto/lucioPro.jpg'),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Lucio Ricolini Arriola",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'lucionicoliniarriolapro@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: AppColors.tertiary,
            ),
          ),
          const SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.4,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(40),
              ),
              onPressed: () {},
              child: const Text(
                'Editar perfil',
                style: TextStyle(color: AppColors.textDark),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const ProfileDivider(),
          ProfileMenuItem(
            icon: LucideIcons.settings,
            label: 'Configuración',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: LucideIcons.clock,
            label: 'Historial de pedidos',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: LucideIcons.lock,
            label: 'Cambiar contraseña',
            onTap: () {},
          ),
          const ProfileDivider(),
          ProfileMenuItem(
            icon: LucideIcons.messageCircle,
            label: 'Contactar a soporte',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: LucideIcons.logOut,
            label: 'Salir',
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
