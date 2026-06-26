// lib/disease_details/foot_mouth_detail_screen.dart
import 'package:flutter/material.dart';

class FootMouthDetailScreen extends StatelessWidget {
  const FootMouthDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Foot-and-Mouth Disease'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Add your specific images, text, and treatments here
            const Text(
              'Symptoms & Diagnosis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF1A1F36)),
            ),
            const SizedBox(height: 16),
            const Text(
              'This is where you put the specific details for Foot-and-Mouth disease. You can add images, bullet points for symptoms, and treatment plans.',
              style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}