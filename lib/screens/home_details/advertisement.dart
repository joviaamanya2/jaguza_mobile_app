import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateAdvertScreen extends StatefulWidget {
  const CreateAdvertScreen({super.key});

  @override
  State<CreateAdvertScreen> createState() => _CreateAdvertScreenState();
}

class _CreateAdvertScreenState extends State<CreateAdvertScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _urlController = TextEditingController();
  final _remarksController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _contactController = TextEditingController();
  
  // Variables
  String _selectedPlan = 'Basic';
  File? _advertImage;
  File? _advertVideo;
  String _selectedCountry = 'Uganda';
  bool _showNameOnAdvert = true;
  bool _showContactOnAdvert = true;
  String _selectedMediaType = 'image'; // 'image' or 'video'
  
  final ImagePicker _picker = ImagePicker();
  
  final List<String> _plans = ['Basic', 'Standard', 'Premium', 'Enterprise'];
  final List<String> _countries = ['Uganda', 'Kenya', 'Tanzania', 'Rwanda', 'Burundi', 'South Sudan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text(
          'Create Advert',
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
          TextButton(
            onPressed: _submitAdvert,
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF57C00),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Choose Advert Plan
              _buildSectionHeader('Choose Advert Plan'),
              const SizedBox(height: 8),
              _buildPlanSelector(),
              
              const SizedBox(height: 20),
              
              // Advert Details
              _buildSectionHeader('Advert Details'),
              const SizedBox(height: 12),
              
              // Title
              _buildTextField(
                controller: _titleController,
                label: 'Title',
                hint: 'Enter advert title',
                icon: Icons.title_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Description
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Enter advert description',
                icon: Icons.description_rounded,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Media Type Selection
              _buildSectionHeader('Select Media Type'),
              const SizedBox(height: 8),
              _buildMediaTypeSelector(),
              const SizedBox(height: 12),
              
              // Media Uploader based on selection
              if (_selectedMediaType == 'image')
                _buildImageUploader()
              else
                _buildVideoUploader(),
              const SizedBox(height: 12),
              
              // Attach link/URL
              _buildTextField(
                controller: _urlController,
                label: 'Attach link/URL',
                hint: 'https://example.com',
                icon: Icons.link_rounded,
              ),
              const SizedBox(height: 12),
              
              // Additional Remarks
              _buildTextField(
                controller: _remarksController,
                label: 'Additional Remarks',
                hint: 'Any additional information',
                icon: Icons.note_rounded,
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              
              // Personal Details Section
              _buildSectionHeader('Personal Details'),
              const SizedBox(height: 12),
              
              // Country Selector
              _buildCountrySelector(),
              const SizedBox(height: 12),
              
              // Full Name
              _buildTextField(
                controller: _fullNameController,
                label: 'Your FullName',
                hint: 'Enter your full name',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Contact
              _buildTextField(
                controller: _contactController,
                label: 'Your Contact',
                hint: 'Enter phone number or email',
                icon: Icons.phone_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Advert Settings
              _buildSectionHeader('Advert Settings'),
              const SizedBox(height: 12),
              
              // Show Name on Advert
              _buildToggleTile(
                title: 'Show Name on advert',
                value: _showNameOnAdvert,
                onChanged: (value) {
                  setState(() {
                    _showNameOnAdvert = value;
                  });
                },
              ),
              
              // Show Contact on Advert
              _buildToggleTile(
                title: 'Show Contact on advert',
                value: _showContactOnAdvert,
                onChanged: (value) {
                  setState(() {
                    _showContactOnAdvert = value;
                  });
                },
              ),
              
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitAdvert,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF57C00),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'SUBMIT ADVERT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  SECTION HEADER
  // ═══════════════════════════════════════
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1F36),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  PLAN SELECTOR
  // ═══════════════════════════════════════
  Widget _buildPlanSelector() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _plans.map((plan) {
          final isSelected = _selectedPlan == plan;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPlan = plan;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                ),
              ),
              child: Text(
                plan,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  MEDIA TYPE SELECTOR
  // ═══════════════════════════════════════
  Widget _buildMediaTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          _buildMediaOption(
            icon: Icons.image_rounded,
            label: 'Image',
            value: 'image',
            isSelected: _selectedMediaType == 'image',
          ),
          const SizedBox(width: 4),
          _buildMediaOption(
            icon: Icons.videocam_rounded,
            label: 'Video',
            value: 'video',
            isSelected: _selectedMediaType == 'video',
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required String label,
    required String value,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMediaType = value;
            // Clear the other media file
            if (value == 'image') {
              _advertVideo = null;
            } else {
              _advertImage = null;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TEXT FIELD
  // ═══════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1F36),
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: const Color(0xFF2E7D32),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  IMAGE UPLOADER
  // ═══════════════════════════════════════
  Widget _buildImageUploader() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(
                Icons.image_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Advert Image (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const Spacer(),
              Text(
                'Optional',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8E8E8), style: BorderStyle.solid),
              ),
              child: _advertImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _advertImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to upload image',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          'PNG, JPG, JPEG up to 5MB',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_advertImage != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _advertImage!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _advertImage = null;
                    });
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  VIDEO UPLOADER
  // ═══════════════════════════════════════
  Widget _buildVideoUploader() {
    return Container(
      padding: const EdgeInsets.all(12),
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
              const Icon(
                Icons.videocam_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Advert Video (Optional)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const Spacer(),
              Text(
                'Optional',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickVideo,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE8E8E8), style: BorderStyle.solid),
              ),
              child: _advertVideo != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 48,
                            color: const Color(0xFF2E7D32),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _advertVideo!.path.split('/').last,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to upload video',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                        Text(
                          'MP4, MOV up to 50MB',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (_advertVideo != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _advertVideo!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _advertVideo = null;
                    });
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  COUNTRY SELECTOR
  // ═══════════════════════════════════════
  Widget _buildCountrySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountry,
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1F36),
          ),
          icon: Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.grey[600],
          ),
          items: _countries.map((country) {
            return DropdownMenuItem(
              value: country,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 16,
                    color: const Color(0xFF2E7D32),
                  ),
                  const SizedBox(width: 8),
                  Text(country),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCountry = value;
              });
            }
          },
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TOGGLE TILE
  // ═══════════════════════════════════════
  Widget _buildToggleTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Icon(
            value ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            size: 20,
            color: value ? const Color(0xFFF57C00) : Colors.grey[400],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1F36),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFF57C00),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  IMAGE PICKER
  // ═══════════════════════════════════════
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      
      if (image != null) {
        setState(() {
          _advertImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  // ═══════════════════════════════════════
  //  VIDEO PICKER
  // ═══════════════════════════════════════
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5),
      );
      
      if (video != null) {
        setState(() {
          _advertVideo = File(video.path);
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  // ═══════════════════════════════════════
  //  SUBMIT
  // ═══════════════════════════════════════
  void _submitAdvert() {
    if (_formKey.currentState!.validate()) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF57C00).withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Success!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your advert has been submitted successfully!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1F36),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Plan', _selectedPlan),
                    _buildSummaryRow('Title', _titleController.text),
                    _buildSummaryRow('Country', _selectedCountry),
                    _buildSummaryRow('Media Type', _selectedMediaType == 'image' ? 'Image' : 'Video'),
                    _buildSummaryRow('Name on Advert', _showNameOnAdvert ? 'Yes' : 'No'),
                    _buildSummaryRow('Contact on Advert', _showContactOnAdvert ? 'Yes' : 'No'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to previous screen
              },
              child: Text(
                'Done',
                style: TextStyle(
                  color: const Color(0xFFF57C00),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1F36),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _remarksController.dispose();
    _fullNameController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}