import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/api_service.dart';
import '../../services/app_localizations.dart';
import './login_screen.dart';

// =========================================================
// SCREEN 1: Enter Email/Phone to Request Code
// =========================================================
class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  late final AnimationController _logoController;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    setState(() => _isSending = true);

    Map<String, dynamic> result;
    try {
      result = await _apiService.forgotPassword(email);
    } catch (error) {
      result = {'success': false, 'error': error.toString()};
    }

    if (!mounted) return;
    setState(() => _isSending = false);

    if (result['success'] == true && ApiService.usePhp) {
      // The PHP backend emails a reset link instead of a 6-digit code.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']?.toString() ??
              'A password reset link was sent to your email.'),
        ),
      );
      Navigator.pop(context);
    } else if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationScreen(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']?.toString() ?? context.tr('Failed to send verification code'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: const Color(0xFF1E7B4E)),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.tr('Forgot Password?'),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: scheme.onSurface,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          context.tr("No worries! Enter your email address and we'll send you a code to reset your password."),
                          style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant, height: 1.5),
                        ),
                        const SizedBox(height: 32),
                        _FieldLabel(context.tr('Email Address')),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          enabled: !_isSending,
                          validator: (value) {
                            final trimmed = value?.trim() ?? '';
                            if (trimmed.isEmpty) {
                              return context.tr('Please enter your email address');
                            }
                            if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(trimmed)) {
                              return context.tr('Please enter a valid email address');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            prefixIcon: Icon(Icons.alternate_email_rounded, color: scheme.onSurfaceVariant, size: 22),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _ActionBtn(
                          title: context.tr('SEND CODE'),
                          isLoading: _isSending,
                          onPressed: _sendCode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 30, 123, 35),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 70),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.question_answer_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
              ],
            ),
            const SizedBox(height: 28),
            ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut)),
              child: FadeTransition(opacity: _logoController, child: const _AppLogo()),
            ),
          ],
        ),
      ),
    );
  }
}



// =========================================================
// SCREEN 2: Enter 6-Digit Verification Code
// =========================================================
class VerificationScreen extends StatefulWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  final ApiService _apiService = ApiService();
  bool _isVerifying = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyCode() async {
    String code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.tr('Please enter the 6-digit code'))));
      return;
    }

    setState(() => _isVerifying = true);
    Map<String, dynamic> result;
    try {
      result = await _apiService.verifyResetCode(widget.email, code);
    } catch (error) {
      result = {'success': false, 'error': error.toString()};
    }

    if (!mounted) return;
    setState(() => _isVerifying = false);

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPasswordScreen(email: widget.email, code: code),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']?.toString() ?? context.tr('Invalid or expired code'))),
      );
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);
    final result = await _apiService.forgotPassword(widget.email);

    if (!mounted) return;
    setState(() => _isResending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result['success'] == true
              ? '${context.tr('A new code has been sent to')} ${widget.email}'
              : (result['error']?.toString() ?? context.tr('Failed to resend the code')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: const Color(0xFF1E7B4E)),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.tr('Verification'),
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: scheme.onSurface),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${context.tr('Enter the 6-digit code sent to')}\n${widget.email}',
                        style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant, height: 1.5),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => SizedBox(
                            width: 48,
                            height: 56,
                            child: TextFormField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              enabled: !_isVerifying,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
                              decoration: _otpInputDecoration(scheme),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                }
                                if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: _isResending ? null : _resendCode,
                          child: Text(
                            _isResending ? context.tr('Sending...') : context.tr("Didn't receive a code? Resend"),
                            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _ActionBtn(title: context.tr('VERIFY CODE'), isLoading: _isVerifying, onPressed: _verifyCode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _otpInputDecoration(ColorScheme scheme) {
    return InputDecoration(
      filled: true,
      fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: scheme.outlineVariant, width: 1)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: scheme.primary, width: 1.5)),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        height: 160,
        color: const Color(0xFF1E7B4E),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.question_answer_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                // Removed "ASK US" text
              ],
            ),
            const SizedBox(height: 20),
            const Center(
              child: Icon(Icons.lock_reset_rounded, color: Colors.white, size: 40),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// SCREEN 3: Enter New Password
// =========================================================
class NewPasswordScreen extends StatefulWidget {
  final String email;
  final String code;
  const NewPasswordScreen({super.key, required this.email, required this.code});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isResetting = false;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isResetting = true);
    Map<String, dynamic> result;
    try {
      result = await _apiService.resetPassword(
        widget.email,
        widget.code,
        _newPassController.text,
        _confirmPassController.text,
      );
    } catch (error) {
      result = {'success': false, 'error': error.toString()};
    }

    if (!mounted) return;
    setState(() => _isResetting = false);

    if (result['success'] == true) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SuccessScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['error']?.toString() ?? context.tr('Failed to reset password'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: const Color(0xFF1E7B4E)),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(context.tr('Create New Password'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: scheme.onSurface)),
                        const SizedBox(height: 10),
                        Text(context.tr('Your new password must be different from previously used passwords.'), style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant, height: 1.5)),
                        const SizedBox(height: 32),
                        _FieldLabel(context.tr('New Password')),
                        TextFormField(
                          controller: _newPassController,
                          obscureText: _obscureNew,
                          enabled: !_isResetting,
                          validator: (value) {
                            if (value == null || value.isEmpty) return context.tr('Please enter a new password');
                            if (value.length < 8) return context.tr('Password must be at least 8 characters');
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: scheme.onSurfaceVariant, size: 22),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: scheme.onSurfaceVariant, size: 22),
                              onPressed: () => setState(() => _obscureNew = !_obscureNew),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel(context.tr('Confirm Password')),
                        TextFormField(
                          controller: _confirmPassController,
                          obscureText: _obscureConfirm,
                          enabled: !_isResetting,
                          validator: (value) {
                            if (value == null || value.isEmpty) return context.tr('Please confirm your password');
                            if (value != _newPassController.text) return context.tr('Passwords do not match');
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: scheme.onSurfaceVariant, size: 22),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: scheme.onSurfaceVariant, size: 22),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        _ActionBtn(title: context.tr('RESET PASSWORD'), isLoading: _isResetting, onPressed: _resetPassword),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        height: 160,
        color: const Color(0xFF1E7B4E),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.question_answer_rounded, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                // Removed "ASK US" text
              ],
            ),
            const Spacer(),
            const Center(
              child: Icon(Icons.key_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// SCREEN 4: Success Screen (Routes back to Login)
// =========================================================
class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
          (route) => false,
        );
      }
    });

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: scheme.primary, size: 60),
              ),
              const SizedBox(height: 32),
              Text(
                context.tr('Password Reset\nSuccessful!'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.tr('Your password has been successfully reset. You can now use your new credentials to log in.'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant, height: 1.5),
              ),
              const SizedBox(height: 40),
              _ActionBtn(
                title: context.tr('BACK TO LOGIN'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// SHARED REUSABLE WIDGETS
// =========================================================

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  const _ActionBtn({required this.title, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A1A),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFF7A1A).withValues(alpha: 0.7),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
            : Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 22, offset: const Offset(0, 12))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset('lib/assets/images/logo.png', fit: BoxFit.contain),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 36);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 36);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
