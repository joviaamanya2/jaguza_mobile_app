import 'package:flutter/material.dart';

class UlcerativeMammillitisDetail extends StatelessWidget {
  const UlcerativeMammillitisDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Ulcerative Mammillitis',
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
                  Icons.medical_services_rounded,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Ulcerative Mammillitis',
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
              'Ulcerative Mammillitis is a painful viral disease affecting the teats and udder skin of dairy cattle. It is caused by a herpesvirus (Bovine Herpesvirus 2 - BoHV-2) that is closely related to the human herpes simplex virus. The disease is characterized by the development of painful ulcers and scabs on the teats, which can significantly impact milking operations and animal welfare.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The virus infects the epithelial cells of the skin, causing cell death and the formation of characteristic blister-like lesions that quickly ulcerate. The disease is particularly problematic because the lesions are extremely painful, making milking difficult and stressful for both the cow and the milker. Secondary bacterial infections often complicate the condition.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Although the disease is usually self-limiting and resolves within 2-4 weeks, the economic impact can be significant due to reduced milk production, increased milking time, risk of mastitis, and the cost of treatment. The condition is more common in the winter months and can spread rapidly through a herd via contaminated milking equipment and hands.',
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
              '• Blister-like lesions on the teats that quickly ulcerate\n• Painful, weeping ulcers with raised edges\n• Scab formation over healing ulcers\n• Swelling and inflammation of the teat skin\n• Redness and heat around affected areas\n• Reluctance to be milked due to pain\n• Reduced milk production\n• Secondary bacterial infections (mastitis)\n• Lesions may affect one or multiple teats',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'TRANSMISSION',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Direct contact with infected teats\n• Contaminated milking equipment and liners\n• Milkers\' hands carrying the virus\n• Contaminated bedding and environment\n• Insect vectors (flies) may spread the virus\n• Virus can survive in the environment for several days\n• Stress and poor hygiene increase susceptibility',
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
              '• Topical antiseptic creams to prevent secondary infection\n• Antibiotic ointments for bacterial complications\n• Pain relief medications to reduce discomfort\n• Emollient teat dips (lanolin, glycerin) to soothe and moisturize\n• Switch to once-a-day milking to reduce trauma\n• Hand-milk affected cows gently\n• Provide clean, dry bedding to minimize contamination\n• Maintain proper milking hygiene practices\n• In severe cases, oral antibiotics may be prescribed',
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
              '• Use proper milking techniques to minimize teat damage\n• Regularly clean and sanitize milking equipment\n• Use disposable gloves during milking\n• Apply high-quality teat dip after milking\n• Isolate infected cows during the acute phase\n• Maintain excellent bedding hygiene\n• Reduce stress factors (overcrowding, poor ventilation)\n• Use fly control measures to reduce transmission\n• Feed a balanced diet to boost immunity\n• Monitor herd regularly for early detection',
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
                    Icons.biotech_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Caused By',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bovine Herpesvirus 2 (BoHV-2)',
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
                    Icons.timer_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recovery Time',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '2-4 weeks with proper management',
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