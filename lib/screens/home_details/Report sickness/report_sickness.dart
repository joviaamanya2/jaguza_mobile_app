import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ReportSicknessScreen extends StatefulWidget {
  const ReportSicknessScreen({super.key});

  @override
  State<ReportSicknessScreen> createState() => _ReportSicknessScreenState();
}

class _ReportSicknessScreenState extends State<ReportSicknessScreen> {
  final _formKey = GlobalKey<FormState>();
  final _farmerNameController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _locationController = TextEditingController();
  final _animalCountController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  String _selectedAnimalType = 'Cattle';
  String _selectedSeverity = 'Medium';
  String _selectedLocation = 'Kampala';
  String _selectedDuration = 'Less than 24 hours';
  String _selectedSymptoms = 'Select symptoms';
  String _selectedPrimarySymptom = 'Fever';
  bool _isEmergency = false;
  bool _isSubmitting = false;

  // Map location state - using simple coordinates
  double? _selectedLatitude;
  double? _selectedLongitude;
  String _mapLocationAddress = '';
  bool _isGettingLocation = false;

  // Media files
  final List<File> _selectedImages = [];
  final List<File> _selectedVideos = [];

  final List<String> _severityLevels = ['Mild', 'Medium', 'Severe', 'Critical'];
  final List<String> _animalTypes = [
    'Cattle', 'Goat', 'Sheep', 'Pig', 'Poultry', 'Rabbit', 'Fish', 'Other'
  ];

  final List<String> _locations = [
    'Kampala', 'Wakiso', 'Mukono', 'Jinja', 'Mbarara', 'Gulu', 'Lira',
    'Mbale', 'Masaka', 'Entebbe', 'Fort Portal', 'Kabale', 'Other'
  ];

  final List<String> _durations = [
    'Less than 24 hours', '1-2 days', '3-5 days', '1 week', '2 weeks', 'More than 2 weeks'
  ];

  final List<String> _symptomOptions = [
    'Fever',
    'Loss of Appetite',
    'Diarrhea',
    'Coughing',
    'Lethargy',
    'Weight Loss',
    'Skin Lesions',
    'Difficulty Breathing',
    'Swelling',
    'Discharge',
    'Vomiting',
    'Lameness',
    'Abortion',
    'Sudden Death'
  ];

  final List<String> _primarySymptoms = [
    'Fever', 'Loss of Appetite', 'Diarrhea', 'Coughing', 'Lethargy',
    'Weight Loss', 'Skin Lesions', 'Difficulty Breathing', 'Swelling'
  ];

  final ImagePicker _imagePicker = ImagePicker();

  // Default center (Kampala, Uganda)
  static const double _defaultLatitude = 0.3476;
  static const double _defaultLongitude = 32.5825;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _farmerNameController.dispose();
    _farmNameController.dispose();
    _contactNumberController.dispose();
    _locationController.dispose();
    _animalCountController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  // ── Helper: Create Default Position ───────────────────────────
  Position _createDefaultPosition() {
    return Position(
      latitude: _defaultLatitude,
      longitude: _defaultLongitude,
      timestamp: DateTime.now(),
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
    );
  }

  // ── Get Current Location ─────────────────────────────────────
  Future<Position> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return _createDefaultPosition();
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return _createDefaultPosition();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return _createDefaultPosition();
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      debugPrint('Error getting location: $e');
      return _createDefaultPosition();
    }
  }

  // ── Reverse Geocode to Get Address ──────────────────────────
  Future<String> _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final List<String> addressParts = [
          place.subLocality ?? '',
          place.locality ?? '',
          place.subAdministrativeArea ?? '',
          place.administrativeArea ?? '',
        ].where((part) => part.isNotEmpty).toList();

        return addressParts.isNotEmpty 
            ? addressParts.join(', ') 
            : '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
      }
      return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
    }
  }

  // ── Open Google Maps ─────────────────────────────────────────
  Future<void> _openGoogleMaps() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      // Get current location first
      final Position currentLocation = await _getCurrentLocation();
      
      // Create Google Maps URL
      final String googleMapsUrl = 
          'https://www.google.com/maps/search/?api=1&query=${currentLocation.latitude},${currentLocation.longitude}';
      
      final Uri url = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        
        // After user returns, show a dialog to confirm location
        _showLocationConfirmationDialog();
      } else {
        // Fallback to Google Maps web if app not installed
        final String fallbackUrl = 
            'https://www.google.com/maps/search/?api=1&query=${currentLocation.latitude},${currentLocation.longitude}';
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.inAppWebView);
          _showLocationConfirmationDialog();
        } else {
          _showErrorSnackBar('Could not open Google Maps');
        }
      }
    } catch (e) {
      debugPrint('Error opening Google Maps: $e');
      _showErrorSnackBar('Could not open Google Maps: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  // ── Open Google Maps with Specific Location ─────────────────
  Future<void> _openGoogleMapsWithLocation(double latitude, double longitude) async {
    try {
      final String googleMapsUrl = 
          'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      
      final Uri url = Uri.parse(googleMapsUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        final String fallbackUrl = 
            'https://www.google.com/maps/@$latitude,$longitude,15z';
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        
        if (await canLaunchUrl(fallbackUri)) {
          await launchUrl(fallbackUri, mode: LaunchMode.inAppWebView);
        }
      }
    } catch (e) {
      debugPrint('Error opening Google Maps: $e');
      _showErrorSnackBar('Could not open Google Maps');
    }
  }

  // ── Show Location Confirmation Dialog ────────────────────────
  void _showLocationConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Confirm Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF2E7D32),
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'Did you select your location on the map?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1F36),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'After returning from Google Maps, the app will automatically detect your location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Try to get updated location
              _getCurrentLocationAndUpdate();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _getCurrentLocationAndUpdate();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Set Location'),
          ),
        ],
      ),
    );
  }

  // ── Get Current Location and Update ─────────────────────────
  Future<void> _getCurrentLocationAndUpdate() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      final Position position = await _getCurrentLocation();
      final String address = await _getAddressFromCoordinates(
        position.latitude, 
        position.longitude
      );
      
      if (mounted) {
        setState(() {
          _selectedLatitude = position.latitude;
          _selectedLongitude = position.longitude;
          _mapLocationAddress = address;
          _selectedLocation = address.isNotEmpty 
              ? address 
              : 'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
          _locationController.text = _selectedLocation;
        });
        _showSuccessSnackBar('Location set to: $_selectedLocation');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Could not get location: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  // ── Pick Images ───────────────────────────────────────────────
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking images: $e');
    }
  }

  // ── Pick Video ───────────────────────────────────────────────
  Future<void> _pickVideo() async {
    try {
      final XFile? video = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      if (video != null) {
        setState(() {
          _selectedVideos.add(File(video.path));
        });
      }
    } catch (e) {
      _showErrorSnackBar('Error picking video: $e');
    }
  }

  // ── Remove Image ──────────────────────────────────────────────
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // ── Remove Video ──────────────────────────────────────────────
  void _removeVideo(int index) {
    setState(() {
      _selectedVideos.removeAt(index);
    });
  }

  // ── Build Media Upload Section ──────────────────────────────
  Widget _buildMediaUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Media Attachments'),
        const SizedBox(height: 12),

        // Upload buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectedImages.length < 5 ? _pickImages : null,
                icon: const Icon(Icons.image_rounded, size: 20),
                label: Text(
                  _selectedImages.isEmpty
                      ? 'Add Images'
                      : '${_selectedImages.length} Images',
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _selectedVideos.length < 2 ? _pickVideo : null,
                icon: const Icon(Icons.videocam_rounded, size: 20),
                label: Text(
                  _selectedVideos.isEmpty
                      ? 'Add Video'
                      : '${_selectedVideos.length} Video',
                  style: const TextStyle(fontSize: 13),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Image previews
        if (_selectedImages.isNotEmpty) ...[
          Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                        image: DecorationImage(
                          image: FileImage(_selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
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

        // Video previews
        if (_selectedVideos.isNotEmpty) ...[
          Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedVideos.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                        color: Colors.black,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.play_circle_filled_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                          Positioned(
                            bottom: 4,
                            left: 8,
                            child: Text(
                              'Video ${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 12,
                      child: GestureDetector(
                        onTap: () => _removeVideo(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            color: Colors.white,
                            size: 14,
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

        // Helper text
        if (_selectedImages.isEmpty && _selectedVideos.isEmpty) ...[
          Text(
            'Upload photos or videos of the affected animals (Max 5 images, 2 videos)',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ] else ...[
          Text(
            '${_selectedImages.length} image(s), ${_selectedVideos.length} video(s) attached',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ],
    );
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
          'Report Sickness',
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
          TextButton.icon(
            onPressed: _isSubmitting ? null : _submitReport,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_isSubmitting ? 'Sending...' : 'Submit'),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency Banner
              _buildEmergencyBanner(),

              const SizedBox(height: 20),

              // Farmer Information Section
              _buildSectionHeader('Farmer Details'),
              const SizedBox(height: 12),

              // Farmer Name
              _buildTextField(
                controller: _farmerNameController,
                label: 'Farmer Name',
                hint: 'Enter your full name',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farmer name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Farm Name
              _buildTextField(
                controller: _farmNameController,
                label: 'Farm Name',
                hint: 'Enter your farm name',
                icon: Icons.storefront_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Contact Number
              _buildTextField(
                controller: _contactNumberController,
                label: 'Contact Number',
                hint: 'e.g., 0772 123 456',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Location with Map Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildDropdownField(
                          label: 'Location',
                          hint: 'Select your district',
                          value: _selectedLocation,
                          items: _locations,
                          icon: Icons.location_on_rounded,
                          onChanged: (value) {
                            setState(() {
                              _selectedLocation = value ?? 'Kampala';
                              _selectedLatitude = null;
                              _selectedLongitude = null;
                              _mapLocationAddress = '';
                              _locationController.clear();
                              if (_selectedLocation == 'Other') {
                                _showCustomLocationDialog();
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your location';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Map Button - Opens Google Maps
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isGettingLocation ? null : _openGoogleMaps,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedLatitude != null
                                  ? const Color(0xFF1B5E20)
                                  : const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: _isGettingLocation
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _selectedLatitude != null
                                            ? Icons.check_circle_rounded
                                            : Icons.map_rounded,
                                        size: 18,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _selectedLatitude != null ? 'Set' : 'Map',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Show map-selected location info
                  if (_selectedLatitude != null && _selectedLongitude != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withOpacity(0.06),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF2E7D32).withOpacity(0.15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.my_location_rounded,
                            color: Color(0xFF2E7D32),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocation,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF2E7D32),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLatitude = null;
                                _selectedLongitude = null;
                                _mapLocationAddress = '';
                                _selectedLocation = 'Kampala';
                                _locationController.clear();
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: const Color(0xFF2E7D32).withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),

              // Animal Information Section
              _buildSectionHeader('Animal Details'),
              const SizedBox(height: 12),

              // Animal Type
              _buildDropdownField(
                label: 'Animal Type',
                hint: 'Select the type of animal',
                value: _selectedAnimalType,
                items: _animalTypes,
                icon: Icons.pets_rounded,
                onChanged: (value) {
                  setState(() {
                    _selectedAnimalType = value ?? 'Cattle';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select animal type';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Number of Animals
              _buildTextField(
                controller: _animalCountController,
                label: 'Number of Animals Affected',
                hint: 'Enter the number of sick animals',
                icon: Icons.numbers_rounded,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of animals';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Symptoms Section
              _buildSectionHeader('Symptoms'),
              const SizedBox(height: 12),

              // Primary Symptom
              _buildDropdownField(
                label: 'Primary Symptom',
                hint: 'Select the main symptom observed',
                value: _selectedPrimarySymptom,
                items: _primarySymptoms,
                icon: Icons.medical_information_rounded,
                onChanged: (value) {
                  setState(() {
                    _selectedPrimarySymptom = value ?? 'Fever';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a primary symptom';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // Other Symptoms
              _buildDropdownField(
                label: 'Other Symptoms (Optional)',
                hint: 'Select additional symptoms',
                value: _selectedSymptoms == 'Select symptoms'
                    ? null
                    : _selectedSymptoms,
                items: _symptomOptions,
                icon: Icons.list_alt_rounded,
                onChanged: (value) {
                  setState(() {
                    _selectedSymptoms = value ?? 'Select symptoms';
                  });
                },
              ),

              const SizedBox(height: 14),

              // Duration
              _buildDropdownField(
                label: 'Duration of Symptoms',
                hint: 'How long have symptoms been present?',
                value: _selectedDuration,
                items: _durations,
                icon: Icons.timer_rounded,
                onChanged: (value) {
                  setState(() {
                    _selectedDuration = value ?? 'Less than 24 hours';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select duration';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Severity Section
              _buildSectionHeader('Severity Level'),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSeverity,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down_rounded,
                        color: Colors.grey[500]),
                    style: const TextStyle(
                      color: Color(0xFF1A1F36),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: _severityLevels.map((level) {
                      Color color;
                      switch (level) {
                        case 'Mild':
                          color = Colors.green;
                          break;
                        case 'Medium':
                          color = Colors.orange;
                          break;
                        case 'Severe':
                          color = Colors.red;
                          break;
                        case 'Critical':
                          color = Colors.deepPurple;
                          break;
                        default:
                          color = Colors.grey;
                      }
                      return DropdownMenuItem<String>(
                        value: level,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              level,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSeverity = value ?? 'Medium';
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Select the severity level based on the animal\'s condition',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 20),

              // Additional Information Section
              _buildSectionHeader('Additional Information'),
              const SizedBox(height: 12),

              // Additional Notes
              _buildTextField(
                controller: _additionalNotesController,
                label: 'Additional Notes',
                hint: 'Any other relevant information',
                maxLines: 3,
                icon: Icons.edit_note_rounded,
              ),

              const SizedBox(height: 14),

              // Media Upload Section
              _buildMediaUploadSection(),

              const SizedBox(height: 14),

              // Emergency Checkbox
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isEmergency,
                      onChanged: (value) {
                        setState(() {
                          _isEmergency = value ?? false;
                        });
                      },
                      activeColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Emergency Case',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Check this if immediate veterinary attention is required',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isEmergency ? Colors.red : const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isSubmitting) ...[
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(
                        _isEmergency
                            ? Icons.warning_rounded
                            : Icons.send_rounded,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSubmitting
                            ? 'Submitting Report...'
                            : _isEmergency
                                ? 'Submit Emergency Report'
                                : 'Submit Report',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Info Banner
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
                    Expanded(
                      child: Text(
                        'A veterinary professional will review your report and contact you shortly.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[800],
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

  // ── Submit Report ─────────────────────────────────────────────
  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Build the report data including map coordinates if available
      final Map<String, dynamic> reportData = {
        'farmerName': _farmerNameController.text.trim(),
        'farmName': _farmNameController.text.trim(),
        'contactNumber': _contactNumberController.text.trim(),
        'location': _selectedLocation,
        'animalType': _selectedAnimalType,
        'animalCount': int.tryParse(_animalCountController.text.trim()) ?? 0,
        'primarySymptom': _selectedPrimarySymptom,
        'otherSymptoms': _selectedSymptoms != 'Select symptoms'
            ? _selectedSymptoms
            : null,
        'duration': _selectedDuration,
        'severity': _selectedSeverity,
        'additionalNotes': _additionalNotesController.text.trim(),
        'isEmergency': _isEmergency,
        // Include map coordinates if set
        if (_selectedLatitude != null && _selectedLongitude != null) ...{
          'latitude': _selectedLatitude,
          'longitude': _selectedLongitude,
          'mapAddress': _mapLocationAddress,
        },
      };

      // TODO: Replace with your actual API call
      // final response = await ApiService.submitSicknessReport(
      //   reportData: reportData,
      //   images: _selectedImages,
      //   videos: _selectedVideos,
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to submit report: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ── Emergency Banner ──────────────────────────────────────────
  Widget _buildEmergencyBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.phone_rounded,
              color: Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Veterinary Hotline',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Call 0800-123-456 for immediate assistance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '24/7',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1F36),
          ),
        ),
      ],
    );
  }

  // ── Text Field ────────────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
          prefixIcon: icon != null
              ? Icon(icon, size: 20, color: Colors.grey[500])
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ── Dropdown Field ────────────────────────────────────────────
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    IconData? icon,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null
              ? Icon(icon, size: 20, color: Colors.grey[500])
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Color(0xFF1A1F36),
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        isExpanded: true,
        icon:
            Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[500]),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Color(0xFF1A1F36), fontSize: 14),
      ),
    );
  }

  // ── Custom Location Dialog ────────────────────────────────────
  void _showCustomLocationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController customLocationController =
            TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Enter Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36),
            ),
          ),
          content: TextField(
            controller: customLocationController,
            decoration: InputDecoration(
              hintText: 'Enter your district or village',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (customLocationController.text.trim().isNotEmpty) {
                  setState(() {
                    _selectedLocation =
                        customLocationController.text.trim();
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ── Show Success Dialog ──────────────────────────────────────
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E7D32),
                size: 48,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Report Submitted Successfully!',
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
          children: [
            Text(
              'Your sickness report has been sent to our veterinary team.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSuccessRow('Farmer', _farmerNameController.text),
                  _buildSuccessRow('Farm', _farmNameController.text),
                  _buildSuccessRow('Animal', _selectedAnimalType),
                  _buildSuccessRow('Symptom', _selectedPrimarySymptom),
                  _buildSuccessRow('Severity', _selectedSeverity),
                  if (_selectedLatitude != null && _selectedLongitude != null) ...[
                    _buildSuccessRow(
                      'GPS',
                      '${_selectedLatitude!.toStringAsFixed(4)}, ${_selectedLongitude!.toStringAsFixed(4)}',
                    ),
                  ],
                  if (_selectedImages.isNotEmpty) ...[
                    _buildSuccessRow(
                        'Images', '${_selectedImages.length} attached'),
                  ],
                  if (_selectedVideos.isNotEmpty) ...[
                    _buildSuccessRow(
                        'Videos', '${_selectedVideos.length} attached'),
                  ],
                  if (_isEmergency) ...[
                    const Divider(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.warning_rounded,
                            color: Colors.red, size: 14),
                        const SizedBox(width: 6),
                        const Text(
                          'Emergency Case',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                  child: const Text('Go Back'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Reset form
                    _formKey.currentState?.reset();
                    setState(() {
                      _farmerNameController.clear();
                      _farmNameController.clear();
                      _contactNumberController.clear();
                      _locationController.clear();
                      _animalCountController.clear();
                      _additionalNotesController.clear();
                      _selectedAnimalType = 'Cattle';
                      _selectedSeverity = 'Medium';
                      _selectedLocation = 'Kampala';
                      _selectedDuration = 'Less than 24 hours';
                      _selectedSymptoms = 'Select symptoms';
                      _selectedPrimarySymptom = 'Fever';
                      _isEmergency = false;
                      _selectedImages.clear();
                      _selectedVideos.clear();
                      _selectedLatitude = null;
                      _selectedLongitude = null;
                      _mapLocationAddress = '';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('New Report'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Success Row ───────────────────────────────────────────────
  Widget _buildSuccessRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1F36),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── SnackBars ─────────────────────────────────────────────────
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}