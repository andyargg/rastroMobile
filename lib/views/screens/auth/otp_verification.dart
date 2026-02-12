import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';
import 'package:rastro/views/screens/auth/widgets/logo_widget.dart';
import 'package:rastro/views/widgets/custom_snack_bar.dart';
import 'package:rastro/views/widgets/otp_input.dart';
import 'package:rastro/views/widgets/responsive_center.dart';

@RoutePage()
class OtpVerificationPage extends StatefulWidget {
  final String email;
  final Function(bool)? onResult;

  const OtpVerificationPage({
    super.key,
    required this.email,
    this.onResult,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _authService = GetIt.instance<AuthService>();
  final List<TextEditingController> _controllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  bool _isLoading = false;
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;
  String? _otpError;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startResendTimer() {
    _resendSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    setState(() => _otpError = null);

    if (value.length == 1 && index < 7) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_otpCode.length == 8) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode;
    if (code.length != 8) {
      setState(() => _otpError = 'Ingresa los 8 dígitos');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.verifyOtp(widget.email, code);
      if (!mounted) return;

      if (response.user != null) {
        widget.onResult?.call(true);
      } else {
        setState(() => _otpError = 'Código inválido');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _otpError = 'Código inválido o expirado');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _authService.signInWithOtp(widget.email);
      if (!mounted) return;
      CustomSnackbar.showSuccess(context, message: 'Código reenviado');
      _startResendTimer();
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Error al reenviar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.router.maybePop(),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
            children: [
              const SizedBox(height: 20),
              const LogoWidget(),
              const SizedBox(height: 40),
              const Text('Verificar código', style: AppTextStyles.title),
              const SizedBox(height: 16),
              const Text(
                'Ingresa el código de 8 dígitos enviado a',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.email,
                style: AppTextStyles.label,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // otp fields
              OtpInput(
                digitCount: 8,
                controllers: _controllers,
                focusNodes: _focusNodes,
                enabled: !_isLoading,
                hasError: _otpError != null,
                onChanged: _onOtpChanged,
              ),
              if (_otpError != null) ...[
                const SizedBox(height: 8),
                Text(_otpError!, style: AppTextStyles.errorText),
              ],
              const SizedBox(height: 32),

              // verify button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
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
                      : const Text('VERIFICAR', style: AppTextStyles.button),
                ),
              ),
              const SizedBox(height: 24),

              // resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No recibiste el código? ',
                    style: AppTextStyles.body,
                  ),
                  GestureDetector(
                    onTap: _canResend ? _resendCode : null,
                    child: Text(
                      _canResend ? 'Reenviar' : 'Reenviar en ${_resendSeconds}s',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _canResend ? AppColors.primary : AppColors.tertiary,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
