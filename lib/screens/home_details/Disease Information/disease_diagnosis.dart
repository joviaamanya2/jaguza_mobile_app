import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jaguza_app/services/api_service.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final TextEditingController _customSymptomsController = TextEditingController();
  
  String _selectedAnimalType = 'Cattle';
  String _selectedPrimarySymptom = 'Fever';
  bool _isAnalyzing = false;
  bool _showResults = false;
  
  Map<String, dynamic>? _diagnosisResults;

  final List<String> _animalTypes = [
    'Cattle', 'Goat', 'Sheep', 'Pig', 'Poultry', 'Rabbit', 'Fish', 'Other'
  ];

  final List<String> _primarySymptoms = [
    'Fever', 'Loss of Appetite', 'Diarrhea', 'Coughing', 'Lethargy',
    'Weight Loss', 'Skin Lesions', 'Difficulty Breathing', 'Swelling',
    'Discharge', 'Vomiting', 'Lameness'
  ];

  final List<Map<String, dynamic>> _possibleDiseases = [
    {
      'name': 'Foot and Mouth Disease',
      'match': 85,
      'severity': 'High',
      'description': 'Viral disease causing fever and blisters on feet and mouth',
      'symptoms': 'Fever, blisters on mouth and feet, excessive salivation, lameness, reduced appetite',
      'prevention': 'Vaccination, strict biosecurity, quarantine new animals, disinfect equipment',
      'treatment': 'Vaccination, supportive care, pain relief, foot baths, veterinary consultation',
      'color': Colors.red,
    },
    {
      'name': 'Mastitis',
      'match': 78,
      'severity': 'High',
      'description': 'Inflammation of the mammary gland causing swelling and pain',
      'symptoms': 'Swollen udder, pain, fever, abnormal milk (clots, discoloration), reduced milk yield',
      'prevention': 'Proper milking hygiene, dry cow therapy, teat dipping, clean bedding',
      'treatment': 'Antibiotics, anti-inflammatory drugs, frequent milking, proper hygiene',
      'color': Colors.orange,
    },
    {
      'name': 'Newcastle Disease',
      'match': 72,
      'severity': 'High',
      'description': 'Viral disease affecting respiratory and nervous systems',
      'symptoms': 'Coughing, twisted neck, drop in feed intake, green diarrhea, respiratory distress',
      'prevention': 'Vaccination, biosecurity, quarantine, proper sanitation',
      'treatment': 'Supportive care, antibiotics for secondary infections, vaccination program',
      'color': Colors.red,
    },
    {
      'name': 'Brucellosis',
      'match': 65,
      'severity': 'High',
      'description': 'Bacterial disease causing reproductive failure',
      'symptoms': 'Abortion, retained placenta, reduced fertility, swollen joints, fever',
      'prevention': 'Vaccination, testing, culling infected animals, biosecurity',
      'treatment': 'Antibiotics (prolonged), supportive care, culling in severe cases',
      'color': Colors.deepPurple,
    },
    {
      'name': 'White Muscle Disease',
      'match': 58,
      'severity': 'Medium',
      'description': 'Nutritional muscular dystrophy from selenium/vitamin E deficiency',
      'symptoms': 'Muscle weakness, stiff gait, difficulty standing, heart problems, sudden death',
      'prevention': 'Selenium and vitamin E supplementation, balanced nutrition',
      'treatment': 'Selenium and vitamin E injections, nutritional support, rest',
      'color': Colors.orange,
    },
    {
      'name': 'Coccidiosis',
      'match': 55,
      'severity': 'Medium',
      'description': 'Parasitic disease causing diarrhea and weight loss',
      'symptoms': 'Diarrhea (sometimes bloody), weight loss, dehydration, rough coat, reduced feed intake',
      'prevention': 'Good sanitation, proper housing, rotational grazing, anticoccidial feed additives',
      'treatment': 'Anticoccidial drugs, fluid therapy, nutritional support, cleanliness',
      'color': Colors.orange,
    },
  ];

  // Disease details for the detail screen
  final Map<String, Map<String, dynamic>> _diseaseDetails = {
    'Foot and Mouth Disease': {
      'description': 'Foot and Mouth Disease (FMD) is a highly contagious viral disease affecting cloven-hoofed animals including cattle, sheep, goats, and pigs. It is characterized by fever and vesicular lesions in the mouth and on the feet.',
      'symptoms': 'Fever (up to 104°F), Blisters in the mouth and on the feet, Excessive salivation, Lameness, Reduced appetite, Weight loss, Decreased milk production',
      'prevention': 'Regular vaccination of all susceptible animals, Strict quarantine of new animals, Biosecurity measures, Disinfection of equipment and premises, Limit animal movement',
      'treatment': 'Rest and supportive care, Soft food to ease mouth pain, Anti-inflammatory drugs for fever, Secondary infection prevention, Veterinary consultation, Culling in severe cases',
    },
    'Mastitis': {
      'description': 'Mastitis is an inflammation of the mammary gland usually caused by bacterial infection. It is one of the most common diseases in dairy cattle and can significantly impact milk production and animal welfare.',
      'symptoms': 'Swollen, hard, or hot udder, Pain and discomfort, Fever, Milk abnormalities (clots, watery, discolored), Reduced milk yield, Systemic signs of infection',
      'prevention': 'Proper milking hygiene and techniques, Regular teat dipping, Dry cow therapy, Clean and dry bedding, Good nutrition, Vaccination against common pathogens',
      'treatment': 'Antibiotics (intramammary or systemic), Anti-inflammatory drugs, Frequent milking to remove infected milk, Proper hydration, Isolation and monitoring, Veterinary consultation',
    },
    'Newcastle Disease': {
      'description': 'Newcastle Disease is a highly contagious viral disease affecting poultry and other birds. It can cause significant mortality and economic losses in affected flocks.',
      'symptoms': 'Respiratory distress (coughing, sneezing), Twisted neck (torticollis), Greenish diarrhea, Drop in feed intake, Egg production decline, Nervous signs, Sudden death',
      'prevention': 'Vaccination program (live or inactivated vaccines), Strict biosecurity measures, Quarantine of new birds, Proper sanitation, Wild bird control, Farm visitor protocols',
      'treatment': 'No specific treatment, Supportive care for affected birds, Antibiotics for secondary infections, Proper nutrition and hydration, Isolation of affected birds, Culling in severe outbreaks',
    },
    'Brucellosis': {
      'description': 'Brucellosis is a bacterial disease that causes reproductive problems in livestock and can also infect humans. It is caused by bacteria of the genus Brucella and can lead to significant economic losses.',
      'symptoms': 'Abortions (usually in late pregnancy), Retained placenta, Reduced fertility in males, Swollen joints (arthritis), Fever, Weight loss, Decreased milk production',
      'prevention': 'Vaccination of young animals, Regular testing and surveillance, Culling of infected animals, Quarantine of affected herds, Strict biosecurity, Proper hygiene',
      'treatment': 'Antibiotic therapy (prolonged), Supportive care, Isolation of infected animals, Culling in chronic cases, Veterinary consultation, Public health reporting',
    },
    'White Muscle Disease': {
      'description': 'White Muscle Disease is a nutritional disorder caused by selenium and vitamin E deficiency in young animals. It affects the skeletal and cardiac muscles, leading to weakness and potentially death.',
      'symptoms': 'Sudden weakness or inability to stand, Muscle stiffness, Difficulty in movement, Breathing difficulties (heart involvement), Swallowing problems, Sudden death in severe cases',
      'prevention': 'Proper nutrition during pregnancy, Selenium supplementation, Vitamin E-rich feeds, Soil selenium testing, Balanced feed rations, Veterinary consultation',
      'treatment': 'Selenium and vitamin E injections, Nutritional support, Rest and confinement, Supportive care, Fluid therapy in severe cases, Monitoring of muscle function',
    },
    'Coccidiosis': {
      'description': 'Coccidiosis is a parasitic disease caused by protozoan parasites of the genus Eimeria. It primarily affects young animals and can cause severe diarrhea, dehydration, and weight loss.',
      'symptoms': 'Diarrhea (often with blood or mucus), Weight loss, Dehydration, Loss of appetite, Rough and dull coat, Lethargy, Reduced growth rates',
      'prevention': 'Good sanitation and hygiene, Proper housing and ventilation, Rotational grazing, Use of anticoccidial feed additives, Reducing stocking density, Regular cleaning of waterers and feeders',
      'treatment': 'Anticoccidial drugs (e.g., amprolium, sulfadimethoxine), Fluid and electrolyte therapy, Nutritional support, Supportive care, Isolation of affected animals, Enhanced sanitation',
    },
  };

  @override
  void dispose() {
    _customSymptomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Disease Diagnosis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              _buildSectionHeader('Animal Details'),
              const SizedBox(height: 12),
              
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
              
              const SizedBox(height: 20),
              
              _buildSectionHeader('Symptoms'),
              const SizedBox(height: 12),
              
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
              
              _buildCustomSymptomsField(),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnalyzing ? null : _analyzeSymptoms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: scheme.surfaceContainerHighest,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isAnalyzing) ...[
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Icon(
                        _isAnalyzing ? Icons.hourglass_top_rounded : Icons.auto_awesome_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isAnalyzing ? 'Analyzing Symptoms...' : 'Analyze Symptoms',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              if (_showResults && _diagnosisResults != null) ...[
                const SizedBox(height: 24),
                _buildDiagnosisResults(),
              ],
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 3,
          height: 18,
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    IconData? icon,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        ),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(icon, size: 20, color: scheme.onSurfaceVariant)
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
            borderSide: BorderSide(color: scheme.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: scheme.error, width: 1.5),
          ),
          filled: true,
          fillColor: scheme.surface,
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
              style: TextStyle(
                color: scheme.onSurface,
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
        isExpanded: true,
        icon: Icon(Icons.arrow_drop_down_rounded, color: scheme.onSurfaceVariant),
        dropdownColor: scheme.surface,
        style: TextStyle(color: scheme.onSurface, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSymptomsField() {
    final scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: _customSymptomsController,
      minLines: 2,
      maxLines: 4,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Describe other symptoms (optional)',
        hintText: 'For example: nasal discharge, weakness, or unusual behavior',
        hintStyle: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
        prefixIcon: Icon(Icons.edit_note_rounded, color: scheme.onSurfaceVariant),
        filled: true,
        fillColor: scheme.surface,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDiagnosisResults() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: scheme.onPrimary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Diagnosis Results',
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: scheme.onPrimary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_diagnosisResults!['matches'] ?? 0} matches',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFE082)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_rounded, color: Colors.orange[700], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Consult a veterinarian for final confirmation.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: _diagnosisResults!['diseases']?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final disease = _diagnosisResults!['diseases'][index];
              return GestureDetector(
                onTap: () => _navigateToDiseaseDetail(disease),
                child: _buildDiseaseCard(disease),
              );
            },
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease) {
    final scheme = Theme.of(context).colorScheme;
    final match = (disease['match'] as num?)?.round() ?? 0;
    final diseaseColor = disease['color'] is Color
        ? disease['color'] as Color
        : _colorForSeverity(disease['severity']?.toString());
    Color matchColor;
    if (match >= 75) {
      matchColor = Colors.red;
    } else if (match >= 60) {
      matchColor = Colors.orange;
    } else {
      matchColor = Colors.grey;
    }

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: scheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 3,
                height: 30,
                decoration: BoxDecoration(
                  color: diseaseColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            disease['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      disease['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: matchColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: matchColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  '$match%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: matchColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services_rounded, size: 14, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      'Treatment: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        disease['treatment'],
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.warning_rounded, size: 14, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      'Severity: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: diseaseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        disease['severity'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        color: diseaseColor,
                        ),
                      ),
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

  Color _colorForSeverity(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'critical':
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  void _navigateToDiseaseDetail(Map<String, dynamic> disease) {
    final diseaseName = disease['name']?.toString() ?? 'Disease';
    final details = <String, dynamic>{
      ...?_diseaseDetails[diseaseName],
      'description': disease['description'] ?? disease['symptoms'] ?? '',
      'symptoms': disease['symptoms'] ?? '',
      'prevention': disease['prevention'] ?? 'Consult a veterinarian.',
      'treatment': disease['treatment'] ?? 'Consult a veterinarian.',
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiseaseDetailScreen(
          diseaseName: diseaseName,
          details: details,
        ),
      ),
    );
  }

  Future<void> _analyzeSymptoms() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isAnalyzing = true;
      _showResults = false;
    });

    final symptoms = <String>[
      _selectedPrimarySymptom,
      if (_customSymptomsController.text.trim().isNotEmpty)
        _customSymptomsController.text.trim(),
    ];

    try {
      final results = await _apiService.diagnoseSymptoms(
        animalType: _selectedAnimalType,
        symptoms: symptoms,
      );
      if (!mounted) return;
      setState(() {
        _isAnalyzing = false;
        _showResults = true;
        _diagnosisResults = results;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isAnalyzing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not analyze symptoms: $error'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────
// DISEASE DETAIL SCREEN
// ─────────────────────────────────────────────────────────────────
class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseName;
  final Map<String, dynamic> details;

  const DiseaseDetailScreen({
    super.key,
    required this.diseaseName,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          diseaseName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  _buildDetailSection(
                    scheme,
                    'Description',
                    details['description'],
                    Icons.description_rounded,
                    scheme.primary,
                  ),

                  const SizedBox(height: 16),

                  // Symptoms
                  _buildDetailSection(
                    scheme,
                    'Symptoms',
                    details['symptoms'],
                    Icons.medical_information_rounded,
                    Colors.red,
                  ),

                  const SizedBox(height: 16),

                  // Prevention
                  _buildDetailSection(
                    scheme,
                    'Prevention',
                    details['prevention'],
                    Icons.shield_rounded,
                    Colors.blue,
                  ),

                  const SizedBox(height: 16),

                  // Treatment
                  _buildDetailSection(
                    scheme,
                    'Treatment',
                    details['treatment'],
                    Icons.medical_services_rounded,
                    scheme.primary,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Contact Banner at bottom
          _buildContactBanner(scheme),
        ],
      ),
    );
  }

  Widget _buildDetailSection(ColorScheme scheme, String title, String content, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: scheme.outlineVariant),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: scheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBanner(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: scheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Need expert advice?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      Text(
                        'Contact a veterinarian directly',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // WhatsApp Button
                GestureDetector(
                  onTap: () => _launchWhatsApp(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF25D366),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.chat_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Call Button
                GestureDetector(
                  onTap: () => _launchPhoneCall(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.call_rounded,
                          color: scheme.onPrimary,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Call',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchWhatsApp() async {
    const phoneNumber = '256700123456';
    const url = 'https://wa.me/$phoneNumber?text=Hello%20Doctor%2C%20I%20need%20assistance%20with%20my%20animal%20health%20issue.';
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      // Show error or fallback
    }
  }

  void _launchPhoneCall() async {
    const phoneNumber = 'tel:+256700123456';
    try {
      await launchUrl(Uri.parse(phoneNumber));
    } catch (e) {
      // Show error or fallback
    }
  }
}
