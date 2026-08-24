import 'package:flutter/material.dart';
import 'package:jaguza_app/screens/home_details/AI%20chart/ai_chart_screen.dart';

// Import your screens here
import './cattle_decision.dart';
import './goat_decision.dart';
import './sheep_decision.dart';
import './poultry_decision.dart';
import './pigs_decision.dart';
import './rabbits_decision.dart';

class DecisionSupportScreen extends StatelessWidget {
  const DecisionSupportScreen({super.key});

  final List<AnimalCard> _animals = const [
    AnimalCard('Cattle', 'lib/assets/images/cattle.jpg', Colors.grey),
    AnimalCard('Goats', 'lib/assets/images/Goat.png', Colors.grey),
    AnimalCard('Sheep', 'lib/assets/images/Sheep.png', Colors.grey),
    AnimalCard('Poultry', 'lib/assets/images/Poultry.png', Colors.grey),
    AnimalCard('Pigs', 'lib/assets/images/Pigs.png', Colors.grey),
    AnimalCard('Rabbits', 'lib/assets/images/Rabbit.png', Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        title: Text(
          'Decision Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: const Icon(Icons.auto_awesome_rounded, size: 24),
              color: scheme.primary,
              onPressed: () => _showAIAssistantDialog(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Animal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Get decision support for your livestock',
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.0,
                ),
                physics: const BouncingScrollPhysics(),
                itemCount: _animals.length,
                itemBuilder: (context, index) {
                  final animal = _animals[index];
                  return GestureDetector(
                    onTap: () {
                      _navigateToAnimalScreen(context, animal.name);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: scheme.outlineVariant),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 78,
                            width: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: scheme.primary.withValues(alpha: 0.18),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                animal.imagePath,
                                height: 78,
                                width: 78,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: scheme.onSurfaceVariant,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            animal.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'View Decisions',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: scheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAnimalScreen(BuildContext context, String animalName) {
    // Navigate to the respective screen based on animal name
    switch (animalName) {
      case 'Cattle':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CattleDecisionScreen()),
        );
        break;
      case 'Goats':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GoatDecisionScreen()),
        );
        break;
      case 'Sheep':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SheepDecisionScreen()),
        );
        break;
      case 'Poultry':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PoultryDecisionScreen()),
        );
        break;
      case 'Pigs':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PigDecisionScreen()),
        );
        break;
      case 'Rabbits':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RabbitDecisionScreen()),
        );
        break;
      default:
        // Show a snackbar if screen doesn't exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$animalName screen coming soon!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
    }
  }

  void _showAIAssistantDialog(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Theme.of(context).cardColor,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: scheme.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'AI Farm Assistant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          'Ask me anything about livestock management:',
          style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: scheme.onSurfaceVariant)),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AIChatTab(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
              ),
              child: const Text('Ask AI'),
            ),
        ],
      ),
    );
  }
}

// Data model for animal cards
class AnimalCard {
  final String name;
  final String imagePath;
  final Color color;

  const AnimalCard(this.name, this.imagePath, this.color);
}
