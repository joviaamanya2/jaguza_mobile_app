import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../terms_and_conditions.dart';
import '../language_selection.dart';
import '../../services/api_service.dart';

// ─── App entry ──
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _SignupApp());
}

class _SignupApp extends StatelessWidget {
  const _SignupApp();
  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: RegisterScreen(),
      );
}

// ─── Theme constants ─
const _kGreen = Color(0xFF2E7D32);
const _kGreenLight = Color(0xFF2E7D32);
const _kError = Color(0xFFE5484D);
const _kText = Color(0xFF1A1F36);
const _kSubtext = Color(0xFF6B7280);
const _kBorder = Color(0xFFE3E8EE);
const _kFill = Color(0xFFF6F8FA);
const _kPrimary = Color(0xFFFF7A1A);

// ─── Password strength helper ───────────
enum _PasswordStrength { empty, weak, fair, strong, veryStrong }

_PasswordStrength _evalStrength(String password) {
  if (password.isEmpty) return _PasswordStrength.empty;
  int score = 0;
  if (password.length >= 8) score++;
  if (password.length >= 12) score++;
  if (RegExp(r'[A-Z]').hasMatch(password)) score++;
  if (RegExp(r'[0-9]').hasMatch(password)) score++;
  if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
  if (score <= 1) return _PasswordStrength.weak;
  if (score == 2) return _PasswordStrength.fair;
  if (score == 3) return _PasswordStrength.strong;
  return _PasswordStrength.veryStrong;
}

Color _strengthColor(_PasswordStrength s) => switch (s) {
      _PasswordStrength.weak => const Color(0xFFE5484D),
      _PasswordStrength.fair => const Color(0xFFF59E0B),
      _PasswordStrength.strong => const Color(0xFF10B981),
      _PasswordStrength.veryStrong => _kGreen,
      _ => _kBorder,
    };

String _strengthLabel(_PasswordStrength s) => switch (s) {
      _PasswordStrength.weak => 'Weak',
      _PasswordStrength.fair => 'Fair',
      _PasswordStrength.strong => 'Strong',
      _PasswordStrength.veryStrong => 'Very strong',
      _ => '',
    };

int _strengthSegments(_PasswordStrength s) => switch (s) {
      _PasswordStrength.weak => 1,
      _PasswordStrength.fair => 2,
      _PasswordStrength.strong => 3,
      _PasswordStrength.veryStrong => 4,
      _ => 0,
    };

// ─── RegisterScreen ──
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  bool _agreedToTerms = false;
  _PasswordStrength _passwordStrength = _PasswordStrength.empty;

  String _selectedCountryCode = '+256';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+256', 'flag': '🇺🇬', 'name': 'Uganda'},
    {'code': '+254', 'flag': '🇰🇪', 'name': 'Kenya'},
    {'code': '+255', 'flag': '🇹🇿', 'name': 'Tanzania'},
    {'code': '+250', 'flag': '🇷🇼', 'name': 'Rwanda'},
    {'code': '+251', 'flag': '🇪🇹', 'name': 'Ethiopia'},
    {'code': '+234', 'flag': '🇳🇬', 'name': 'Nigeria'},
    {'code': '+27', 'flag': '🇿🇦', 'name': 'South Africa'},
    {'code': '+1', 'flag': '🇺🇸', 'name': 'United States'},
    {'code': '+44', 'flag': '🇬🇧', 'name': 'United Kingdom'},
  ];

  late final AnimationController _headerAnim;
  late final Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade =
        CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);

    _passwordCtrl.addListener(() {
      setState(() {
        _passwordStrength = _evalStrength(_passwordCtrl.text);
      });
    });
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _headerAnim.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      _showSnack(
        'Please accept the Terms & Conditions to continue.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final apiService = ApiService();
      
      final String email = _emailCtrl.text.trim();
      final String username = email.split('@').first;
      
      final userData = {
        'name': '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
        'email': email,
        'password': _passwordCtrl.text,
        'password_confirmation': _confirmPasswordCtrl.text,
        'phone_number': _phoneCtrl.text.trim(),
        'role': 'farmer',
        'farm_name': '',
        'farm_location': '',
      };
      
      final result = await apiService.register(userData);
      
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSnack('Account created successfully! Welcome aboard');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LanguageSelectionScreen()),
        );
      } else {
        String errorMessage = 'Registration failed. Please try again.';
        if (result['error'] is Map) {
          final errors = result['error'] as Map;
          errorMessage = errors.values.first.toString();
        } else if (result['error'] is String) {
          errorMessage = result['error'];
        }
        _showSnack(errorMessage, isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('Network error: ${e.toString()}', isError: true);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
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
        backgroundColor: isError ? _kError : _kGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            FadeTransition(
              opacity: _headerFade,
              child: _buildHeader(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _FormGroup(
                              label: 'First Name',
                              child: _AppField(
                                controller: _firstNameCtrl,
                                focusNode: _firstNameFocus,
                                nextFocus: _lastNameFocus,
                                hint: 'John',
                                icon: Icons.person_outline_rounded,
                                capitalization: TextCapitalization.words,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  if (v.trim().length < 2) {
                                    return 'Too short';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _FormGroup(
                              label: 'Last Name',
                              child: _AppField(
                                controller: _lastNameCtrl,
                                focusNode: _lastNameFocus,
                                nextFocus: _emailFocus,
                                hint: 'Doe',
                                icon: Icons.person_outline_rounded,
                                capitalization: TextCapitalization.words,
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _FormGroup(
                        label: 'Email Address',
                        child: _AppField(
                          controller: _emailCtrl,
                          focusNode: _emailFocus,
                          nextFocus: _phoneFocus,
                          hint: 'you@example.com',
                          icon: Icons.alternate_email_rounded,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                                    r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$')
                                .hasMatch(v.trim())) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),

                      _FormGroup(
                        label: 'Phone Number',
                        child: _PhoneField(
                          controller: _phoneCtrl,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          selectedCode: _selectedCountryCode,
                          countryCodes: _countryCodes,
                          onCodeChanged: (code) =>
                              setState(() => _selectedCountryCode = code),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _FormGroup(
                        label: 'Password',
                        child: _AppField(
                          controller: _passwordCtrl,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmFocus,
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          autofillHints: const [AutofillHints.newPassword],
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _kSubtext,
                              size: 21,
                            ),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (v.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      if (_passwordStrength != _PasswordStrength.empty) ...[
                        const SizedBox(height: 10),
                        _PasswordStrengthMeter(strength: _passwordStrength),
                      ],
                      const SizedBox(height: 16),

                      _FormGroup(
                        label: 'Confirm Password',
                        child: _AppField(
                          controller: _confirmPasswordCtrl,
                          focusNode: _confirmFocus,
                          hint: '••••••••',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscureConfirm,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.newPassword],
                          onFieldSubmitted: (_) => _handleRegister(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _kSubtext,
                              size: 21,
                            ),
                            onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (v != _passwordCtrl.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      _TermsRow(
                        isChecked: _agreedToTerms,
                        onChanged: (v) =>
                            setState(() => _agreedToTerms = v ?? false),
                        onTermsTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const TermsAndConditionsScreen(fromSignup: true),
                          ),
                        ).then((accepted) {
                          if (accepted == true) {
                            setState(() => _agreedToTerms = true);
                          }
                        }),
                      ),
                      const SizedBox(height: 28),

                      _RegisterButton(
                        isLoading: _isLoading,
                        onPressed: _handleRegister,
                      ),
                      const SizedBox(height: 20),

                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                    color: _kSubtext,
                                    fontSize: 14,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: _kGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _kGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        color: _kGreen,
        padding: const EdgeInsets.fromLTRB(22, 48, 22, 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.maybePop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Join Jaguza and manage your herd smarter.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Wave clipper ────
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 32);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 32);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ─── Form group label wrapper ───────────
class _FormGroup extends StatelessWidget {
  final String label;
  final Widget child;
  const _FormGroup({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _kText,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

// ─── Shared text field ──────────────────
class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization capitalization;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onFieldSubmitted;

  const _AppField({
    required this.controller,
    this.focusNode,
    this.nextFocus,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.capitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.validator,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: capitalization,
      textInputAction:
          nextFocus != null ? TextInputAction.next : textInputAction,
      autofillHints: autofillHints,
      onFieldSubmitted: (v) {
        if (nextFocus != null) {
          FocusScope.of(context).requestFocus(nextFocus);
        } else if (onFieldSubmitted != null) {
          onFieldSubmitted!(v);
        }
      },
      validator: validator,
      style: const TextStyle(fontSize: 14, color: _kText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        filled: true,
        fillColor: _kFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Icon(icon, color: _kSubtext, size: 21),
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kError, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 11.5, color: _kError),
      ),
    );
  }
}

// ─── Phone field with country code ─────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final String selectedCode;
  final List<Map<String, String>> countryCodes;
  final ValueChanged<String> onCodeChanged;

  const _PhoneField({
    required this.controller,
    this.focusNode,
    this.nextFocus,
    required this.selectedCode,
    required this.countryCodes,
    required this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.telephoneNumber],
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onFieldSubmitted: (_) {
        if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
      },
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please enter your phone number';
        if (v.length < 7) return 'Enter a valid phone number';
        return null;
      },
      style: const TextStyle(fontSize: 14, color: _kText),
      decoration: InputDecoration(
        hintText: '712 345 678',
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
        filled: true,
        fillColor: _kFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCode,
              icon: const Icon(Icons.arrow_drop_down_rounded,
                  color: _kSubtext, size: 20),
              isDense: true,
              style: const TextStyle(
                color: _kText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              onChanged: (v) {
                if (v != null) onCodeChanged(v);
              },
              items: [
                for (final c in countryCodes)
                  DropdownMenuItem(
                    value: c['code'],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('${c['flag']} ${c['code']}'),
                    ),
                  )
              ],
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kError, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kError, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 11.5, color: _kError),
      ),
    );
  }
}

// ─── Password Strength Meter ────────────
class _PasswordStrengthMeter extends StatelessWidget {
  final _PasswordStrength strength;
  const _PasswordStrengthMeter({required this.strength});

  @override
  Widget build(BuildContext context) {
    final color = _strengthColor(strength);
    final filled = _strengthSegments(strength);
    final label = _strengthLabel(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
                height: 5,
                decoration: BoxDecoration(
                  color: i < filled ? color : _kBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.shield_rounded, size: 13, color: color),
            const SizedBox(width: 5),
            Text(
              'Password strength: $label',
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Terms row ───────
class _TermsRow extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onTermsTap;

  const _TermsRow({
    required this.isChecked,
    required this.onChanged,
    required this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isChecked,
              onChanged: onChanged,
              checkColor: Colors.white,
              activeColor: _kGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              side: const BorderSide(color: Color(0xFF9CA3AF), width: 1.5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'I have read and agree to the Jaguza Livestock ',
                    style: TextStyle(
                      fontSize: 13,
                      color: _kSubtext,
                      height: 1.5,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: onTermsTap,
                      child: const Text(
                        'Terms & Conditions',
                        style: TextStyle(
                          fontSize: 13,
                          color: _kGreen,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: _kGreen,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(
                    text: ' and Privacy Policy.',
                    style: TextStyle(
                      fontSize: 13,
                      color: _kSubtext,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Register button ─
class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _RegisterButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _kPrimary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _kPrimary.withOpacity(0.6),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
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
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CREATE ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ],
              ),
      ),
    );
  }
}