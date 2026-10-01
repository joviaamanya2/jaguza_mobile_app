import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../language_selection.dart';
import '../../services/php_api_service.dart';

/// Verifies the SMS PIN sent by the PHP backend after registration (or when a
/// login comes back as "notactivated").
class PinVerificationScreen extends StatefulWidget {
  final String userId;
  final String phone;
  const PinVerificationScreen({
    super.key,
    required this.userId,
    required this.phone,
  });

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final _pinCtrl = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _pinCtrl.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool error = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? scheme.error : scheme.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  Future<void> _verify() async {
    final pin = _pinCtrl.text.trim();
    if (pin.length < 4) {
      _snack('Enter the PIN sent to ${widget.phone}', error: true);
      return;
    }
    setState(() => _busy = true);
    try {
      final res = await PhpApiService.instance.verifyPin(
        userId: widget.userId,
        phone: widget.phone,
        pin: pin,
      );
      if (!mounted) return;
      if (res['success'] == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
          (_) => false,
        );
      } else {
        _snack('${res['error']}', error: true);
      }
    } on PhpApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    try {
      final res = await PhpApiService.instance.resendCode(widget.phone);
      if (!mounted) return;
      _snack(res['success'] == true ? 'A new PIN was sent' : '${res['error']}',
          error: res['success'] != true);
    } on PhpApiException catch (e) {
      if (mounted) _snack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Verify your phone')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'We sent a PIN to ${widget.phone}. Enter it below to activate your account.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _pinCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, letterSpacing: 8),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '------',
                ),
                onSubmitted: (_) => _verify(),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _busy ? null : _verify,
                child: _busy
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Text('Verify'),
              ),
              TextButton(onPressed: _resend, child: const Text('Resend PIN')),
            ],
          ),
        ),
      ),
    );
  }
}
