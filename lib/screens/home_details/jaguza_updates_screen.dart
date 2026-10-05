import 'package:flutter/material.dart';

class JaguzaUpdatesScreen extends StatefulWidget {
  const JaguzaUpdatesScreen({super.key});

  @override
  State<JaguzaUpdatesScreen> createState() => _JaguzaUpdatesScreenState();
}

class _JaguzaUpdatesScreenState extends State<JaguzaUpdatesScreen> {
  int _selectedTab = 0;

  static const _updates = [
    _Update(
      title: 'Jaguza is bringing new tools to farmers',
      description:
          'Discover practical resources, expert advice and new ways to grow your farm with Jaguza.',
      image: 'lib/assets/images/cattle.jpg',
      date: 'Latest update',
    ),
    _Update(
      title: 'Better care for a healthier herd',
      description:
          'Explore animal health guidance and keep up with the latest farming stories from our community.',
      image: 'lib/assets/images/Goat.png',
      date: 'Community news',
    ),
    _Update(
      title: 'More knowledge for your farm',
      description:
          'Find useful tips and information to help you make confident decisions on your farm.',
      image: 'lib/assets/images/Poultry.png',
      date: 'Farm resources',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF08783E),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Image.asset(
              'lib/assets/images/jaguza_j_mark.png',
              width: 34,
              height: 34,
            ),
            const SizedBox(width: 10),
            const Text('Notifications',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
      body: Column(
        children: [
          Material(
            color: Theme.of(context).cardColor,
            child: Row(children: [
              _tab(scheme, 0, 'Updates'),
              _tab(scheme, 1, 'Alerts'),
            ]),
          ),
          Expanded(
            child: _selectedTab == 0
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: _updates.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 96,
                      color: scheme.outlineVariant,
                    ),
                    itemBuilder: (context, index) =>
                        _UpdateCard(update: _updates[index]),
                  )
                : _alerts(context),
          ),
        ],
      ),
    );
  }

  Widget _tab(ColorScheme scheme, int index, String label) {
    final active = _selectedTab == index;
    final color = active ? const Color(0xFF08783E) : scheme.onSurfaceVariant;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = index),
        child: Column(children: [
          const SizedBox(height: 14),
          Text(label,
              style: TextStyle(
                color: active ? const Color(0xFF08783E) : color,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                fontSize: 14,
              )),
          const SizedBox(height: 12),
          Container(height: 2, color: active ? const Color(0xFF08783E) : Colors.transparent),
        ]),
      ),
    );
  }

  Widget _alerts(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.notifications_none_rounded,
              size: 54, color: scheme.onSurfaceVariant.withValues(alpha: .55)),
          const SizedBox(height: 12),
          Text('You’re all caught up',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          const SizedBox(height: 6),
          Text('Important alerts about your farm will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ]),
      ),
    );
  }
}

class _Update {
  final String title;
  final String description;
  final String image;
  final String date;

  const _Update({required this.title, required this.description, required this.image, required this.date});
}

class _UpdateCard extends StatelessWidget {
  final _Update update;

  const _UpdateCard({required this.update});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              update.image,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  update.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  update.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  update.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
