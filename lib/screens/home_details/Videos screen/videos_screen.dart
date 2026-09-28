import 'package:flutter/material.dart';
import 'package:jaguza_app/services/api_service.dart';
import '../Explore Screen/explore_screen.dart';

/// Standalone Videos screen, reached from the home feature grid. Renders the
/// exact same category-icon row, search bar, and post-card feed as the
/// Explore tab (see explore_screen.dart) — just filtered to video content
/// and wrapped in its own app bar since it's pushed rather than embedded.
class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0;
  bool _isLoading = true;
  String? _loadError;
  List<FeedPost> _videoPosts = [];

  final List<CategoryItem> _categories = exploreCategories;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVideos() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final videos = await ApiService().getVideos();
      final posts = videos.whereType<Map>().map(videoJsonToFeedPost).toList();
      if (!mounted) return;
      setState(() {
        _videoPosts = posts;
        _isLoading = false;
        if (posts.isEmpty) {
          _loadError = 'No videos published yet.';
        }
      });
    } catch (e) {
      debugPrint('Video load error: $e');
      if (!mounted) return;
      setState(() {
        _videoPosts = [];
        _isLoading = false;
        _loadError = 'Could not load videos. Pull down to try again.';
      });
    }
  }

  List<FeedPost> get _filteredPosts {
    var source = _videoPosts;
    if (_selectedCategory != 0) {
      final catLabel = _categories[_selectedCategory].label.toLowerCase();
      source = source.where((p) => p.category.toLowerCase() == catLabel).toList();
    }
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return source;
    return source
        .where((post) => '${post.title} ${post.excerpt} ${post.category}'.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Videos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: scheme.surface,
      body: Column(
        children: [
          _buildCategoryIcons(),
          _buildSearchBar(),
          const SizedBox(height: 6),
          Expanded(
            child: RefreshIndicator(
              color: scheme.primary,
              onRefresh: _loadVideos,
              child: _buildFeed(),
            ),
          ),
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
                : GestureDetector(
                    onTap: _loadVideos,
                    child: Icon(Icons.refresh_rounded, color: scheme.onSurfaceVariant, size: 20),
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

  Widget _buildFeed() {
    final scheme = Theme.of(context).colorScheme;
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: scheme.primary));
    }

    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 360,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.video_library_outlined, size: 48, color: scheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text(
                    _loadError ?? 'No matching videos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _loadError == null ? 'Try another category or search term' : 'Pull down to refresh',
                    style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) => FeedPostCard(post: posts[index]),
    );
  }
}
