import 'package:flutter/material.dart';

class PoultryDecisionScreen extends StatefulWidget {
  const PoultryDecisionScreen({super.key});

  @override
  State<PoultryDecisionScreen> createState() => _PoultryDecisionScreenState();
}

class _PoultryDecisionScreenState extends State<PoultryDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Choosing the right poultry breed is fundamental to your farming success. Consider your primary purpose (eggs, meat, or dual-purpose), climate adaptation, disease resistance, and market demand in your region.',
      image: 'assets/poultry_breed.jpg',
      details: [
        'Layer breeds: Isa Brown, Lohmann, Hy-Line, Leghorn',
        'Broiler breeds: Ross, Cobb, Hubbard, Arbor Acres',
        'Dual-purpose: Rhode Island Red, Plymouth Rock, Sussex',
        'Heritage breeds: Cornish, Wyandotte, Orpington',
        'Climate adaptation and local market preferences',
      ],
    ),
    DecisionTopic(
      title: 'Housing & Infrastructure',
      description:
          'Proper housing is essential for poultry health, productivity, and welfare. Good housing design protects birds from predators, weather, and diseases while optimizing production.',
      image: 'assets/poultry_housing.jpg',
      details: [
        'Space: 1-2 sq ft per bird (layers), 0.5-1 sq ft (broilers)',
        'Ventilation: 4-8 air changes per hour minimum',
        'Temperature: 65-75°F for optimal production',
        'Lighting: 14-16 hours for layers, 23 hours for broilers',
        'Litter management: 4-6 inches deep (wood shavings)',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Proper nutrition is critical for poultry performance, egg production, and growth. Feed costs represent 60-70% of production costs, making feed efficiency crucial for profitability.',
      image: 'assets/poultry_feeding.jpg',
      details: [
        'Starter feed: 20-22% protein (0-6 weeks)',
        'Grower feed: 18-20% protein (6-18 weeks)',
        'Layer feed: 16-18% protein with calcium (18+ weeks)',
        'Broiler feed: 22-24% protein starter, 18-20% finisher',
        'Feed conversion: 1.8-2.2 kg feed per kg live weight',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Biosecurity',
      description:
          'Maintaining flock health through vaccination, biosecurity, and regular monitoring prevents costly diseases and improves productivity. A proactive health program is essential.',
      image: 'assets/poultry_health.jpg',
      details: [
        'Common diseases: Newcastle, Gumboro, Infectious Bronchitis',
        'Vaccination program: Marek\'s, IBD, ND, IB, IBH, Fowl Pox',
        'Biosecurity: All-in-all-out system, footbaths, restricted access',
        'Parasite control: Worming every 3-4 months',
        'Regular health monitoring and record keeping',
      ],
    ),
    DecisionTopic(
      title: 'Layer Management',
      description:
          'Layer management focuses on optimizing egg production, quality, and consistency while maintaining hen health and welfare. Proper management extends laying cycles and improves profitability.',
      image: 'assets/poultry_layer.jpg',
      details: [
        'Peak production: 90-95% at 26-32 weeks of age',
        'Annual production: 280-320 eggs per hen per year',
        'Egg weight: 55-65 grams average',
        'Molting: 10-14 days for production breaks',
        'Lighting program: 14-16 hours for consistent production',
      ],
    ),
    DecisionTopic(
      title: 'Broiler Management',
      description:
          'Broiler management focuses on maximizing growth rate and feed efficiency from day-old to market weight, directly impacting profitability in meat production.',
      image: 'assets/poultry_broiler.jpg',
      details: [
        'Growth rate: 40-60 grams per day',
        'Market weight: 1.5-2.5 kg (depending on market)',
        'Market age: 6-8 weeks (depending on target weight)',
        'Feed conversion ratio: 1.8-2.2 kg feed per kg gain',
        'Stocking density: 15-20 birds per square meter',
      ],
    ),
    DecisionTopic(
      title: 'Breeder Management',
      description:
          'Breeder flock management focuses on producing high-quality hatching eggs through proper nutrition, housing, and health management. Genetic improvement drives productivity.',
      image: 'assets/poultry_breeder.jpg',
      details: [
        'Age at first lay: 20-24 weeks',
        'Hen to rooster ratio: 8-10 hens per rooster',
        'Fertility rate: 85-95% (managed properly)',
        'Hatchability: 80-85% of fertile eggs',
        'Breeding program: Record keeping and selection',
      ],
    ),
    DecisionTopic(
      title: 'Incubation & Hatchery Management',
      description:
          'Incubation management determines hatch rates and chick quality. Proper temperature, humidity, and turning schedules are critical for successful hatching.',
      image: 'assets/poultry_incubation.jpg',
      details: [
        'Incubation temperature: 99.5°F (37.5°C) forced air',
        'Incubation humidity: 50-55% (days 1-18), 65-75% (days 19-21)',
        'Egg turning: 3-5 times daily during incubation',
        'Hatching: Day 18-21 for chickens',
        'Chick quality: Vaccination, sexing, grading',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Clean, accessible water is essential for poultry health, digestion, egg production, and thermoregulation. Water quality directly affects feed intake and productivity.',
      image: 'assets/poultry_water.jpg',
      details: [
        'Daily water: 150-200 ml per chicken (environment dependent)',
        'Waterers: 1 per 20-30 birds (plastic or stainless)',
        'Water quality: Clean, fresh, uncontaminated',
        'Water sanitation: Clean waterers daily',
        'Summer: Additional water or electrolytes in hot weather',
      ],
    ),
    DecisionTopic(
      title: 'Waste Management',
      description:
          'Poultry manure is a valuable fertilizer resource. Proper management transforms waste into profit while ensuring environmental compliance and sustainability.',
      image: 'assets/poultry_waste.jpg',
      details: [
        'Manure production: 4-6 lbs per 100 birds per day',
        'Composting: 2-3 months for quality fertilizer',
        'Nutrient values: 3% N, 2% P, 2% K (dry matter)',
        'Deep litter system: 4-6 inches depth maintenance',
        'Bioprocessing: Black soldier fly larvae, worm farming',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Successful poultry farming requires careful financial planning, cost tracking, and revenue optimization. Understanding production costs is essential for profitability.',
      image: 'assets/poultry_finance.jpg',
      details: [
        'Feed costs: 60-70% of total expenses',
        'Chick costs: 15-20% of total expenses',
        'Veterinary and medicine costs: 5-10%',
        'Housing and equipment costs',
        'Revenue streams: Eggs, meat, breeding stock, manure',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Understanding market dynamics and choosing the right marketing channels helps maximize returns from poultry production. Multiple revenue streams can improve profitability.',
      image: 'assets/poultry_market.jpg',
      details: [
        'Egg market: Table eggs, fertile eggs, specialty eggs',
        'Meat market: Whole birds, cut pieces, processed products',
        'Breeding stock: Day-old chicks, growers, adults',
        'Value-added: Egg products, processed chicken, manure',
        'Market timing and price forecasting strategies',
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
            Icon(Icons.egg, size: 22),
            SizedBox(width: 8),
            Text(
              'Poultry Decision Support',
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

// ─── TopicDetailScreen — Using AssetImage ───────────────────────────────
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
            // Hero image - Using AssetImage
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
                  // Title with icon
                  Row(
                    children: [
                      Icon(
                        Icons.egg,
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
                  // Description section
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
                  // Pro Tips section - Poultry specific
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
                                'Implement an all-in-all-out production system to break disease cycles',
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
                                'Maintain detailed flock records for performance tracking and disease surveillance',
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
                                'Monitor daily feed and water consumption for early disease detection',
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
