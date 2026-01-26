import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';
import 'package:rastro/views/widgets/custom_snack_bar.dart';
import 'package:rastro/views/widgets/otp_input.dart';

class ChangeEmailModal extends StatefulWidget {
  const ChangeEmailModal({super.key});

  @override
  State<ChangeEmailModal> createState() => _ChangeEmailModalState();
}

class _ChangeEmailModalState extends State<ChangeEmailModal> {
  final _authService = GetIt.instance<AuthService>();
  final _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(8, (_) => FocusNode());

  bool _isLoading = false;
  bool _otpSent = false;
  String? _emailError;
  String? _otpError;
  String _newEmail = '';

  // resend timer
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void dispose() {
    _emailController.dispose();
    _timer?.cancel();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _otpFocusNodes) {
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

  bool _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'El email es requerido');
      return false;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() => _emailError = 'Ingresa un email valido');
      return false;
    }
    setState(() => _emailError = null);
    return true;
  }

  Future<void> _sendOtp() async {
    if (_isLoading) return;
    if (!_validateEmail()) return;

    setState(() => _isLoading = true);
    try {
      _newEmail = _emailController.text.trim();
      await _authService.sendEmailChangeOtp(_newEmail);
      if (!mounted) return;

      setState(() => _otpSent = true);
      _startResendTimer();
      CustomSnackbar.showSuccess(context, message: 'Codigo enviado');
    } catch (e, stackTrace) {
      print('========== ERROR CHANGE EMAIL ==========');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      print('=========================================');
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Error al enviar codigo: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _authService.sendEmailChangeOtp(_newEmail);
      if (!mounted) return;
      CustomSnackbar.showSuccess(context, message: 'Codigo reenviado');
      _startResendTimer();
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Error al reenviar: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    setState(() => _otpError = null);

    if (value.length == 1 && index < 7) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    if (_otpCode.length == 8) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode;
    if (code.length != 8) {
      setState(() => _otpError = 'Ingresa los 8 digitos');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.verifyEmailChange(_newEmail, code);
      if (!mounted) return;

      if (response.user != null) {
        CustomSnackbar.showSuccess(context, message: 'Email actualizado');
        Navigator.pop(context, true);
      } else {
        setState(() => _otpError = 'Codigo invalido');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _otpError = 'Codigo invalido o expirado');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.tertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // title
          Center(
            child: Text(
              _otpSent ? 'Verificar codigo' : 'Cambiar email',
              style: AppTextStyles.title,
            ),
          ),
          const SizedBox(height: 24),

          if (!_otpSent) ...[
            // email input step
            Text('Nuevo email', style: AppTextStyles.label),
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
            const SizedBox(height: 24),

            // send otp button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOtp,
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
                    : const Text('ENVIAR CODIGO', style: AppTextStyles.button),
              ),
            ),
          ] else ...[
            // otp verification step
            Center(
              child: Text(
                'Ingresa el codigo enviado a',
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(_newEmail, style: AppTextStyles.label),
            ),
            const SizedBox(height: 24),

            // otp fields
            OtpInput(
              digitCount: 8,
              controllers: _otpControllers,
              focusNodes: _otpFocusNodes,
              enabled: !_isLoading,
              hasError: _otpError != null,
              onChanged: _onOtpChanged,
            ),
            if (_otpError != null) ...[
              const SizedBox(height: 8),
              Center(child: Text(_otpError!, style: AppTextStyles.errorText)),
            ],
            const SizedBox(height: 24),

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
            const SizedBox(height: 16),

            // resend
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No recibiste el codigo? ', style: AppTextStyles.body),
                  GestureDetector(
                    onTap: _canResend ? _resendOtp : null,
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
            ),
          ],
        ],
      ),
    );
  }
}
