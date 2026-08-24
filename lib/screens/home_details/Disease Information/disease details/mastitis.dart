import 'package:flutter/material.dart';

class MastitisDetail extends StatelessWidget {
  const MastitisDetail({super.key});

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
          'Mastitis',
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
                  Icons.water_drop_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('Mastitis in Cattle', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Mastitis is an inflammation of the mammary gland (udder) in cattle, primarily caused by bacterial infection. It is one of the most common and economically significant diseases affecting dairy cattle worldwide. The disease can be clinical (visible symptoms) or subclinical (no visible signs but reduced milk quality).',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The infection occurs when bacteria enter the teat canal, multiply in the mammary gland, and trigger an inflammatory response. The most common pathogens include Staphylococcus aureus, Streptococcus agalactiae, Streptococcus uberis, and Escherichia coli. Environmental factors such as poor hygiene, dirty bedding, and wet conditions significantly increase the risk of infection.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Mastitis results in reduced milk production, poor milk quality, changes in milk composition (increased somatic cell count), and in severe cases, can lead to systemic illness, udder damage, and even death. Subclinical mastitis is particularly problematic because it goes undetected and causes significant economic losses over time.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Swollen, hot, and painful udder quarters\n• Redness and inflammation of the udder\n• Abnormal milk appearance (clots, flakes, watery, or discolored)\n• Decreased milk production\n• Fever and elevated body temperature\n• Loss of appetite and depression\n• Dehydration and weakness\n• Reduced milk flow or difficulty milking\n• Cows may kick or resist milking due to pain',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('CAUSES & RISK FACTORS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Poor milking hygiene and contaminated equipment\n• Dirty or wet bedding and stalls\n• Incomplete milking leaving milk in the udder\n• High milk production making cows more susceptible\n• Damaged or cracked teats allowing bacterial entry\n• Nutritionally stressed or immunocompromised animals\n• Environmental contamination with manure and dirt\n• Poor ventilation leading to damp conditions',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Administer appropriate intramammary antibiotics as prescribed by a veterinarian\n• Use anti-inflammatory drugs to reduce pain and swelling\n• Frequently strip affected quarters to remove infected milk\n• Isolate infected cows to prevent spread\n• Provide clean, dry, and comfortable bedding\n• Ensure adequate hydration and nutrition\n• Supportive therapy with fluids if the cow is showing signs of systemic illness',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Practice good milking hygiene (wash, dry, and disinfect teats)\n• Use clean, dry bedding in stalls and resting areas\n• Implement proper udder disinfection before and after milking\n• Regularly test for subclinical mastitis using somatic cell counts\n• Dry cow therapy at the end of lactation\n• Maintain clean and sanitized milking equipment\n• Ensure proper nutrition and supplementation\n• Vaccination against common bacterial pathogens\n• Implement culling of chronic or unresponsive cases',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Dairy cattle, especially high-yielding cows',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.coronavirus_rounded,
              label: 'Common Pathogens',
              value: 'S. aureus, Strep. agalactiae, E. coli',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.monetization_on_rounded,
              label: 'Economic Impact',
              value: 'Reduced milk yield, milk discard, and treatment costs',
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
