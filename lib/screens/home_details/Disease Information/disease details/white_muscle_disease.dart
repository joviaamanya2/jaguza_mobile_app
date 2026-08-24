import 'package:flutter/material.dart';

class WhiteMuscleDiseaseDetail extends StatelessWidget {
  const WhiteMuscleDiseaseDetail({super.key});

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'White Muscle Disease',
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
                  Icons.fitness_center_rounded,
                  size: 60,
                  color: scheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Title
            Text('White Muscle Disease', style: headingStyle),

            const SizedBox(height: 24),

            // Section Label
            Text('DESCRIPTION', style: labelStyle),

            const SizedBox(height: 12),

            // Body Text
            Text(
              'White muscle disease is a nutritional myopathy caused by a deficiency of selenium or vitamin E in young ruminants. It leads to the degeneration of skeletal and cardiac muscle fibers.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'The condition primarily affects calves, lambs, and piglets. It often strikes fast-growing, young animals and can manifest in two main forms: a congenital form affecting newborns, and a delayed form appearing a few weeks after birth.',
              style: bodyStyle,
            ),

            const SizedBox(height: 16),

            Text(
              'Affected animals show general weakness, stiffness, and a reluctance to move. In severe cases where the heart muscle is damaged, it can cause sudden death without any prior visible warning signs.',
              style: bodyStyle,
            ),

            const SizedBox(height: 32),

            // Simple plain info row without shadows
            _InfoRow(
              scheme: scheme,
              icon: Icons.pets_rounded,
              label: 'Most Common In',
              value: 'Calves, lambs, and piglets',
            ),

            const SizedBox(height: 12),

            _InfoRow(
              scheme: scheme,
              icon: Icons.science_rounded,
              label: 'Primary Cause',
              value: 'Selenium & Vitamin E deficiency',
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
