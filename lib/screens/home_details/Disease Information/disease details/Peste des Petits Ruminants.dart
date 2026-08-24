import 'package:flutter/material.dart';

class PPRDetail extends StatelessWidget {
  const PPRDetail({super.key});

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
          'PPR',
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
            Text('Peste des Petits Ruminants (PPR)', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Peste des Petits Ruminants (PPR), also known as goat plague or ovine rinderpest, is a highly contagious and often fatal viral disease affecting small ruminants, particularly goats and sheep. The disease is caused by the PPR virus (PPRV), which belongs to the genus Morbillivirus in the family Paramyxoviridae, closely related to rinderpest and measles viruses.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'PPR is characterized by fever, erosive stomatitis, conjunctivitis, gastroenteritis, and pneumonia. It is one of the most devastating diseases of small ruminants in Africa, the Middle East, and Asia, causing significant economic losses and threatening food security and livelihoods of millions of smallholder farmers.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The disease spreads rapidly through direct contact between infected and susceptible animals, via aerosol transmission, and through contaminated feed and water. The mortality rate can be as high as 50-80% in naive populations, making PPR a major constraint to sheep and goat production in endemic areas. The disease is notifiable and has been targeted for global eradication.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• High fever (40-41°C) in early stages\n• Severe depression and weakness\n• Nasal discharge (initially watery, then thick and crusty)\n• Eye discharge (conjunctivitis)\n• Mouth ulcers and erosions on gums, cheeks, and tongue\n• Excessive salivation (drooling)\n• Diarrhea (often foul-smelling and contains blood or mucus)\n• Severe dehydration and weight loss\n• Difficulty breathing and coughing\n• Abortion in pregnant animals\n• High mortality in young animals',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Direct contact with infected animals (respiratory droplets)\n• Aerosol transmission through coughing and sneezing\n• Contact with contaminated feed, water, and bedding\n• Infected secretions (nasal, ocular, and oral discharges)\n• Infected feces and urine\n• Survival of virus in the environment for several days\n• Movement of infected animals between herds\n• Wildlife reservoirs (certain wild ungulates)',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• RT-PCR testing for viral RNA detection\n• Virus isolation in cell culture\n• ELISA for antigen or antibody detection\n• Serological testing (competitive ELISA - cELISA)\n• Post-mortem examination with tissue sampling\n• Clinical signs and epidemiology\n• Differential diagnosis from other diseases (e.g., FMD, bluetongue, contagious ecthyma)',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• No specific treatment for PPR virus\n• Supportive care to prevent secondary infections\n• Antibiotics to manage secondary bacterial infections\n• Provide clean water to prevent dehydration\n• Offer palatable and nutritious feed\n• Use anti-inflammatory drugs to reduce fever\n• Isolate infected animals immediately\n• Implement strict quarantine measures\n• Culling of severely affected animals\n• Proper disposal of carcasses',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION & CONTROL', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Vaccination is the most effective control measure\n• Use live attenuated vaccines (PPR vaccine provides lifelong immunity)\n• Vaccinate all susceptible animals annually\n• Implement mass vaccination campaigns in endemic areas\n• Maintain strict biosecurity protocols\n• Quarantine new or returning animals for 21 days\n• Restrict animal movement from infected areas\n• Practice all-in-all-out management\n• Regular monitoring and surveillance\n• Report suspected cases immediately to veterinary authorities\n• Participate in national and international eradication programs',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('GLOBAL ERADICATION EFFORTS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              'PPR has been identified by FAO and OIE as a target for global eradication by 2030. The success of the rinderpest eradication program has provided a framework for PPR control. Key strategies include mass vaccination campaigns, improved surveillance, movement control, and community engagement. The goal is to eliminate the disease worldwide, reducing its impact on smallholder farmers and ensuring food security.',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Goats and sheep (rarely cattle)',
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
              icon: Icons.biotech_rounded,
              label: 'Caused By',
              value: 'PPR virus (Morbillivirus genus)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.monetization_on_rounded,
              label: 'Economic Impact',
              value: 'Mortality 50-80% in naive populations',
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
