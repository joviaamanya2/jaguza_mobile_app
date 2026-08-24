import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jaguza_app/services/api_service.dart';
import '../Gestation tracker/gestation_tracker.dart';

// Add to pubspec.yaml: image_picker: ^1.0.7

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _isLoadingProfile = true;
  int _animalCount = 0;
  int _reportCount = 0;
  int _savedCount = 0;

  String _userName = 'Loading profile...';
  String _userEmail = '';
  String _userPhone = '';
  String _userLocation = 'Location not set';
  String _userFarmType = 'Farm type not set';
  String _userFarmSize = 'Farm size not set';
  String _userRole = 'farmer';
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final api = ApiService();
      final results = await Future.wait<dynamic>([
        api.get('user'),
        api.getAnimals(),
        api.getReports(),
      ]);
      final user = results[0] is Map
          ? Map<String, dynamic>.from(results[0] as Map)
          : <String, dynamic>{};
      final farms = user['farms'] is List ? user['farms'] as List : const [];

      if (!mounted) return;
      setState(() {
        _userName = (user['name'] ?? user['full_name'] ?? '').toString();
        if (_userName.trim().isEmpty) _userName = 'Jaguza Farmer';
        _userEmail = (user['email'] ?? '').toString();
        _userPhone = (user['phone_number'] ?? '').toString();
        _userRole = (user['role'] ?? 'farmer').toString();
        if (_userRole.trim().isEmpty) _userRole = 'farmer';
        _isVerified = user['is_verified'] == true;
        _userLocation = (user['farm_location'] ?? '').toString();
        if (_userLocation.trim().isEmpty && farms.isNotEmpty && farms.first is Map) {
          _userLocation = (farms.first['location'] ?? 'Location not set').toString();
        }
        if (_userLocation.trim().isEmpty) _userLocation = 'Location not set';
        _userFarmType = (user['farm_name'] ?? user['farm_type'] ?? 'Farm name not set').toString();
        _userFarmSize = (user['farm_size'] ?? '').toString();
        if (_userFarmSize.trim().isEmpty && farms.isNotEmpty && farms.first is Map) {
          _userFarmSize = (farms.first['size'] ?? 'Farm size not set').toString();
        }
        if (_userFarmSize.trim().isEmpty) _userFarmSize = 'Farm size not set';
        _animalCount = results[1] is List ? (results[1] as List).length : 0;
        _reportCount = results[2] is List ? (results[2] as List).length : 0;
        _isLoadingProfile = false;
      });
    } catch (e) {
      debugPrint('Profile load error: $e');
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    setState(() => _isUploading = true);
    try {
      final picked = await _picker.pickImage(source: source, imageQuality: 85);
      if (picked != null) {
        setState(() => _profileImage = File(picked.path));
      }
    } catch (e) {
      debugPrint('Image pick error: $e');
    }
    if (mounted) setState(() => _isUploading = false);
  }

  void _showImagePicker() {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: scheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 20),
            Text('Update Profile Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 20),
            Row(
              children: [
                _imagePickOption(Icons.camera_alt_rounded, 'Camera', 'Take a new photo', () => _pickImage(ImageSource.camera)),
                const SizedBox(width: 12),
                _imagePickOption(Icons.photo_library_rounded, 'Gallery', 'Choose from gallery', () => _pickImage(ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 12),
            if (_profileImage != null)
              TextButton.icon(
                onPressed: () => setState(() => _profileImage = null),
                icon: Icon(Icons.delete_outline_rounded, size: 16, color: scheme.error),
                label: Text('Remove Photo', style: TextStyle(color: scheme.error, fontSize: 13, fontWeight: FontWeight.w600)),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _imagePickOption(IconData icon, String title, String subtitle, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Material(
        color: scheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(icon, color: scheme.primary, size: 24),
                ),
                const SizedBox(height: 10),
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _updateUserData({
    String? name,
    String? email,
    String? phone,
    String? location,
    String? farmType,
    String? farmSize,
  }) {
    setState(() {
      if (name != null) _userName = name;
      if (email != null) _userEmail = email;
      if (phone != null) _userPhone = phone;
      if (location != null) _userLocation = location;
      if (farmType != null) _userFarmType = farmType;
      if (farmSize != null) _userFarmSize = farmSize;
    });
    _saveProfileToBackend();
  }

  Future<void> _saveProfileToBackend() async {
    try {
      await ApiService().put('user/profile', {
        'name': _userName,
        'phone_number': _userPhone,
        'farm_name': _userFarmType,
        'farm_location': _userLocation,
      });
      if (mounted) _showMessage('Profile updated successfully');
    } catch (e) {
      if (mounted) _showMessage('Profile could not be updated: $e', error: true);
    }
  }

  void _showMessage(String message, {bool error = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? scheme.error : scheme.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showChangePasswordDialog() {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangePasswordDialog(
        onPasswordChanged: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Password changed successfully'),
              backgroundColor: scheme.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const SizedBox(height: 16),
            _buildMenuSection('My Farm', [
              MenuItem(icon: Icons.pets_rounded, title: 'My Animals', subtitle: 'Animals registered in your account', color: const Color(0xFF6D4C41), count: '$_animalCount', screen: const MyAnimalsScreen()),
              MenuItem(icon: Icons.coronavirus_rounded, title: 'Health Records', subtitle: 'Track vaccinations & treatments', color: const Color(0xFFE53935), count: '$_reportCount', screen: const HealthRecordsScreen()),
              MenuItem(icon: Icons.pregnant_woman_rounded, title: 'Gestation Tracking', subtitle: 'Monitor active pregnancies', color: const Color(0xFFEC407A), screen: const GestationTrackerScreen()),
            ]),
            _buildMenuSection('Activity', [
              MenuItem(icon: Icons.history_rounded, title: 'My Reports', subtitle: 'Disease reports submitted', color: const Color(0xFF1E88E5), count: '$_reportCount', screen: const MyReportsScreen()),
              MenuItem(icon: Icons.star_rounded, title: 'Saved Articles', subtitle: 'Bookmarked posts', color: const Color(0xFFFFA000), count: '$_savedCount', screen: const SavedArticlesScreen()),
              MenuItem(icon: Icons.chat_rounded, title: 'Chat History', subtitle: 'Previous AI conversations', color: const Color(0xFF8E24AA), screen: const ChatHistoryScreen()),
            ]),
            _buildMenuSection('Settings', [
              MenuItem(icon: Icons.lock_rounded, title: 'Change Password', subtitle: 'Update your account password', color: Theme.of(context).colorScheme.primary, screen: null, onTap: _showChangePasswordDialog),
              MenuItem(icon: Icons.notifications_rounded, title: 'Notifications', subtitle: 'Manage your alerts', color: const Color(0xFFF59E0B), screen: const NotificationsScreen()),
              MenuItem(icon: Icons.help_rounded, title: 'Help & Support', subtitle: 'FAQs and contact us', color: const Color(0xFF3B82F6), screen: const HelpSupportScreen()),
            ]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // Get initials from name
    String initials = _userName
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    if (initials.isEmpty) initials = 'U';
    final scheme = Theme.of(context).colorScheme;

    return Container(
      color: scheme.primary,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _navigateTo(
                  EditProfileScreen(
                    currentName: _userName,
                    currentEmail: _userEmail,
                    currentPhone: _userPhone,
                    currentLocation: _userLocation,
                    currentFarmType: _userFarmType,
                    currentFarmSize: _userFarmSize,
                    onSave: _updateUserData,
                  )
                ),
                child: Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showImagePicker,
            child: Stack(
              children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: _isUploading
                      ? const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : _profileImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(23),
                              child: Image.file(_profileImage!, width: 90, height: 90, fit: BoxFit.cover),
                            )
                          : Center(
                              child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)),
                            ),
                ),
                Positioned(
                  bottom: -2, right: -2,
                  child: Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: scheme.primary, width: 2)),
                    child: Icon(Icons.camera_alt_rounded, color: scheme.primary, size: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(_userLocation, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.5)),
          const SizedBox(height: 4),
          Text(_userEmail, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_rounded, color: Color(0xFF66BB6A), size: 14),
                const SizedBox(width: 4),
                Text(
                  _isVerified ? 'Verified ${_userRole[0].toUpperCase()}${_userRole.substring(1)}' : '${_userRole[0].toUpperCase()}${_userRole.substring(1)} account',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statCard('Animals', '$_animalCount', Icons.pets_rounded, const Color(0xFF6D4C41), () => _navigateTo(const MyAnimalsScreen())),
          const SizedBox(width: 10),
          _statCard('Reports', '$_reportCount', Icons.coronavirus_rounded, const Color(0xFFE53935), () => _navigateTo(const MyReportsScreen())),
          const SizedBox(width: 10),
          _statCard('Saved', '$_savedCount', Icons.bookmark_rounded, const Color(0xFFFFA000), () => _navigateTo(const SavedArticlesScreen())),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color, VoidCallback onTap) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: scheme.outlineVariant)),
          child: Column(
            children: [
              Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18)),
              const SizedBox(height: 6),
              Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 10.5, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<MenuItem> items) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outlineVariant)),
            child: Column(
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : BorderRadius.zero,
                    onTap: item.onTap ?? (item.screen != null ? () => _navigateTo(item.screen!) : null),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                      child: Row(
                        children: [
                          Container(width: 38, height: 38, decoration: BoxDecoration(color: item.color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                            child: Icon(item.icon, color: item.color, size: 18)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(item.title, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: scheme.onSurface)),
                              const SizedBox(height: 1),
                              Text(item.subtitle, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
                            ]),
                          ),
                          if (item.count != null) ...[
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: item.color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                              child: Text(item.count!, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: item.color))),
                            const SizedBox(width: 8),
                          ],
                          Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String? count;
  final Widget? screen;
  final VoidCallback? onTap;

  const MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.count,
    this.screen,
    this.onTap,
  });
}

// ═══════════════════════════════════════════════════════════════
//  CHANGE PASSWORD DIALOG
// ═══════════════════════════════════════════════════════════════
class ChangePasswordDialog extends StatefulWidget {
  final VoidCallback onPasswordChanged;

  const ChangePasswordDialog({
    super.key,
    required this.onPasswordChanged,
  });

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pop(context);
          widget.onPasswordChanged();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_rounded,
              color: scheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Change Password',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(
              'Current Password',
              _currentPasswordController,
              _obscureCurrent,
              () => setState(() => _obscureCurrent = !_obscureCurrent),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              'New Password',
              _newPasswordController,
              _obscureNew,
              () => setState(() => _obscureNew = !_obscureNew),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                if (value == _currentPasswordController.text) {
                  return 'New password must be different';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              'Confirm New Password',
              _confirmPasswordController,
              _obscureConfirm,
              () => setState(() => _obscureConfirm = !_obscureConfirm),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your new password';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: scheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(100, 40),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Update',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggleVisibility, {
    required String? Function(String?)? validator,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: scheme.onSurfaceVariant,
            size: 20,
          ),
          onPressed: toggleVisibility,
        ),
      ),
      style: TextStyle(fontSize: 14, color: scheme.onSurface),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  EDIT PROFILE SCREEN
// ═══════════════════════════════════════════════════════════════
class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentPhone;
  final String currentLocation;
  final String currentFarmType;
  final String currentFarmSize;
  final Function({String? name, String? email, String? phone, String? location, String? farmType, String? farmSize}) onSave;

  const EditProfileScreen({
    super.key,
    required this.currentName,
    required this.currentEmail,
    required this.currentPhone,
    required this.currentLocation,
    required this.currentFarmType,
    required this.currentFarmSize,
    required this.onSave,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _farmTypeController;
  late TextEditingController _farmSizeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _emailController = TextEditingController(text: widget.currentEmail);
    _phoneController = TextEditingController(text: widget.currentPhone);
    _locationController = TextEditingController(text: widget.currentLocation);
    _farmTypeController = TextEditingController(text: widget.currentFarmType);
    _farmSizeController = TextEditingController(text: widget.currentFarmSize);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _farmTypeController.dispose();
    _farmSizeController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    widget.onSave(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      farmType: _farmTypeController.text.trim(),
      farmSize: _farmSizeController.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context)
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _editField('Full Name', _nameController),
            _editField('Email Address', _emailController, keyboardType: TextInputType.emailAddress),
            _editField('Phone Number', _phoneController, keyboardType: TextInputType.phone),
            _editField('Location', _locationController),
            _editField('Farm Type', _farmTypeController),
            _editField('Farm Size', _farmSizeController),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                )
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  MY ANIMALS SCREEN
// ═══════════════════════════════════════════════════════════════
class MyAnimalsScreen extends StatelessWidget {
  const MyAnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animals = [
      {'name': 'Bessie', 'type': 'Cattle', 'breed': 'Holstein Friesian', 'age': '3 years', 'status': 'Healthy', 'color': const Color(0xFF6D4C41)},
      {'name': 'Daisy', 'type': 'Cattle', 'breed': 'Holstein Friesian', 'age': '2 years', 'status': 'Pregnant', 'color': const Color(0xFF6D4C41)},
      {'name': 'Brownie', 'type': 'Goat', 'breed': 'Boer', 'age': '1.5 years', 'status': 'Healthy', 'color': const Color(0xFF2E7D32)},
      {'name': 'Layer Flock A', 'type': 'Poultry', 'breed': 'Isa Brown', 'age': '8 months', 'status': 'Producing', 'color': const Color(0xFFFB8C00)},
      {'name': 'Broiler Batch 12', 'type': 'Poultry', 'breed': 'Cobb 500', 'age': '4 weeks', 'status': 'Growing', 'color': const Color(0xFFE65100)},
    ];
    return _DetailScaffold(title: 'My Animals', subtitle: '12 animals registered', icon: Icons.pets_rounded, color: const Color(0xFF6D4C41),
      children: animals.map((a) => _animalCard(a, context)).toList());
  }

  Widget _animalCard(Map<String, dynamic> a, BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outlineVariant)),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: (a['color'] as Color).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.pets_rounded, color: a['color'] as Color, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(a['name'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface)),
            const SizedBox(height: 2),
            Text('${a['breed']} • ${a['age']}', style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ])),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: scheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
            child: Text(a['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: scheme.primary)),
      )],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HEALTH RECORDS SCREEN
// ═══════════════════════════════════════════════════════════════
class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final records = [
      {'date': '15 Jan 2025', 'animal': 'Bessie', 'type': 'Vaccination', 'detail': 'FMD Vaccine (Booster)', 'vet': 'Dr. Okello', 'status': 'Completed', 'color': const Color(0xFF2E7D32)},
      {'date': '10 Jan 2025', 'animal': 'Layer Flock A', 'type': 'Deworming', 'detail': 'Albendazole 10% - All birds', 'vet': 'Self-administered', 'status': 'Completed', 'color': const Color(0xFF1E88E5)},
      {'date': '28 Dec 2024', 'animal': 'Brownie', 'type': 'Treatment', 'detail': 'Respiratory infection - 5 day course', 'vet': 'Dr. Namukwaya', 'status': 'Recovered', 'color': const Color(0xFFE65100)},
      {'date': '15 Dec 2024', 'animal': 'Daisy', 'type': 'Checkup', 'detail': 'Pregnancy ultrasound - confirmed 4 months', 'vet': 'Dr. Okello', 'status': 'Completed', 'color': const Color(0xFFEC407A)},
    ];
    return _DetailScaffold(title: 'Health Records', subtitle: 'Vaccinations, treatments & checkups', icon: Icons.coronavirus_rounded, color: const Color(0xFFE53935),
      children: records.map((r) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outlineVariant)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: r['color'] as Color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(r['type'] as String, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: r['color'] as Color)),
            const Spacer(),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: (r['color'] as Color).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
              child: Text(r['status'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: r['color'] as Color)),
        )]),
          const SizedBox(height: 8),
          Text(r['detail'] as String, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.4)),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.calendar_today_rounded, size: 13, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(r['date'] as String, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            const SizedBox(width: 16),
            Icon(Icons.pets_rounded, size: 13, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(r['animal'] as String, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
            const Spacer(),
            Icon(Icons.person_rounded, size: 13, color: scheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(r['vet'] as String, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
          ]),
        ]),
      )).toList());
  }
}

// ═══════════════════════════════════════════════════════════════
//  MY REPORTS SCREEN
// ═══════════════════════════════════════════════════════════════
class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reports = [
      {'date': '18 Jan 2025', 'disease': 'Suspected FMD', 'animal': 'Bessie (Cattle)', 'symptoms': 'Fever, blisters on mouth, excessive salivation', 'severity': 'High', 'status': 'Under Review', 'statusColor': Colors.orange},
      {'date': '12 Jan 2025', 'disease': 'Coccidiosis', 'animal': 'Layer Flock A (Poultry)', 'symptoms': 'Diarrhea, weight loss, ruffled feathers', 'severity': 'Medium', 'status': 'Diagnosed', 'statusColor': const Color(0xFF1E88E5)},
      {'date': '05 Jan 2025', 'disease': 'Mastitis', 'animal': 'Daisy (Cattle)', 'symptoms': 'Swollen udder, clots in milk, reduced yield', 'severity': 'Medium', 'status': 'Resolved', 'statusColor': const Color(0xFF2E7D32)},
      {'date': '20 Dec 2024', 'disease': 'Newcastle Disease', 'animal': 'Broiler Batch 10 (Poultry)', 'symptoms': 'Coughing, twisted neck, drop in feed intake', 'severity': 'High', 'status': 'Resolved', 'statusColor': const Color(0xFF2E7D32)},
      {'date': '15 Dec 2024', 'disease': 'Tick Infestation', 'animal': 'Brownie (Goat)', 'symptoms': 'Restlessness, anemia, tick clusters on ears', 'severity': 'Low', 'status': 'Resolved', 'statusColor': const Color(0xFF2E7D32)},
    ];
    
    return _DetailScaffold(
      title: 'My Reports',
      subtitle: 'Disease reports submitted',
      icon: Icons.history_rounded,
      color: const Color(0xFF1E88E5),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE082)),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_rounded,
                color: Colors.orange[700],
                size: 16
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Report suspected diseases early. Include photos, symptoms, and affected animals for faster diagnosis by our AI system and veterinarians.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    height: 1.5
                  )
                )
              ),
            ],
          ),
        ),
        ...reports.map((r) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      r['disease'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface
                      )
                    )
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: (r['statusColor'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Text(
                      r['status'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: r['statusColor'] as Color
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(
                    Icons.pets_rounded,
                    size: 13,
                    color: scheme.onSurfaceVariant
                  ),
                  const SizedBox(width: 4),
                  Text(
                    r['animal'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant
                    )
                  ),
                  const Spacer(),
                  Icon(
                    Icons.warning_rounded,
                    size: 13,
                    color: scheme.onSurfaceVariant
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Severity: ${r['severity']}',
                    style: TextStyle(
                      fontSize: 11,
                      color: scheme.onSurfaceVariant
                    )
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                r['symptoms'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                  height: 1.4
                )
              ),
              const SizedBox(height: 8),
              Text(
                r['date'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: scheme.onSurfaceVariant
                )
              ),
            ],
          ),
        )),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SAVED ARTICLES SCREEN
// ═══════════════════════════════════════════════════════════════
class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final articles = [
      {'title': 'How to Prevent FMD in Cattle', 'category': 'Disease Prevention', 'date': '16 Jan 2025', 'readTime': '5 min'},
      {'title': 'Feeding Strategies for Dry Season', 'category': 'Nutrition', 'date': '14 Jan 2025', 'readTime': '8 min'},
      {'title': 'Understanding Poultry Biosecurity', 'category': 'Management', 'date': '10 Jan 2025', 'readTime': '6 min'},
      {'title': 'Goat Breeding Best Practices', 'category': 'Breeding', 'date': '08 Jan 2025', 'readTime': '7 min'},
    ];

    return _DetailScaffold(
      title: 'Saved Articles',
      subtitle: '14 bookmarked posts',
      icon: Icons.star_rounded,
      color: const Color(0xFFFFA000),
      children: articles.map((a) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              a['title'] as String,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
                height: 1.3
              )
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA000).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text(
                    a['category'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFA000)
                    )
                  ),
                ),
                const Spacer(),
                Text(
                  '${a['readTime']} read',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant
                  )
                ),
                const SizedBox(width: 12),
                Text(
                  a['date'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant
                  )
                ),
              ],
            ),
          ],
        ),
      )).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CHAT HISTORY SCREEN
// ═══════════════════════════════════════════════════════════════
class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final chats = [
      {'title': 'FMD symptoms in my cattle', 'date': '18 Jan 2025', 'preview': 'Based on the symptoms you described...'},
      {'title': 'Poultry feed formulation help', 'date': '15 Jan 2025', 'preview': 'For 100 layers, you need approximately...'},
      {'title': 'Goat vaccination schedule', 'date': '12 Jan 2025', 'preview': 'Here is the recommended vaccination...'},
      {'title': 'Mastitis treatment options', 'date': '05 Jan 2025', 'preview': 'For mild mastitis, I recommend...'},
    ];

    return _DetailScaffold(
      title: 'Chat History',
      subtitle: '23 AI conversations',
      icon: Icons.chat_rounded,
      color: const Color(0xFF8E24AA),
      children: chats.map((c) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: scheme.outlineVariant)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8E24AA).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF8E24AA),
                    size: 16
                  )
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    c['title'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface
                    )
                  )
                ),
                Text(
                  c['date'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurfaceVariant
                  )
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              c['preview'] as String,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onSurfaceVariant
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      )).toList(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  NOTIFICATIONS SCREEN
// ═══════════════════════════════════════════════════════════════
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _notifToggle(context, 'Disease Alerts', 'Get notified about disease outbreaks in your area', true),
        _notifToggle(context, 'Health Reminders', 'Vaccination and deworming reminders', true),
        _notifToggle(context, 'Report Updates', 'Status updates on your submitted reports', true),
        _notifToggle(context, 'AI Chat Replies', 'Responses from AI diagnosis assistant', false),
        _notifToggle(context, 'Marketplace', 'Price alerts and new product listings', false),
        _notifToggle(context, 'Community Updates', 'New posts and discussions', true),
      ]),
    );
  }

  Widget _notifToggle(BuildContext context, String title, String subtitle, bool initial) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(14), border: Border.all(color: scheme.outlineVariant)),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: scheme.onSurface)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant)),
        ])),
        Switch(value: initial, activeColor: scheme.primary, onChanged: (val) {}),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  HELP & SUPPORT SCREEN
// ═══════════════════════════════════════════════════════════════
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          )
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context)
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: scheme.primary.withValues(alpha: 0.15)
                )
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.headset_mic_rounded,
                    color: scheme.primary,
                    size: 22
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Need help? Contact our support team directly.',
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.primary,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface
              )
            ),
            const SizedBox(height: 12),
            ...['How do I submit a disease report?', 'How does the AI diagnosis work?', 'Can I track multiple farms?', 'How do I contact a vet directly?', 'Is my data secure?'].map((q) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: scheme.outlineVariant)
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      q,
                      style: TextStyle(
                        fontSize: 13,
                        color: scheme.onSurface
                      )
                    )
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: scheme.onSurfaceVariant
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.email_rounded),
                label: const Text('Contact Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: scheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  )
                )
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.phone_rounded, size: 18),
                label: const Text('Call Us'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: scheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  side: BorderSide(color: scheme.primary)
                )
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED DETAIL SCAFFOLD
// ═══════════════════════════════════════════════════════════════
class _DetailScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Widget> children;

  const _DetailScaffold({required this.title, required this.subtitle, required this.icon, required this.color, required this.children});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(elevation: 0,
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onPrimary.withValues(alpha: 0.85))),
        ]),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(16), child: Column(children: children)),
    );
  }
}
