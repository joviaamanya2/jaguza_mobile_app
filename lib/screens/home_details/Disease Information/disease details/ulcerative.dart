import 'package:flutter/material.dart';

class UlcerativeMammillitisDetail extends StatelessWidget {
  const UlcerativeMammillitisDetail({super.key});

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
          'Ulcerative Mammillitis',
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
                  Icons.medical_services_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('Ulcerative Mammillitis', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'Ulcerative Mammillitis is a painful viral disease affecting the teats and udder skin of dairy cattle. It is caused by a herpesvirus (Bovine Herpesvirus 2 - BoHV-2) that is closely related to the human herpes simplex virus. The disease is characterized by the development of painful ulcers and scabs on the teats, which can significantly impact milking operations and animal welfare.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The virus infects the epithelial cells of the skin, causing cell death and the formation of characteristic blister-like lesions that quickly ulcerate. The disease is particularly problematic because the lesions are extremely painful, making milking difficult and stressful for both the cow and the milker. Secondary bacterial infections often complicate the condition.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Although the disease is usually self-limiting and resolves within 2-4 weeks, the economic impact can be significant due to reduced milk production, increased milking time, risk of mastitis, and the cost of treatment. The condition is more common in the winter months and can spread rapidly through a herd via contaminated milking equipment and hands.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('SYMPTOMS', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Blister-like lesions on the teats that quickly ulcerate\n• Painful, weeping ulcers with raised edges\n• Scab formation over healing ulcers\n• Swelling and inflammation of the teat skin\n• Redness and heat around affected areas\n• Reluctance to be milked due to pain\n• Reduced milk production\n• Secondary bacterial infections (mastitis)\n• Lesions may affect one or multiple teats',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TRANSMISSION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Direct contact with infected teats\n• Contaminated milking equipment and liners\n• Milkers\' hands carrying the virus\n• Contaminated bedding and environment\n• Insect vectors (flies) may spread the virus\n• Virus can survive in the environment for several days\n• Stress and poor hygiene increase susceptibility',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('TREATMENT & MANAGEMENT', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Topical antiseptic creams to prevent secondary infection\n• Antibiotic ointments for bacterial complications\n• Pain relief medications to reduce discomfort\n• Emollient teat dips (lanolin, glycerin) to soothe and moisturize\n• Switch to once-a-day milking to reduce trauma\n• Hand-milk affected cows gently\n• Provide clean, dry bedding to minimize contamination\n• Maintain proper milking hygiene practices\n• In severe cases, oral antibiotics may be prescribed',
              style: bodyStyleTight,
            ),

            const SizedBox(height: 32),

            // Section Label
            Text('PREVENTION', style: labelStyle),

            const SizedBox(height: 12),

            Text(
              '• Use proper milking techniques to minimize teat damage\n• Regularly clean and sanitize milking equipment\n• Use disposable gloves during milking\n• Apply high-quality teat dip after milking\n• Isolate infected cows during the acute phase\n• Maintain excellent bedding hygiene\n• Reduce stress factors (overcrowding, poor ventilation)\n• Use fly control measures to reduce transmission\n• Feed a balanced diet to boost immunity\n• Monitor herd regularly for early detection',
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
              icon: Icons.biotech_rounded,
              label: 'Caused By',
              value: 'Bovine Herpesvirus 2 (BoHV-2)',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.timer_rounded,
              label: 'Recovery Time',
              value: '2-4 weeks with proper management',
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
