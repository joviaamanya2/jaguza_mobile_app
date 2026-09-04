import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Ankole_cattle_bull_in_western_Uganda_%28not_the_American_Ankole-Watusi%29.png/960px-Ankole_cattle_bull_in_western_Uganda_%28not_the_American_Ankole-Watusi%29.png',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Ankole-Watusi_Cattle_in_a_Kraal%2C_Kamdini_Ocini%2C_Uganda_01.jpg/960px-Ankole-Watusi_Cattle_in_a_Kraal%2C_Kamdini_Ocini%2C_Uganda_01.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Cattle%2C_feeding_on_silage%2C_at_East_Ridge_Farm_-_geograph.org.uk_-_1626473.jpg/960px-Cattle%2C_feeding_on_silage%2C_at_East_Ridge_Farm_-_geograph.org.uk_-_1626473.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Lady_spraying_a_cattle.jpg/960px-Lady_spraying_a_cattle.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/New_born_Frisian_red_white_calf.jpg/960px-New_born_Frisian_red_white_calf.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Milking_a_cow.jpg/960px-Milking_a_cow.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4e/Cow_grazing_on_Shores_of_Lake_Victoria.jpg/960px-Cow_grazing_on_Shores_of_Lake_Victoria.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Kenyan_20_Shilling_Note.jpg/960px-Kenyan_20_Shilling_Note.jpg',
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
      image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Cattle_sale_1.JPG/960px-Cattle_sale_1.JPG',
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
      appBar: AppBar(
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
              child: CachedNetworkImage(
                imageUrl: topic.image,
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: scheme.surfaceContainerHighest,
                  highlightColor: scheme.surface,
                  child: Container(height: 180, color: scheme.surfaceContainerHighest),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
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

// â”€â”€â”€ TopicDetailScreen â€” Using AssetImage â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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
              child: CachedNetworkImage(
                imageUrl: topic.image,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: scheme.surfaceContainerHighest,
                  highlightColor: scheme.surface,
                  child: Container(color: scheme.surfaceContainerHighest),
                ),
                errorWidget: (context, url, error) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
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
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
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
                              'â€¢ ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Regular veterinary checkups are essential for herd health',
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
                              'â€¢ ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Maintain detailed records of breeding, health, and production',
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
                              'â€¢ ',
                              style: TextStyle(
                                color: scheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Invest in quality feed for better milk and meat production',
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
