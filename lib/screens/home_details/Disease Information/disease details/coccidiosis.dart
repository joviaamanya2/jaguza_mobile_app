import 'package:flutter/material.dart';

class CoccidiosisDetail extends StatelessWidget {
  const CoccidiosisDetail({super.key});

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
          'Coccidiosis',
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
            Text('Coccidiosis in Poultry', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Coccidiosis is a common and highly contagious parasitic disease of poultry caused by protozoan parasites of the genus Eimeria. The parasites invade and multiply within the intestinal cells of chickens, turkeys, and other birds, causing severe damage to the intestinal lining. Coccidiosis is one of the most economically significant diseases in the poultry industry worldwide.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'There are several species of Eimeria that affect poultry, each with different levels of pathogenicity. The most common and pathogenic species in chickens include Eimeria tenella (causes cecal coccidiosis), Eimeria acervulina, Eimeria maxima, and Eimeria brunetti. The life cycle of the parasite is direct, meaning it does not require an intermediate host.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The disease is transmitted through the fecal-oral route. Birds ingest sporulated oocysts (the infective stage) from contaminated litter, feed, or water. The oocysts then release sporozoites that invade intestinal epithelial cells, multiply rapidly, and cause extensive tissue damage. The disease is often triggered or worsened by stress factors such as overcrowding, poor ventilation, and sudden dietary changes.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Bloody diarrhea (often fresh or dark-colored)\n• Excessive mucus in droppings\n• Reduced feed intake and weight loss\n• Poor growth rates and stunted development\n• Dehydration and weakness\n• Pale comb and wattles\n• Ruffled feathers and depression\n• Reduced egg production in layers\n• High mortality in acute cases\n• Young birds are most severely affected',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Ingestion of sporulated oocysts from contaminated litter\n• Contaminated feed and water sources\n• Direct contact with infected birds\n• Oocysts survive in the environment for months\n• Spread through feces of infected birds\n• Introduction of carrier birds\n• Stress and overcrowding increase transmission',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('DIAGNOSIS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Fecal flotation test to identify oocysts\n• Post-mortem examination of affected birds\n• Intestinal tissue examination and histopathology\n• Clinical signs and gross lesions\n• Age of affected birds (young birds more susceptible)\n• History of poor litter management and overcrowding',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Anti-coccidial drugs (e.g., amprolium, sulfonamides, toltrazuril)\n• Provide antibiotics to prevent secondary infections\n• Ensure adequate hydration to prevent dehydration\n• Add vitamins A and K to the feed\n• Improve nutrition to support recovery\n• Reduce stress factors in the flock\n• Isolate affected birds\n• Clean and disinfect waterers and feeders\n• Remove wet litter and replace with fresh, dry material',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Use anticoccidial drugs as feed additives (ionophores)\n• Vaccinate chicks with live attenuated vaccines\n• Maintain good hygiene and sanitation practices\n• Regular cleaning and disinfection of housing\n• Keep feed and water containers clean\n• Avoid overcrowding in the poultry house\n• Provide adequate ventilation\n• Use deep litter management with regular turning\n• All-in-all-out production systems\n• Ensure adequate nutrition to boost immunity',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Simple plain info rows without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Chickens, turkeys, and other birds',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.bloodtype_rounded,
              label: 'Key Sign',
              value: 'Bloody diarrhea (pathognomonic sign)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.vaccines_rounded,
              label: 'Control Methods',
              value: 'Anticoccidial drugs and vaccination',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.bug_report_rounded,
              label: 'Caused By',
              value: 'Eimeria species (protozoan parasites)',
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
