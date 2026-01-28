import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/routes/app_router.dart';
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
  final _authService = GetIt.instance<AuthService>();

  bool _isLoading = false;
  String? _emailError;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'El email es requerido');
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Ingresa un email válido');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  Future<void> _handleEmailSignIn() async {
    if (_isLoading) return;
    if (!_validateEmail()) return;

    setState(() => _isLoading = true);
    try {
      final email = _emailController.text.trim();

      // block if the email is already registered with google
      final provider = await _authService.getEmailProvider(email);
      if (provider == 'google') {
        if (!mounted) return;
        CustomSnackbar.showError(
          context,
          'Este email está registrado con Google. '
          'Usá el botón de Google para iniciar sesión.',
        );
        return;
      }

      await _authService.signInWithOtp(email);
      if (!mounted) return;

      context.router.push(OtpVerificationRoute(
        email: email,
        onResult: widget.onResult,
      ));
    } catch (e) {
      if (!mounted) return;
      debugPrint(e.toString());
      CustomSnackbar.showError(context, 'Error al enviar código: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(child: LogoWidget()),
              const SizedBox(height: 40),
              const Center(
                child: Text('Inicia sesión en tu cuenta', style: AppTextStyles.title),
              ),
              const SizedBox(height: 32),

              // email field
              Text(
                _emailError != null ? 'Email *' : 'Email',
                style: _emailError != null ? AppTextStyles.labelError : AppTextStyles.label,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                enabled: !_isLoading,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textDark,
                  fontFamily: 'Roboto',
                ),
                decoration: InputDecoration(
                  hintText: 'ejemplo@correo.com',
                  hintStyle: const TextStyle(color: AppColors.tertiary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: _emailError != null
                        ? const BorderSide(color: AppColors.error, width: 1.5)
                        : BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: _emailError != null
                        ? const BorderSide(color: AppColors.error, width: 1.5)
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _emailError != null ? AppColors.error : AppColors.primary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onChanged: (_) => setState(() => _emailError = null),
              ),
              if (_emailError != null) ...[
                const SizedBox(height: 4),
                Text(_emailError!, style: AppTextStyles.errorText),
              ],
              const SizedBox(height: 32),

              // login button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleEmailSignIn,
                  style: AppButtonStyles.primary,
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text('ENVIAR CÓDIGO', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 24),

              // divider
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.divider)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('o continúa con', style: AppTextStyles.dividerText),
                  ),
                  const Expanded(child: Divider(color: AppColors.divider)),
                ],
              ),
              const SizedBox(height: 24),

              // google button
              GoogleButton(onPressed: _isLoading ? null : _handleGoogleSignIn),
              const SizedBox(height: 32),

            ],
          ),
        ),
      ),
    );
  }
}
