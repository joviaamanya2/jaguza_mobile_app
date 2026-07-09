import 'package:flutter/material.dart';

class BrucellosisDetail extends StatelessWidget {
  const BrucellosisDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Brucellosis',
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
                  Icons.coronavirus_rounded,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Brucellosis',
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
              'Brucellosis is a highly contagious bacterial disease caused by bacteria of the genus Brucella. In cattle, the disease is primarily caused by Brucella abortus and is characterized by reproductive failure, including abortions, retained placentas, and infertility. Brucellosis is a significant zoonotic disease, meaning it can be transmitted from animals to humans, making it a major public health concern in livestock-rearing communities.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The bacteria have a high affinity for the reproductive tract, particularly the placenta, uterus, and mammary glands. They also localize in the joints, bursae, and lymph nodes. Brucella organisms are shed in milk, uterine fluids, and aborted fetal tissues, making these the primary sources of infection for other animals and humans.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Brucellosis leads to significant economic losses through abortion storms, reduced milk production, infertility, and the cost of control and eradication programs. The disease also creates international trade barriers for affected countries and regions. The chronic nature of the infection makes it difficult to eliminate from herds without comprehensive testing and vaccination programs.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'SYMPTOMS IN CATTLE',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Abortion during the second half of pregnancy (5-7 months)\n• Retention of fetal membranes (retained placenta)\n• Infertility and poor conception rates\n• Swollen, painful joints (arthritis) in chronic cases\n• Reduced milk production\n• Weak or stillborn calves\n• Swollen testicles in bulls (orchitis)\n• Decreased bull fertility\n• Weight loss and poor condition',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'SYMPTOMS IN HUMANS (Zoonotic)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Fever (undulant fever with recurring spikes)\n• Severe headaches and muscle pain\n• Sweating (especially at night)\n• Weakness and fatigue\n• Joint pain (arthralgia)\n• Weight loss\n• Swollen lymph nodes\n• In severe cases, endocarditis and meningitis',
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
              '• Ingestion of contaminated feed, water, or pastures\n• Direct contact with aborted fetuses or fetal fluids\n• Through the placenta during pregnancy\n• Drinking infected milk (especially in calves)\n• Through mucous membranes and broken skin\n• Artificial insemination with infected semen\n• Contact with infected udder tissue during milking',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'DIAGNOSIS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Serological tests (Rose Bengal test, ELISA)\n• Milk ring test (to detect antibodies in milk)\n• Culture and identification from aborted tissues\n• Complement fixation test\n• PCR testing for accurate diagnosis\n• History of reproductive problems in the herd',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'TREATMENT & CONTROL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Vaccination with Strain 19 (heifers) or RB51 vaccine\n• Test and slaughter programs for infected animals\n• Quarantine of infected herds\n• Proper disposal of aborted fetuses and placentas\n• Disinfection of contaminated areas\n• Regular herd testing and monitoring\n• Use of artificial insemination from Brucella-free bulls\n• Avoid mixing infected and clean herds',
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
              '• Vaccinate replacement heifers between 4-8 months of age\n• Implement a strict biosecurity protocol\n• Quarantine new animals before introduction\n• Regular screening and testing of the herd\n• Use separate calving areas for infected animals\n• Practice good hygiene (wear gloves, wash hands)\n• Avoid feeding unpasteurized milk to calves\n• Report abortion cases to veterinary authorities',
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
                          'Cattle, goats, sheep, and pigs',
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
                    Icons.warning_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zoonotic Risk',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'High risk for farmers, vets, and dairy workers',
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
                    Icons.vaccines_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Key Control Measure',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Vaccination of heifers + test and slaughter',
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