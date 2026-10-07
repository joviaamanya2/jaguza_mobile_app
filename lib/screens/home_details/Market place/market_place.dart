import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/data/uganda_markets.dart';
import 'package:jaguza_app/services/api_service.dart';
import 'package:jaguza_app/models/user.dart';
import 'package:jaguza_app/farm_premium/FarmRequests/AddFarmRequestsPage.dart';
import 'package:jaguza_app/farm_premium/FarmRequests/FarmRequestsPage.dart';
import 'package:jaguza_app/services/jaguza_market_api.dart';
import 'package:jaguza_app/screens/home_details/Profile/profile_screen.dart';
import 'package:jaguza_app/services/php_api_service.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  // Bottom nav: 0 = Livestock, 1 = Equipments, 2 = Market Prices
  int _selectedTab = 0;
  int _priceSubTab = 0; // 0 = Prices, 1 = Nearby Markets

  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String? _selectedLivestockCategory;
  String? _selectedEquipmentCategory;
  bool _showAllLivestock = false;
  bool _showAllEquipment = false;
  bool? _sortAscending; // null = default order

  // Sample cart items
  final List<CartItem> _cartItems = [];

  // Populated from the JaguzaMarket API.
  final List<Product> _products = [];

  bool _isLoadingMarketplace = false;
  String? _marketplaceError;
  String? _userProductsWarning;
  int? _currentUserId;
  final List<Map<String, dynamic>> _marketCategories = [];
  JaguzaMarketApi get _marketApi => JaguzaMarketApi.instance;

  // ---- Nearby markets (real Uganda markets, sorted by GPS distance) ----
  Position? _position;
  bool _locationDenied = false;
  bool _loadingMarkets = true;
  bool _marketsFromServer = false;
  List<_MarketView> _markets = [];

  // ---- Livestock/produce prices ----
  bool _loadingPrices = true;
  bool _pricesFromServer = false;
  List<MarketPrice> _prices = kReferencePrices;

  static const List<_TopCategory> _livestockTopCategories = [
    _TopCategory(label: 'Cows', asset: 'lib/assets/images/cattle.jpg', filterValue: 'Cattle'),
    _TopCategory(label: 'Goats', asset: 'lib/assets/images/Goat.png', filterValue: 'Goats'),
    _TopCategory(label: 'Sheep', asset: 'lib/assets/images/Sheep.png', filterValue: 'Sheep'),
    _TopCategory(label: 'Pigs', asset: 'lib/assets/images/Pigs.png', filterValue: 'Pigs'),
    _TopCategory(label: 'Poultry', asset: 'lib/assets/images/Poultry.png', filterValue: 'Poultry'),
  ];

  static const List<_TopCategory> _equipmentTopCategories = [
    _TopCategory(label: 'Equipment', icon: Icons.handyman_rounded, filterValue: 'Equipment'),
    _TopCategory(label: 'Housing', icon: Icons.warehouse_rounded, filterValue: 'Housing'),
  ];

  bool _isEquipmentCategory(String category) {
    final value = category.toLowerCase();
    return value.contains('equipment') ||
        value.contains('housing') ||
        value.contains('machinery') ||
        value.contains('tools');
  }

  List<Product> _applySort(List<Product> list) {
    if (_sortAscending == null) return list;
    final sorted = [...list];
    sorted.sort((a, b) => _sortAscending!
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
    return sorted;
  }

  List<Product> get _filteredLivestockProducts {
    final query = _searchQuery.toLowerCase();
    final list = _products.where((p) {
      if (_isEquipmentCategory(p.category)) return false;
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.seller.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query);
      final matchesCategory =
          _selectedLivestockCategory == null || p.category == _selectedLivestockCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    return _applySort(list);
  }

  List<Product> get _filteredEquipmentProducts {
    final query = _searchQuery.toLowerCase();
    final list = _products.where((p) {
      if (!_isEquipmentCategory(p.category)) return false;
      final matchesSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.seller.toLowerCase().contains(query);
      final matchesCategory =
          _selectedEquipmentCategory == null || p.category == _selectedEquipmentCategory;
      return matchesSearch && matchesCategory;
    }).toList();
    return _applySort(list);
  }

  List<Product> _recentProducts({required bool equipment}) {
    final products = _products
        .where((product) =>
            product.inStock > 0 &&
            _isEquipmentCategory(product.category) == equipment)
        .toList();
    products.sort((a, b) {
      final byDate = (b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0));
      if (byDate != 0) return byDate;
      final aId = int.tryParse(a.id.replaceFirst('dashboard_', '')) ?? 0;
      final bId = int.tryParse(b.id.replaceFirst('dashboard_', '')) ?? 0;
      return bId.compareTo(aId);
    });
    return products;
  }

  // Sample sold products
  final List<SoldProduct> _soldProducts = [
    SoldProduct(
      name: 'Local Chicken',
      quantity: 50,
      price: 25000,
      total: 1250000,
      buyer: 'Mukasa Restaurant',
      date: '2024-06-28',
      status: 'Completed',
    ),
    SoldProduct(
      name: 'Milk (Litres)',
      quantity: 200,
      price: 3000,
      total: 600000,
      buyer: 'Kampala Dairy Ltd',
      date: '2024-06-25',
      status: 'Completed',
    ),
    SoldProduct(
      name: 'Layer Feed (Bags)',
      quantity: 20,
      price: 45000,
      total: 900000,
      buyer: 'Happy Farm',
      date: '2024-06-20',
      status: 'Pending',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadMarketplaceListings();
    _initMarketsAndPrices();
  }

  Future<void> _initMarketsAndPrices() async {
    await _resolveLocation();
    await Future.wait([_loadMarkets(), _loadPrices()]);
  }

  Future<void> _resolveLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() => _locationDenied = true);
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) setState(() => _locationDenied = true);
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 12),
      );
      if (mounted) {
        setState(() {
          _position = position;
          _locationDenied = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _locationDenied = true);
    }
  }

  Future<void> _loadMarkets() async {
    if (mounted) setState(() => _loadingMarkets = true);
    List<_MarketView> views = [];
    bool fromServer = false;
    try {
      final raw = await ApiService().getMarkets(
        lat: _position?.latitude,
        lng: _position?.longitude,
      );
      if (raw.isNotEmpty) {
        views = raw
            .whereType<Map>()
            .map((m) => _MarketView.fromServer(
                  Map<String, dynamic>.from(m),
                  _position,
                ))
            .toList();
        fromServer = true;
      }
    } catch (_) {
      // No markets endpoint yet / offline: fall back to the bundled list.
    }
    if (views.isEmpty) {
      views = kUgandaMarkets.map((m) {
        final km = _position == null
            ? null
            : Geolocator.distanceBetween(
                  _position!.latitude,
                  _position!.longitude,
                  m.lat,
                  m.lng,
                ) /
                1000;
        return _MarketView.fromLocal(m, km);
      }).toList();
    }
    if (_position != null) {
      views.sort((a, b) {
        if (a.distanceKm == null && b.distanceKm == null) return 0;
        if (a.distanceKm == null) return 1;
        if (b.distanceKm == null) return -1;
        return a.distanceKm!.compareTo(b.distanceKm!);
      });
    }
    if (mounted) {
      setState(() {
        _markets = views;
        _marketsFromServer = fromServer;
        _loadingMarkets = false;
      });
    }
  }

  Future<void> _loadPrices() async {
    if (mounted) setState(() => _loadingPrices = true);
    try {
      final raw = await ApiService().getMarketPrices(
        lat: _position?.latitude,
        lng: _position?.longitude,
      );
      final prices = raw.whereType<Map>().map((p) {
        final j = Map<String, dynamic>.from(p);
        final low = int.tryParse(
                '${j['low'] ?? j['min_price'] ?? j['price'] ?? 0}') ??
            0;
        final high = int.tryParse(
                '${j['high'] ?? j['max_price'] ?? j['price'] ?? low}') ??
            low;
        return MarketPrice(
          item: '${j['item'] ?? j['name'] ?? 'Item'}',
          category: '${j['category'] ?? 'Other'}',
          low: low,
          high: high,
          unit: '${j['unit'] ?? 'per unit'}',
          trend: j['trend'] as String?,
        );
      }).toList();
      if (prices.isNotEmpty) {
        if (mounted) {
          setState(() {
            _prices = prices;
            _pricesFromServer = true;
            _loadingPrices = false;
          });
        }
        return;
      }
    } catch (_) {
      // No market-prices endpoint yet / offline: fall back to reference data.
    }
    if (mounted) {
      setState(() {
        _prices = kReferencePrices;
        _pricesFromServer = false;
        _loadingPrices = false;
      });
    }
  }

  Future<void> _openInMaps(_MarketView view) async {
    final query = view.lat != null && view.lng != null
        ? '${view.lat},${view.lng}'
        : Uri.encodeComponent('${view.name}, Uganda');
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps app.')),
      );
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final response = await ApiService().get('user');
      if (response is Map && mounted) {
        setState(() {
          _currentUserId = User.fromJson(Map<String, dynamic>.from(response)).id;
        });
        _loadMarketplaceListings();
      }
    } catch (_) {
      // Not logged in / unreachable: owner actions simply won't show.
    }
  }

  Future<void> _loadMarketplaceListings() async {
    setState(() {
      _isLoadingMarketplace = true;
      _marketplaceError = null;
    });
    try {
      final categories = <Map<String, dynamic>>[];
      var rawProducts = <dynamic>[];
      final userId = _currentUserId;
      String? userProductsWarning;
      String? marketApiError;
      try {
        categories.addAll((await _marketApi.getCategories())
            .whereType<Map>()
            .map((entry) => Map<String, dynamic>.from(entry)));
        final query = _searchQuery.trim();
        final categoryId = categories
            .where((category) =>
                '${category['title']}'.toLowerCase() ==
                (_selectedLivestockCategory ?? '').toLowerCase())
            .map((category) => '${category['id']}')
            .firstOrNull;
        rawProducts = query.isNotEmpty
            ? await _marketApi.searchProducts(query)
            : categoryId != null
                ? await _marketApi.getCategoryProducts(categoryId)
                : await _marketApi.getProducts();
        if (userId != null && userId > 0 && query.isEmpty) {
          final ownProducts = await _marketApi.getUserProducts(userId);
          final byId = <String, dynamic>{
            for (final item in rawProducts.whereType<Map>()) '${item['id']}': item,
            for (final item in ownProducts.whereType<Map>()) '${item['id']}': item,
          };
          rawProducts = byId.values.toList();
        }
      } catch (error) {
        marketApiError = 'Could not connect to the Jaguza Market server.';
        debugPrint('Jaguza Market API unavailable: $error');
      }
      final products = rawProducts.whereType<Map>().map((raw) {
        final listing = Map<String, dynamic>.from(raw);
        final categoryRaw = listing['category'];
        final rawCategory = categoryRaw is Map
            ? '${categoryRaw['title'] ?? 'Other'}'
            : '${listing['category_title'] ?? listing['category'] ?? 'Other'}';
        final category = _displayCategory(rawCategory);
        final filename = '${listing['picture'] ?? listing['image'] ?? ''}';
        final status = '${listing['product_status'] ?? listing['status'] ?? 'active'}'.toLowerCase();
        final createdAt = DateTime.tryParse(
          '${listing['created_at'] ?? listing['createdAt'] ?? listing['date_created'] ?? ''}',
        );
        final seller = listing['seller'] is Map
            ? Map<String, dynamic>.from(listing['seller'] as Map)
            : listing['user'] is Map
                ? Map<String, dynamic>.from(listing['user'] as Map)
                : <String, dynamic>{};
        return Product(
          id: '${listing['id'] ?? ''}',
          name: '${listing['name'] ?? listing['title'] ?? 'Marketplace listing'}',
          category: category,
          categoryId: '${categoryRaw is Map ? categoryRaw['id'] ?? listing['category_id'] ?? '' : listing['category_id'] ?? ''}',
          price: double.tryParse('${listing['unit_price_buyer'] ?? listing['unit_price_seller'] ?? listing['price'] ?? 0}')?.round() ?? 0,
          unit: 'per ${listing['unit_of_measure'] ?? 'unit'}',
          seller: '${seller['name'] ?? listing['seller_name'] ?? listing['author'] ?? 'Seller #${listing['user_id'] ?? ''}'}',
          sellerId: int.tryParse('${listing['user_id'] ?? listing['seller_id'] ?? seller['id'] ?? ''}'),
          sellerPhone: '${listing['phone_number'] ?? listing['telephone'] ?? seller['phone'] ?? ''}',
          location: '${listing['seller_location'] ?? listing['location'] ?? 'Unknown location'}',
          rating: 0,
          imageUrl: filename.isEmpty ? null : _marketApi.productImageUrl(filename),
          inStock: const {'active', 'available', 'approved', 'published'}.contains(status)
              ? int.tryParse('${listing['stock_available'] ?? listing['quantity'] ?? 1}') ?? 0
              : 0,
          description: '${listing['description'] ?? ''}',
          status: status,
          createdAt: createdAt,
          isServerBacked: true,
        );
      }).toList();

      // Also include farmer posts published from the Jaguza dashboard.
      try {
        final dashboardRows = await ApiService().getMarketplaceListings();
        final dashboardProducts = dashboardRows.whereType<Map>().map((raw) {
          final listing = Map<String, dynamic>.from(raw);
          final seller = listing['seller'] is Map
              ? Map<String, dynamic>.from(listing['seller'] as Map)
              : <String, dynamic>{};
          final sellerId = int.tryParse(
            '${listing['seller_id'] ?? listing['user_id'] ?? seller['id'] ?? ''}',
          );
          final rawImages = listing['images'];
          final imageValue = rawImages is List && rawImages.isNotEmpty
              ? '${rawImages.first ?? ''}'
              : '${listing['image_url'] ?? listing['photo'] ?? ''}';
          final imageUri = Uri.tryParse(imageValue);
          final imageUrl = imageValue.isEmpty
              ? null
              : imageUri != null && imageUri.hasScheme
                  ? imageUri.toString()
                  : '${PhpApiService.host}${imageValue.startsWith('/') ? imageValue : '/images/$imageValue'}';
          final rawCategory = listing['category'];
          final rawCategoryName = rawCategory is Map
              ? '${rawCategory['title'] ?? 'Other'}'
              : '${rawCategory ?? 'Other'}';
          final category = _displayCategory(rawCategoryName);
          final normalizedStatus =
              '${listing['status'] ?? 'available'}'.toLowerCase();
          final createdAt = DateTime.tryParse(
            '${listing['created_at'] ?? listing['createdAt'] ?? listing['date_created'] ?? ''}',
          );
          final available = const {
            'active',
            'available',
            'approved',
            'published',
            '1',
          }.contains(normalizedStatus);
          return Product(
            id: 'dashboard_${listing['id'] ?? ''}',
            name: '${listing['title'] ?? listing['name'] ?? 'Marketplace listing'}',
            category: category,
            price: double.tryParse(
                      '${listing['price'] ?? listing['unit_price_buyer'] ?? 0}',
                    )
                    ?.round() ??
                0,
            unit: 'per unit',
            seller: '${seller['name'] ?? listing['seller_name'] ?? listing['author'] ?? 'Farmer'}',
            sellerId: sellerId,
            sellerPhone: '${listing['phone_number'] ?? listing['telephone'] ?? ''}',
            location: '${listing['location'] ?? listing['seller_location'] ?? 'Unknown location'}',
            rating: 0,
            imageUrl: imageUrl,
            inStock: available ? 1 : 0,
            description: '${listing['description'] ?? ''}',
            status: normalizedStatus,
            createdAt: createdAt,
            isDashboardListing: true,
          );
        }).toList();
        final productIds = products
            .map((product) => product.id.replaceFirst('dashboard_', ''))
            .toSet();
        products.addAll(
          dashboardProducts.where(
            (product) =>
                !productIds.contains(product.id.replaceFirst('dashboard_', '')),
          ),
        );
      } catch (error) {
        debugPrint('Could not load dashboard marketplace posts: $error');
      }

      if (mounted) {
        setState(() {
          _marketCategories
            ..clear()
            ..addAll(categories);
          _userProductsWarning = userProductsWarning;
          _marketplaceError = products.isEmpty ? marketApiError : null;
          _products
            ..clear()
            ..addAll(products);
        });
      }
    } catch (error) {
      debugPrint('Jaguza Market API unavailable: $error');
      if (mounted) {
        setState(() {
          _products.clear();
          _marketplaceError = 'Could not connect to the Jaguza Market server. Pull down to try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoadingMarketplace = false);
    }
  }

  Future<void> _deleteProduct(Product product) async {
    final id = int.tryParse(product.id);
    if (id == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete listing?'),
        content: Text('Remove "${product.name}" from the marketplace? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _marketApi.deleteProduct(product.id);
      if (!mounted) return;
      setState(() {
        _products.removeWhere((p) => p.id == product.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Listing deleted.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete listing: $e')),
      );
    }
  }

  String _displayCategory(String value) {
    final category = value.trim().toLowerCase();
    switch (category) {
      case 'cow':
      case 'cattle':
      case 'livestock':
        return 'Cattle';
      case 'goat':
      case 'goats':
        return 'Goats';
      case 'pig':
      case 'pigs':
        return 'Pigs';
      case 'sheep':
        return 'Sheep';
      case 'rabbit':
      case 'rabbits':
        return 'Rabbits';
      case 'chicken':
      case 'poultry':
        return 'Poultry';
      case 'feed':
        return 'Feed';
      case 'dairy':
        return 'Dairy';
      case 'crops':
        return 'Crops';
      case 'medicine':
        return 'Medicine';
      case 'equipment':
        return 'Equipment';
      case 'housing':
        return 'Housing';
      default:
        return category.isEmpty
            ? 'Other'
            : '${category[0].toUpperCase()}${category.substring(1)}';
    }
  }

  String _apiCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cattle':
      case 'goats':
      case 'pigs':
      case 'sheep':
      case 'rabbits':
        return 'livestock';
      case 'poultry':
        return 'poultry';
      case 'feed':
        return 'feed';
      case 'equipment':
        return 'equipment';
      case 'housing':
        return 'housing';
      default:
        return 'other';
    }
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
          'Jaguza Market',
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
            icon: Icon(_showSearch ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () => setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) {
                _searchController.clear();
                _searchQuery = '';
              }
            }),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                onPressed: _openCart,
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: scheme.error,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${_cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              switch (value) {
                case 'refresh':
                  _loadMarketplaceListings();
                  break;
                case 'my_listings':
                  _showMyListings();
                  break;
                case 'seller_profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileTab()),
                  );
                  break;
                case 'price_low':
                  setState(() => _sortAscending = true);
                  break;
                case 'price_high':
                  setState(() => _sortAscending = false);
                  break;
                case 'price_default':
                  setState(() => _sortAscending = null);
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'my_listings', child: Text('My Listings')),
              PopupMenuItem(value: 'seller_profile', child: Text('Farmer Profile')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'refresh', child: Text('Refresh listings')),
              PopupMenuItem(value: 'price_low', child: Text('Sort: Price low to high')),
              PopupMenuItem(value: 'price_high', child: Text('Sort: Price high to low')),
              PopupMenuItem(value: 'price_default', child: Text('Sort: Default')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMarketplaceActions(scheme),
          if (_showSearch) _buildSearchBar(),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildLivestockTab(),
                _buildEquipmentsTab(),
                _buildMarketPricesTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => setState(() => _selectedTab = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).cardColor,
        selectedItemColor: scheme.primary,
        unselectedItemColor: scheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded), label: 'Livestock'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer_rounded), label: 'Equipments'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money_rounded), label: 'Market Prices'),
        ],
      ),
    );
  }

  Widget _buildMarketplaceActions(ColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showSellProductDialog(context),
              icon: const Icon(Icons.add_business_rounded, size: 18),
              label: const Text('Sell Product'),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.primary,
                side: BorderSide(color: scheme.primary.withValues(alpha: .45)),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _showMyOrders,
              icon: const Icon(Icons.receipt_long_rounded, size: 18),
              label: const Text('My Orders'),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.onSurface,
                side: BorderSide(color: scheme.outlineVariant),
                padding: const EdgeInsets.symmetric(vertical: 11),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMyOrders() {
    final userId = _currentUserId;
    if (userId == null || userId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign in to view your orders.')),
      );
      return;
    }
    var ordersFuture = _marketApi.getOrders(userId);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setSheetState) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * .72,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Row(children: [
                Text('My Orders', style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                IconButton(
                  onPressed: () => setSheetState(() => ordersFuture = _marketApi.getOrders(userId)),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ]),
            ),
            Expanded(child: FutureBuilder<List<dynamic>>(
              future: ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Could not load orders: ${snapshot.error}', textAlign: TextAlign.center),
                  ));
                }
                final orders = snapshot.data ?? [];
                if (orders.isEmpty) return const Center(child: Text('You have no orders yet.'));
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = Map<String, dynamic>.from(orders[index] as Map);
                    final id = '${order['id'] ?? ''}';
                    final status = '${order['order_status'] ?? 'pending'}';
                    final rows = order['order_products'] is List ? order['order_products'] as List : const [];
                    return Card(child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Expanded(child: Text('Order #$id', style: const TextStyle(fontWeight: FontWeight.w700))),
                          Text(status.toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700, fontSize: 11)),
                        ]),
                        const SizedBox(height: 6),
                        Text('${rows.length} item(s) · UGX ${_formatPrice(double.tryParse('${order['total_order_cost'] ?? 0}')?.round() ?? 0)}'),
                        if (status == 'pending' || status == 'processing')
                          Align(alignment: Alignment.centerRight, child: TextButton(
                            onPressed: () async {
                              try {
                                await _marketApi.cancelOrder(id);
                                setSheetState(() => ordersFuture = _marketApi.getOrders(userId));
                              } catch (error) {
                                if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not cancel order: $error')));
                              }
                            },
                            child: const Text('Cancel order'),
                          )),
                      ]),
                    ));
                  },
                );
              },
            )),
          ]),
        ),
      )),
    );
  }

  // ============= SEARCH BAR =============
  Widget _buildSearchBar() {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        onChanged: (val) => setState(() => _searchQuery = val),
        onSubmitted: (_) => _loadMarketplaceListings(),
        decoration: InputDecoration(
          hintText: 'Search products, sellers, or locations...',
          hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
          prefixIcon: Icon(Icons.search_rounded, color: scheme.primary, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                    _loadMarketplaceListings();
                  },
                  icon: Icon(Icons.close_rounded,
                      color: scheme.onSurfaceVariant, size: 18),
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: scheme.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        ),
      ),
    );
  }

  // ============= SECTION HEADER =============
  Widget _sectionHeader(String title, {VoidCallback? onViewMore}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface),
          ),
          if (onViewMore != null)
            GestureDetector(
              onTap: onViewMore,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View more',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.primary),
                  ),
                  Icon(Icons.chevron_right_rounded, size: 16, color: scheme.primary),
                ],
              ),
            )
          else
            Icon(Icons.chevron_right_rounded, size: 18, color: scheme.onSurfaceVariant),
        ],
      ),
    );
  }

  // ============= TOP CATEGORIES =============
  Widget _buildTopCategories({
    required List<_TopCategory> items,
    required String? selected,
    required ValueChanged<String?> onSelect,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final item = items[index];
          final isActive = selected == item.filterValue;
          return GestureDetector(
            onTap: () => onSelect(isActive ? null : item.filterValue),
            child: Column(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? scheme.primary : scheme.primary.withValues(alpha: 0.35),
                      width: isActive ? 2.5 : 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: item.asset != null
                        ? Image.asset(
                            item.asset!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: scheme.primary.withValues(alpha: 0.08),
                              child: Icon(Icons.pets_rounded, color: scheme.primary),
                            ),
                          )
                        : Container(
                            color: scheme.primary.withValues(alpha: 0.08),
                            child: Icon(item.icon, color: scheme.primary, size: 26),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? scheme.primary : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============= LIVESTOCK TAB =============
  Widget _buildLivestockTab() {
    final all = _filteredLivestockProducts;
    final shown = _showAllLivestock ? all : all.take(4).toList();
    return RefreshIndicator(
      onRefresh: _loadMarketplaceListings,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          const SizedBox(height: 8),
          _buildTopCategoriesBanner(_recentProducts(equipment: false).take(2).toList()),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Search Requests',
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                ),
                OutlinedButton.icon(
                  onPressed: _openPostRequest,
                  icon: const Icon(Icons.chevron_right_rounded, size: 22),
                  label: const Text('Post Request'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF08783E),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openMoreRequests,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF08783E),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 16, letterSpacing: 1.2, fontWeight: FontWeight.w700),
                ),
                child: const Text('View More Requests'),
              ),
            ),
          ),
          const SizedBox(height: 18),
          _marketSectionHeader(
            'Featured Products',
            onViewMore: all.length > 4
                ? () => setState(() => _showAllLivestock = !_showAllLivestock)
                : null,
          ),
          if (_isLoadingMarketplace)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_marketplaceError != null)
            _buildEmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Market unavailable',
              subtitle: _marketplaceError!,
            )
          else if (shown.isEmpty)
            _buildEmptyState(
              icon: Icons.storefront_rounded,
              title: 'No Products Found',
              subtitle: _userProductsWarning ?? 'Products published in the Jaguza Market dashboard will appear here.',
            )
          else
            _buildProductsGrid(shown),
        ],
      ),
    );
  }

  Widget _buildTopCategoriesBanner(List<Product> products) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _marketSectionHeader('Top Categories'),
      if (_isLoadingMarketplace && products.isEmpty)
        const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
      else if (products.isNotEmpty)
        _buildProductsGrid(products)
      else
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            'Recently added products will appear here.',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
    ]);
  }

  Widget _marketSectionHeader(String title, {VoidCallback? onViewMore}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Row(children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ),
          if (onViewMore != null)
            TextButton(
              onPressed: onViewMore,
              child: const Text('View more'),
            ),
        ]),
    );
  }

  Future<void> _editProduct(Product product) async {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(text: '${product.price}');
    final quantityController = TextEditingController(text: '${product.inStock}');
    final unitController = TextEditingController(text: product.unit.replaceFirst('per ', ''));
    final locationController = TextEditingController(text: product.location);
    final descriptionController = TextEditingController(text: product.description);
    final formKey = GlobalKey<FormState>();

    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        fullscreenDialog: true,
        builder: (pageContext) => Scaffold(
          appBar: AppBar(title: const Text('Edit Listing')),
          body: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product name', border: OutlineInputBorder()),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Enter a product name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price (UGX)', border: OutlineInputBorder()),
                  validator: (value) => (double.tryParse(value ?? '') ?? 0) <= 0 ? 'Enter a valid price' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Quantity available', border: OutlineInputBorder()),
                  validator: (value) => (int.tryParse(value ?? '') ?? -1) < 0 ? 'Enter a valid quantity' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(controller: unitController, decoration: const InputDecoration(labelText: 'Unit of measure', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: locationController, decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder())),
                const SizedBox(height: 12),
                TextFormField(controller: descriptionController, maxLines: 4, decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder())),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    try {
                      await _marketApi.updateProduct(product.id, {
                        'name': nameController.text.trim(),
                        'description': descriptionController.text.trim(),
                        'unit_of_measure': unitController.text.trim(),
                        'stock_available': quantityController.text.trim(),
                        'unit_price_seller': priceController.text.trim(),
                        'unit_price_buyer': priceController.text.trim(),
                        'seller_location': locationController.text.trim(),
                        if (product.sellerId != null) 'user_id': '${product.sellerId}',
                        if (product.categoryId.isNotEmpty) 'category_id': product.categoryId,
                      });
                      if (pageContext.mounted) Navigator.pop(pageContext, true);
                    } catch (error) {
                      if (pageContext.mounted) {
                        ScaffoldMessenger.of(pageContext).showSnackBar(
                          SnackBar(content: Text('Could not update listing: $error')),
                        );
                      }
                    }
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    unitController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    if (saved == true) {
      await _loadMarketplaceListings();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing updated.')));
    }
  }

  Widget _marketCategoryCard({
    required Map<String, dynamic> category,
    required double width,
    required VoidCallback onTap,
  }) {
    final title = '${category['title'] ?? 'Category'}';
    final iconName = '${category['icon'] ?? ''}';
    final icon = _iconForMarketCategory(title);
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: 108,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (iconName.isNotEmpty)
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: _marketApi.categoryIconUrl(iconName),
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => Icon(icon, color: scheme.primary, size: 32),
                ),
              )
            else
              Icon(icon, color: scheme.primary, size: 32),
            const SizedBox(height: 5),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: scheme.onSurface, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }

  IconData _iconForMarketCategory(String title) {
    switch (title.toLowerCase()) {
      case 'all':
        return Icons.storefront_rounded;
      case 'meat':
        return Icons.set_meal_rounded;
      case 'goats':
        return Icons.pets_rounded;
      case 'wine':
        return Icons.local_bar_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _selectMarketplaceCategory(Map<String, dynamic> category) {
    final title = '${category['title'] ?? ''}';
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _selectedLivestockCategory = title.toLowerCase() == 'all' ? null : title;
    });
    _loadMarketplaceListings();
  }

  void _openPostRequest() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddFarmRequestsPage()));
  }

  void _openMoreRequests() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => FarmRequestsPage()));
  }

  Future<void> _showMyListings() async {
    if (_currentUserId == null) await _loadCurrentUser();
    final userId = _currentUserId;
    if (userId == null || userId <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in to view your listings.')),
        );
      }
      return;
    }

    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
      setState(() => _searchQuery = '');
    }
    await _loadMarketplaceListings();
    if (!mounted) return;
    final ownProducts = _products.where((product) => product.sellerId == userId).toList();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Text(
                  'My Listings',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
              if (ownProducts.isEmpty)
                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'You have not posted any products yet.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: ownProducts.length,
                    separatorBuilder: (_, __) => const Divider(height: 1, indent: 76),
                    itemBuilder: (context, index) {
                      final product = ownProducts[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 52,
                          height: 52,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: _buildProductImage(
                              product,
                              Theme.of(context).colorScheme,
                            ),
                          ),
                        ),
                        title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: product.isDashboardListing || int.tryParse(product.id) == null
                            ? const Tooltip(
                                message: 'Management for this listing type is not available yet.',
                                child: Icon(Icons.info_outline_rounded),
                              )
                            : PopupMenuButton<String>(
                                onSelected: (action) {
                                  if (action == 'edit') _editProduct(product);
                                  if (action == 'delete') _deleteProduct(product);
                                },
                                itemBuilder: (_) => const [
                                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                                ],
                              ),
                        subtitle: Text(
                          'UGX ${_formatPrice(product.price)} · ${product.status}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============= EQUIPMENTS TAB =============
  Widget _buildEquipmentsTab() {
    final all = _filteredEquipmentProducts;
    final shown = _showAllEquipment ? all : all.take(4).toList();
    return RefreshIndicator(
      onRefresh: _loadMarketplaceListings,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          const SizedBox(height: 12),
          const SizedBox(height: 8),
          _marketSectionHeader('Top Categories'),
          if (_recentProducts(equipment: true).isNotEmpty)
            _buildProductsGrid(_recentProducts(equipment: true).take(2).toList())
          else
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text('Recently added products will appear here.'),
            ),
          _sectionHeader(
            'Featured Products',
            onViewMore: all.length > 4
                ? () => setState(() => _showAllEquipment = !_showAllEquipment)
                : null,
          ),
          if (_isLoadingMarketplace)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_marketplaceError != null)
            _buildEmptyState(
              icon: Icons.cloud_off_rounded,
              title: 'Market unavailable',
              subtitle: _marketplaceError!,
            )
          else if (shown.isEmpty)
            _buildEmptyState(
              icon: Icons.handyman_rounded,
              title: 'No Equipment Found',
              subtitle: 'Products published in the Jaguza Market dashboard will appear here.',
            )
          else
            _buildProductsGrid(shown),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _buildProductCard(products[index]),
    );
  }

  // ============= MARKET PRICES TAB =============
  Widget _buildMarketPricesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(child: _priceModeChip('Prices', 0)),
              const SizedBox(width: 8),
              Expanded(child: _priceModeChip('Nearby Markets', 1)),
            ],
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: _priceSubTab,
            children: [
              _buildAnimalPrices(),
              _buildNearbyMarkets(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceModeChip(String label, int index) {
    final scheme = Theme.of(context).colorScheme;
    final active = _priceSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _priceSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? scheme.primary : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: active ? scheme.primary : scheme.outlineVariant),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ============= PRODUCT CARD (matches the Jaguza Market design) =============
  Widget _buildProductCard(Product product) {
    final scheme = Theme.of(context).colorScheme;
    final isAvailable = product.inStock > 0 && product.status != 'sold';
    final isOwner = product.sellerId != null && product.sellerId == _currentUserId;
    final stockLabel = product.status == 'active'
        ? isAvailable
            ? '${product.inStock} Available'
            : 'Out of Stock'
        : product.status == 'outofstock'
            ? 'Out of Stock'
            : product.status[0].toUpperCase() + product.status.substring(1);
    final stockColor = isAvailable
        ? const Color(0xFFFF9800)
        : product.status == 'pending'
            ? const Color(0xFFD97A1E)
            : scheme.error;
    return GestureDetector(
          onTap: !isAvailable
              ? null
              : product.isDashboardListing
                  ? () => _showDashboardProductDetails(product)
                  : product.isServerBacked
                      ? () => _addToCart(product)
                      : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 108,
                  width: double.infinity,
                  color: scheme.primary.withValues(alpha: 0.06),
                  child: _buildProductImage(product, scheme),
                ),
              ),
              if (isOwner && !product.isDashboardListing)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, size: 16, color: Colors.white),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      onSelected: (value) {
                        if (value == 'delete') _deleteProduct(product);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: stockColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stockLabel,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'UGX ${_formatPrice(product.price)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: scheme.onSurface),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDashboardProductDetails(Product product) async {
    final phone = product.sellerPhone.trim();
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(product.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('UGX ${_formatPrice(product.price)} · ${product.unit}'),
              const SizedBox(height: 6),
              Text('Seller: ${product.seller}'),
              Text('Location: ${product.location}'),
              if (product.description.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(product.description),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
          if (phone.isNotEmpty)
            FilledButton.icon(
              onPressed: () async {
                final uri = Uri(scheme: 'tel', path: phone);
                if (await launchUrl(uri) && dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              icon: const Icon(Icons.call_outlined),
              label: const Text('Call seller'),
            ),
        ],
      ),
    );
  }

  // ============= ANIMAL PRICES =============
  Widget _buildAnimalPrices() {
    final scheme = Theme.of(context).colorScheme;

    if (_loadingPrices) {
      return const Center(child: CircularProgressIndicator());
    }

    final grouped = <String, List<MarketPrice>>{};
    for (final p in _prices) {
      grouped.putIfAbsent(p.category, () => []).add(p);
    }
    final nearestMarket = _markets.isNotEmpty ? _markets.first : null;

    return RefreshIndicator(
      onRefresh: _loadPrices,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _pricesFromServer
                    ? scheme.primary.withValues(alpha: 0.08)
                    : const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _pricesFromServer
                      ? scheme.primary.withValues(alpha: 0.3)
                      : const Color(0xFFFFE082),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    _pricesFromServer ? Icons.wifi_tethering_rounded : Icons.info_rounded,
                    color: _pricesFromServer ? scheme.primary : Colors.orange[700],
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _pricesFromServer
                          ? 'Live prices reported to Jaguza from markets across Uganda.'
                          : 'No live price feed reachable right now — showing indicative reference ranges (reviewed $kReferencePricesUpdated). Actual prices vary by market and season.',
                      style: TextStyle(
                        fontSize: 12,
                        color: _pricesFromServer ? scheme.primary : Colors.orange[900],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (nearestMarket != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: scheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nearestMarket.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: scheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            nearestMarket.distanceKm != null
                                ? 'Nearest reference market · ${_formatDistance(nearestMarket.distanceKm!)}'
                                : 'Nearest reference market',
                            style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            for (final category in grouped.keys) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              ...grouped[category]!.map((p) => _buildPriceCard(p)),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(MarketPrice data) {
    final scheme = Theme.of(context).colorScheme;
    Color trendColor;
    IconData trendIcon;
    String trendLabel;
    switch (data.trend) {
      case 'up':
        trendColor = Colors.green;
        trendIcon = Icons.trending_up_rounded;
        trendLabel = 'Rising';
        break;
      case 'down':
        trendColor = Colors.red;
        trendIcon = Icons.trending_down_rounded;
        trendLabel = 'Falling';
        break;
      default:
        trendColor = Colors.orange;
        trendIcon = Icons.trending_flat_rounded;
        trendLabel = 'Stable';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getProductIcon(data.category),
              size: 20,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data.unit,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.low == data.high
                    ? 'UGX ${_formatPrice(data.low)}'
                    : 'UGX ${_formatPrice(data.low)} - ${_formatPrice(data.high)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: scheme.primary,
                ),
              ),
              if (data.trend != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(trendIcon, size: 14, color: trendColor),
                    const SizedBox(width: 2),
                    Text(
                      trendLabel,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ============= NEARBY MARKETS =============
  Widget _buildNearbyMarkets() {
    final scheme = Theme.of(context).colorScheme;

    if (_loadingMarkets) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _initMarketsAndPrices,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        children: [
          if (_locationDenied)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  Icon(Icons.my_location_rounded, color: Colors.orange[700], size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Location is off, so markets are shown by region instead of distance.',
                      style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: _initMarketsAndPrices,
                    child: const Text('Enable', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            )
          else if (_position != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                '${_markets.length} markets sorted by distance from you'
                '${_marketsFromServer ? '' : ' · Jaguza reference list'}',
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ),
          for (final market in _markets) ...[
            _buildMarketCard(market),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }

  Widget _buildMarketCard(_MarketView market) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.storefront_rounded,
                  size: 22,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            market.location,
                            style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (market.distanceKm != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatDistance(market.distanceKm!),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: market.trades.map((trade) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trade,
                  style: TextStyle(
                    fontSize: 10,
                    color: scheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.event_rounded, size: 12, color: scheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  market.schedule,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _openInMaps(market),
                icon: const Icon(Icons.directions_rounded, size: 16),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============= SELL PRODUCT DIALOG =============
  Future<void> _showSellProductDialog(BuildContext context, {String? initialCategory}) async {
    final isEquipmentTab = _selectedTab == 1;
    if (_marketCategories.isEmpty) {
      try {
        final categories = (await _marketApi.getCategories())
            .whereType<Map>()
            .map((entry) => Map<String, dynamic>.from(entry))
            .toList();
        if (mounted) {
          setState(() {
            _marketCategories
              ..clear()
              ..addAll(categories);
          });
        }
      } catch (error) {
        if (mounted && !isEquipmentTab) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Could not load product categories: $error',
                style: TextStyle(color: Theme.of(context).colorScheme.onError),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
      }
    }
    if (_marketCategories.isEmpty && !isEquipmentTab) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Add a product category before listing farm products.',
            style: TextStyle(color: Theme.of(context).colorScheme.onError),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final unitController = TextEditingController(text: 'unit');
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    final initialType = _selectedTab == 1 ? 'Equipment' : 'Farm product';
    String selectedType = initialType;
    String selectedCategoryId = '';
    File? selectedImage;
    bool isUploading = false;
    final categories = _marketCategories
        .where((category) => '${category['title']}'.toLowerCase() != 'all')
        .toList();
    List<Map<String, dynamic>> categoriesForType(String type) => categories.where((category) {
      final title = _displayCategory('${category['title'] ?? ''}');
      return type == 'Equipment'
          ? _isEquipmentCategory(title)
          : !_isEquipmentCategory(title);
    }).toList();
    final initialChoices = categoriesForType(selectedType);
    final requestedCategory = initialCategory ??
        (selectedType == 'Equipment' ? 'Equipment' : 'Cattle');
    final initialCategoryEntry = initialChoices.cast<Map<String, dynamic>?>().firstWhere(
      (category) => '${category?['title']}'.toLowerCase() == requestedCategory.toLowerCase(),
      orElse: () => initialChoices.isEmpty ? null : initialChoices.first,
    );
    selectedCategoryId = '${initialCategoryEntry?['id'] ?? ''}';

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          final scheme = Theme.of(context).colorScheme;
          return Scaffold(
            appBar: AppBar(title: const Text('Sell Your Product')),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Listing type *',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Farm product',
                        child: Text('Farm product', overflow: TextOverflow.ellipsis),
                      ),
                      DropdownMenuItem(
                        value: 'Equipment',
                        child: Text('Equipment', overflow: TextOverflow.ellipsis),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        selectedType = value;
                        final choices = categoriesForType(value);
                        selectedCategoryId = choices.isEmpty ? '' : '${choices.first['id']}';
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Image Upload Section
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 800,
                        maxHeight: 800,
                        imageQuality: 80,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          selectedImage = File(pickedFile.path);
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: scheme.primary.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 120,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 40,
                                  color: scheme.primary.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap to upload product image',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId.isEmpty ? null : selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: selectedType == 'Equipment' ? 'Category (optional)' : 'Category *',
                      border: OutlineInputBorder(),
                    ),
                    items: categoriesForType(selectedType)
                        .map((cat) => DropdownMenuItem(
                              value: '${cat['id']}',
                              child: Text(
                                '${cat['title'] ?? 'Category'}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    hint: Text(categoriesForType(selectedType).isEmpty
                        ? 'No ${selectedType.toLowerCase()} categories available'
                        : 'Choose a category'),
                    onChanged: (value) => setState(() => selectedCategoryId = value ?? ''),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name *',
                      hintText: 'e.g., Local Chicken',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price (UGX) *',
                      hintText: 'e.g., 25000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity Available *',
                      hintText: 'e.g., 50',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: unitController,
                    decoration: const InputDecoration(
                      labelText: 'Unit of measure *',
                      hintText: 'e.g., kg, bunch, bag',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location *',
                      hintText: 'e.g., Wakiso, Kampala',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Describe your product...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Row(children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isUploading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                onPressed: () async {
                  if (isUploading) return;
                  final missingFields = <String>[
                    if (nameController.text.trim().isEmpty) 'product name',
                    if (priceController.text.trim().isEmpty) 'price',
                    if (quantityController.text.trim().isEmpty) 'quantity',
                    if (unitController.text.trim().isEmpty) 'unit of measure',
                    if (selectedType != 'Equipment' && selectedCategoryId.isEmpty) 'category',
                    if (selectedImage == null) 'product photo',
                    if (locationController.text.trim().isEmpty) 'location',
                  ];
                  if (missingFields.isEmpty) {

                    setState(() => isUploading = true);
                    try {
                      final userId = _currentUserId;
                      if (userId == null || userId <= 0) {
                        throw Exception('Sign in to sell products.');
                      }
                      await _marketApi.createProduct(
                        fields: {
                          'name': nameController.text.trim(),
                          'description': descriptionController.text.trim(),
                          'unit_of_measure': unitController.text.trim(),
                          'stock_available': quantityController.text.trim(),
                          'unit_price_seller': priceController.text.trim(),
                          'unit_price_buyer': priceController.text.trim(),
                          'seller_location': locationController.text.trim(),
                          'user_id': '$userId',
                          if (selectedCategoryId.isNotEmpty) 'category_id': selectedCategoryId,
                        },
                        picture: selectedImage!,
                      );
                      await _loadMarketplaceListings();
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Unable to save listing. $error',
                            style: TextStyle(color: scheme.onError),
                          ),
                          backgroundColor: scheme.error,
                          behavior: SnackBarBehavior.floating,
                        ));
                      }
                      return;
                    } finally {
                      if (context.mounted) setState(() => isUploading = false);
                    }

                    if (!context.mounted) return;

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Product listed for sale successfully!'),
                        backgroundColor: scheme.primary,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Complete these required fields: ${missingFields.join(', ')}.',
                          style: TextStyle(color: scheme.onError),
                        ),
                        backgroundColor: scheme.error,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                ),
                child: isUploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('List Product', maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
                  ),
                ]),
              ),
            ),
          );
        },
        ),
      ),
    );
  }

  // ============= CART DIALOG =============
  Future<void> _openCart() async {
    await _loadCart();
    if (mounted) _showCartDialog(context);
  }

  Future<void> _loadCart() async {
    final userId = _currentUserId;
    if (userId == null || userId <= 0) return;
    try {
      final rows = await _marketApi.getCart(userId);
      final items = rows.whereType<Map>().map((raw) {
        final row = Map<String, dynamic>.from(raw);
        final product = row['product'] is Map ? Map<String, dynamic>.from(row['product'] as Map) : <String, dynamic>{};
        return CartItem(
          cartId: '${row['id'] ?? ''}',
          productId: '${product['id'] ?? ''}',
          name: '${product['name'] ?? 'Product'}',
          price: double.tryParse('${product['unit_price_buyer'] ?? 0}')?.round() ?? 0,
          sellerPrice: double.tryParse('${product['unit_price_seller'] ?? 0}')?.round() ?? 0,
          category: '${(product['category'] is Map ? product['category']['title'] : null) ?? 'Other'}',
          quantity: int.tryParse('${row['quantity'] ?? 1}') ?? 1,
        );
      }).toList();
      if (mounted) setState(() => _cartItems..clear()..addAll(items));
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not load your cart: $error')));
    }
  }

  Future<void> _updateCartItem(CartItem item, int quantity) async {
    try {
      if (quantity <= 0) {
        await _marketApi.deleteCart(item.cartId);
        if (mounted) setState(() => _cartItems.remove(item));
      } else {
        await _marketApi.updateCart(item.cartId, quantity);
        if (mounted) setState(() => item.quantity = quantity);
      }
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not update cart: $error')));
    }
  }

  void _showCartDialog(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_cartItems.length} items',
                    style: TextStyle(
                      fontSize: 14,
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            Expanded(
              child: _cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 64, color: scheme.outlineVariant),
                          const SizedBox(height: 12),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(fontSize: 16, color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start shopping for farm products',
                            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: scheme.primary.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getProductIcon(item.category),
                              size: 24,
                              color: scheme.primary,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'UGX ${_formatPrice(item.price)} x ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _updateCartItem(item, item.quantity - 1);
                                },
                                icon: const Icon(Icons.remove_rounded, size: 18),
                                color: scheme.onSurfaceVariant,
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _updateCartItem(item, item.quantity + 1);
                                },
                                icon: const Icon(Icons.add_rounded, size: 18),
                                color: scheme.primary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: scheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                        Text(
                          'UGX ${_formatPrice(_calculateTotal())}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _cartItems.isEmpty ? null : _startCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

  // ============= HELPERS =============
  Future<void> _addToCart(Product product) async {
    final userId = _currentUserId;
    if (userId == null || userId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sign in to add products to your cart.')));
      return;
    }
    try {
      await _marketApi.addToCart(userId: userId, productId: product.id, quantity: 1);
      await _loadCart();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} added to cart'), backgroundColor: Theme.of(context).colorScheme.primary, duration: const Duration(seconds: 2)),
      );
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not add to cart: $error')));
    }
  }

  Future<void> _startCheckout() async {
    final userId = _currentUserId;
    if (userId == null || userId <= 0 || _cartItems.isEmpty) return;
    final locationController = TextEditingController();
    var deliveryMode = 'pickup';
    var submitting = false;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(builder: (dialogContext, setDialogState) => AlertDialog(
        title: const Text('Checkout'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: const Text('Pick up'),
            value: 'pickup',
            groupValue: deliveryMode,
            onChanged: submitting ? null : (value) => setDialogState(() => deliveryMode = value!),
          ),
          RadioListTile<String>(
            contentPadding: EdgeInsets.zero,
            title: const Text('Delivery'),
            value: 'delivery',
            groupValue: deliveryMode,
            onChanged: submitting ? null : (value) => setDialogState(() => deliveryMode = value!),
          ),
          if (deliveryMode == 'delivery') ...[
            const SizedBox(height: 8),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Delivery location', border: OutlineInputBorder()),
              onChanged: (_) => setDialogState(() {}),
            ),
          ],
          const SizedBox(height: 8),
          Text('Total: UGX ${_formatPrice(_calculateTotal())}', style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
        actions: [
          TextButton(onPressed: submitting ? null : () => Navigator.pop(dialogContext), child: const Text('Back')),
          ElevatedButton(
            onPressed: submitting || (deliveryMode == 'delivery' && locationController.text.trim().isEmpty)
                ? null
                : () async {
                    if (deliveryMode == 'delivery' && locationController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(dialogContext).showSnackBar(const SnackBar(content: Text('Enter a delivery location.')));
                      return;
                    }
                    setDialogState(() => submitting = true);
                    try {
                      final response = await _marketApi.checkout(
                        userId: userId,
                        deliveryMode: deliveryMode,
                        deliveryLocation: locationController.text.trim(),
                        totalCost: _calculateTotal(),
                        totalProfits: _calculateProfit(),
                      );
                      if (!dialogContext.mounted) return;
                      Navigator.pop(dialogContext);
                      Navigator.pop(context); // close cart
                      setState(_cartItems.clear);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${response['message'] ?? 'Order submitted successfully.'}')),
                      );
                      _loadCart();
                    } catch (error) {
                      if (dialogContext.mounted) {
                        setDialogState(() => submitting = false);
                        ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text('Checkout failed: $error')));
                      }
                    }
                  },
            child: submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Place order'),
          ),
        ],
      )),
    );
    locationController.dispose();
  }

  int _calculateTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int _calculateProfit() => _cartItems.fold(
        0,
        (sum, item) => sum + ((item.price - item.sellerPrice) * item.quantity),
      );

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  // Bundled fallback photo for each category so a card always shows a real
  // image instantly, even offline or while a network image is still loading.
  String? _categoryImageAsset(String category) {
    switch (category.toLowerCase()) {
      case 'cattle':
      case 'livestock':
        return 'lib/assets/images/marketplace/cattle.jpg';
      case 'dairy':
        return 'lib/assets/images/marketplace/milk.jpg';
      case 'poultry':
        return 'lib/assets/images/Poultry.png';
      case 'goats':
        return 'lib/assets/images/Goat.png';
      case 'pigs':
        return 'lib/assets/images/Pigs.png';
      case 'sheep':
        return 'lib/assets/images/Sheep.png';
      case 'rabbits':
        return 'lib/assets/images/Rabbit.png';
      case 'feed':
        return 'lib/assets/images/marketplace/feed.jpg';
      case 'equipment':
      case 'housing':
        return null; // No stock photos for equipment — render an icon instead.
      default:
        return 'lib/assets/images/marketplace/cattle.jpg';
    }
  }

  // Chooses a representative icon for an equipment/housing item based on its
  // name, since there's no stock photo to fall back to.
  IconData _equipmentIconFor(Product product) {
    final n = product.name.toLowerCase();
    if (n.contains('drone')) return Icons.flight_rounded;
    if (n.contains('tractor')) return Icons.agriculture_rounded;
    if (n.contains('milk')) return Icons.local_drink_rounded;
    if (n.contains('incubator') || n.contains('egg')) return Icons.egg_rounded;
    if (n.contains('coop') || n.contains('house') || n.contains('barn') || n.contains('shed') || n.contains('crush') || n.contains('pen')) {
      return Icons.warehouse_rounded;
    }
    if (n.contains('water') || n.contains('pump')) return Icons.water_drop_rounded;
    return Icons.handyman_rounded;
  }

  Widget _categoryImage(Product product) {
    final scheme = Theme.of(context).colorScheme;
    final asset = _categoryImageAsset(product.category);
    if (asset == null) {
      return Container(
        color: scheme.primary.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: Icon(_equipmentIconFor(product), size: 32, color: scheme.primary.withValues(alpha: 0.7)),
      );
    }
    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      cacheWidth: 400,
    );
  }

  // Renders the product photo. Local assets and freshly picked files paint
  // immediately; network images are cached to disk after the first load and
  // fall back to the bundled category photo (or an icon, for equipment) on error.
  Widget _buildProductImage(Product product, ColorScheme scheme) {
    if (product.imageFile != null) {
      return Image.file(
        product.imageFile!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 400,
      );
    }

    final asset = product.imageAsset;
    if (asset != null && asset.startsWith('lib/assets/')) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        cacheWidth: 400,
        errorBuilder: (_, __, ___) => _categoryImage(product),
      );
    }

    final url = product.imageUrl;
    if (url != null && url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        memCacheWidth: 400,
        fadeInDuration: const Duration(milliseconds: 200),
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: scheme.surfaceContainerHighest,
          highlightColor: scheme.surface,
          child: Container(color: scheme.surfaceContainerHighest),
        ),
        errorWidget: (_, __, ___) => _categoryImage(product),
      );
    }

    return _categoryImage(product);
  }

  IconData _getProductIcon(String category) {
    switch (category) {
      case 'Cattle':
        return Icons.agriculture_rounded;
      case 'Poultry':
        return Icons.egg_rounded;
      case 'Goats':
        return Icons.pets_rounded;
      case 'Pigs':
        return Icons.cruelty_free_rounded;
      case 'Sheep':
        return Icons.pets_rounded;
      case 'Rabbits':
        return Icons.cruelty_free_rounded;
      case 'Dairy':
        return Icons.local_drink_rounded;
      case 'Feed':
        return Icons.grain_rounded;
      case 'Crops':
        return Icons.grass_rounded;
      case 'Equipment':
        return Icons.handyman_rounded;
      case 'Housing':
        return Icons.warehouse_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  /// "800 m away" below 1 km, otherwise "12.4 km away".
  String _formatDistance(double km) {
    if (km < 1) return '${(km * 1000).round()} m away';
    return '${km.toStringAsFixed(1)} km away';
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: scheme.outlineVariant),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

// ============= MODELS =============

/// One circular shortcut in the "Top Categories" row — backed by a photo
/// asset (livestock) or an icon (equipment, which has no stock photos).
class _TopCategory {
  final String label;
  final String filterValue;
  final String? asset;
  final IconData? icon;

  const _TopCategory({
    required this.label,
    required this.filterValue,
    this.asset,
    this.icon,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final String categoryId;
  final int price;
  final String unit;
  final String seller;
  final int? sellerId;
  final String sellerPhone;
  final String location;
  final double rating;
  final String? imageAsset;
  final String? imageUrl;
  final File? imageFile;
  final int inStock;
  final String description;
  final String status;
  final DateTime? createdAt;
  final bool isServerBacked;
  final bool isDashboardListing;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.categoryId = '',
    required this.price,
    required this.unit,
    required this.seller,
    this.sellerId,
    this.sellerPhone = '',
    required this.location,
    required this.rating,
    this.imageAsset,
    this.imageUrl,
    this.imageFile,
    required this.inStock,
    required this.description,
    this.status = 'active',
    this.createdAt,
    this.isServerBacked = false,
    this.isDashboardListing = false,
  });
}

class CartItem {
  final String cartId;
  final String productId;
  final String name;
  final int price;
  final int sellerPrice;
  final String category;
  int quantity;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.name,
    required this.price,
    required this.sellerPrice,
    required this.category,
    required this.quantity,
  });
}

/// A market ready to render, whether it came from the backend or the
/// bundled Uganda reference list.
class _MarketView {
  final String name;
  final String location;
  final String schedule;
  final List<String> trades;
  final double? distanceKm;
  final double? lat;
  final double? lng;

  const _MarketView({
    required this.name,
    required this.location,
    required this.schedule,
    required this.trades,
    this.distanceKm,
    this.lat,
    this.lng,
  });

  factory _MarketView.fromLocal(UgandaMarket m, double? distanceKm) {
    return _MarketView(
      name: m.name,
      location: '${m.district} · ${m.region} Region',
      schedule: m.schedule,
      trades: m.trades,
      distanceKm: distanceKm,
      lat: m.lat,
      lng: m.lng,
    );
  }

  factory _MarketView.fromServer(Map<String, dynamic> j, Position? pos) {
    final lat = double.tryParse('${j['lat'] ?? j['latitude'] ?? ''}');
    final lng = double.tryParse('${j['lng'] ?? j['longitude'] ?? ''}');
    double? distanceKm = double.tryParse('${j['distance_km'] ?? ''}');
    if (distanceKm == null && pos != null && lat != null && lng != null) {
      distanceKm = Geolocator.distanceBetween(
            pos.latitude,
            pos.longitude,
            lat,
            lng,
          ) /
          1000;
    }
    final trades = j['trades'];
    return _MarketView(
      name: '${j['name'] ?? 'Market'}',
      location: '${j['district'] ?? j['location'] ?? 'Uganda'}',
      schedule: '${j['schedule'] ?? j['hours'] ?? 'Check locally'}',
      trades: trades is List ? trades.map((e) => '$e').toList() : const [],
      distanceKm: distanceKm,
      lat: lat,
      lng: lng,
    );
  }
}

class SoldProduct {
  final String name;
  final int quantity;
  final int price;
  final int total;
  final String buyer;
  final String date;
  final String status;

  SoldProduct({
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
    required this.buyer,
    required this.date,
    required this.status,
  });
}
