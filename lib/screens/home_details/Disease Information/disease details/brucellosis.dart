import 'package:flutter/material.dart';

class BrucellosisDetail extends StatelessWidget {
  const BrucellosisDetail({super.key});

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
          'Brucellosis',
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
            Text('Brucellosis', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Brucellosis is a highly contagious bacterial disease caused by bacteria of the genus Brucella. In cattle, the disease is primarily caused by Brucella abortus and is characterized by reproductive failure, including abortions, retained placentas, and infertility. Brucellosis is a significant zoonotic disease, meaning it can be transmitted from animals to humans, making it a major public health concern in livestock-rearing communities.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The bacteria have a high affinity for the reproductive tract, particularly the placenta, uterus, and mammary glands. They also localize in the joints, bursae, and lymph nodes. Brucella organisms are shed in milk, uterine fluids, and aborted fetal tissues, making these the primary sources of infection for other animals and humans.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Brucellosis leads to significant economic losses through abortion storms, reduced milk production, infertility, and the cost of control and eradication programs. The disease also creates international trade barriers for affected countries and regions. The chronic nature of the infection makes it difficult to eliminate from herds without comprehensive testing and vaccination programs.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS IN CATTLE', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Abortion during the second half of pregnancy (5-7 months)\n• Retention of fetal membranes (retained placenta)\n• Infertility and poor conception rates\n• Swollen, painful joints (arthritis) in chronic cases\n• Reduced milk production\n• Weak or stillborn calves\n• Swollen testicles in bulls (orchitis)\n• Decreased bull fertility\n• Weight loss and poor condition',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS IN HUMANS (Zoonotic)', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Fever (undulant fever with recurring spikes)\n• Severe headaches and muscle pain\n• Sweating (especially at night)\n• Weakness and fatigue\n• Joint pain (arthralgia)\n• Weight loss\n• Swollen lymph nodes\n• In severe cases, endocarditis and meningitis',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Ingestion of contaminated feed, water, or pastures\n• Direct contact with aborted fetuses or fetal fluids\n• Through the placenta during pregnancy\n• Drinking infected milk (especially in calves)\n• Through mucous membranes and broken skin\n• Artificial insemination with infected semen\n• Contact with infected udder tissue during milking',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Serological tests (Rose Bengal test, ELISA)\n• Milk ring test (to detect antibodies in milk)\n• Culture and identification from aborted tissues\n• Complement fixation test\n• PCR testing for accurate diagnosis\n• History of reproductive problems in the herd',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & CONTROL', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Vaccination with Strain 19 (heifers) or RB51 vaccine\n• Test and slaughter programs for infected animals\n• Quarantine of infected herds\n• Proper disposal of aborted fetuses and placentas\n• Disinfection of contaminated areas\n• Regular herd testing and monitoring\n• Use of artificial insemination from Brucella-free bulls\n• Avoid mixing infected and clean herds',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Vaccinate replacement heifers between 4-8 months of age\n• Implement a strict biosecurity protocol\n• Quarantine new animals before introduction\n• Regular screening and testing of the herd\n• Use separate calving areas for infected animals\n• Practice good hygiene (wear gloves, wash hands)\n• Avoid feeding unpasteurized milk to calves\n• Report abortion cases to veterinary authorities',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Cattle, goats, sheep, and pigs',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.warning_rounded,
              label: 'Zoonotic Risk',
              value: 'High risk for farmers, vets, and dairy workers',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.vaccines_rounded,
              label: 'Key Control Measure',
              value: 'Vaccination of heifers + test and slaughter',
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
