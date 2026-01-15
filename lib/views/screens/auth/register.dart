import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';
import 'package:rastro/views/screens/auth/widgets/auth_button.dart';
import 'package:rastro/views/screens/auth/widgets/auth_text_field.dart';
import 'package:rastro/views/screens/auth/widgets/logo_widget.dart';
import 'package:rastro/views/screens/auth/widgets/social_divider.dart';
import 'package:rastro/views/widgets/custom_snack_bar.dart';
import 'package:rastro/views/widgets/google_button.dart';

@RoutePage()
class RegisterPage extends StatefulWidget {
  final Function(bool)? onResult;

  const RegisterPage({super.key, this.onResult});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;
  final _authService = GetIt.instance<AuthService>();

  bool _obscurePassword = true;
  bool _obscureConfirmation = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
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
        AutoRouter.of(context).maybePop();
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
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(child: LogoWidget()),
              const SizedBox(height: 40),
              const Center(
                child: Text('Crea tu cuenta', style: AppTextStyles.title),
              ),
              const SizedBox(height: 32),
              AuthTextField(
                controller: _emailController,
                label: 'Correo electronico',
                hintText: 'ej: juan.perez@gmail.com',
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: _passwordController,
                label: 'Contraseña',
                hintText: '******',
                enabled: !_isLoading,
                obscureText: _obscurePassword,
                onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: _passwordConfirmationController,
                label: 'Confirmar contraseña',
                hintText: '******',
                enabled: !_isLoading,
                obscureText: _obscureConfirmation,
                onToggleObscure: () => setState(() => _obscureConfirmation = !_obscureConfirmation),
              ),
              const SizedBox(height: 32),
              AuthButton(
                text: 'REGISTRARSE',
                onPressed: () {},
                isLoading: _isLoading,
              ),
              const SizedBox(height: 24),
              const SocialDivider(text: 'o registrate con'),
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
