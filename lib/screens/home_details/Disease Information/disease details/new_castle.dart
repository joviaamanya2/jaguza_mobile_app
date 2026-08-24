import 'package:flutter/material.dart';

class NewcastleDiseaseDetail extends StatelessWidget {
  const NewcastleDiseaseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final headingStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: scheme.onSurface,
      height: 1.3,
    );
    final labelStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: scheme.primary,
      letterSpacing: 1.2,
    );
    final bodyStyle = TextStyle(
      fontSize: 15,
      color: scheme.onSurfaceVariant,
      height: 1.6,
    );
    final bodyStyleTight = bodyStyle.copyWith(height: 1.8);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Newcastle Disease',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onPrimary,
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
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.coronavirus_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('Newcastle Disease', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Newcastle Disease (ND) is a highly contagious and often fatal viral disease affecting poultry and many other bird species. It is caused by the Avian paramyxovirus type 1 (APMV-1) and is considered one of the most important viral diseases of poultry worldwide. The disease affects chickens, turkeys, pigeons, and many wild birds.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The severity of Newcastle Disease varies depending on the virulence of the strain. There are three main pathotypes: Velogenic (highly virulent) causes high mortality with nervous and respiratory signs; Mesogenic (moderately virulent) causes primarily respiratory signs; and Lentogenic (low virulence) causes mild respiratory signs or no symptoms at all.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The disease is characterized by respiratory distress, nervous signs (tremors, paralysis), and digestive issues. It is a major threat to the poultry industry and is notifiable to veterinary authorities due to its devastating economic impact and trade restrictions.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Respiratory signs: gasping, coughing, sneezing, nasal discharge\n• Nervous signs: tremors, head twisting, paralysis of wings and legs\n• Greenish-yellow watery diarrhea\n• Swelling of the head and neck (in some strains)\n• Drooping wings and inability to stand\n• Reduced or complete loss of appetite\n• Sudden death without prior signs (highly virulent strains)\n• Decreased egg production and abnormal egg shape\n• Depression and lethargy',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Direct contact with infected birds (droppings, respiratory secretions)\n• Airborne transmission through droplets\n• Contaminated feed, water, and bedding\n• Infected equipment and footwear\n• Wild birds (carriers)\n• Movement of infected or carrier birds\n• Virus can survive weeks in contaminated environments',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• RT-PCR testing for viral RNA identification\n• Virus isolation in embryonated chicken eggs\n• Serological tests (ELISA, HI test)\n• Tissue sampling for laboratory confirmation\n• Clinical signs and mortality pattern analysis\n• Testing of paired serum samples for rising antibody titers',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• No specific treatment for viral infection\n• Supportive care with antibiotics to prevent secondary infections\n• Ensure clean water and electrolytes to prevent dehydration\n• Provide easily digestible and nutritious feed\n• Isolate infected birds immediately\n• Culling and proper disposal of severely affected flocks\n• Maintain good ventilation to reduce respiratory distress\n• Heat stress management in affected birds',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Vaccination is the most effective control method (B1 strain, Lasota strain)\n• Vaccinate at 7-10 days, then booster at 3-4 weeks\n• Use live or inactivated vaccines as recommended\n• Maintain strict biosecurity measures\n• Control wild bird access to poultry houses\n• Quarantine new birds for 14-30 days\n• Disinfect equipment, housing, and transport vehicles\n• Implement all-in-all-out flock management\n• Regular monitoring and surveillance\n• Report suspected cases immediately to veterinary authorities',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Chickens, turkeys, pigeons, wild birds',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.warning_rounded,
              label: 'Notifiable Disease',
              value: 'Must be reported to veterinary authorities',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.vaccines_rounded,
              label: 'Key Prevention Method',
              value: 'Vaccination and strict biosecurity',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.bug_report_rounded,
              label: 'Caused By',
              value: 'Avian paramyxovirus type 1 (APMV-1)',
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final ColorScheme scheme;
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.scheme,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: scheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
