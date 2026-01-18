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
import 'package:rastro/views/widgets/phone_input_field.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  final Function(bool)? onResult;

  const LoginPage({super.key, this.onResult});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _phoneController;
  final _authService = GetIt.instance<AuthService>();

  bool _isLoading = false;
  String? _phoneError;

  @override
  void initState() {
    _phoneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool _validatePhone() {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      setState(() => _phoneError = 'El teléfono es requerido');
      return false;
    }
    if (digits.length != 10) {
      setState(() => _phoneError = 'Ingresa un número válido de 10 dígitos');
      return false;
    }
    setState(() => _phoneError = null);
    return true;
  }

  Future<void> _handlePhoneSignIn() async {
    if (_isLoading) return;
    if (!_validatePhone()) return;

    setState(() => _isLoading = true);
    try {
      final phone = PhoneInputField.getFullNumber(_phoneController.text);
      await _authService.signInWithOtp(phone);
      if (!mounted) return;

      context.router.push(OtpVerificationRoute(
        phone: phone,
        onResult: widget.onResult,
      ));
    } catch (e) {
      if (!mounted) return;
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

              // phone field
              Text(
                _phoneError != null ? 'Número de Celular *' : 'Número de Celular',
                style: _phoneError != null ? AppTextStyles.labelError : AppTextStyles.label,
              ),
              const SizedBox(height: 8),
              PhoneInputField(
                controller: _phoneController,
                enabled: !_isLoading,
                errorText: _phoneError,
                onChanged: () => setState(() => _phoneError = null),
              ),
              if (_phoneError != null) ...[
                const SizedBox(height: 4),
                Text(_phoneError!, style: AppTextStyles.errorText),
              ],
              const SizedBox(height: 32),

              // login button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handlePhoneSignIn,
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
