import 'package:flutter/material.dart';

class PigDecisionScreen extends StatefulWidget {
  const PigDecisionScreen({super.key});

  @override
  State<PigDecisionScreen> createState() => _PigDecisionScreenState();
}

class _PigDecisionScreenState extends State<PigDecisionScreen> {
  final List<DecisionTopic> _decisionTopics = [
    DecisionTopic(
      title: 'Breed Selection',
      description:
          'Choosing the right pig breed is critical for your farming success. Consider your primary purpose (meat, breeding stock, or show), growth rate, feed conversion efficiency, disease resistance, and market demand.',
      image: 'assets/images/pig_breed.jpg',
      details: [
        'Meat breeds: Large White, Landrace, Duroc, Hampshire',
        'Maternal breeds: Yorkshire, Landrace, Chester White',
        'Paternal breeds: Duroc, Hampshire, Pietrain',
        'Crossbreeding programs for hybrid vigor',
        'Adaptability to local climate and conditions',
      ],
    ),
    DecisionTopic(
      title: 'Housing & Facilities',
      description:
          'Proper housing is essential for pig health, productivity, and welfare. Good facility design reduces stress, prevents diseases, and improves feed efficiency and growth rates.',
      image: 'assets/images/pig_housing.jpg',
      details: [
        'Space requirement: 8-30 sq ft per pig (age dependent)',
        'Proper ventilation: 20-30 air changes per hour',
        'Temperature control: 65-75°F for optimum growth',
        'Separate areas: Farrowing, nursery, grower, finisher',
        'Slatted floors for waste management (concrete or plastic)',
      ],
    ),
    DecisionTopic(
      title: 'Feeding & Nutrition',
      description:
          'Pigs require balanced nutrition for optimal growth, reproduction, and health. Feed costs represent 60-70% of production costs, making feed efficiency crucial for profitability.',
      image: 'assets/images/pig_feeding.jpg',
      details: [
        'Creep feed: 18-22% protein for piglets (0-20 lbs)',
        'Grower feed: 16-18% protein (20-50 lbs)',
        'Finisher feed: 14-16% protein (50-260+ lbs)',
        'Gestating sow: 12-14% protein with fiber',
        'Lactating sow: 16-18% protein with high energy',
      ],
    ),
    DecisionTopic(
      title: 'Health Management & Disease Prevention',
      description:
          'Maintaining herd health through vaccination, biosecurity, and regular monitoring prevents costly diseases and improves productivity. A proactive health program is essential for success.',
      image: 'assets/images/pig_health.jpg',
      details: [
        'Vaccination: PRRS, Swine Flu, E. coli, PCV2, Mycoplasma',
        'Biosecurity: All-in-all-out production systems',
        'Parasite control: Internal and external deworming',
        'Regular health monitoring and record keeping',
        'Quarantine protocols for new breeding stock',
      ],
    ),
    DecisionTopic(
      title: 'Reproduction Management',
      description:
          'Strategic breeding decisions ensure consistent piglet production, healthy offspring, and improved herd genetics. Understanding reproductive cycles is key to maximizing production.',
      image: 'assets/images/pig_reproduction.jpg',
      details: [
        'Age at first breeding: 7-8 months (gilts)',
        'Estrous cycle: 21 days (standing heat for 2-3 days)',
        'Gestation period: 114 days (3 months, 3 weeks, 3 days)',
        'Weaning age: 18-28 days (depending on system)',
        'Sow productivity: 2-2.5 litters per year',
      ],
    ),
    DecisionTopic(
      title: 'Farrowing Management',
      description:
          'Farrowing is the most critical phase in pig production. Proper management during farrowing and lactation ensures high piglet survival rates and sow productivity.',
      image: 'assets/images/pig_farrowing.jpg',
      details: [
        'Farrowing crate: Prevents piglet crushing',
        'Litter size: 10-14 piglets per litter (average)',
        'Birth weight: 2.5-3.5 lbs (critical for survival)',
        'Colostrum intake: Critical within first 6 hours',
        'Iron supplementation: Within first 3 days',
      ],
    ),
    DecisionTopic(
      title: 'Grower-Finisher Management',
      description:
          'Grower-finisher management focuses on maximizing daily gain and feed efficiency from weaning to market weight, directly impacting profitability.',
      image: 'assets/images/pig_grower.jpg',
      details: [
        'Growth rate: 1.5-2.2 lbs per day (feed dependent)',
        'Market weight: 240-280 lbs (depending on market)',
        'Feed conversion ratio: 2.6-3.0 lbs feed per lb gain',
        'Group housing: 20-40 pigs per pen (space dependent)',
        'Feed efficiency monitoring and adjustments',
      ],
    ),
    DecisionTopic(
      title: 'Water Management',
      description:
          'Clean, accessible water is essential for pig health, digestion, growth, and thermoregulation. Water quality and availability directly affect feed intake and productivity.',
      image: 'assets/images/pig_water.jpg',
      details: [
        'Daily water: 2-6 gallons per pig (age dependent)',
        'Waterer: 1 per 20 pigs (nipple or bowl)',
        'Water flow rate: 0.5-1 gallon per minute',
        'Water quality monitoring (pH, bacteria, minerals)',
        'Clean, fresh water available 24/7',
      ],
    ),
    DecisionTopic(
      title: 'Waste Management',
      description:
          'Effective waste management is crucial for environmental sustainability, regulatory compliance, and farm economics. Proper manure handling can also be a valuable nutrient source.',
      image: 'assets/images/pig_waste.jpg',
      details: [
        'Manure: 1-2 cubic yards per finishing pig per year',
        'Storage: Covered pits, lagoons, or composting',
        'Nutrient management: Nitrogen and phosphorus planning',
        'Application: Crop land as fertilizer',
        'Environmental regulations and compliance',
      ],
    ),
    DecisionTopic(
      title: 'Financial Management',
      description:
          'Successful pig farming requires careful financial planning, cost tracking, and revenue optimization. Understanding production costs is essential for profitability in a volatile market.',
      image: 'assets/images/pig_finance.jpg',
      details: [
        'Feed costs: 60-70% of total expenses',
        'Piglet costs: 20-25% of total expenses',
        'Veterinary and medicine costs: 5-10%',
        'Facility and equipment costs',
        'Market price fluctuations and hedging strategies',
      ],
    ),
    DecisionTopic(
      title: 'Marketing & Sales',
      description:
          'Understanding market dynamics and choosing the right marketing channels helps maximize returns from pork production. Multiple revenue streams can improve farm profitability.',
      image: 'assets/images/pig_market.jpg',
      details: [
        'Market hogs: Contract production vs. spot market',
        'Breeding stock: Sales to other producers',
        'Niche markets: Pasture-raised, heritage breeds',
        'Value-added: Processed pork products',
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
            Icon(Icons.pets, size: 22),
            SizedBox(width: 8),
            Text(
              'Pig Decision Support',
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
            // Image in the middle
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

// ─── TopicDetailScreen — UNCHANGED ───────────────────────────────
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
                                'Implement a strict biosecurity program to prevent disease introduction',
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
                                'Use all-in-all-out production system to break disease cycles',
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
                                'Monitor feed conversion ratios to optimize profitability',
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
