import 'package:flutter/material.dart';
import 'package:jaguza_app/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Farming Tips',
    'Animal Health',
    'Disease Management',
    'Success Stories',
    'Training',
    'Interviews',
  ];

  final List<VideoItem> _videos = [
    VideoItem(
      id: '1',
      title: 'Modern Poultry Farming Techniques',
      description: 'Learn the latest techniques for sustainable poultry farming.',
      category: 'Farming Tips',
      duration: '15:30',
      views: 12450,
      date: '2024-06-28',
      thumbnailColor: const Color(0xFFFF8F00),
      icon: Icons.egg_rounded,
      isFeatured: true,
    ),
    VideoItem(
      id: '2',
      title: 'Foot and Mouth Disease - Prevention and Control',
      description: 'Comprehensive guide on preventing and controlling foot and mouth disease.',
      category: 'Disease Management',
      duration: '22:15',
      views: 8760,
      date: '2024-06-25',
      thumbnailColor: const Color(0xFFE53935),
      icon: Icons.coronavirus_rounded,
      isFeatured: false,
    ),
    VideoItem(
      id: '3',
      title: 'Dairy Farming Success - From Farm to Market',
      description: 'Inspiring story of how a small dairy farm became a successful business.',
      category: 'Success Stories',
      duration: '12:20',
      views: 21340,
      date: '2024-06-20',
      thumbnailColor: const Color(0xFF1E88E5),
      icon: Icons.water_drop_rounded,
      isFeatured: false,
    ),
    VideoItem(
      id: '4',
      title: 'Pig Farming - Nutrition and Health',
      description: 'Learn about the nutritional needs of pigs and how to ensure their health.',
      category: 'Animal Health',
      duration: '20:10',
      views: 9870,
      date: '2024-06-18',
      thumbnailColor: const Color(0xFFD84315),
      icon: Icons.set_meal_rounded,
      isFeatured: false,
    ),
    VideoItem(
      id: '5',
      title: 'Goat Rearing - Breeding and Management',
      description: 'Complete guide to goat breeding, feeding, and health management.',
      category: 'Farming Tips',
      duration: '14:50',
      views: 6540,
      date: '2024-06-15',
      thumbnailColor: const Color(0xFF8E24AA),
      icon: Icons.grass_rounded,
      isFeatured: false,
    ),
    VideoItem(
      id: '6',
      title: 'Veterinary Interview - Common Cattle Diseases',
      description: 'Veterinary expert discusses common cattle diseases and treatment.',
      category: 'Interviews',
      duration: '25:00',
      views: 4320,
      date: '2024-06-12',
      thumbnailColor: const Color(0xFF6D4C41),
      icon: Icons.medical_services_rounded,
      isFeatured: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final response = await ApiService().getVideos();
      final loaded = response.whereType<Map>().map((raw) {
        final item = Map<String, dynamic>.from(raw);
        final categoryValue = item['category'];
        final category = categoryValue is Map
            ? '${categoryValue['name'] ?? 'General'}'
            : '${categoryValue ?? 'General'}';
        final color = _categoryColor(category);
        return VideoItem(
          id: '${item['id'] ?? ''}',
          title: '${item['title'] ?? 'Jaguza video'}',
          description: '${item['description'] ?? ''}',
          category: category,
          duration: '${item['duration'] ?? '—'}',
          views: int.tryParse('${item['views_count'] ?? 0}') ?? 0,
          date: '${item['created_at'] ?? ''}'.split('T').first,
          thumbnailColor: color,
          icon: _categoryIcon(category),
          isFeatured: item['is_featured'] == true,
          videoUrl: item['video_url']?.toString(),
          thumbnailUrl: item['thumbnail_url']?.toString(),
        );
      }).where((video) => video.id.isNotEmpty).toList();
      if (!mounted) return;
      setState(() {
        _videos
          ..clear()
          ..addAll(loaded);
        _categories
          ..clear()
          ..add('All')
          ..addAll(loaded.map((video) => video.category).toSet());
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Video load error: $e');
      if (mounted) {
        setState(() {
          _videos.clear();
          _categories
            ..clear()
            ..add('All');
          _isLoading = false;
        });
      }
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'poultry': return const Color(0xFFFF8F00);
      case 'cattle': return const Color(0xFF1E88E5);
      case 'pig': case 'pigs': return const Color(0xFFD84315);
      case 'goat': case 'goats': return const Color(0xFF8E24AA);
      default: return const Color(0xFF2E7D32);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'poultry': return Icons.egg_rounded;
      case 'cattle': return Icons.pets_rounded;
      case 'pig': case 'pigs': return Icons.set_meal_rounded;
      case 'goat': case 'goats': return Icons.grass_rounded;
      default: return Icons.play_circle_fill_rounded;
    }
  }

  List<VideoItem> get _filteredVideos {
    final query = _searchQuery.toLowerCase();
    return _videos.where((video) {
      final matchesSearch = video.title.toLowerCase().contains(query) ||
          video.description.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || video.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<VideoItem> get _featuredVideos {
    return _videos.where((video) => video.isFeatured).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Jaguza Videos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: scheme.onPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border_rounded, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator(color: scheme.primary))
                : RefreshIndicator(
                    color: scheme.primary,
                    onRefresh: _loadVideos,
                    child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              children: [
                if (_selectedCategory == 'All' && _searchQuery.isEmpty) ...[
                  _buildFeaturedSection(),
                  const SizedBox(height: 16),
                ],
                _buildVideoList(),
              ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  SEARCH BAR
  // ═══════════════════════════════════════
  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search videos...',
            hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            prefixIcon: Icon(Icons.search_rounded, color: scheme.primary, size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant, size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  CATEGORY CHIPS
  // ═══════════════════════════════════════
  Widget _buildCategoryChips() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isActive = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? scheme.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? scheme.primary : scheme.outlineVariant,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════
  //  FEATURED SECTION
  // ═══════════════════════════════════════
  Widget _buildFeaturedSection() {
    if (_featuredVideos.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.star_rounded,
                size: 16,
                color: scheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Featured Videos',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _featuredVideos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildFeaturedCard(_featuredVideos[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(VideoItem video) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showVideoDetails(context, video),
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                color: video.thumbnailColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(video.thumbnailUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                      ),
                    ),
                  Center(
                    child: Icon(
                      video.icon,
                      size: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Watch',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              video.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.visibility_rounded, size: 10, color: scheme.onSurfaceVariant),
                const SizedBox(width: 3),
                Text(
                  _formatViews(video.views),
                  style: TextStyle(
                    fontSize: 10,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.access_time_rounded, size: 10, color: scheme.onSurfaceVariant),
                const SizedBox(width: 3),
                Text(
                  video.duration,
                  style: TextStyle(
                    fontSize: 10,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  VIDEO LIST
  // ═══════════════════════════════════════
  Widget _buildVideoList() {
    final scheme = Theme.of(context).colorScheme;
    final videos = _filteredVideos;

    if (videos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Icon(Icons.video_library_rounded, size: 64, color: scheme.outlineVariant),
              const SizedBox(height: 16),
              Text(
                'No videos found',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try adjusting your search or category',
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: videos.map((video) => _buildVideoCard(video)).toList(),
    );
  }

  Widget _buildVideoCard(VideoItem video) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _showVideoDetails(context, video),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 70,
              decoration: BoxDecoration(
                color: video.thumbnailColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  if (video.thumbnailUrl != null && video.thumbnailUrl!.isNotEmpty)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(video.thumbnailUrl!, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                      ),
                    ),
                  Center(
                    child: Icon(
                      video.icon,
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    video.description,
                    style: TextStyle(
                      fontSize: 10,
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: video.thumbnailColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          video.category,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            color: video.thumbnailColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility_rounded, size: 10, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(
                            _formatViews(video.views),
                            style: TextStyle(
                              fontSize: 9,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today_rounded, size: 9, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 2),
                          Text(
                            video.date,
                            style: TextStyle(
                              fontSize: 9,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  VIDEO DETAILS DIALOG
  // ═══════════════════════════════════════
  void _showVideoDetails(BuildContext context, VideoItem video) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video Preview
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: video.thumbnailColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(
                              video.icon,
                              size: 56,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: scheme.primary.withValues(alpha: 0.8),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                video.duration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Title
                    Text(
                      video.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Meta Info
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: video.thumbnailColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            video.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: video.thumbnailColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.visibility_rounded, size: 12, color: scheme.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Text(
                              _formatViews(video.views),
                              style: TextStyle(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today_rounded, size: 10, color: scheme.onSurfaceVariant),
                            const SizedBox(width: 3),
                            Text(
                              video.date,
                              style: TextStyle(
                                fontSize: 11,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: video.videoUrl == null || video.videoUrl!.isEmpty
                                ? null
                                : () async {
                                    await launchUrl(
                                      Uri.parse(video.videoUrl!),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  },
                            icon: const Icon(Icons.share_rounded, size: 16),
                            label: const Text('Watch'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: scheme.primary,
                              foregroundColor: scheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border_rounded, size: 16),
                            label: const Text('Save'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: scheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: scheme.primary),
                              textStyle: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Related Videos
                    Text(
                      'Related Videos',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._videos.where((v) => v.id != video.id).take(3).map((v) => 
                      _buildRelatedVideoCard(v),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedVideoCard(VideoItem video) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showVideoDetails(context, video);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 50,
              decoration: BoxDecoration(
                color: video.thumbnailColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Icon(
                  video.icon,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${video.duration} • ${_formatViews(video.views)} views',
                    style: TextStyle(
                      fontSize: 9,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════
  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
  }
}

// ═══════════════════════════════════════
//  DATA MODELS
// ═══════════════════════════════════════
class VideoItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String duration;
  final int views;
  final String date;
  final Color thumbnailColor;
  final IconData icon;
  final bool isFeatured;
  final String? videoUrl;
  final String? thumbnailUrl;

  VideoItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.duration,
    required this.views,
    required this.date,
    required this.thumbnailColor,
    required this.icon,
    required this.isFeatured,
    this.videoUrl,
    this.thumbnailUrl,
  });
}
