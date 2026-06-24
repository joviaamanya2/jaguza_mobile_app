import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E7B4E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last Updated Text
                  Text(
                    'Last updated: January 15, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Introduction
                  _buildSectionTitle('1. Introduction'),
                  _buildParagraph(
                    'Welcome to Jaguza Livestock ("we," "our," or "us"). By accessing or using our mobile application, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, you must not use our app.'
                  ),
                  const SizedBox(height: 20),

                  // Acceptance of Terms
                  _buildSectionTitle('2. Acceptance of Terms'),
                  _buildParagraph(
                    'By creating an account, logging in, or using the Jaguza Livestock app, you acknowledge that you have read, understood, and agree to be bound by these Terms and Conditions in their entirety.'
                  ),
                  const SizedBox(height: 20),

                  // User Accounts
                  _buildSectionTitle('3. User Accounts'),
                  _buildParagraph(
                    'To access certain features, you may be required to register for an account. You are responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.'
                  ),
                  const SizedBox(height: 20),

                  // Use of Service
                  _buildSectionTitle('4. Use of Service'),
                  _buildParagraph(
                    'Jaguza Livestock provides tools for livestock tracking, health monitoring, GPS location mapping, and AI-powered analytics. You agree to use the app only for lawful purposes and in accordance with these terms. You must not misuse the app by attempting to access unauthorized areas or interfere with its proper functioning.'
                  ),
                  const SizedBox(height: 20),

                  // Data and Privacy
                  _buildSectionTitle('5. Data and Privacy'),
                  _buildParagraph(
                    'Your privacy is important to us. Our collection and use of personal information, including livestock data and location tracking, is governed by our Privacy Policy, which is incorporated into these Terms by reference. By using the app, you consent to the collection and use of your information as outlined in the Privacy Policy.'
                  ),
                  const SizedBox(height: 20),

                  // Intellectual Property
                  _buildSectionTitle('6. Intellectual Property'),
                  _buildParagraph(
                    'All content, features, and functionality of the Jaguza Livestock app—including but not limited to text, graphics, logos, icons, images, audio clips, digital downloads, and software—are the exclusive property of Jaguza Livestock and are protected by international copyright, trademark, and other intellectual property laws.'
                  ),
                  const SizedBox(height: 20),

                  // Limitation of Liability
                  _buildSectionTitle('7. Limitation of Liability'),
                  _buildParagraph(
                    'In no event shall Jaguza Livestock, its directors, employees, partners, agents, suppliers, or affiliates be liable for any indirect, incidental, special, consequential, or punitive damages, including loss of profits, data, or livestock, resulting from your access to or use of (or inability to access or use) the app.'
                  ),
                  const SizedBox(height: 20),

                  // Changes to Terms
                  _buildSectionTitle('8. Changes to Terms'),
                  _buildParagraph(
                    'We reserve the right to modify or replace these Terms at any time. If a revision is material, we will provide at least 30 days\' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion.'
                  ),
                  const SizedBox(height: 20),

                  // Contact Information
                  _buildSectionTitle('9. Contact Information'),
                  _buildParagraph(
                    'If you have any questions about these Terms and Conditions, please contact us at:'
                  ),
                  const SizedBox(height: 8),
                  _buildContactInfo('Email: legal@jaguzalivestock.com'),
                  _buildContactInfo('Phone: +256 XXX XXX XXX'),
                  _buildContactInfo('Address: Kampala, Uganda'),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Bottom Accept Button
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A1A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // Handle acceptance logic here (e.g., save to SharedPreferences)
                  Navigator.pop(context); // Go back to previous screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms accepted successfully.'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Color(0xFF1E7B4E),
                    ),
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ACCEPT & CONTINUE',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.check_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Widget Builders ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A1F36),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF6B7280),
        height: 1.6,
      ),
    );
  }

  Widget _buildContactInfo(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF1E7B4E),
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
      ),
    );
  }
}