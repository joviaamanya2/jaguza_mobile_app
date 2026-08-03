import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  int _selectedTab = 0;
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sample cart items
  final List<CartItem> _cartItems = [];

  // Sample products with market-based prices
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Local Chicken (Broiler)',
      category: 'Poultry',
      price: 25000,
      unit: 'per bird',
      seller: 'Green Valley Farm',
      location: 'Wakiso',
      rating: 4.8,
      imageAsset: 'assets/chicken.png',
      imageUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=400&h=300&fit=crop',
      inStock: 50,
      description: 'Healthy local chickens raised on organic feed',
    ),
    Product(
      id: '2',
      name: 'Fresh Cow Milk',
      category: 'Dairy',
      price: 3000,
      unit: 'per litre',
      seller: 'Milk Masters Ltd',
      location: 'Mbarara',
      rating: 4.9,
      imageAsset: 'assets/milk.png',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400&h=300&fit=crop',
      inStock: 100,
      description: 'Fresh pasteurized milk from healthy Friesian cows',
    ),
    Product(
      id: '3',
      name: 'Friesian Heifer',
      category: 'Cattle',
      price: 2500000,
      unit: 'per animal',
      seller: 'Elite Cattle Farm',
      location: 'Jinja',
      rating: 4.7,
      imageAsset: 'assets/cattle.png',
      imageUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=300&fit=crop',
      inStock: 5,
      description: 'High quality Friesian heifer, vaccinated and dewormed',
    ),
    Product(
      id: '4',
      name: 'Layer Poultry Feed',
      category: 'Feed',
      price: 45000,
      unit: 'per 50kg bag',
      seller: 'Jaguza Feeds Ltd',
      location: 'Kampala',
      rating: 4.6,
      imageAsset: 'assets/feed.png',
      imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=300&fit=crop',
      inStock: 200,
      description: 'Balanced layer feed with 18% protein content',
    ),
    Product(
      id: '5',
      name: 'Goat (Mature)',
      category: 'Goats',
      price: 180000,
      unit: 'per goat',
      seller: 'Mukono Goat Farm',
      location: 'Mukono',
      rating: 4.5,
      imageAsset: 'assets/goat.png',
      imageUrl: 'https://images.unsplash.com/photo-1484557985045-edf25e08da73?w=400&h=300&fit=crop',
      inStock: 15,
      description: 'Healthy mature Boer goats for breeding or meat',
    ),
    Product(
      id: '6',
      name: 'Organic Pig Feed',
      category: 'Feed',
      price: 15000,
      unit: 'per 25kg bag',
      seller: 'Green Harvest Farm',
      location: 'Entebbe',
      rating: 4.8,
      imageAsset: 'assets/feed.png',
      imageUrl: 'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?w=400&h=300&fit=crop',
      inStock: 30,
      description: 'Organic feed for pigs',
    ),
    Product(
      id: '7',
      name: 'Pig (Weaner)',
      category: 'Pigs',
      price: 120000,
      unit: 'per piglet',
      seller: 'Pork Masters',
      location: 'Gulu',
      rating: 4.4,
      imageAsset: 'assets/pig.png',
      imageUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=400&h=300&fit=crop',
      inStock: 20,
      description: 'Healthy weaner pigs, 8 weeks old, vaccinated',
    ),
    Product(
      id: '8',
      name: 'Eggs (Tray)',
      category: 'Poultry',
      price: 12000,
      unit: 'per tray (30 eggs)',
      seller: 'Happy Hens Farm',
      location: 'Kampala',
      rating: 4.7,
      imageAsset: 'assets/eggs.png',
      imageUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=400&h=300&fit=crop',
      inStock: 150,
      description: 'Fresh free-range eggs from healthy hens',
    ),
  ];

  // User uploaded products
  final List<Product> _userProducts = [];

  // Sample markets with location-based pricing
  final List<Market> _nearbyMarkets = [
    Market(
      name: 'Kampala Livestock Market',
      location: 'Nakawa, Kampala',
      distance: '2.5 km',
      rating: 4.2,
      activeHours: '6:00 AM - 6:00 PM',
      products: ['Cattle', 'Goats', 'Sheep', 'Poultry'],
      priceRange: 'Premium',
      averagePrice: 'UGX 2,800,000',
    ),
    Market(
      name: 'Wandegeya Farm Products Market',
      location: 'Wandegeya, Kampala',
      distance: '4.0 km',
      rating: 4.5,
      activeHours: '7:00 AM - 7:00 PM',
      products: ['Vegetables', 'Fruits', 'Dairy', 'Grains'],
      priceRange: 'Mid-Range',
      averagePrice: 'UGX 1,200,000',
    ),
    Market(
      name: 'Jinja Livestock Trading Center',
      location: 'Jinja Town',
      distance: '8.0 km',
      rating: 4.0,
      activeHours: '5:30 AM - 5:30 PM',
      products: ['Cattle', 'Pigs', 'Poultry', 'Feed'],
      priceRange: 'Standard',
      averagePrice: 'UGX 2,100,000',
    ),
    Market(
      name: 'Mbarara Cattle Market',
      location: 'Mbarara Town',
      distance: '12.0 km',
      rating: 4.3,
      activeHours: '6:00 AM - 5:00 PM',
      products: ['Cattle', 'Goats', 'Sheep', 'Dairy'],
      priceRange: 'Standard',
      averagePrice: 'UGX 2,500,000',
    ),
  ];

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

  List<Product> get _filteredProducts {
    final allProducts = [..._products, ..._userProducts];
    final query = _searchQuery.toLowerCase();
    return allProducts.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(query) ||
          p.seller.toLowerCase().contains(query) ||
          p.location.toLowerCase().contains(query);
      final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Market Place',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, size: 24),
                onPressed: () => _showCartDialog(context),
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
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
        ],
      ),
      body: Column(
        children: [
          _buildTabBar(),
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(
            child: IndexedStack(
              index: _selectedTab,
              children: [
                _buildProductsList(),
                _buildAnimalPrices(),
                _buildNearbyMarkets(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedTab == 0
          ? FloatingActionButton(
              onPressed: () => _showSellProductDialog(context),
              backgroundColor: const Color(0xFF2E7D32),
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
    );
  }

  // ============= TAB BAR =============
  Widget _buildTabBar() {
    final tabs = [
      {'icon': Icons.storefront_rounded, 'label': 'Products'},
      {'icon': Icons.monetization_on_rounded, 'label': 'Prices'},
      {'icon': Icons.location_on_rounded, 'label': 'Markets'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isActive = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF2E7D32).withOpacity(0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 20,
                      color: isActive ? const Color(0xFF2E7D32) : Colors.grey[500],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tab['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? const Color(0xFF2E7D32) : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============= SEARCH BAR =============
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E8E8)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) => setState(() => _searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search products, sellers, or locations...',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
            prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2E7D32), size: 20),
            suffixIcon: _searchQuery.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                    child: Icon(Icons.close_rounded, color: Colors.grey[400], size: 18),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          ),
        ),
      ),
    );
  }

  // ============= CATEGORY CHIPS =============
  Widget _buildCategoryChips() {
    final categories = ['All', 'Cattle', 'Poultry', 'Goats', 'Pigs', 'Dairy', 'Feed', 'Crops'];
    
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isActive = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isActive ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
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

  // ============= PRODUCTS LIST =============
  Widget _buildProductsList() {
    final products = _filteredProducts;
    
    if (products.isEmpty) {
      return _buildEmptyState(
        icon: Icons.storefront_rounded,
        title: 'No Products Found',
        subtitle: 'Try adjusting your search or category',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _buildProductCard(products[index]),
    );
  }

  Widget _buildProductCard(Product product) {
    final isAvailable = product.inStock > 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.06),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: product.imageFile != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.file(
                          product.imageFile!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120,
                        ),
                      )
                    : product.imageUrl != null
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Icon(
                                    _getProductIcon(product.category),
                                    size: 48,
                                    color: const Color(0xFF2E7D32).withOpacity(0.3),
                                  ),
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Icon(
                              _getProductIcon(product.category),
                              size: 48,
                              color: const Color(0xFF2E7D32).withOpacity(0.3),
                            ),
                          ),
              ),
              // Available/Sold Badge at Top Right
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    isAvailable ? 'Available' : 'Sold',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        product.location,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.star_rounded, size: 12, color: Colors.amber[600]),
                    Text(
                      product.rating.toString(),
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      'UGX ${_formatPrice(product.price)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        product.unit,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: product.inStock > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.inStock > 0 ? '${product.inStock} in stock' : 'Out of stock',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: product.inStock > 0 ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: product.inStock > 0
                          ? () => _addToCart(product)
                          : null,
                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                      color: const Color(0xFF2E7D32),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============= ANIMAL PRICES =============
  Widget _buildAnimalPrices() {
    final priceData = [
      {'animal': 'Friesian Heifer', 'price': '2,500,000 - 3,500,000', 'unit': 'per animal', 'trend': 'up', 'market': 'Kampala'},
      {'animal': 'Broiler Chicken', 'price': '25,000 - 30,000', 'unit': 'per bird', 'trend': 'stable', 'market': 'Wakiso'},
      {'animal': 'Local Goat', 'price': '150,000 - 250,000', 'unit': 'per goat', 'trend': 'up', 'market': 'Mbarara'},
      {'animal': 'Weaner Pig', 'price': '100,000 - 150,000', 'unit': 'per piglet', 'trend': 'down', 'market': 'Jinja'},
      {'animal': 'Layer (Point of Lay)', 'price': '20,000 - 25,000', 'unit': 'per bird', 'trend': 'stable', 'market': 'Kampala'},
      {'animal': 'Fresh Milk', 'price': '2,500 - 3,500', 'unit': 'per litre', 'trend': 'up', 'market': 'Mbarara'},
      {'animal': 'Sheep (Mature)', 'price': '120,000 - 180,000', 'unit': 'per sheep', 'trend': 'stable', 'market': 'Gulu'},
      {'animal': 'Rabbit (Breeder)', 'price': '30,000 - 50,000', 'unit': 'per rabbit', 'trend': 'up', 'market': 'Entebbe'},
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_rounded, color: Colors.orange[700], size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Prices are based on current market trends at major trading centers.',
                    style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Market Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_rounded, color: Color(0xFF2E7D32), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Market: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Kampala Central Market',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          ...priceData.map((data) => _buildPriceCard(data)),
        ],
      ),
    );
  }

  Widget _buildPriceCard(Map<String, String> data) {
    Color trendColor;
    IconData trendIcon;
    if (data['trend'] == 'up') {
      trendColor = Colors.green;
      trendIcon = Icons.trending_up_rounded;
    } else if (data['trend'] == 'down') {
      trendColor = Colors.red;
      trendIcon = Icons.trending_down_rounded;
    } else {
      trendColor = Colors.orange;
      trendIcon = Icons.trending_flat_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getAnimalIcon(data['animal']!),
              size: 20,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['animal']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${data['unit']!} • ${data['market']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'UGX ${data['price']}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    trendIcon,
                    size: 14,
                    color: trendColor,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    data['trend'] == 'up' ? 'Rising' : data['trend'] == 'down' ? 'Falling' : 'Stable',
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: _nearbyMarkets.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildMarketCard(_nearbyMarkets[index]),
      ),
    );
  }

  Widget _buildMarketCard(Market market) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.storefront_rounded,
                  size: 22,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1F36),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            market.location,
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.timer_rounded, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 3),
                        Text(
                          market.distance,
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_rounded, size: 12, color: Colors.amber[600]),
                    Text(
                      market.rating.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: market.products.map((product) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  product,
                  style: TextStyle(
                    fontSize: 10,
                    color: const Color(0xFF2E7D32),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time_rounded, size: 12, color: Colors.grey[400]),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  market.activeHours,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  market.priceRange!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[700],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.directions_rounded, size: 16),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
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
  void _showSellProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    final descriptionController = TextEditingController();
    final locationController = TextEditingController();
    String selectedCategory = 'Cattle';
    File? selectedImage;
    bool isUploading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Sell Your Product'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        color: const Color(0xFF2E7D32).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2E7D32).withOpacity(0.2),
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
                                  color: const Color(0xFF2E7D32).withOpacity(0.4),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap to upload product image',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category *',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      'Cattle', 'Poultry', 'Goats', 'Pigs', 'Dairy', 'Feed', 'Crops'
                    ].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                    onChanged: (value) => selectedCategory = value ?? 'Cattle',
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
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      quantityController.text.isNotEmpty &&
                      locationController.text.isNotEmpty) {
                    
                    final newProduct = Product(
                      id: DateTime.now().toString(),
                      name: nameController.text,
                      category: selectedCategory,
                      price: int.parse(priceController.text),
                      unit: 'per unit',
                      seller: 'Your Farm',
                      location: locationController.text,
                      rating: 0,
                      imageFile: selectedImage,
                      inStock: int.parse(quantityController.text),
                      description: descriptionController.text,
                    );
                    
                    setState(() {
                      _userProducts.add(newProduct);
                    });
                    
                    Navigator.pop(context);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product listed for sale successfully!'),
                        backgroundColor: Color(0xFF2E7D32),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in all required fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('List Product'),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============= CART DIALOG =============
  void _showCartDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Shopping Cart',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '2 items',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2E7D32),
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
                          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                          const SizedBox(height: 12),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start shopping for farm products',
                            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
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
                              color: const Color(0xFF2E7D32).withOpacity(0.06),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getProductIcon(item.category),
                              size: 24,
                              color: const Color(0xFF2E7D32),
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
                              color: Colors.grey[500],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (item.quantity > 1) {
                                      item.quantity--;
                                    } else {
                                      _cartItems.remove(item);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove_rounded, size: 18),
                                color: Colors.grey[400],
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
                                  setState(() {
                                    item.quantity++;
                                  });
                                },
                                icon: const Icon(Icons.add_rounded, size: 18),
                                color: const Color(0xFF2E7D32),
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
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          'UGX ${_formatPrice(_calculateTotal())}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1F36),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _cartItems.isEmpty ? null : () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
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
  void _addToCart(Product product) {
    setState(() {
      final existing = _cartItems.where((item) => item.name == product.name).firstOrNull;
      if (existing != null) {
        existing.quantity++;
      } else {
        _cartItems.add(CartItem(
          name: product.name,
          price: product.price,
          category: product.category,
          quantity: 1,
        ));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: const Color(0xFF2E7D32),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int _calculateTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
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
      case 'Dairy':
        return Icons.local_drink_rounded;
      case 'Feed':
        return Icons.grain_rounded;
      case 'Crops':
        return Icons.grass_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  IconData _getAnimalIcon(String animal) {
    if (animal.toLowerCase().contains('cattle') || animal.toLowerCase().contains('heifer') || animal.toLowerCase().contains('cow')) {
      return Icons.agriculture_rounded;
    } else if (animal.toLowerCase().contains('chicken') || animal.toLowerCase().contains('layer') || animal.toLowerCase().contains('broiler')) {
      return Icons.egg_rounded;
    } else if (animal.toLowerCase().contains('goat')) {
      return Icons.pets_rounded;
    } else if (animal.toLowerCase().contains('pig')) {
      return Icons.cruelty_free_rounded;
    } else if (animal.toLowerCase().contains('milk') || animal.toLowerCase().contains('dairy')) {
      return Icons.local_drink_rounded;
    } else if (animal.toLowerCase().contains('sheep')) {
      return Icons.pets_rounded;
    } else if (animal.toLowerCase().contains('rabbit')) {
      return Icons.cruelty_free_rounded;
    }
    return Icons.category_rounded;
  }

  Widget _buildEmptyState({required IconData icon, required String title, required String subtitle}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1A1F36)),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}

// ============= MODELS =============
class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final String unit;
  final String seller;
  final String location;
  final double rating;
  final String? imageAsset;
  final String? imageUrl;
  final File? imageFile;
  final int inStock;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.unit,
    required this.seller,
    required this.location,
    required this.rating,
    this.imageAsset,
    this.imageUrl,
    this.imageFile,
    required this.inStock,
    required this.description,
  });
}

class CartItem {
  final String name;
  final int price;
  final String category;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.category,
    required this.quantity,
  });
}

class Market {
  final String name;
  final String location;
  final String distance;
  final double rating;
  final String activeHours;
  final List<String> products;
  final String? priceRange;
  final String? averagePrice;

  Market({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.activeHours,
    required this.products,
    this.priceRange,
    this.averagePrice,
  });
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