import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaguza_app/services/api_service.dart';

// Import your disease and marketplace screens
import '../../home_details/Disease Information/disease_info.dart';
import '../../home_details/Market place/market_place.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0;
  bool _isLoading = true;
  String? _loadError;
  List<FeedPost> _feedPosts = [];

  final List<CategoryItem> _categories = [
    CategoryItem(icon: Icons.grid_view_rounded, label: 'All'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Cattle'),
    CategoryItem(icon: Icons.egg_rounded, label: 'Poultry'),
    CategoryItem(icon: Icons.set_meal_rounded, label: 'Pigs'),
    CategoryItem(icon: Icons.grass_rounded, label: 'Goats'),
  ];

  @override
  void initState() {
    super.initState();
    _loadExploreContent();
  }

  Future<void> _loadExploreContent() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    final posts = <FeedPost>[];
    try {
      final resources = await ApiService().getDecisionSupport();
      posts.addAll(resources.whereType<Map>().map(_resourceToPost));
    } catch (e) {
      debugPrint('Decision support load error: $e');
    }
    try {
      final videos = await ApiService().getVideos();
      posts.addAll(videos.whereType<Map>().map(_videoToPost));
    } catch (e) {
      debugPrint('Explore videos load error: $e');
    }

    if (!mounted) return;
    setState(() {
      _feedPosts = posts;
      _isLoading = false;
      if (posts.isEmpty) {
        _loadError = 'No published dashboard content is available yet.';
      }
    });
  }

  FeedPost _resourceToPost(Map raw) {
    final item = Map<String, dynamic>.from(raw);
    final category = _displayCategory('${item['category'] ?? 'General'}');
    final title = '${item['title'] ?? 'Jaguza farming resource'}';
    final content = '${item['summary'] ?? item['content'] ?? ''}';
    return FeedPost(
      author: 'Jaguza Support',
      location: category,
      dateTime: _dateLabel(item['created_at']),
      timeAgo: _timeAgo(item['created_at']),
      title: title,
      excerpt: content,
      category: category,
      likes: int.tryParse('${item['views_count'] ?? 0}') ?? 0,
      comments: 0,
      isVerified: true,
      authorColor: const Color(0xFF2E7D32),
      categoryColor: _categoryColor(category),
      categoryIcon: _categoryIcon(category),
      imageGradientStart: const Color(0xFF2E7D32),
      imageGradientEnd: const Color(0xFF66BB6A),
    );
  }

  FeedPost _videoToPost(Map raw) {
    final item = Map<String, dynamic>.from(raw);
    final categoryValue = item['category'];
    final categoryName = categoryValue is Map ? categoryValue['name'] : categoryValue;
    final category = _displayCategory('${categoryName ?? 'Videos'}');
    final title = '${item['title'] ?? 'Jaguza farming video'}';
    return FeedPost(
      author: 'Jaguza Official',
      location: category,
      dateTime: _dateLabel(item['created_at']),
      timeAgo: _timeAgo(item['created_at']),
      title: title,
      excerpt: '${item['description'] ?? 'Watch this farming lesson from the Jaguza dashboard.'}',
      category: category,
      likes: int.tryParse('${item['views_count'] ?? 0}') ?? 0,
      comments: 0,
      isVerified: true,
      authorColor: const Color(0xFF1565C0),
      categoryColor: const Color(0xFF1565C0),
      categoryIcon: Icons.play_circle_fill_rounded,
      imageGradientStart: const Color(0xFF1565C0),
      imageGradientEnd: const Color(0xFF42A5F5),
    );
  }

  String _displayCategory(String value) {
    final cleaned = value.trim();
    if (cleaned.isEmpty) return 'General';
    return cleaned[0].toUpperCase() + cleaned.substring(1).toLowerCase();
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'poultry': return const Color(0xFFE65100);
      case 'cattle': return const Color(0xFF1E88E5);
      case 'pig': case 'pigs': return const Color(0xFFD84315);
      case 'goat': case 'goats': return const Color(0xFF6D4C41);
      default: return const Color(0xFF2E7D32);
    }
  }

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'poultry': return Icons.egg_rounded;
      case 'cattle': return Icons.pets_rounded;
      case 'pig': case 'pigs': return Icons.set_meal_rounded;
      case 'goat': case 'goats': return Icons.grass_rounded;
      default: return Icons.agriculture_rounded;
    }
  }

  String _dateLabel(dynamic value) {
    final date = DateTime.tryParse('${value ?? ''}');
    if (date == null) return 'Recently published';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _timeAgo(dynamic value) {
    final date = DateTime.tryParse('${value ?? ''}');
    if (date == null) return 'recently';
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    return 'recently';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FeedPost> get _filteredPosts {
    final source = _feedPosts;
    if (_selectedCategory == 0) return _filterSearch(source);
    final catLabel = _categories[_selectedCategory].label.toLowerCase();
    return _filterSearch(source.where((p) => p.category.toLowerCase() == catLabel).toList());
  }

  List<FeedPost> _filterSearch(List<FeedPost> posts) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return posts;
    return posts.where((post) => '${post.title} ${post.excerpt} ${post.category} ${post.author}'.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildQuickBanners(),
          _buildCategoryChips(),
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  HEADER - Clean, solid color
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildHeader() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: scheme.primary,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              _headerBtn(Icons.menu_rounded, () {}),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Explore Community',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _headerBtn(Icons.notifications_none_rounded, () {}),
              const SizedBox(width: 8),
              _headerBtn(Icons.chat_bubble_outline_rounded, () {}),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _trendTag('# PoultryFarming'),
              const SizedBox(width: 8),
              _trendTag('# DairyTips'),
              const SizedBox(width: 8),
              _trendTag('# AnimalHealth'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _trendTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  SEARCH BAR
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search posts, topics, or authors...',
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

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  QUICK BANNERS - Flat, clean with navigation
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildQuickBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _quickBanner(
              icon: Icons.storefront_rounded,
              title: 'Sell your agricultural products',
              subtitle: 'in Market Place',
              color: const Color(0xFFF57C00),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MarketplaceScreen()),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _quickBanner(
              icon: Icons.biotech_rounded,
              title: 'Know more about',
              subtitle: 'animal Diseases',
              color: Theme.of(context).colorScheme.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AnimalDiseasesScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickBanner({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: scheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  CATEGORY CHIPS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildCategoryChips() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final isActive = _selectedCategory == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? scheme.primary : Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive ? scheme.primary : scheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      cat.icon,
                      size: 14,
                      color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      cat.label,
                      style: TextStyle(
                        color: isActive ? scheme.onPrimary : scheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  FEED
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  Widget _buildFeed() {
    final scheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: scheme.primary),
      );
    }

    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text(
              _loadError ?? 'No matching posts',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _loadError == null ? 'Try another category or search term' : 'Pull down to refresh dashboard content',
              style: TextStyle(
                fontSize: 13,
                color: scheme.onSurfaceVariant,
              ),
            ),
            if (_loadError != null) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _loadExploreContent,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) => _FeedPostCard(post: posts[index]),
    );
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  FEED POST CARD - Clean, flat design
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class _FeedPostCard extends StatefulWidget {
  final FeedPost post;
  const _FeedPostCard({required this.post});

  @override
  State<_FeedPostCard> createState() => _FeedPostCardState();
}

class _FeedPostCardState extends State<_FeedPostCard> {
  bool _isLiked = false;
  int _likeCount = 0;
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final post = widget.post;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: post.authorColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      post.authorInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Author info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.author,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                          ),
                          if (post.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(Icons.verified_rounded, color: scheme.primary, size: 14),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: scheme.onSurfaceVariant, size: 11),
                          const SizedBox(width: 2),
                          Text(
                            post.location,
                            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'â€¢',
                            style: TextStyle(color: scheme.outlineVariant, fontSize: 11),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            post.timeAgo,
                            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Category tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: post.categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(post.categoryIcon, size: 12, color: post.categoryColor),
                      const SizedBox(width: 3),
                      Text(
                        post.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: post.categoryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Post image
          Container(
            width: double.infinity,
            height: 180,
            color: post.imageGradientStart,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      post.categoryIcon,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.camera_alt_rounded, color: Colors.white.withValues(alpha: 0.8), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${post.location}, ${post.dateTime}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Title & excerpt
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Text(
              post.title,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
                height: 1.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 4),
            child: Text(
              post.excerpt,
              style: TextStyle(
                fontSize: 12.5,
                color: scheme.onSurfaceVariant,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Read more
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'Read more',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scheme.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: scheme.primary.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Divider(color: scheme.outlineVariant, height: 1),
          ),

          // Action bar
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 10, 10),
            child: Row(
              children: [
                _actionBtn(
                  icon: _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  label: '$_likeCount',
                  color: _isLiked ? const Color(0xFFE53935) : scheme.onSurfaceVariant,
                  onTap: () {
                    setState(() {
                      _isLiked = !_isLiked;
                      _likeCount += _isLiked ? 1 : -1;
                    });
                  },
                ),
                _actionBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '${post.comments}',
                  color: scheme.onSurfaceVariant,
                  onTap: () => _showCommentsSheet(context, post),
                ),
                const Spacer(),
                _actionBtn(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: scheme.onSurfaceVariant,
                  onTap: () {},
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                      color: _isBookmarked ? const Color(0xFFFFA000) : scheme.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, FeedPost post) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.55,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(ctx).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Comments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${post.comments}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            if (post.comments == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 44, color: scheme.outlineVariant),
                      const SizedBox(height: 10),
                      Text(
                        'No comments yet',
                        style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Be the first to share your thoughts',
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),
            // Comment input
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: scheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Y',
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Text(
                        'Add a comment...',
                        style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.send_rounded, color: scheme.onPrimary, size: 16),
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
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DATA MODELS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class CategoryItem {
  final IconData icon;
  final String label;
  const CategoryItem({required this.icon, required this.label});
}

class FeedPost {
  final String author;
  final String location;
  final String dateTime;
  final String timeAgo;
  final String title;
  final String excerpt;
  final String category;
  final int likes;
  final int comments;
  final bool isVerified;
  final Color authorColor;
  final Color categoryColor;
  final IconData categoryIcon;
  final Color imageGradientStart;
  final Color imageGradientEnd;

  String get authorInitials => author.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

  const FeedPost({
    required this.author,
    required this.location,
    required this.dateTime,
    required this.timeAgo,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.likes,
    required this.comments,
    this.isVerified = false,
    required this.authorColor,
    required this.categoryColor,
    required this.categoryIcon,
    required this.imageGradientStart,
    required this.imageGradientEnd,
  });
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  SAMPLE DATA
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
const List<FeedPost> feedPosts = [
  FeedPost(
    author: 'Jaguza Official',
    location: 'Kampala',
    dateTime: 'Sep 8, 2023 Â· 1:19 PM',
    timeAgo: '2h ago',
    title: 'Benefits of Small Scale Poultry ~ Poultry Farming Guide',
    excerpt: 'Ever wondered whether small scale poultry farming is worth it? Here is a detailed breakdown of benefits, challenges, and tips to get started successfully in your backyard.',
    category: 'Poultry',
    likes: 24,
    comments: 5,
    isVerified: true,
    authorColor: Color(0xFF2E7D32),
    categoryColor: Color(0xFFE65100),
    categoryIcon: Icons.egg_rounded,
    imageGradientStart: Color(0xFFFF8F00),
    imageGradientEnd: Color(0xFFF57C00),
  ),
  FeedPost(
    author: 'Dr. Atim Nancy',
    location: 'Jinja',
    dateTime: 'Sep 7, 2023 Â· 10:30 AM',
    timeAgo: '1d ago',
    title: 'Understanding Cattle Nutrition: A Complete Feeding Guide',
    excerpt: 'Proper nutrition is the backbone of a healthy herd. Learn about balanced feed rations, mineral supplements, and seasonal feeding strategies for optimal cattle productivity.',
    category: 'Cattle',
    likes: 38,
    comments: 12,
    isVerified: true,
    authorColor: Color(0xFF8E24AA),
    categoryColor: Color(0xFF1E88E5),
    categoryIcon: Icons.pets_rounded,
    imageGradientStart: Color(0xFF1565C0),
    imageGradientEnd: Color(0xFF42A5F5),
  ),
  FeedPost(
    author: 'Mugisha David',
    location: 'Kabale',
    dateTime: 'Sep 6, 2023 Â· 4:45 PM',
    timeAgo: '2d ago',
    title: 'Modern Pig Farming Techniques for Ugandan Farmers',
    excerpt: 'Discover modern techniques in pig housing, feeding, disease prevention, and breeding that can significantly increase your farm output and profitability.',
    category: 'Pigs',
    likes: 15,
    comments: 3,
    isVerified: false,
    authorColor: Color(0xFFFB8C00),
    categoryColor: Color(0xFFD84315),
    categoryIcon: Icons.set_meal_rounded,
    imageGradientStart: Color(0xFFD84315),
    imageGradientEnd: Color(0xFFFF7043),
  ),
  FeedPost(
    author: 'Nabukenya Sarah',
    location: 'Wakiso',
    dateTime: 'Sep 5, 2023 Â· 9:00 AM',
    timeAgo: '3d ago',
    title: 'Dairy Farming Best Practices: From Milking to Market',
    excerpt: 'Learn the essential best practices for dairy farming including proper milking hygiene, milk storage, quality testing, and finding the best markets for your products.',
    category: 'Cattle',
    likes: 42,
    comments: 8,
    isVerified: true,
    authorColor: Color(0xFF1E88E5),
    categoryColor: Color(0xFF1E88E5),
    categoryIcon: Icons.pets_rounded,
    imageGradientStart: Color(0xFF0D47A1),
    imageGradientEnd: Color(0xFF1976D2),
  ),
  FeedPost(
    author: 'Okello James',
    location: 'Lira',
    dateTime: 'Sep 4, 2023 Â· 2:15 PM',
    timeAgo: '4d ago',
    title: 'Crop-Livestock Integration: Maximizing Your Farm Output',
    excerpt: 'How integrating crops and livestock on the same farm can reduce costs, improve soil fertility, and create multiple income streams for smallholder farmers.',
    category: 'Crops',
    likes: 19,
    comments: 6,
    isVerified: false,
    authorColor: Color(0xFF2E7D32),
    categoryColor: Color(0xFF2E7D32),
    categoryIcon: Icons.agriculture_rounded,
    imageGradientStart: Color(0xFF2E7D32),
    imageGradientEnd: Color(0xFF66BB6A),
  ),
  FeedPost(
    author: 'Kemigisha Alice',
    location: 'Fort Portal',
    dateTime: 'Sep 3, 2023 Â· 11:30 AM',
    timeAgo: '5d ago',
    title: 'Goat Rearing in Uganda: Breeds, Feeding & Health Tips',
    excerpt: 'A comprehensive guide to the best goat breeds in Uganda, their feeding requirements, common diseases, vaccination schedules, and market opportunities.',
    category: 'Goats',
    likes: 27,
    comments: 9,
    isVerified: true,
    authorColor: Color(0xFF8E24AA),
    categoryColor: Color(0xFF6D4C41),
    categoryIcon: Icons.grass_rounded,
    imageGradientStart: Color(0xFF4E342E),
    imageGradientEnd: Color(0xFF8D6E63),
  ),
  FeedPost(
    author: 'Ssebaggala Joseph',
    location: 'Masaka',
    dateTime: 'Sep 2, 2023 Â· 3:00 PM',
    timeAgo: '6d ago',
    title: 'Starting a Fish Farm: A Beginner\'s Guide to Aquaculture',
    excerpt: 'Everything you need to know about setting up a fish pond in Uganda â€” from site selection and pond construction to stocking, feeding, and harvesting.',
    category: 'Fish',
    likes: 11,
    comments: 2,
    isVerified: false,
    authorColor: Color(0xFFFFA000),
    categoryColor: Color(0xFF039BE5),
    categoryIcon: Icons.water_drop_rounded,
    imageGradientStart: Color(0xFF0277BD),
    imageGradientEnd: Color(0xFF29B6F6),
  ),
];
