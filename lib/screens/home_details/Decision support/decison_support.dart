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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Decision Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
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
              color: const Color(0xFF2E7D32),
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
            const Text(
              'Select Animal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Get decision support for your livestock',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.06),
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
                                color: const Color(0xFF2E7D32).withOpacity(0.18),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
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
                                  return const Icon(
                                    Icons.image_not_supported,
                                    size: 48,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            animal.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1F36),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2E7D32).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'View Decisions',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
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
            backgroundColor: const Color(0xFF2E7D32),
          ),
        );
    }
  }

  void _showAIAssistantDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF2E7D32),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AI Farm Assistant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36),
              ),
            ),
          ],
        ),
        content: const Text(
          'Ask me anything about livestock management:',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.grey[600])),
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
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
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