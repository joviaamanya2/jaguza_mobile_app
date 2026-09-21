import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/services/api_service.dart';
import 'package:jaguza_app/models/user.dart';

/// "Jaguza Equipment" — farm equipment and housing/structures listed on the
/// shared marketplace, filtered to the `equipment` and `housing` categories.
class JaguzaEquipmentScreen extends StatefulWidget {
  const JaguzaEquipmentScreen({super.key});

  @override
  State<JaguzaEquipmentScreen> createState() => _JaguzaEquipmentScreenState();
}

class _JaguzaEquipmentScreenState extends State<JaguzaEquipmentScreen> {
  static const _categories = ['All', 'Equipment', 'Housing'];

  String _selectedCategory = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  int? _currentUserId;
  List<EquipmentListing> _listings = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadListings();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final response = await ApiService().get('user');
      if (response is Map && mounted) {
        setState(() {
          _currentUserId =
              User.fromJson(Map<String, dynamic>.from(response)).id;
        });
      }
    } catch (_) {
      // Not logged in / unreachable: owner actions simply won't show.
    }
  }

  Future<void> _loadListings() async {
    setState(() => _isLoading = true);
    try {
      final raw = await ApiService().getMarketplaceListings();
      final listings = raw
          .whereType<Map>()
          .map((m) => EquipmentListing.fromJson(Map<String, dynamic>.from(m)))
          .where((l) => l.category == 'equipment' || l.category == 'housing')
          .toList();
      if (mounted) setState(() => _listings = listings);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not load equipment: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<EquipmentListing> get _filtered {
    final query = _searchQuery.toLowerCase();
    return _listings.where((l) {
      final matchesCategory = _selectedCategory == 'All' ||
          l.category == _selectedCategory.toLowerCase();
      final matchesSearch = query.isEmpty ||
          l.title.toLowerCase().contains(query) ||
          l.location.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Jaguza Equipment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadListings,
        child: Column(
          children: [
            _buildSearchBar(scheme),
            _buildCategoryChips(scheme),
            Expanded(child: _buildBody(scheme)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showListEquipmentDialog(context),
        backgroundColor: scheme.primary,
        child: Icon(Icons.add_rounded, color: scheme.onPrimary),
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme scheme) {
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
            hintText: 'Search equipment, housing, or location...',
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

  Widget _buildCategoryChips(ColorScheme scheme) {
    return Container(
      height: 40,
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
                border: Border.all(color: isActive ? scheme.primary : scheme.outlineVariant),
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

  Widget _buildBody(ColorScheme scheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final listings = _filtered;
    if (listings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          Icon(Icons.warehouse_rounded, size: 64, color: scheme.outlineVariant),
          const SizedBox(height: 12),
          Text(
            'No equipment or housing listed yet',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to list a tractor, incubator, chicken coop, or barn.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
          ),
        ],
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: listings.length,
      itemBuilder: (context, index) => _EquipmentCard(
        item: listings[index],
        isOwner: listings[index].sellerId != null && listings[index].sellerId == _currentUserId,
        onTap: () => _showDetail(listings[index]),
        onDelete: () => _deleteListing(listings[index]),
      ),
    );
  }

  void _showDetail(EquipmentListing item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EquipmentDetailSheet(item: item),
    );
  }

  Future<void> _deleteListing(EquipmentListing item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete listing?'),
        content: Text('Remove "${item.title}" from Jaguza Equipment? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ApiService().deleteMarketplaceListing(item.id);
      if (!mounted) return;
      setState(() => _listings.removeWhere((l) => l.id == item.id));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing deleted.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete listing: $e')),
      );
    }
  }

  void _showListEquipmentDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'Equipment';
    File? selectedImage;
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final scheme = Theme.of(context).colorScheme;
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('List Equipment or Housing'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                        setDialogState(() => selectedImage = File(pickedFile.path));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(selectedImage!, fit: BoxFit.cover, width: double.infinity, height: 120),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, size: 40, color: scheme.primary.withValues(alpha: 0.4)),
                                const SizedBox(height: 6),
                                Text('Tap to upload a photo', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: const InputDecoration(labelText: 'Type *', border: OutlineInputBorder()),
                    items: const ['Equipment', 'Housing']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                        .toList(),
                    onChanged: (value) => selectedCategory = value ?? 'Equipment',
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      hintText: 'e.g., Milking Machine, Chicken Coop',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price (UGX) *', hintText: 'e.g., 350000', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(labelText: 'Location *', hintText: 'e.g., Mbarara', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description', hintText: 'Condition, dimensions, capacity...', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(context),
                child: Text('Cancel', style: TextStyle(color: scheme.onSurfaceVariant)),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        if (titleController.text.trim().isEmpty ||
                            priceController.text.trim().isEmpty ||
                            locationController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please fill in all required fields'),
                              backgroundColor: scheme.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isSaving = true);
                        try {
                          await ApiService().createMarketplaceListing({
                            'title': titleController.text.trim(),
                            'category': selectedCategory.toLowerCase(),
                            'price': priceController.text.trim(),
                            'location': locationController.text.trim(),
                            'description': descriptionController.text.trim(),
                          }, imageFile: selectedImage);
                          await _loadListings();
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not list item: $error')),
                            );
                          }
                          return;
                        } finally {
                          if (context.mounted) setDialogState(() => isSaving = false);
                        }

                        if (!context.mounted) return;
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Listed successfully!'),
                            backgroundColor: scheme.primary,
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(backgroundColor: scheme.primary, foregroundColor: scheme.onPrimary),
                child: isSaving
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('List Item'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final EquipmentListing item;
  final bool isOwner;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _EquipmentCard({
    required this.item,
    required this.isOwner,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isHousing = item.category == 'housing';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: scheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.06),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: _buildImage(scheme),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isHousing ? const Color(0xFF8D6E63) : scheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isHousing ? 'Housing' : 'Equipment',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  if (isOwner)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 16, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          onSelected: (value) {
                            if (value == 'delete') onDelete();
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurface),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 10, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          item.location,
                          style: TextStyle(fontSize: 9, color: scheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UGX ${item.formattedPrice}',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ColorScheme scheme) {
    final url = item.imageUrl;
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
        errorWidget: (_, __, ___) => _fallbackIcon(scheme),
      );
    }
    return _fallbackIcon(scheme);
  }

  Widget _fallbackIcon(ColorScheme scheme) {
    return Center(
      child: Icon(
        item.category == 'housing' ? Icons.warehouse_rounded : Icons.handyman_rounded,
        size: 32,
        color: scheme.primary.withValues(alpha: 0.4),
      ),
    );
  }
}

class _EquipmentDetailSheet extends StatelessWidget {
  final EquipmentListing item;
  const _EquipmentDetailSheet({required this.item});

  Future<void> _callSeller(BuildContext context) async {
    final phone = item.sellerPhone;
    if (phone == null || phone.isEmpty) return;
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not start a call on this device.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: scheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            if (item.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 16),
            Text(item.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on_rounded, size: 14, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(item.location, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'UGX ${item.formattedPrice}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: scheme.primary),
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(item.description, style: TextStyle(fontSize: 14, color: scheme.onSurface, height: 1.5)),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.person_rounded, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Listed by ${item.sellerName}', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (item.sellerPhone != null && item.sellerPhone!.isNotEmpty)
                    ? () => _callSeller(context)
                    : null,
                icon: const Icon(Icons.call_rounded, size: 18),
                label: Text((item.sellerPhone != null && item.sellerPhone!.isNotEmpty)
                    ? 'Call Seller'
                    : 'No contact number on file'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: scheme.onPrimary,
                  disabledBackgroundColor: scheme.surfaceContainerHighest,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EquipmentListing {
  final int id;
  final String title;
  final String description;
  final String category; // 'equipment' or 'housing'
  final int price;
  final String location;
  final String? imageUrl;
  final int? sellerId;
  final String sellerName;
  final String? sellerPhone;

  const EquipmentListing({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.location,
    this.imageUrl,
    this.sellerId,
    required this.sellerName,
    this.sellerPhone,
  });

  factory EquipmentListing.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'];
    final sellerMap = seller is Map ? Map<String, dynamic>.from(seller) : null;
    final images = json['images'];
    final imageUrl = images is List && images.isNotEmpty ? images.first.toString() : null;

    return EquipmentListing(
      id: int.tryParse('${json['id'] ?? ''}') ?? 0,
      title: '${json['title'] ?? 'Listing'}',
      description: '${json['description'] ?? ''}',
      category: '${json['category'] ?? 'equipment'}'.toLowerCase(),
      price: double.tryParse('${json['price'] ?? 0}')?.round() ?? 0,
      location: '${json['location'] ?? 'Unknown location'}',
      imageUrl: imageUrl,
      sellerId: sellerMap != null ? int.tryParse('${sellerMap['id'] ?? ''}') : null,
      sellerName: sellerMap != null ? '${sellerMap['name'] ?? 'Seller'}' : 'Seller',
      sellerPhone: sellerMap != null ? sellerMap['phone_number']?.toString() : null,
    );
  }

  String get formattedPrice => price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}
