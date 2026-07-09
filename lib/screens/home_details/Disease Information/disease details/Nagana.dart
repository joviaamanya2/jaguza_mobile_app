import 'package:flutter/material.dart';

class NaganaDetail extends StatelessWidget {
  const NaganaDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Nagana',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simple flat illustration replacement
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: const Icon(
                  Icons.bedtime_rounded,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Nagana (Sleeping Sickness)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A1A),
                height: 1.3,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Section Label
            const Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Body Text
            const Text(
              'Nagana, also known as animal trypanosomiasis, is a parasitic disease caused by protozoan parasites of the genus Trypanosoma. It primarily affects livestock and is a major constraint on agricultural production in sub-Saharan Africa.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The disease is transmitted biologically by the bite of the tsetse fly. Once injected into the animal\'s bloodstream, the parasites multiply and spread, leading to severe systemic damage.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Infected animals exhibit intermittent fever, severe anemia, progressive weight loss, and extreme lethargy—hence the name "sleeping sickness." If left untreated, the condition is usually fatal.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Simple plain info row without shadows
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.pets_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Most Common In',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Cattle, sheep, goats, and pigs',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.bug_report_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Transmitted By',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tsetse fly (Glossina species)',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF777777),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}