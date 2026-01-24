import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/views/screens/profile/widgets/change_phone_modal.dart';
import 'package:rastro/views/screens/profile/widgets/profile_menu_item.dart';

// profile for users logged in with phone number
class ProfilePhone extends StatefulWidget {
  const ProfilePhone({super.key});

  @override
  State<ProfilePhone> createState() => _ProfilePhoneState();
}

class _ProfilePhoneState extends State<ProfilePhone> {
  final _authService = GetIt.instance<AuthService>();

  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);

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
          // avatar placeholder
          

          const ProfileDivider(),
          ProfileMenuItem(
            icon: LucideIcons.phone,
            label: 'Cambiar número',
            onTap: () => _showChangePhoneModal(context),
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
            onTap: () async {
              await _authService.signOut();
              router.reevaluateGuards();
            },
          ),
        ],
      ),
    );
  }

  void _showChangePhoneModal(BuildContext context) async {
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
        child: const ChangePhoneModal(),
      ),
    );

    if (result == true && mounted) {
      setState(() {});
    }
  }
}
