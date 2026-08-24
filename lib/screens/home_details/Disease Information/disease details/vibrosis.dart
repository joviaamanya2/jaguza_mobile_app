import 'package:flutter/material.dart';

class VibriosisDetail extends StatelessWidget {
  const VibriosisDetail({super.key});

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
          'Vibriosis',
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
                  Icons.bug_report_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('Vibriosis (Campylobacteriosis) in Cattle', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Vibriosis, also known as Campylobacteriosis, is a contagious bacterial disease of cattle caused by Campylobacter fetus subsp. fetus (formerly Vibrio fetus). The disease primarily affects the reproductive system, causing infertility, early embryonic death, and abortion in cows. It is a significant cause of reproductive failure in cattle herds worldwide and is responsible for substantial economic losses in the livestock industry.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The bacteria colonize the reproductive tract, particularly the uterus, cervix, and vagina. In bulls, the organism resides in the prepuce and is transmitted during natural breeding. The disease is insidious in nature, often going unnoticed until breeding problems become apparent through extended calving intervals and reduced pregnancy rates.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Campylobacter fetus is a fragile organism that survives poorly in the environment but is well adapted to the reproductive tract environment. The disease is often introduced into a herd through the purchase of infected bulls or cows, making biosecurity and quarantine measures essential for prevention.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS IN CATTLE', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Early embryonic death (0-45 days of gestation)\n• Irregular return to estrus (cycling)\n• Extended calving intervals\n• Reduced pregnancy rates (conception failure)\n• Varying degrees of infertility\n• Abortion in mid to late pregnancy (less common)\n• Mild endometritis in some cows\n• Asymptomatic bulls (carriers without clinical signs)\n• Poor conception in heifers and cows\n• Reduced overall herd reproductive performance',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS IN BULLS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Usually no clinical signs\n• Asymptomatic carriers\n• Organisms present in the prepuce and semen\n• Can shed bacteria for months or years\n• No visible lesions or reproductive dysfunction\n• Serves as the primary reservoir in the herd',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Venereal transmission during natural breeding\n• Infected bulls serving multiple cows\n• Introduction of infected breeding animals\n• Artificial insemination with infected semen\n• Contaminated breeding equipment\n• Contact with infected fetal membranes\n• Organisms survive in the prepuce of bulls for long periods',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Culture and isolation of Campylobacter from samples\n• Preputial scraping or aspiration in bulls\n• Vaginal mucus culture in cows\n• Fetal abomasal contents and placental samples\n• Serological tests (ELISA, agglutination tests)\n• Serum bactericidal antibody tests\n• History of infertility and reproductive failure in the herd\n• PCR testing for rapid and accurate identification',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Antibiotic treatment with procaine penicillin\n• Streptomycin and dihydrostreptomycin injections\n• Oxytetracycline administration\n• Intrauterine antibiotic infusion in cows\n• Treat bulls with antibiotics (two courses)\n• Restrict bulls from breeding during treatment\n• Antibiotic treatment may require multiple courses\n• Retest bulls after treatment to confirm clearance',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION & CONTROL', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Use artificial insemination instead of natural breeding\n• Quarantine new animals for 30-60 days\n• Test breeding bulls for Campylobacter infection\n• Vaccination of cows and heifers\n• Use commercial vaccines (available in many countries)\n• Maintain closed herd status when possible\n• Cull persistently infected bulls\n• Use only approved AI stud bulls\n• Regular health monitoring of breeding animals\n• Good hygiene and sanitation in breeding facilities',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('ECONOMIC IMPACT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Increased calving intervals (extended days open)\n• Reduced pregnancy rates (10-15% reduction)\n• Loss of calves through embryonic death\n• Cost of diagnosis and treatment\n• Cost of culling and replacing infected animals\n• Lost breeding opportunities\n• Extended time to achieve herd reproduction targets\n• Decreased overall herd productivity',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Beef and dairy cattle (breeding herds)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.male_rounded,
              label: 'Primary Reservoir',
              value: 'Bulls (asymptomatic carriers)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.biotech_rounded,
              label: 'Caused By',
              value: 'Campylobacter fetus subsp. fetus',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.vaccines_rounded,
              label: 'Key Control Method',
              value: 'Vaccination + AI + infected bull culling',
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
