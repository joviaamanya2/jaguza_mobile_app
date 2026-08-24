import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../../services/api_service.dart';

class ReportSicknessScreen extends StatefulWidget {
  const ReportSicknessScreen({super.key});

  @override
  State<ReportSicknessScreen> createState() => _ReportSicknessScreenState();
}

class _ReportSicknessScreenState extends State<ReportSicknessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otherSymptomsController = TextEditingController();
  final ApiService _apiService = ApiService();

  String? _selectedAnimalType;
  String? _selectedSeverity;
  String? _selectedSymptom;
  
  // Media files
  List<XFile> _images = [];
  List<XFile> _videos = [];
  XFile? _audioFile;
  
  final ImagePicker _picker = ImagePicker();
  
  bool _isSubmitting = false;

  // Maximum limits
  static const int maxImages = 2;
  static const int maxVideos = 1;
  
  final List<String> _animalTypes = [
    'Cattle',
    'Goat',
    'Sheep',
    'Pig',
    'Chicken',
    'Ruminants',
    'Other'
  ];
  
  final List<String> _severityLevels = [
    'Mild',
    'Severe',
  ];
  
  final List<String> _commonSymptoms = [
    'Loss of appetite',
    'Fever',
    'Diarrhea',
    'Coughing',
    'Lethargy',
    'Weight loss',
    'Difficulty breathing',
    'Swelling',
    'Skin lesions',
    'Lameness',
    'Vomiting',
    'Nasal discharge',
    'Eye discharge',
    'Rough coat',
    'Decreased milk production',
  ];

  @override
  void dispose() {
    _otherSymptomsController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    if (_images.length >= maxImages) {
      _showSnackBar('You can only upload up to $maxImages images');
      return;
    }
    
    try {
      final List<XFile> images = await _picker.pickMultiImage(
          limit: maxImages - _images.length,
        );
      if (images.isNotEmpty) {
        setState(() {
          _images.addAll(images);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e');
    }
  }

  Future<void> _pickVideo() async {
    if (_videos.length >= maxVideos) {
      _showSnackBar('You can only upload up to $maxVideos video');
      return;
    }
    
    try {
      final XFile? video = await _picker.pickVideo(
          source: ImageSource.gallery,
        );
      if (video != null) {
        setState(() {
          _videos.add(video);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking video: $e');
    }
  }

  Future<void> _pickAudio() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.audio,
          allowMultiple: false,
        );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _audioFile = XFile(result.files.single.path!);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking audio: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _removeVideo(int index) {
    setState(() {
      _videos.removeAt(index);
    });
  }

  void _removeAudio() {
    setState(() {
      _audioFile = null;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  Future<void> _submitReport() async {
    // Validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Additional validation for severity
    if (_selectedSeverity == null || _selectedSeverity!.isEmpty) {
      _showSnackBar('Please select a severity level');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Prepare the data with proper validation
      final data = {
        'affected_animal_type': _selectedAnimalType,
        'affected_animal_count': 1,
        'symptom_primary': _selectedSymptom,
        'symptom_other': _otherSymptomsController.text.trim().isNotEmpty
            ? _otherSymptomsController.text.trim()
            : null,
        'severity_level': _selectedSeverity,
      };

      await _apiService.createReportWithMedia(
        data,
        images: _images.map<File>((image) => File(image.path)).toList(),
        videos: _videos.map<File>((video) => File(video.path)).toList(),
        audio: _audioFile == null ? null : File(_audioFile!.path),
      );

      // Reset form after successful submission
      setState(() {
        _isSubmitting = false;
        _selectedAnimalType = null;
        _selectedSymptom = null;
        _selectedSeverity = null;
        _otherSymptomsController.clear();
        _images.clear();
        _videos.clear();
        _audioFile = null;
      });

      // Show success popup
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        _showSnackBar('Failed to submit report: ${e.toString().replaceAll('Exception: ', '')}');
      }
    }
  }

  void _showSuccessDialog() {
    final scheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: scheme.primary, size: 32),
            const SizedBox(width: 12),
            Text(
              'Report Submitted',
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Your sickness report has been submitted successfully. A veterinary expert will review it and get back to you shortly.',
          style: TextStyle(color: scheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to previous screen
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: scheme.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Report Sickness',
          style: TextStyle(
            color: scheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: scheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildFormTab(),
    );
  }

  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal Type Dropdown
            _buildDropdownField(
              label: 'Animal Type *',
              value: _selectedAnimalType,
              items: _animalTypes,
              hint: 'Select animal type',
              onChanged: (value) {
                setState(() {
                  _selectedAnimalType = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select animal type';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Common Symptoms Dropdown
            _buildDropdownField(
              label: 'Common Symptoms *',
              value: _selectedSymptom,
              items: _commonSymptoms,
              hint: 'Select a symptom',
              onChanged: (value) {
                setState(() {
                  _selectedSymptom = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a symptom';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Other Symptoms Field
            _buildTextField(
              label: 'Other Symptoms / Details',
              hint: 'Describe any additional symptoms or details...',
              controller: _otherSymptomsController,
              maxLines: 4,
            ),
            
            const SizedBox(height: 20),
            
            // Severity Dropdown
            _buildDropdownField(
              label: 'Severity Level *',
              value: _selectedSeverity,
              items: _severityLevels,
              hint: 'Select severity level',
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select severity level';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Media Upload Section
            _buildMediaUploadSection(),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Submit Report',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          hint: Text(
            hint,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    bool isRequired = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: scheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: scheme.onSurfaceVariant),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: scheme.primary),
            ),
          ),
          validator: isRequired ? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          } : null,
        ),
      ],
    );
  }

  Widget _buildMediaUploadSection() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add Media (Optional)',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload images, videos, or audio to help with diagnosis',
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          
          // Images
          _buildImageSection(),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Videos
          _buildVideoSection(),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          // Audio
          _buildAudioSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Images (${_images.length}/$maxImages)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
            if (_images.length < maxImages)
              TextButton.icon(
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate_rounded, size: 18),
                label: const Text('Add Images'),
                style: TextButton.styleFrom(
                  foregroundColor: scheme.primary,
                ),
              ),
          ],
        ),
        if (_images.isNotEmpty)
          const SizedBox(height: 8),
        if (_images.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(_images[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildVideoSection() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Videos (${_videos.length}/$maxVideos)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
            if (_videos.length < maxVideos)
              TextButton.icon(
                onPressed: _pickVideo,
                icon: const Icon(Icons.video_library_rounded, size: 18),
                label: const Text('Add Video'),
                style: TextButton.styleFrom(
                  foregroundColor: scheme.primary,
                ),
              ),
          ],
        ),
        if (_videos.isNotEmpty)
          const SizedBox(height: 8),
        if (_videos.isNotEmpty)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 32,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _videos[index].path.split('/').last,
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 8,
                      child: GestureDetector(
                        onTap: () => _removeVideo(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildAudioSection() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Audio Recording',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            ),
            if (_audioFile == null)
              TextButton.icon(
                onPressed: _pickAudio,
                icon: const Icon(Icons.audio_file_rounded, size: 18),
                label: const Text('Add Audio'),
                style: TextButton.styleFrom(
                  foregroundColor: scheme.primary,
                ),
              ),
          ],
        ),
        if (_audioFile != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.audio_file_rounded,
                  color: scheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _audioFile!.path.split('/').last,
                    style: TextStyle(
                      fontSize: 13,
                      color: scheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _removeAudio,
                  icon: Icon(
                    Icons.close_rounded,
                    color: scheme.error,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}