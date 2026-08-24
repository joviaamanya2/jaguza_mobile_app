import 'package:flutter/material.dart';

class RabbitDecisionScreen extends StatefulWidget {
  const RabbitDecisionScreen({super.key});

  @override
  State<RabbitDecisionScreen> createState() => _RabbitDecisionScreenState();
}

class _RabbitDecisionScreenState extends State<RabbitDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Choosing the right rabbit breed is essential for your farming success. Consider your primary purpose (meat, fur, wool, show, or pets), growth rate, reproductive performance, and market demand in your area.',
      image: 'assets/rabbit_breed.jpg',
      details: [
        'Meat breeds: New Zealand White, Californian, Flemish Giant',
        'Fur breeds: Rex, Chinchilla, Satin',
        'Wool breeds: Angora, English Angora, French Angora',
        'Dual-purpose: New Zealand, Californian, Champagne d\'Argent',
        'Climate adaptation and local market preferences',
      ],
    ),
    DecisionTopic(
      title: 'Housing & Caging Systems',
      description:
          'Proper housing is crucial for rabbit health, productivity, and welfare. Good cage design prevents diseases, reduces stress, and improves feed efficiency and growth rates.',
      image: 'assets/rabbit_housing.jpg',
      details: [
        'Cage space: 2-6 sq ft per rabbit (breed dependent)',
        'Wire cage floors: 1/2 x 1 inch mesh (prevents sore hocks)',
        'Tray or droppings collection system',
        'Individual cages for breeding, group pens for growers',
        'Clean, dry environment: 60-70°F (15-21°C)',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Rabbits require a balanced diet of hay, pellets, and fresh vegetables for optimal health, growth, and reproduction. Digestive health is critical in rabbit production.',
      image: 'assets/rabbit_feeding.jpg',
      details: [
        'Hay: 70-80% of diet (timothy, orchard, or oat hay)',
        'Pellets: 16-18% protein, 14-18% fiber for growing rabbits',
        'Fresh vegetables: Leafy greens in limited quantities',
        'Fresh water: Clean water available 24/7',
        'Feed conversion: 2.5-3.0 lbs feed per lb gain',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Disease Prevention',
      description:
          'Rabbit health management includes vaccination, parasite control, and regular monitoring. A proactive health program prevents common diseases and reduces losses.',
      image: 'assets/rabbit_health.jpg',
      details: [
        'Common diseases: Pasteurellosis, Enteritis, Coccidiosis',
        'Vaccination: Myxomatosis, RHD (Rabbit Hemorrhagic Disease)',
        'Parasite control: Coccidiosis prevention and treatment',
        'Regular health checks: Nails, teeth, fur, weight',
        'Quarantine new rabbits for minimum 14-21 days',
      ],
    ),
    DecisionTopic(
      title: 'Breeding & Reproduction',
      description:
          'Strategic breeding decisions improve herd genetics, increase productivity, and ensure healthy kits. Understanding rabbit reproduction is essential for profitability.',
      image: 'assets/rabbit_reproduction.jpg',
      details: [
        'Age at first breeding: 4-6 months (does)',
        'Breeding frequency: 3-5 litters per year',
        'Gestation period: 28-31 days (average 30 days)',
        'Litter size: 6-10 kits (breed dependent)',
        'Weaning age: 4-8 weeks (depending on system)',
      ],
    ),
    DecisionTopic(
      title: 'Kindling Management',
      description:
          'Kindling (birthing) is a critical phase in rabbit production. Proper management during kindling and lactation ensures high kit survival rates and doe productivity.',
      image: 'assets/rabbit_kindling.jpg',
      details: [
        'Nest box: Provide 1-2 days before kindling',
        'Kindling materials: Hay, straw, wood shavings',
        'Kit survival: 80-90% with proper management',
        'Lactation: Doe can nurse 6-12 kits effectively',
        'Cross-fostering: Reduce large litters, equalize sizes',
      ],
    ),
    DecisionTopic(
      title: 'Grower Management',
      description:
          'Raising healthy grower rabbits from weaning to market requires careful management of nutrition, housing, and health to maximize growth and efficiency.',
      image: 'assets/rabbit_grower.jpg',
      details: [
        'Weaning weight: 1-1.5 lbs (breed dependent)',
        'Market weight: 4-6 lbs (depending on market)',
        'Growth rate: 0.5-1.0 lb per week',
        'Market age: 8-12 weeks (depending on market)',
        'Sexing: Separate males and females at weaning',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Clean, accessible water is essential for rabbit health, digestion, and growth. Water quality directly affects feed intake and productivity in rabbit production.',
      image: 'assets/rabbit_water.jpg',
      details: [
        'Daily water: 2-4 liters per rabbit (breed dependent)',
        'Waterers: Automatic nipple drinkers or crocks',
        'Water quality: Clean, fresh, uncontaminated',
        'Water sanitation: Clean waterers daily',
        'Winter: Heated waterers to prevent freezing',
      ],
    ),
    DecisionTopic(
      title: 'Waste Management & Composting',
      description:
          'Effective waste management converts rabbit manure into valuable fertilizer. Rabbit manure is one of the best organic fertilizers for gardens and crops.',
      image: 'assets/rabbit_waste.jpg',
      details: [
        'Rabbit manure: 1-2 lbs per rabbit per month',
        'Composting: Nitrogen-rich compost in 2-3 months',
        'Worm farming: Excellent feed for composting worms',
        'Direct garden application: Can be used without aging',
        'Manure values: 2.4% N, 1.4% P, 0.6% K by weight',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Successful rabbit farming requires careful financial planning, cost tracking, and revenue optimization. Understanding production costs is essential for profitability.',
      image: 'assets/rabbit_finance.jpg',
      details: [
        'Feed costs: 50-60% of total expenses',
        'Breeding stock costs: Initial investment',
        'Veterinary and medicine costs',
        'Housing and equipment costs',
        'Revenue streams: Meat, breeding stock, fur, manure',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Understanding market dynamics and choosing the right marketing channels helps maximize returns from rabbit production. Multiple revenue streams can improve farm profitability.',
      image: 'assets/rabbit_market.jpg',
      details: [
        'Meat market: Butcheries, restaurants, direct sales',
        'Breeding stock: Sales to other producers',
        'Pet market: Companion rabbits',
        'Angora wool: Craft markets, fiber arts',
        'Value-added: Processed products, furs, pet supplies',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            SizedBox(width: 8),
            Icon(Icons.pets, size: 22),
            SizedBox(width: 8),
            Text(
              'Rabbit Decision Support',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _decisionTopics.length,
        itemBuilder: (context, index) {
          final topic = _decisionTopics[index];
          return _buildDecisionCard(topic);
        },
      ),
    );
  }

  Widget _buildDecisionCard(DecisionTopic topic) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopicDetailScreen(topic: topic),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title at the top
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                topic.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
            // Image in the middle - USING ASSET IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.asset(
                topic.image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: scheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            // Description at the bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                topic.description,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TopicDetailScreen — USING ASSET IMAGE ──────────
class TopicDetailScreen extends StatelessWidget {
  final DecisionTopic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image - USING ASSET IMAGE
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                topic.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: scheme.surfaceContainerHighest,
                    child: Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: scheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.pets,
                        color: scheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          topic.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Overview section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: scheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          topic.description,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Key Points section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: scheme.primary,
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Key Points',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...topic.details.map((detail) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 6, right: 12),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: scheme.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Pro Tips section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.primary.withValues(alpha: 0.1),
                          scheme.primary.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: scheme.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: scheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pro Tips',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Always provide fresh hay daily for digestive health',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: scheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Keep breeding records to track fertility and production',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: scheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Implement biosecurity protocols for new stock',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: scheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Share feature coming soon'),
                                backgroundColor: scheme.primary,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text(
                            'Share',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Bookmark feature coming soon'),
                                backgroundColor: scheme.primary,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: scheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: scheme.primary),
                          ),
                          icon: const Icon(Icons.bookmark_border, size: 20),
                          label: const Text(
                            'Save',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DecisionTopic {
  final String title;
  final String description;
  final String image;
  final List<String> details;

  DecisionTopic({
    required this.title,
    required this.description,
    required this.image,
    required this.details,
  });
}
