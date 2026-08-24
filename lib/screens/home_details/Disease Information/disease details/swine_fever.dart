import 'package:flutter/material.dart';

class AfricanSwineFeverDetail extends StatelessWidget {
  const AfricanSwineFeverDetail({super.key});

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
          'African Swine Fever',
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
                  Icons.warning_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('African Swine Fever (ASF)', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'African Swine Fever (ASF) is a highly contagious and often fatal viral disease affecting domestic pigs and wild boar. It is caused by the African Swine Fever Virus (ASFV), a large DNA virus that is the only member of the Asfaviridae family. The disease is characterized by high fever, hemorrhagic lesions, and high mortality rates, often approaching 100% in susceptible pig populations.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'ASF is endemic in sub-Saharan Africa and has spread to Europe, Asia, and other regions in recent years, causing devastating losses to the global pig industry. The virus is remarkably stable in the environment, able to survive for long periods in pig pens, meat products, and even animal feed. This stability makes control and eradication extremely challenging.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Unlike classical swine fever, ASF is not related to the pestivirus that causes CSF. The disease has significant implications for food security, international trade, and rural livelihoods. There is currently no vaccine available for ASF, making strict biosecurity and early detection the most critical control measures.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• High fever (40-42°C) in early stages\n• Loss of appetite and depression\n• Incoordination and difficulty walking (ataxia)\n• Vomiting and diarrhea (sometimes bloody)\n• Reddening of the skin (especially on ears, snout, and legs)\n• Hemorrhages (bleeding) under the skin\n• Difficulty breathing (respiratory distress)\n• Abortion in pregnant sows\n• Bleeding from nose, rectum, or injection sites\n• High mortality (often approaching 100%)\n• Sudden death without apparent clinical signs',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Direct contact with infected pigs (blood, saliva, feces, urine)\n• Indirect contact with contaminated objects (fomites)\n• Feeding contaminated feed (especially swill/garbage containing infected pork)\n• Biological vectors: soft ticks (Ornithodoros species)\n• Contact with infected wild boar or warthogs\n• Contaminated equipment, clothing, and vehicles\n• Virus survival in pork products for months\n• Aerosol transmission over short distances',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('CLINICAL FORMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Peracute form: Sudden death without clinical signs\n• Acute form: High fever, skin hemorrhages, and high mortality\n• Subacute form: Less severe signs, recovery in some pigs\n• Chronic form: Intermittent fever, skin ulcers, arthritis, and poor growth',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• PCR testing for viral DNA detection\n• Virus isolation in cell culture\n• ELISA for antibody detection (serology)\n• Indirect immunofluorescent test\n• Post-mortem examination and tissue sampling\n• Clinical signs and high mortality patterns\n• Differential diagnosis from Classical Swine Fever (CSF)',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('POST-MORTEM LESIONS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Enlarged, dark, and hemorrhagic spleen\n• Hemorrhagic lymph nodes (especially in the head region)\n• Petechial hemorrhages on kidneys and bladder\n• Hemorrhages on the liver and other organs\n• Fluid accumulation in body cavities\n• Respiratory system congestion and hemorrhage',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• No specific treatment or vaccine available\n• Immediate reporting to veterinary authorities\n• Stamp out policy: humane culling of infected and exposed pigs\n• Strict quarantine of affected premises\n• Disposal of carcasses (burning or deep burial with lime)\n• Cleaning and disinfection of premises\n• Vector control for ticks\n• Implementation of biosecurity measures',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION & CONTROL', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Implement strict biosecurity protocols on farms\n• Ban feeding of swill/garbage containing pork products\n• Control movement of pigs and vehicles\n• Maintain separate clothing and equipment for different areas\n• Regular cleaning and disinfection\n• Quarantine new animals for 30 days\n• Surveillance and early detection systems\n• Control of wild boar and tick populations\n• Public awareness campaigns\n• Comply with national ASF control policies\n• Participate in regional control programs',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('GLOBAL IMPACT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              'The global spread of ASF has caused unprecedented losses in the pig industry. China, the world\'s largest pig producer, lost approximately 50% of its pig population in the 2018-2019 outbreak. The disease has spread to Europe, the Americas, and continues to threaten countries worldwide. Control efforts have led to trade restrictions, significant economic losses, and disruption of global pork supply chains.',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Domestic pigs and wild boar',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.warning_rounded,
              label: 'Notifiable Disease',
              value: 'Must be reported immediately to authorities',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.biotech_rounded,
              label: 'Caused By',
              value: 'African Swine Fever Virus (ASFV)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.bloodtype_rounded,
              label: 'Mortality Rate',
              value: 'Up to 100% in susceptible pigs',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.vaccines_rounded,
              label: 'Available Treatment',
              value: 'No vaccine or specific treatment available',
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
