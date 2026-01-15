import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';
import 'package:rastro/views/screens/auth/widgets/logo_widget.dart';
import 'package:rastro/views/widgets/custom_snack_bar.dart';
import 'package:rastro/views/widgets/google_button.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  final Function(bool)? onResult;

  const LoginPage({super.key, this.onResult});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _authService = GetIt.instance<AuthService>();

  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      final response = await _authService.nativeGoogleSignIn();
      if (!mounted) return;
      if (response.user != null) {
        widget.onResult?.call(true);
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(child: LogoWidget()),
              const SizedBox(height: 40),
              const Center(
                child: Text('Inicia sesion en tu cuenta', style: AppTextStyles.title),
              ),
              const SizedBox(height: 32),
              
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              Center(child: GoogleButton(onPressed: _handleGoogleSignIn)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
