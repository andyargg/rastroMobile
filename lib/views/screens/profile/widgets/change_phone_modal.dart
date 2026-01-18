import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:rastro/services/auth_service.dart';
import 'package:rastro/utils/styles/app_colors.dart';
import 'package:rastro/utils/styles/app_styles.dart';
import 'package:rastro/views/widgets/custom_snack_bar.dart';
import 'package:rastro/views/widgets/phone_input_field.dart';

class ChangePhoneModal extends StatefulWidget {
  const ChangePhoneModal({super.key});

  @override
  State<ChangePhoneModal> createState() => _ChangePhoneModalState();
}

class _ChangePhoneModalState extends State<ChangePhoneModal> {
  final _authService = GetIt.instance<AuthService>();
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _otpSent = false;
  String? _phoneError;
  String? _otpError;
  String _newPhone = '';

  // resend timer
  bool _canResend = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
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

  Future<void> _sendOtp() async {
    if (_isLoading) return;
    if (!_validatePhone()) return;

    setState(() => _isLoading = true);
    try {
      _newPhone = PhoneInputField.getFullNumber(_phoneController.text);
      await _authService.sendPhoneChangeOtp(_newPhone);
      if (!mounted) return;

      setState(() => _otpSent = true);
      _startResendTimer();
      CustomSnackbar.showSuccess(context, message: 'Código enviado');
    } catch (e) {
      if (!mounted) return;
      CustomSnackbar.showError(context, 'Error al enviar código: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend || _isLoading) return;

    setState(() => _isLoading = true);
    try {
      await _authService.sendPhoneChangeOtp(_newPhone);
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

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  void _onOtpChanged(int index, String value) {
    setState(() => _otpError = null);

    if (value.length == 1 && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    if (_otpCode.length == 6) {
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _otpCode;
    if (code.length != 6) {
      setState(() => _otpError = 'Ingresa los 6 dígitos');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.verifyPhoneChange(_newPhone, code);
      if (!mounted) return;

      if (response.user != null) {
        CustomSnackbar.showSuccess(context, message: 'Número actualizado');
        Navigator.pop(context, true);
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
              _otpSent ? 'Verificar código' : 'Cambiar número',
              style: AppTextStyles.title,
            ),
          ),
          const SizedBox(height: 24),

          if (!_otpSent) ...[
            // phone input step
            Text('Nuevo número de celular', style: AppTextStyles.label),
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
                    : const Text('ENVIAR CÓDIGO', style: AppTextStyles.button),
              ),
            ),
          ] else ...[
            // otp verification step
            Center(
              child: Text(
                'Ingresa el código enviado a',
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(_newPhone, style: AppTextStyles.label),
            ),
            const SizedBox(height: 24),

            // otp fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpField(index)),
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
                  const Text('¿No recibiste el código? ', style: AppTextStyles.body),
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

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 48,
      height: 56,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _otpFocusNodes[index],
        enabled: !_isLoading,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: _otpError != null
                ? const BorderSide(color: AppColors.error, width: 1.5)
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: _otpError != null
                ? const BorderSide(color: AppColors.error, width: 1.5)
                : BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: _otpError != null ? AppColors.error : AppColors.primary,
              width: 2,
            ),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onOtpChanged(index, value),
      ),
    );
  }
}
