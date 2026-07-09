import 'package:flutter/material.dart';

class CattleDecisionScreen extends StatefulWidget {
  const CattleDecisionScreen({super.key});

  @override
  State<CattleDecisionScreen> createState() => _CattleDecisionScreenState();
}

class _CattleDecisionScreenState extends State<CattleDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Your choice of cattle breed(s) plays a vital role in your success in the cattle farming industry. It\'s not a choice that should be taken lightly. Consider factors like climate adaptation, milk/meat production, disease resistance, and market demand.',
      image: 'assets/cattle_breed.jpg',
      details: [
        'Dairy breeds: Holstein, Jersey, Guernsey',
        'Beef breeds: Angus, Hereford, Simmental',
        'Dual-purpose breeds: Brown Swiss, Simmental',
        'Consider local climate and conditions',
        'Market demand in your region',
      ],
    ),
    DecisionTopic(
      title: 'Housing Management',
      description:
          'Good site selection and housing management is very important for your cattle health and productivity. Proper shelter protects from extreme weather and reduces stress.',
      image: 'assets/cattle_housing.jpg',
      details: [
        'Adequate space: 40-50 sq ft per animal',
        'Proper ventilation and natural lighting',
        'Durable flooring (concrete, compacted earth)',
        'Water access throughout the barn',
        'Separate areas for feeding, resting, milking',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Proper nutrition is essential for cattle growth, milk production, and reproduction. A balanced diet improves overall herd health and productivity.',
      image: 'assets/cattle_feeding.jpg',
      details: [
        'Forage: 60-80% of daily diet (hay, silage, pasture)',
        'Concentrate feed based on production level',
        'Mineral and vitamin supplementation',
        'Access to clean, fresh water daily',
        'Feeding schedule and portions vary by age/stage',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Disease Prevention',
      description:
          'Maintaining herd health through vaccination, parasite control, and regular monitoring prevents costly diseases and improves productivity.',
      image: 'assets/cattle_health.jpg',
      details: [
        'Vaccination program: FMD, LSD, Anthrax, Blackquarter',
        'De-worming: Every 3 months internally and externally',
        'Regular health checkups and veterinary care',
        'Quarantine procedures for new animals',
        'Biosecurity measures to prevent disease spread',
      ],
    ),
    DecisionTopic(
      title: 'Reproductive Management',
      description:
          'Strategic breeding decisions ensure consistent milk/meat production, healthy calves, and improved herd genetics over time.',
      image: 'assets/cattle_reproduction.jpg',
      details: [
        'Age at first breeding: 18-24 months for heifers',
        'Breeding interval: Aim for 12-13 months',
        'Artificial insemination vs. natural breeding',
        'Genetic selection for desirable traits',
        'Pregnancy monitoring and calf care',
      ],
    ),
    DecisionTopic(
      title: 'Milk Production Management',
      description:
          'For dairy farms, optimizing milk production through proper milking practices and cow management maximizes revenue and animal welfare.',
      image: 'assets/cattle_milk.jpg',
      details: [
        'Milking frequency: 2-3 times daily',
        'Proper udder hygiene and sanitation',
        'Mastitis prevention and treatment',
        'Milk quality testing and storage',
        'Lactation cycle management',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Adequate clean water is critical for cattle health, digestion, milk production, and overall productivity. Ensure consistent access year-round.',
      image: 'assets/cattle_water.jpg',
      details: [
        'Daily water requirement: 20-30+ gallons per cow',
        'Clean water sources free from contaminants',
        'Accessible water troughs or systems',
        'Water quality monitoring (pH, salts)',
        'Heated water in cold months',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Managing costs and income effectively is crucial for a profitable cattle farm. Track expenses and plan for seasonal variations.',
      image: 'assets/cattle_finance.jpg',
      details: [
        'Record keeping for expenses and income',
        'Feed costs are typically 50-60% of expenses',
        'Budget for veterinary care and medicine',
        'Infrastructure maintenance planning',
        'Cost-benefit analysis for new investments',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Understanding market trends and finding the right channels helps maximize profits whether selling milk, meat, or breeding stock.',
      image: 'assets/cattle_market.jpg',
      details: [
        'Milk pricing: Local cooperatives, direct sales, processors',
        'Beef marketing: Live sales, processed meat, direct consumer',
        'Breeding stock: Pedigree records, certifications',
        'Value-added products: Cheese, yogurt, specialty beef',
        'Market timing and price forecasting',
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
            Text(
              'Cattle Decision Support',
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
                  Text(
                    topic.title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Overview section
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
                  // Pro Tips section
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
                                'Regular veterinary checkups are essential for herd health',
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
                                'Maintain detailed records of breeding, health, and production',
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
                                'Invest in quality feed for better milk and meat production',
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