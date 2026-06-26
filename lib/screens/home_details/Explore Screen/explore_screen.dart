import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const ExploreApp());
}

class ExploreApp extends StatelessWidget {
  const ExploreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jaguza - Explore',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
        ),
      ),
      home: const ExploreScreen(),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late AnimationController _feedController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedCategory = 0;

  final List<CategoryItem> _categories = [
    CategoryItem(icon: Icons.grid_view_rounded, label: 'All'),
    CategoryItem(icon: Icons.pets_rounded, label: 'Cattle'),
    CategoryItem(icon: Icons.egg_rounded, label: 'Poultry'),
    CategoryItem(icon: Icons.set_meal_rounded, label: 'Pigs'),
    CategoryItem(icon: Icons.agriculture_rounded, label: 'Crops'),
    CategoryItem(icon: Icons.water_drop_rounded, label: 'Fish'),
    CategoryItem(icon: Icons.grass_rounded, label: 'Goats'),
  ];

  @override
  void initState() {
    super.initState();
    _feedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _feedController.forward();
  }

  @override
  void dispose() {
    _feedController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<FeedPost> get _filteredPosts {
    if (_selectedCategory == 0) return feedPosts;
    final catLabel = _categories[_selectedCategory].label.toLowerCase();
    return feedPosts.where((p) => p.category.toLowerCase() == catLabel).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
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

  
  //  HEADER
  
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(color: Color(0xFF1B5E20), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
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
                        color: Colors.white.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Explore Community',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
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
          const SizedBox(height: 16),
          // Trending topics
          Row(
            children: [
              _trendTag('# PoultryFarming'),
              const SizedBox(width: 8),
              _trendTag('# DairyTips'),
              const SizedBox(width: 8),
              _trendTag('# CropHealth'),
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
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 21),
      ),
    );
  }

  Widget _trendTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  
  //  SEARCH BAR
  
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search posts, topics, or authors...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13.5),
            prefixIcon: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32), size: 20),
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.close_rounded, color: Colors.red[400], size: 18),
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  
  //  QUICK BANNERS
  
  Widget _buildQuickBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: _quickBanner(
              icon: Icons.storefront_rounded,
              title: 'Sell your agricultural products',
              subtitle: 'in Market Place',
              gradient: const [Color(0xFFF57C00), Color(0xFFFF9800)],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _quickBanner(
              icon: Icons.biotech_rounded,
              title: 'Know more about',
              subtitle: 'animal Diseases',
              gradient: const [Color(0xFF2E7D32), Color(0xFF66BB6A)],
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
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: gradient[0].withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.25)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11.5)),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.6), size: 20),
        ],
      ),
    );
  }

  
  //  CATEGORY CHIPS
  
  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: SizedBox(
        height: 42,
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
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 3)),
                    if (!isActive)
                      BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(cat.icon, size: 15, color: isActive ? Colors.white : Colors.grey[500]),
                    const SizedBox(width: 6),
                    Text(
                      cat.label,
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
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

  
  //  FEED
  
  Widget _buildFeed() {
    final posts = _filteredPosts;
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.08), shape: BoxShape.circle),
              child: const Icon(Icons.article_outlined, size: 36, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 16),
            Text('No posts yet', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
            const SizedBox(height: 6),
            Text('Check back later for new content', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return _FeedPostCard(
          post: posts[index],
          index: index,
          controller: _feedController,
        );
      },
    );
  }

  
  
  Widget _navItem(IconData icon, String label, bool active) {
    final color = active ? const Color(0xFF2E7D32) : const Color(0xFFBDBDBD);
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: active
                ? BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(12))
                : null,
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10.5, fontWeight: active ? FontWeight.w700 : FontWeight.w500, color: color)),
        ],
      ),
    );
  }
}


//  FEED POST CARD

class _FeedPostCard extends StatefulWidget {
  final FeedPost post;
  final int index;
  final AnimationController controller;

  const _FeedPostCard({
    required this.post,
    required this.index,
    required this.controller,
  });

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
    final post = widget.post;
    final startDelay = (widget.index * 0.07).clamp(0.0, 0.7);
    final slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(
      CurvedAnimation(parent: widget.controller, curve: Interval(startDelay, (startDelay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOutCubic)),
    );
    final fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.controller, curve: Interval(startDelay, (startDelay + 0.4).clamp(0.0, 1.0), curve: Curves.easeOut)),
    );

    return SlideTransition(
      position: slideAnim,
      child: FadeTransition(
        opacity: fadeAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [post.authorColor, post.authorColor.withOpacity(0.7)]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: post.authorColor.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Center(
                        child: Text(
                          post.authorInitials,
                          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Author info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(post.author, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                              if (post.isVerified) ...[
                                const SizedBox(width: 5),
                                const Icon(Icons.verified_rounded, color: Color(0xFF2E7D32), size: 15),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, color: Colors.grey[400], size: 12),
                              const SizedBox(width: 3),
                              Text(post.location, style: TextStyle(fontSize: 11.5, color: Colors.grey[500])),
                              const SizedBox(width: 8),
                              Text('•', style: TextStyle(color: Colors.grey[300], fontSize: 11)),
                              const SizedBox(width: 8),
                              Text(post.timeAgo, style: TextStyle(fontSize: 11.5, color: Colors.grey[400])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Category tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: post.categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(post.categoryIcon, size: 13, color: post.categoryColor),
                          const SizedBox(width: 4),
                          Text(post.category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: post.categoryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Post image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(0)),
                child: _buildPostImage(post),
              ),

              // Title & excerpt
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
                child: Text(
                  post.title,
                  style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36), height: 1.35),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(
                  post.excerpt,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Read more
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Read more',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32), decoration: TextDecoration.underline, decorationColor: const Color(0xFF2E7D32).withOpacity(0.4)),
                  ),
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Divider(color: Colors.grey[200], height: 1),
              ),

              // Action bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 12, 12),
                child: Row(
                  children: [
                    _actionBtn(
                      icon: _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      label: '$_likeCount',
                      color: _isLiked ? const Color(0xFFE53935) : Colors.grey.shade500,
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
                      color: Colors.grey.shade500,
                      onTap: () => _showCommentsSheet(context, post),
                    ),
                    const Spacer(),
                    _actionBtn(
                      icon: Icons.share_rounded,
                      label: 'Share',
                      color: Colors.grey.shade100,
                      onTap: () {},
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                          color: _isBookmarked ? const Color(0xFFFFA000) : Colors.grey[400],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage(FeedPost post) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [post.imageGradientStart, post.imageGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Central icon illustration
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    post.categoryIcon,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_rounded, color: Colors.white.withOpacity(0.8), size: 13),
                      const SizedBox(width: 5),
                      Text(
                        '${post.location}, ${post.dateTime}',
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, FeedPost post) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.55,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('Comments', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1A1F36))),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Text('${post.comments}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Icon(Icons.close_rounded, color: Colors.grey[400]),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            if (post.comments == 0)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text('No comments yet', style: TextStyle(fontSize: 14, color: Colors.grey[500])),
                      const SizedBox(height: 4),
                      Text('Be the first to share your thoughts', style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                    ],
                  ),
                ),
              )
            else
              const Expanded(child: SizedBox()),
            // Comment input
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFB),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text('Y', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Text('Add a comment...', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Icon(Icons.send_rounded, color: Colors.white, size: 18)),
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


//  DATA MODELS

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


//  SAMPLE DATA

const List<FeedPost> feedPosts = [
  FeedPost(
    author: 'Jaguza Official',
    location: 'Kampala',
    dateTime: 'Sep 8, 2023 · 1:19 PM',
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
    dateTime: 'Sep 7, 2023 · 10:30 AM',
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
    dateTime: 'Sep 6, 2023 · 4:45 PM',
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
    dateTime: 'Sep 5, 2023 · 9:00 AM',
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
    dateTime: 'Sep 4, 2023 · 2:15 PM',
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
    dateTime: 'Sep 3, 2023 · 11:30 AM',
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
    dateTime: 'Sep 2, 2023 · 3:00 PM',
    timeAgo: '6d ago',
    title: 'Starting a Fish Farm: A Beginner\'s Guide to Aquaculture',
    excerpt: 'Everything you need to know about setting up a fish pond in Uganda — from site selection and pond construction to stocking, feeding, and harvesting.',
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