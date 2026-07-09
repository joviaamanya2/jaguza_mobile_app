import 'package:flutter/material.dart';

class GoatDecisionScreen extends StatefulWidget {
  const GoatDecisionScreen({super.key});

  @override
  State<GoatDecisionScreen> createState() => _GoatDecisionScreenState();
}

class _GoatDecisionScreenState extends State<GoatDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Choosing the right goat breed is crucial for your farming success. Consider your primary purpose (milk, meat, fiber, or pets), climate adaptability, disease resistance, and market demand in your area.',
      image: 'assets/goat_breed.jpg',
      details: [
        'Dairy breeds: Saanen, Alpine, Nubian, Toggenburg',
        'Meat breeds: Boer, Kalahari Red, Savanna',
        'Fiber breeds: Angora, Cashmere, Pygora',
        'Dual-purpose: Nubian, Alpine, Saanen',
        'Climate adaptation and disease resistance factors',
      ],
    ),
    DecisionTopic(
      title: 'Housing & Shelter',
      description:
          'Proper housing protects goats from extreme weather, predators, and diseases. Good shelter design promotes health, reduces stress, and improves productivity.',
      image: 'assets/goat_housing.jpg',
      details: [
        'Space requirement: 15-20 sq ft per adult goat',
        'Good ventilation and natural lighting',
        'Dry, draft-free sleeping area',
        'Raised platforms for resting (off the ground)',
        'Separate kidding pens for pregnant does',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Goats are browsers, not grazers. They require a diverse diet including browse, forages, concentrates, and minerals for optimal health, milk production, and growth.',
      image: 'assets/goat_feeding.jpg',
      details: [
        'Browse: 60-70% of diet (shrubs, trees, weeds)',
        'Hay: Quality grass/legume hay daily',
        'Grain supplementation for lactating does',
        'Mineral block with copper and selenium',
        'Clean, fresh water accessible at all times',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Disease Prevention',
      description:
          'Goat health management includes vaccination, deworming, foot care, and regular health monitoring. A proactive approach prevents common diseases and reduces losses.',
      image: 'assets/goat_health.jpg',
      details: [
        'Vaccination: PPR, CCPP, FMD, Enterotoxemia',
        'Deworming: Every 3-4 months (rotational)',
        'Hoof trimming: Every 6-8 weeks',
        'Copper and selenium supplementation',
        'Quarantine new animals for 30 days',
      ],
    ),
    DecisionTopic(
      title: 'Breeding & Reproduction',
      description:
          'Strategic breeding decisions improve herd genetics, increase productivity, and ensure healthy offspring. Proper management of breeding cycles is essential for profitability.',
      image: 'assets/goat_reproduction.jpg',
      details: [
        'Age at first breeding: 8-12 months (does)',
        'Breeding season: 2-3 times per year',
        'Gestation period: 150 days (5 months)',
        'Kidding care: Clean, quiet environment',
        'Record keeping for genetic improvement',
      ],
    ),
    DecisionTopic(
      title: 'Milk Production Management',
      description:
          'Dairy goats are excellent milk producers. Proper milking techniques, hygiene, and management maximize milk yield and quality while maintaining udder health.',
      image: 'assets/goat_milk.jpg',
      details: [
        'Milking frequency: 2 times daily',
        'Proper udder preparation and hygiene',
        'Mastitis prevention: Clean teats, dry bedding',
        'Milk testing for quality and fat content',
        'Proper storage and cooling of milk',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Clean, accessible water is essential for goat health, digestion, milk production, and temperature regulation. Water quality directly affects productivity.',
      image: 'assets/goat_water.jpg',
      details: [
        'Daily water: 2-3 gallons per adult goat',
        'Clean waterers: 2-3 times daily in hot weather',
        'Water quality: Clean, fresh, uncontaminated',
        'Heated waterers in cold climates',
        'Water trough cleaning schedule: Weekly',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Successful goat farming requires careful financial planning, cost tracking, and revenue optimization. Understanding your costs helps maximize profitability.',
      image: 'assets/goat_finance.jpg',
      details: [
        'Feed costs: 40-50% of total expenses',
        'Veterinary and medicine costs',
        'Marketing and transportation costs',
        'Infrastructure maintenance budget',
        'Revenue streams: Milk, meat, fiber, breeding stock',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Goat products have a growing market. Understanding consumer preferences, market channels, and pricing helps you maximize revenue from your goat enterprise.',
      image: 'assets/goat_market.jpg',
      details: [
        'Milk: Direct sales, processing, cooperatives',
        'Meat: Local markets, butcheries, direct consumer',
        'Fiber: Spinning mills, craft markets',
        'Breeding stock: Auctions, private sales',
        'Value-added products: Cheese, soap, yogurt',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
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
              'Goat Decision Support',
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ),
            // Image in the middle - Using AssetImage
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
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
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
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── TopicDetailScreen — Using AssetImage ───────────────────────────────
class TopicDetailScreen extends StatelessWidget {
  final DecisionTopic topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
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
            // Hero image - Using AssetImage
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
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
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 80,
                      color: Colors.grey,
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
                  // Title with icon
                  Row(
                    children: [
                      const Icon(
                        Icons.pets,
                        color: Color(0xFF2E7D32),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          topic.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Description section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Overview',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1F36),
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
                            color: Colors.grey[700],
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
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
                              color: const Color(0xFF2E7D32),
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Key Points',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1F36),
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
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.5,
                                      color: Colors.grey[700],
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
                  // Pro Tips section - Goat specific
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF2E7D32).withOpacity(0.1),
                          const Color(0xFF2E7D32).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF2E7D32).withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Pro Tips',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Regular record keeping helps track performance and make informed decisions',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
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
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Provide mineral supplements with copper and selenium for goat health',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
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
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Implement rotational deworming to prevent parasite resistance',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
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
                              const SnackBar(
                                content: Text('Share feature coming soon'),
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
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
                              const SnackBar(
                                content: Text('Bookmark feature coming soon'),
                                backgroundColor: Color(0xFF2E7D32),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(color: Color(0xFF2E7D32)),
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