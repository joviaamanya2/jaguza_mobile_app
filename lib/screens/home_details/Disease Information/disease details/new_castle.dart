import 'package:flutter/material.dart';

class NewcastleDiseaseDetail extends StatelessWidget {
  const NewcastleDiseaseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Newcastle Disease',
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
              'Newcastle Disease',
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
              'Newcastle Disease (ND) is a highly contagious and often fatal viral disease affecting poultry and many other bird species. It is caused by the Avian paramyxovirus type 1 (APMV-1) and is considered one of the most important viral diseases of poultry worldwide. The disease affects chickens, turkeys, pigeons, and many wild birds.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The severity of Newcastle Disease varies depending on the virulence of the strain. There are three main pathotypes: Velogenic (highly virulent) causes high mortality with nervous and respiratory signs; Mesogenic (moderately virulent) causes primarily respiratory signs; and Lentogenic (low virulence) causes mild respiratory signs or no symptoms at all.',
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF555555),
                height: 1.6,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              'The disease is characterized by respiratory distress, nervous signs (tremors, paralysis), and digestive issues. It is a major threat to the poultry industry and is notifiable to veterinary authorities due to its devastating economic impact and trade restrictions.',
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
              '• Respiratory signs: gasping, coughing, sneezing, nasal discharge\n• Nervous signs: tremors, head twisting, paralysis of wings and legs\n• Greenish-yellow watery diarrhea\n• Swelling of the head and neck (in some strains)\n• Drooping wings and inability to stand\n• Reduced or complete loss of appetite\n• Sudden death without prior signs (highly virulent strains)\n• Decreased egg production and abnormal egg shape\n• Depression and lethargy',
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
              '• Direct contact with infected birds (droppings, respiratory secretions)\n• Airborne transmission through droplets\n• Contaminated feed, water, and bedding\n• Infected equipment and footwear\n• Wild birds (carriers)\n• Movement of infected or carrier birds\n• Virus can survive weeks in contaminated environments',
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
              '• RT-PCR testing for viral RNA identification\n• Virus isolation in embryonated chicken eggs\n• Serological tests (ELISA, HI test)\n• Tissue sampling for laboratory confirmation\n• Clinical signs and mortality pattern analysis\n• Testing of paired serum samples for rising antibody titers',
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
              '• No specific treatment for viral infection\n• Supportive care with antibiotics to prevent secondary infections\n• Ensure clean water and electrolytes to prevent dehydration\n• Provide easily digestible and nutritious feed\n• Isolate infected birds immediately\n• Culling and proper disposal of severely affected flocks\n• Maintain good ventilation to reduce respiratory distress\n• Heat stress management in affected birds',
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
              '• Vaccination is the most effective control method (B1 strain, Lasota strain)\n• Vaccinate at 7-10 days, then booster at 3-4 weeks\n• Use live or inactivated vaccines as recommended\n• Maintain strict biosecurity measures\n• Control wild bird access to poultry houses\n• Quarantine new birds for 14-30 days\n• Disinfect equipment, housing, and transport vehicles\n• Implement all-in-all-out flock management\n• Regular monitoring and surveillance\n• Report suspected cases immediately to veterinary authorities',
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
                          'Chickens, turkeys, pigeons, wild birds',
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
                          'Notifiable Disease',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Must be reported to veterinary authorities',
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
                          'Key Prevention Method',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Vaccination and strict biosecurity',
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
                          'Caused By',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Avian paramyxovirus type 1 (APMV-1)',
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