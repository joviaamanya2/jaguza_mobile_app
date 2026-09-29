import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../language_selection.dart';
import '../auth_screens/forgot_password_screen.dart';
import '../auth_screens/Signup_screen.dart';
import '../../services/api_service.dart';
import '../../services/app_localizations.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  late final AnimationController _logoController;

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
    _passwordController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() =>
      setState(() => _obscurePassword = !_obscurePassword);

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final result = await apiService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['requires_password_reset'] == true) {
        await _promptTemporaryPasswordReset(
          int.tryParse('${result['user_id'] ?? ''}'),
        );
        return;
      }

      if (result['success'] == true) {
        _showSnack(context.tr('Login successful! Welcome back'));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
        );
      } else {
        _showSnack(result['error'] ?? context.tr('Invalid login credentials'), isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('${context.tr('Network error')}: ${e.toString()}', isError: true);
    }
  }

  Future<void> _promptTemporaryPasswordReset(int? userId) async {
    if (userId == null) {
      _showSnack('The server did not return a valid user ID.', isError: true);
      return;
    }

    final passwordController = TextEditingController();
    final confirmationController = TextEditingController();
    String? validationError;
    final passwords = await showDialog<(String, String)?>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Set a new password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
              ),
              TextField(
                controller: confirmationController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm password'),
              ),
              if (validationError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    validationError!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final password = passwordController.text;
                if (password.length < 8 || password != confirmationController.text) {
                  setDialogState(() {
                    validationError = password.length < 8
                        ? 'Use at least 8 characters.'
                        : 'Passwords do not match.';
                  });
                  return;
                }
                Navigator.pop(dialogContext, (password, confirmationController.text));
              },
              child: const Text('Update password'),
            ),
          ],
        ),
      ),
    );
    passwordController.dispose();
    confirmationController.dispose();
    if (passwords == null || !mounted) return;

    setState(() => _isLoading = true);
    final result = await ApiService().resetLegacyPassword(
      userId: userId,
      password: passwords.$1,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (result['success'] == true) {
      _showSnack('Password updated successfully.');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
      );
    } else {
      _showSnack(result['error'] ?? 'Could not update password.', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.warning_rounded : Icons.check_circle_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? scheme.error : scheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _handleGoogleSignIn() {
    // Implement Google Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('Google Sign-In initiated')),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _handleAppleSignIn() {
    // Implement Apple Sign-In
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('Apple Sign-In initiated')),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(statusBarColor: const Color.fromARGB(255, 24, 117, 44)),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionHeading(
                          title: context.tr('SIGN IN'),
                          subtitle: context.tr('Welcome back! Please enter your details.'),
                        ),
                        const SizedBox(height: 26),
                        _FieldLabel(context.tr('Email or Phone Number')),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return context.tr('Please enter your email or phone number');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            prefixIcon: Icon(Icons.alternate_email_rounded,
                                color: scheme.onSurfaceVariant, size: 22),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _FieldLabel(context.tr('Password')),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.tr('Please enter your password');
                            }
                            if (value.length < 6) {
                              return context.tr('Password must be at least 6 characters');
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: Icon(Icons.lock_outline_rounded,
                                color: scheme.onSurfaceVariant, size: 22),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: scheme.onSurfaceVariant,
                                size: 22,
                              ),
                              onPressed: _togglePasswordVisibility,
                              tooltip: _obscurePassword
                                  ? context.tr('Show password')
                                  : context.tr('Hide password'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PasswordResetScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              context.tr('Forgot Password?'),
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _SignInButton(
                          isLoading: _isLoading,
                          onPressed: _handleSignIn,
                        ),
                        const SizedBox(height: 26),
                        const _OrDivider(),
                        const SizedBox(height: 22),
                        _SocialButtons(
                          onGoogleTap: _handleGoogleSignIn,
                          onAppleTap: _handleAppleSignIn,
                        ),
                        const SizedBox(height: 28),
                        const _RegisterPrompt(),
                        const SizedBox(height: 24),
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
        color: const Color.fromARGB(255, 33, 123, 30),
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 70),
        child: Column(
          children: [
            const SizedBox(height: 8),
            ScaleTransition(
              scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                CurvedAnimation(
                  parent: _logoController,
                  curve: Curves.elasticOut,
                ),
              ),
              child: FadeTransition(
                opacity: _logoController,
                child: const _AppLogo(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Widgets

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _SignInButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF7A1A),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFFF7A1A),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                context.tr('SIGN IN'),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: Divider(color: scheme.outlineVariant, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            context.tr('OR CONTINUE WITH'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: scheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(child: Divider(color: scheme.outlineVariant, thickness: 1)),
      ],
    );
  }
}

class _SocialButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onAppleTap;

  const _SocialButtons({
    required this.onGoogleTap,
    required this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialTile(
          icon: Image.asset(
            'lib/assets/images/google.png',
            width: 26,
            height: 26,
            fit: BoxFit.contain,
          ),
          semanticLabel: context.tr('Sign in with Google'),
          onTap: onGoogleTap,
        ),
        const SizedBox(width: 18),
        _SocialTile(
          icon: Icon(Icons.apple_rounded,
              color: Theme.of(context).colorScheme.onSurface, size: 30),
          semanticLabel: context.tr('Sign in with Apple'),
          onTap: onAppleTap,
        ),
      ],
    );
  }
}

class _SocialTile extends StatelessWidget {
  final Widget icon;
  final String semanticLabel;
  final VoidCallback onTap;
  const _SocialTile({required this.icon, required this.semanticLabel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.outlineVariant, width: 1.5),
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "${context.tr("Don't have an Account?")} ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: context.tr('Register'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'lib/assets/images/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// Google Logo (vector)

class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final red = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.42
      ..strokeCap = StrokeCap.round;
    final yellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.42
      ..strokeCap = StrokeCap.round;
    final green = Paint()
      ..color = const Color.fromARGB(255, 25, 136, 55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.42
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.78),
      -1.1,
      -1.05,
      false,
      red,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.78),
      2.04,
      1.0,
      false,
      yellow,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.78),
      0.94,
      1.0,
      false,
      green,
    );

    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.42
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: r * 0.78),
      -1.15,
      1.55,
      false,
      blue,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + r * 0.5, center.dy),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Wave Clipper

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 36);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 36,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
