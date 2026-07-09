import 'package:flutter/material.dart';

// ─── Theme constants ──────────────────────────────────────────────────────────
const _kGreen = Color(0xFF2E7D32);
const _kGreenLight = Color(0xFF2E7D32);
const _kGreenFaint = Color(0xFF2E7D32);
const _kText = Color(0xFF1A1F36);
const _kSubtext = Color(0xFF6B7280);
const _kBorder = Color(0xFFE8EDF2);

/// [fromSignup] — when true, tapping "Accept & Continue" pops with `true`
/// so the signup screen can automatically check the checkbox.
class TermsAndConditionsScreen extends StatefulWidget {
  final bool fromSignup;
  const TermsAndConditionsScreen({super.key, this.fromSignup = false});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final _scrollCtrl = ScrollController();
  bool _hasScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.atEdge && _scrollCtrl.position.pixels > 0) {
      if (!_hasScrolledToBottom) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  void _handleAccept() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Terms accepted successfully.'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _kGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    if (widget.fromSignup) {
      Navigator.pop(context, true); // Return true to signup screen
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          _buildHeader(context),

          // ── Scrollable content ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last updated badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _kGreenFaint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 12, color: _kGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Last updated: January 15, 2025',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: _kGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Intro blurb
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _kGreenFaint,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kGreen.withValues(alpha: 0.18)),
                    ),
                    child: const Text(
                      'Please read these Terms & Conditions carefully before creating an account or using the Jaguza Livestock app. By using our services, you agree to these terms.',
                      style: TextStyle(
                        fontSize: 13.5,
                        color: _kText,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildSection(
                    number: '1',
                    title: 'Introduction',
                    icon: Icons.info_outline_rounded,
                    body:
                        'Welcome to Jaguza Livestock ("we," "our," or "us"). By accessing or using our mobile application, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our app.',
                  ),

                  _buildSection(
                    number: '2',
                    title: 'Acceptance of Terms',
                    icon: Icons.handshake_outlined,
                    body:
                        'By creating an account, logging in, or using the Jaguza Livestock app, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions in their entirety.',
                  ),

                  _buildSection(
                    number: '3',
                    title: 'User Accounts',
                    icon: Icons.person_outline_rounded,
                    body:
                        'To access certain features, you may be required to register for an account. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.',
                  ),

                  _buildSection(
                    number: '4',
                    title: 'Use of Service',
                    icon: Icons.apps_rounded,
                    body:
                        'Jaguza Livestock provides tools for livestock tracking, health monitoring, GPS location mapping, and AI-powered analytics. You agree to use the app only for lawful purposes and in accordance with these terms. You must not misuse the app by attempting to access unauthorized areas or interfere with its proper functioning.',
                  ),

                  _buildSection(
                    number: '5',
                    title: 'Data and Privacy',
                    icon: Icons.shield_outlined,
                    body:
                        'Your privacy is important to us. Our collection and use of personal information, including livestock data and location tracking, is governed by our Privacy Policy, which is incorporated into these Terms by reference. By using the app, you consent to the collection and use of your information as outlined in the Privacy Policy.',
                  ),

                  _buildSection(
                    number: '6',
                    title: 'Intellectual Property',
                    icon: Icons.copyright_rounded,
                    body:
                        'All content, features, and functionality of the Jaguza Livestock app — including but not limited to text, graphics, logos, icons, images, audio clips, digital downloads, and software — are the exclusive property of Jaguza Livestock and are protected by international copyright, trademark, and other intellectual property laws.',
                  ),

                  _buildSection(
                    number: '7',
                    title: 'Limitation of Liability',
                    icon: Icons.gavel_rounded,
                    body:
                        'In no event shall Jaguza Livestock, its directors, employees, partners, agents, suppliers, or affiliates be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or livestock, resulting from your access to or use of (or inability to access or use) the app.',
                  ),

                  _buildSection(
                    number: '8',
                    title: 'Changes to Terms',
                    icon: Icons.edit_note_rounded,
                    body:
                        'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.',
                  ),

                  _buildSection(
                    number: '9',
                    title: 'Contact Information',
                    icon: Icons.contact_mail_outlined,
                    body:
                        'If you have any questions about these Terms and Conditions, please reach out to us:',
                    extra: Column(
                      children: [
                        _buildContactChip(Icons.email_outlined,
                            'legal@jaguzalivestock.com'),
                        const SizedBox(height: 8),
                        _buildContactChip(
                            Icons.phone_outlined, '+256 XXX XXX XXX'),
                        const SizedBox(height: 8),
                        _buildContactChip(
                            Icons.location_on_outlined, 'Kampala, Uganda'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Scroll hint
                  if (!_hasScrolledToBottom)
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Scroll down to read all terms',
                            style: TextStyle(
                              fontSize: 12,
                              color: _kSubtext,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: _kGreen, size: 22),
                        ],
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Bottom action bar ──────────────────────────────────────────────
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kGreen, _kGreenLight],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Jaguza Livestock App',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.description_outlined, color: Colors.white, size: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required IconData icon,
    required String body,
    Widget? extra,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _kBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: _kBorder, width: 1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _kGreenFaint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(icon, size: 17, color: _kGreen),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '$number. $title',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kText,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Section body
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: _kSubtext,
                      height: 1.65,
                    ),
                  ),
                  if (extra != null) ...[
                    const SizedBox(height: 14),
                    extra,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _kGreenFaint,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kGreen.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _kGreen),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: _kGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decline button (only shown when fromSignup)
          if (widget.fromSignup) ...[
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context, false),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kSubtext,
                  side: const BorderSide(color: _kBorder, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Accept button
          GestureDetector(
            onTap: _handleAccept,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [_kGreen, _kGreenLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _kGreen.withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ACCEPT & CONTINUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.check_circle_outline_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}