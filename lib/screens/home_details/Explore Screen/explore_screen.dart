import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jaguza_app/services/api_service.dart';

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

  static const String _iconDir = 'lib/assets/images/home icons';
  final List<CategoryItem> _categories = const [
    CategoryItem(icon: Icons.forum_rounded, label: 'All'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Cattle', image: '$_iconDir/cow.png'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Pigs', image: '$_iconDir/pig.png'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Goats', image: '$_iconDir/goat.png'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Rabbits', image: '$_iconDir/rabbit.png'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Sheep', image: '$_iconDir/sheep.png'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Poultry', image: '$_iconDir/poultry.png'),
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
      id: 'resource_${item['id'] ?? title.hashCode}',
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
    final title = '${item['title'] ?? 'Jaguza farming post'}';
    final mediaType = '${item['media_type'] ?? 'video'}'.toLowerCase();
    final isImage = mediaType == 'image';

    String? cleanUrl(dynamic value) {
      final text = '${value ?? ''}'.trim();
      return text.isEmpty ? null : text;
    }

    final imageUrl = isImage
        ? (cleanUrl(item['image_url']) ?? cleanUrl(item['thumbnail_url']))
        : cleanUrl(item['thumbnail_url']);

    return FeedPost(
      id: 'video_${item['id'] ?? title.hashCode}',
      author: 'Jaguza Official',
      location: category,
      dateTime: _dateLabel(item['created_at']),
      timeAgo: _timeAgo(item['created_at']),
      title: title,
      excerpt: '${item['description'] ?? (isImage ? 'Shared from the Jaguza dashboard.' : 'Watch this farming lesson from the Jaguza dashboard.')}',
      category: category,
      likes: int.tryParse('${item['views_count'] ?? 0}') ?? 0,
      comments: 0,
      isVerified: true,
      authorColor: const Color(0xFF1565C0),
      categoryColor: const Color(0xFF1565C0),
      categoryIcon: isImage ? Icons.image_rounded : Icons.play_circle_fill_rounded,
      imageGradientStart: const Color(0xFF1565C0),
      imageGradientEnd: const Color(0xFF42A5F5),
      imageUrl: imageUrl,
      isVideo: !isImage,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildCategoryIcons(),
          _buildSearchBar(),
          const SizedBox(height: 6),
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: 22),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            final active = _selectedCategory == index;
            final color = active
                ? scheme.primary
                : scheme.onSurfaceVariant.withValues(alpha: 0.6);
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = index),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: cat.image != null
                        ? Image.asset(
                            cat.image!,
                            color: color,
                            colorBlendMode: BlendMode.srcIn,
                            errorBuilder: (_, __, ___) =>
                                Icon(cat.icon, size: 22, color: color),
                          )
                        : Icon(cat.icon, size: 24, color: color),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 2.5,
                    width: 22,
                    decoration: BoxDecoration(
                      color: active ? scheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  HEADER - Clean, solid color
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
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
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
  //  CATEGORY CHIPS
  // â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
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
  int _commentCount = 0;
  bool _isBookmarked = false;
  bool _busyLike = false;

  String get _key => widget.post.storageKey;

  @override
  void initState() {
    super.initState();
    _likeCount = widget.post.likes;
    _commentCount = widget.post.comments;
    _loadLocalState();
  }

  Future<void> _loadLocalState() async {
    final liked = await ExploreLocalStore.isLiked(_key);
    final count = await ExploreLocalStore.commentCount(_key);
    if (!mounted) return;
    setState(() {
      _isLiked = liked;
      _likeCount = widget.post.likes + (liked ? 1 : 0);
      _commentCount = widget.post.comments + count;
    });
  }

  Future<void> _toggleLike() async {
    if (_busyLike) return;
    _busyLike = true;
    final nowLiked = await ExploreLocalStore.toggleLike(_key);
    if (mounted) {
      setState(() {
        _isLiked = nowLiked;
        _likeCount = widget.post.likes + (nowLiked ? 1 : 0);
      });
    }
    _busyLike = false;
  }

  Future<void> _sharePost() async {
    final post = widget.post;
    final text = [
      post.title,
      '',
      post.excerpt,
      '',
      'Shared from the Jaguza app',
    ].join('\n');
    try {
      await Share.share(text, subject: post.title);
    } catch (e) {
      if (!mounted) return;
      await Clipboard.setData(ClipboardData(text: text));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard')),
      );
    }
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

          // Post media (image / video thumbnail, with a placeholder fallback)
          _buildMedia(post),

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
                  onTap: _toggleLike,
                ),
                _actionBtn(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: '$_commentCount',
                  color: scheme.onSurfaceVariant,
                  onTap: () => _showCommentsSheet(context, post),
                ),
                const Spacer(),
                _actionBtn(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  color: scheme.onSurfaceVariant,
                  onTap: _sharePost,
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

  Widget _buildMedia(FeedPost post) {
    const height = 180.0;

    Widget placeholder() => Container(
          width: double.infinity,
          height: height,
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
                  child: Icon(post.categoryIcon, color: Colors.white, size: 30),
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
        );

    final url = post.imageUrl;
    if (url == null || url.isEmpty) return placeholder();

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: post.imageGradientStart.withValues(alpha: 0.15),
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: post.imageGradientStart,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => placeholder(),
          ),
          if (post.isVideo)
            Center(
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
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

  Future<void> _showCommentsSheet(BuildContext context, FeedPost post) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _CommentsSheet(storageKey: _key),
    );
    if (mounted) {
      final count = await ExploreLocalStore.commentCount(_key);
      if (mounted) {
        setState(() => _commentCount = widget.post.comments + count);
      }
    }
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  COMMENTS SHEET
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class _CommentsSheet extends StatefulWidget {
  final String storageKey;
  const _CommentsSheet({required this.storageKey});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final TextEditingController _controller = TextEditingController();
  List<PostComment> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final list = await ExploreLocalStore.comments(widget.storageKey);
    if (!mounted) return;
    setState(() {
      _comments = list;
      _loading = false;
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final list = await ExploreLocalStore.addComment(widget.storageKey, text);
    _controller.clear();
    if (!mounted) return;
    setState(() => _comments = list);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                      '${_comments.length}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close_rounded, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator(color: scheme.primary))
                  : _comments.isEmpty
                      ? Center(
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
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          itemCount: _comments.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final c = _comments[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      c.author.isNotEmpty ? c.author[0].toUpperCase() : 'Y',
                                      style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            c.author,
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                              color: scheme.onSurface,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            c.timeAgo,
                                            style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        c.text,
                                        style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
            ),
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
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      style: TextStyle(color: scheme.onSurface, fontSize: 12.5),
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12.5),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: scheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: scheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: scheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
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

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  LOCAL LIKES / COMMENTS STORE (on-device, per post)
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class PostComment {
  final String text;
  final String author;
  final DateTime createdAt;

  const PostComment({required this.text, required this.author, required this.createdAt});

  Map<String, dynamic> toJson() => {
        'text': text,
        'author': author,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PostComment.fromJson(Map<String, dynamic> j) => PostComment(
        text: '${j['text'] ?? ''}',
        author: '${j['author'] ?? 'You'}',
        createdAt: DateTime.tryParse('${j['createdAt'] ?? ''}') ?? DateTime.now(),
      );

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class ExploreLocalStore {
  static const _likesKey = 'explore_liked_posts';
  static const _commentsKey = 'explore_post_comments';

  static Future<Set<String>> _likedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_likesKey) ?? const <String>[]).toSet();
  }

  static Future<bool> isLiked(String postKey) async => (await _likedIds()).contains(postKey);

  static Future<bool> toggleLike(String postKey) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_likesKey) ?? <String>[]).toSet();
    final nowLiked = !ids.contains(postKey);
    if (nowLiked) {
      ids.add(postKey);
    } else {
      ids.remove(postKey);
    }
    await prefs.setStringList(_likesKey, ids.toList());
    return nowLiked;
  }

  static Future<Map<String, dynamic>> _commentMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_commentsKey);
    if (raw == null || raw.isEmpty) return <String, dynamic>{};
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map ? Map<String, dynamic>.from(decoded) : <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  static Future<List<PostComment>> comments(String postKey) async {
    final map = await _commentMap();
    final list = (map[postKey] as List?) ?? const [];
    return list
        .whereType<Map>()
        .map((e) => PostComment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<int> commentCount(String postKey) async => (await comments(postKey)).length;

  static Future<List<PostComment>> addComment(String postKey, String text) async {
    final prefs = await SharedPreferences.getInstance();
    final map = await _commentMap();
    final list = List<dynamic>.from((map[postKey] as List?) ?? const []);
    list.add(PostComment(text: text, author: 'You', createdAt: DateTime.now()).toJson());
    map[postKey] = list;
    await prefs.setString(_commentsKey, jsonEncode(map));
    return list
        .whereType<Map>()
        .map((e) => PostComment.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}

// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
//  DATA MODELS
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
class CategoryItem {
  final IconData icon;
  final String label;
  final String? image;
  const CategoryItem({required this.icon, required this.label, this.image});
}

class FeedPost {
  final String id;
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
  final String? imageUrl;
  final bool isVideo;

  String get authorInitials => author.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase();

  /// Stable key used to persist likes / comments for this post on the device.
  String get storageKey => id.isNotEmpty ? id : 'post_${title.hashCode}';

  const FeedPost({
    this.id = '',
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
    this.imageUrl,
    this.isVideo = false,
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
