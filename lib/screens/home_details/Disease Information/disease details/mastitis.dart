import 'package:flutter/material.dart';

class MastitisDetail extends StatelessWidget {
  const MastitisDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Mastitis',
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
                  Icons.water_drop_rounded,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Mastitis in Cattle',
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
              'Mastitis is an inflammation of the mammary gland (udder) in cattle, primarily caused by bacterial infection. It is one of the most common and economically significant diseases affecting dairy cattle worldwide. The disease can be clinical (visible symptoms) or subclinical (no visible signs but reduced milk quality).',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The infection occurs when bacteria enter the teat canal, multiply in the mammary gland, and trigger an inflammatory response. The most common pathogens include Staphylococcus aureus, Streptococcus agalactiae, Streptococcus uberis, and Escherichia coli. Environmental factors such as poor hygiene, dirty bedding, and wet conditions significantly increase the risk of infection.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Mastitis results in reduced milk production, poor milk quality, changes in milk composition (increased somatic cell count), and in severe cases, can lead to systemic illness, udder damage, and even death. Subclinical mastitis is particularly problematic because it goes undetected and causes significant economic losses over time.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'SYMPTOMS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Swollen, hot, and painful udder quarters\n• Redness and inflammation of the udder\n• Abnormal milk appearance (clots, flakes, watery, or discolored)\n• Decreased milk production\n• Fever and elevated body temperature\n• Loss of appetite and depression\n• Dehydration and weakness\n• Reduced milk flow or difficulty milking\n• Cows may kick or resist milking due to pain',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'CAUSES & RISK FACTORS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Poor milking hygiene and contaminated equipment\n• Dirty or wet bedding and stalls\n• Incomplete milking leaving milk in the udder\n• High milk production making cows more susceptible\n• Damaged or cracked teats allowing bacterial entry\n• Nutritionally stressed or immunocompromised animals\n• Environmental contamination with manure and dirt\n• Poor ventilation leading to damp conditions',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'TREATMENT & MANAGEMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Administer appropriate intramammary antibiotics as prescribed by a veterinarian\n• Use anti-inflammatory drugs to reduce pain and swelling\n• Frequently strip affected quarters to remove infected milk\n• Isolate infected cows to prevent spread\n• Provide clean, dry, and comfortable bedding\n• Ensure adequate hydration and nutrition\n• Supportive therapy with fluids if the cow is showing signs of systemic illness',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'PREVENTION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Practice good milking hygiene (wash, dry, and disinfect teats)\n• Use clean, dry bedding in stalls and resting areas\n• Implement proper udder disinfection before and after milking\n• Regularly test for subclinical mastitis using somatic cell counts\n• Dry cow therapy at the end of lactation\n• Maintain clean and sanitized milking equipment\n• Ensure proper nutrition and supplementation\n• Vaccination against common bacterial pathogens\n• Implement culling of chronic or unresponsive cases',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Simple plain info rows without shadows
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
                          'Dairy cattle, especially high-yielding cows',
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
                    Icons.coronavirus_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Common Pathogens',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'S. aureus, Strep. agalactiae, E. coli',
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
                    Icons.monetization_on_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Economic Impact',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Reduced milk yield, milk discard, and treatment costs',
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