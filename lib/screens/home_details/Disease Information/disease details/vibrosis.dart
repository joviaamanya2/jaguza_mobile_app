import 'package:flutter/material.dart';

class VibriosisDetail extends StatelessWidget {
  const VibriosisDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Vibriosis',
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
                  Icons.bug_report_rounded,
                  size: 60,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Vibriosis (Campylobacteriosis) in Cattle',
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
              'Vibriosis, also known as Campylobacteriosis, is a contagious bacterial disease of cattle caused by Campylobacter fetus subsp. fetus (formerly Vibrio fetus). The disease primarily affects the reproductive system, causing infertility, early embryonic death, and abortion in cows. It is a significant cause of reproductive failure in cattle herds worldwide and is responsible for substantial economic losses in the livestock industry.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The bacteria colonize the reproductive tract, particularly the uterus, cervix, and vagina. In bulls, the organism resides in the prepuce and is transmitted during natural breeding. The disease is insidious in nature, often going unnoticed until breeding problems become apparent through extended calving intervals and reduced pregnancy rates.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'Campylobacter fetus is a fragile organism that survives poorly in the environment but is well adapted to the reproductive tract environment. The disease is often introduced into a herd through the purchase of infected bulls or cows, making biosecurity and quarantine measures essential for prevention.',
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
              '• Early embryonic death (0-45 days of gestation)\n• Irregular return to estrus (cycling)\n• Extended calving intervals\n• Reduced pregnancy rates (conception failure)\n• Varying degrees of infertility\n• Abortion in mid to late pregnancy (less common)\n• Mild endometritis in some cows\n• Asymptomatic bulls (carriers without clinical signs)\n• Poor conception in heifers and cows\n• Reduced overall herd reproductive performance',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'SYMPTOMS IN BULLS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Usually no clinical signs\n• Asymptomatic carriers\n• Organisms present in the prepuce and semen\n• Can shed bacteria for months or years\n• No visible lesions or reproductive dysfunction\n• Serves as the primary reservoir in the herd',
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
              '• Venereal transmission during natural breeding\n• Infected bulls serving multiple cows\n• Introduction of infected breeding animals\n• Artificial insemination with infected semen\n• Contaminated breeding equipment\n• Contact with infected fetal membranes\n• Organisms survive in the prepuce of bulls for long periods',
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
              '• Culture and isolation of Campylobacter from samples\n• Preputial scraping or aspiration in bulls\n• Vaginal mucus culture in cows\n• Fetal abomasal contents and placental samples\n• Serological tests (ELISA, agglutination tests)\n• Serum bactericidal antibody tests\n• History of infertility and reproductive failure in the herd\n• PCR testing for rapid and accurate identification',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'TREATMENT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Antibiotic treatment with procaine penicillin\n• Streptomycin and dihydrostreptomycin injections\n• Oxytetracycline administration\n• Intrauterine antibiotic infusion in cows\n• Treat bulls with antibiotics (two courses)\n• Restrict bulls from breeding during treatment\n• Antibiotic treatment may require multiple courses\n• Retest bulls after treatment to confirm clearance',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'PREVENTION & CONTROL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Use artificial insemination instead of natural breeding\n• Quarantine new animals for 30-60 days\n• Test breeding bulls for Campylobacter infection\n• Vaccination of cows and heifers\n• Use commercial vaccines (available in many countries)\n• Maintain closed herd status when possible\n• Cull persistently infected bulls\n• Use only approved AI stud bulls\n• Regular health monitoring of breeding animals\n• Good hygiene and sanitation in breeding facilities',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.8,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Section Label
            const Text(
              'ECONOMIC IMPACT',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2E7D32),
                letterSpacing: 1.2,
              ),
            ),
            
            const SizedBox(height: 12),
            
            const Text(
              '• Increased calving intervals (extended days open)\n• Reduced pregnancy rates (10-15% reduction)\n• Loss of calves through embryonic death\n• Cost of diagnosis and treatment\n• Cost of culling and replacing infected animals\n• Lost breeding opportunities\n• Extended time to achieve herd reproduction targets\n• Decreased overall herd productivity',
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
                          'Beef and dairy cattle (breeding herds)',
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
                    Icons.male_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Primary Reservoir',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bulls (asymptomatic carriers)',
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
                          'Campylobacter fetus subsp. fetus',
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
                          'Key Control Method',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Vaccination + AI + infected bull culling',
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