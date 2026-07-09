import 'package:flutter/material.dart';

class SheepDecisionScreen extends StatefulWidget {
  const SheepDecisionScreen({super.key});

  @override
  State<SheepDecisionScreen> createState() => _SheepDecisionScreenState();
}

class _SheepDecisionScreenState extends State<SheepDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Choosing the right sheep breed is fundamental to your farming success. Consider your primary goal (meat, wool, milk, or multipurpose), climate adaptation, disease resistance, and market demand in your region.',
      image: 'assets/sheep_breed.jpg',
      details: [
        'Meat breeds: Dorper, Suffolk, Hampshire, Texel',
        'Wool breeds: Merino, Rambouillet, Corriedale',
        'Dairy breeds: East Friesian, Lacaune, Awassi',
        'Dual-purpose: Dorset, Columbia, Polypay',
        'Climate and terrain adaptability factors',
      ],
    ),
    DecisionTopic(
      title: 'Housing & Shelter',
      description:
          'Proper housing protects sheep from predators, extreme weather, and diseases. Good shelter design promotes health, reduces stress, and improves wool quality and productivity.',
      image: 'assets/sheep_housing.jpg',
      details: [
        'Space requirement: 15-20 sq ft per sheep',
        'Good ventilation to prevent respiratory issues',
        'Dry, draft-free sleeping area with bedding',
        'Protection from rain, wind, and direct sun',
        'Separate lambing pens for pregnant ewes',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Sheep are ruminants that require a balanced diet for optimal health, wool production, growth, and reproduction. Proper nutrition is key to profitability.',
      image: 'assets/sheep_feeding.jpg',
      details: [
        'Forage: 70-80% of diet (pasture, hay, silage)',
        'Quality hay and grazing management',
        'Concentrate supplementation when needed',
        'Mineral supplements: Salt, calcium, phosphorus',
        'Clean, fresh water available at all times',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Disease Prevention',
      description:
          'Sheep health management includes vaccination, deworming, foot care, and regular monitoring. A proactive health program prevents diseases and reduces economic losses.',
      image: 'assets/sheep_health.jpg',
      details: [
        'Vaccination: FMD, Sheep Pox, Brucellosis, Enterotoxemia',
        'Deworming schedule: Every 3-4 months (rotational)',
        'Footrot prevention: Regular hoof trimming and footbaths',
        'Parasite control: Internal and external',
        'Quarantine new animals for minimum 30 days',
      ],
    ),
    DecisionTopic(
      title: 'Breeding & Reproduction',
      description:
          'Strategic breeding decisions improve flock genetics, increase productivity, and ensure healthy lambs. Understanding sheep reproduction cycles is essential for profitability.',
      image: 'assets/sheep_reproduction.jpg',
      details: [
        'Age at first breeding: 8-12 months (ewes)',
        'Breeding season: 1-2 times per year',
        'Gestation period: 147 days (5 months)',
        'Lambing care: Clean, warm, quiet environment',
        'Record keeping for genetic improvement',
      ],
    ),
    DecisionTopic(
      title: 'Wool & Fiber Management',
      description:
          'For wool-producing sheep, proper management ensures high-quality fiber production. Shearing, grading, and marketing of wool adds significant value to your operation.',
      image: 'assets/sheep_wool.jpg',
      details: [
        'Shearing frequency: Once or twice annually',
        'Shearing timing: Before lambing or in spring',
        'Wool grading based on micron and quality',
        'Proper wool handling and storage',
        'Market sheep wool, lamb wool, and coarse wool',
      ],
    ),
    DecisionTopic(
      title: 'Lamb Production Management',
      description:
          'Raising healthy lambs from birth to market requires careful management. Proper nutrition, health care, and growth monitoring optimize lamb production and profitability.',
      image: 'assets/sheep_lamb.jpg',
      details: [
        'Colostrum intake: Critical within first 6 hours',
        'Creep feeding for growing lambs',
        'Weaning: 60-90 days (depending on breed)',
        'Growth rate monitoring and feeding adjustments',
        'Market weight: 30-45 kg (depending on market)',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Clean, accessible water is essential for sheep health, digestion, milk production, and wool growth. Water quality directly affects productivity and animal welfare.',
      image: 'assets/sheep_water.jpg',
      details: [
        'Daily water: 1-2 gallons per sheep',
        'Clean water troughs daily',
        'Water quality monitoring for minerals',
        'Heated waterers in cold climates',
        'Accessible water points in all paddocks',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Successful sheep farming requires careful financial planning, cost tracking, and revenue optimization. Understanding costs and income streams maximizes profitability.',
      image: 'assets/sheep_finance.jpg',
      details: [
        'Feed costs: 40-50% of total expenses',
        'Veterinary and medicine costs',
        'Shearing and wool handling costs',
        'Marketing and transportation costs',
        'Revenue streams: Lamb meat, wool, breeding stock',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Understanding market trends and finding the right channels helps maximize profits whether selling lamb meat, wool, or breeding stock. Value-added products can increase revenue.',
      image: 'assets/sheep_market.jpg',
      details: [
        'Lamb meat: Butcheries, direct sales, processors',
        'Wool marketing: Wool cooperatives, direct buyers',
        'Breeding stock: Auctions, private sales, registries',
        'Value-added: Leather, felt, lamb products',
        'Market timing and price forecasting strategies',
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
            Icon(Icons.sports_handball, size: 22),
            SizedBox(width: 8),
            Text(
              'Sheep Decision Support',
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
                        Icons.sports_handball,
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
                  // Pro Tips section - Sheep specific
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
                                'Seasonal management planning is crucial for sheep. Adjust feeding, breeding, and health programs based on seasonal changes to optimize flock performance.',
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
                                'Implement rotational grazing to improve pasture utilization and reduce parasite loads.',
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
                                'Regular hoof trimming prevents footrot and mobility issues.',
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