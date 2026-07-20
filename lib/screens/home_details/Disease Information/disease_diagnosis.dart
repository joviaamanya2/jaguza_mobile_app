import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final _formKey = GlobalKey<FormState>();
  final _animalCountController = TextEditingController();
  final _additionalNotesController = TextEditingController();
  
  String _selectedAnimalType = 'Cattle';
  String _selectedSeverity = 'Medium';
  String _selectedDuration = 'Less than 24 hours';
  String _selectedPrimarySymptom = 'Fever';
  String _selectedOtherSymptoms = 'Select additional symptoms';
  bool _isAnalyzing = false;
  bool _showResults = false;
  
  Map<String, dynamic>? _diagnosisResults;

  final List<String> _animalTypes = [
    'Cattle', 'Goat', 'Sheep', 'Pig', 'Poultry', 'Rabbit', 'Fish', 'Other'
  ];
  
  final List<String> _severityLevels = ['Mild', 'Medium', 'Severe', 'Critical'];

  final List<String> _durations = [
    'Less than 24 hours', '1-2 days', '3-5 days', '1 week', '2 weeks', 'More than 2 weeks'
  ];

  final List<String> _primarySymptoms = [
    'Fever', 'Loss of Appetite', 'Diarrhea', 'Coughing', 'Lethargy',
    'Weight Loss', 'Skin Lesions', 'Difficulty Breathing', 'Swelling',
    'Discharge', 'Vomiting', 'Lameness'
  ];

  final List<String> _otherSymptoms = [
    'Fever', 'Loss of Appetite', 'Diarrhea', 'Coughing', 'Lethargy',
    'Weight Loss', 'Skin Lesions', 'Difficulty Breathing', 'Swelling',
    'Discharge', 'Vomiting', 'Lameness', 'Abortion', 'Sudden Death'
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
    _animalCountController.dispose();
    _additionalNotesController.dispose();
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
          'Disease Diagnosis',
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
          IconButton(
            onPressed: _navigateToAIChart,
            icon: const Icon(
              Icons.analytics_rounded,
              color: Color(0xFF2E7D32),
              size: 24,
            ),
            tooltip: 'View AI Charts',
          ),
          const SizedBox(width: 4),
          TextButton.icon(
            onPressed: _isAnalyzing ? null : _analyzeSymptoms,
            icon: _isAnalyzing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(_isAnalyzing ? 'Diagnosing...' : 'Diagnose'),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(),
              
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
              
              const SizedBox(height: 14),
              
              _buildTextField(
                controller: _animalCountController,
                label: 'Number of Animals Affected',
                hint: 'Enter the number of sick animals',
                icon: Icons.numbers_rounded,
                keyboardType: TextInputType.number,
              ),
              
              const SizedBox(height: 14),
              
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
              
              _buildDropdownField(
                label: 'Other Symptoms',
                hint: 'Select additional symptoms observed',
                value: _selectedOtherSymptoms == 'Select additional symptoms' ? null : _selectedOtherSymptoms,
                items: _otherSymptoms,
                icon: Icons.list_alt_rounded,
                onChanged: (value) {
                  setState(() {
                    _selectedOtherSymptoms = value ?? 'Select additional symptoms';
                  });
                },
              ),
              
              const SizedBox(height: 14),
              
              _buildTextField(
                controller: _additionalNotesController,
                label: 'Additional Details',
                hint: 'Describe any other observations',
                maxLines: 2,
                icon: Icons.note_alt_rounded,
              ),
              
              const SizedBox(height: 20),
              
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
                    icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[500]),
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
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isAnalyzing ? null : _analyzeSymptoms,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
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
                      if (_isAnalyzing) ...[
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

  Widget _buildInfoBanner() {
    return GestureDetector(
      onTap: _navigateToAIChart,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI-Powered Diagnosis',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  Text(
                    'Tap to view AI analytics and charts',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'View analytics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
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
        icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.grey[500]),
        dropdownColor: Colors.white,
        style: const TextStyle(color: Color(0xFF1A1F36), fontSize: 14),
      ),
    );
  }

  Widget _buildDiagnosisResults() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2E7D32),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Text(
                  'Diagnosis Results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_diagnosisResults!['matches'] ?? 0} matches',
                    style: const TextStyle(
                      color: Colors.white,
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
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: _buildAIChartNavigationButton(),
          ),
          
          const SizedBox(height: 8),
          
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            itemCount: _diagnosisResults!['diseases']?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final disease = _diagnosisResults!['diseases'][index];
              return GestureDetector(
                onTap: () => _navigateToDiseaseDetail(disease['name']),
                child: _buildDiseaseCard(disease),
              );
            },
          ),
          
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAIChartNavigationButton() {
    return GestureDetector(
      onTap: _navigateToAIChart,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2E7D32).withOpacity(0.08),
              const Color(0xFF2E7D32).withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF2E7D32).withOpacity(0.15),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'View AI Analytics Dashboard',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36),
                    ),
                  ),
                  Text(
                    'Explore detailed charts and insights',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(Map<String, dynamic> disease) {
    final match = disease['match'] as int;
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
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
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
                  color: disease['color'] as Color,
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1F36),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      disease['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
                  color: matchColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: matchColor.withOpacity(0.3)),
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services_rounded, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Treatment: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        disease['treatment'],
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.warning_rounded, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Text(
                      'Severity: ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: disease['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        disease['severity'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: disease['color'],
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

  void _navigateToDiseaseDetail(String diseaseName) {
    final details = _diseaseDetails[diseaseName];
    if (details != null) {
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
  }

  void _navigateToAIChart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AIChartScreen(),
      ),
    );
  }

  void _analyzeSymptoms() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isAnalyzing = true;
        _showResults = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        final List<Map<String, dynamic>> results = [];
        final primarySymptom = _selectedPrimarySymptom.toLowerCase();
        
        var sortedDiseases = List<Map<String, dynamic>>.from(_possibleDiseases);
        sortedDiseases.sort((a, b) {
          int aMatches = 0;
          int bMatches = 0;
          
          if (a['name'].toLowerCase().contains(primarySymptom) || 
              a['description'].toLowerCase().contains(primarySymptom)) {
            aMatches += 15;
          }
          if (b['name'].toLowerCase().contains(primarySymptom) || 
              b['description'].toLowerCase().contains(primarySymptom)) {
            bMatches += 15;
          }
          
          int aScore = a['match'] + aMatches;
          int bScore = b['match'] + bMatches;
          
          aScore = aScore > 100 ? 100 : aScore;
          bScore = bScore > 100 ? 100 : bScore;
          
          a['match'] = aScore;
          b['match'] = bScore;
          
          return bScore.compareTo(aScore);
        });
        
        results.addAll(sortedDiseases.take(3));
        
        setState(() {
          _isAnalyzing = false;
          _showResults = true;
          _diagnosisResults = {
            'diseases': results,
            'matches': results.length,
          };
        });
        
        // Auto-scroll to results after a short delay
        Future.delayed(const Duration(milliseconds: 300), () {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      });
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1F36),
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
            color: Color(0xFF1A1F36),
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
                    'Description',
                    details['description'],
                    Icons.description_rounded,
                    const Color(0xFF2E7D32),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Symptoms
                  _buildDetailSection(
                    'Symptoms',
                    details['symptoms'],
                    Icons.medical_information_rounded,
                    Colors.red,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Prevention
                  _buildDetailSection(
                    'Prevention',
                    details['prevention'],
                    Icons.shield_rounded,
                    Colors.blue,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Treatment
                  _buildDetailSection(
                    'Treatment',
                    details['treatment'],
                    Icons.medical_services_rounded,
                    const Color(0xFF2E7D32),
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          
          // Contact Banner at bottom
          _buildContactBanner(),
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, String content, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: const Color(0xFFE8E8E8)),
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
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF424242),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Need expert advice?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1F36),
                        ),
                      ),
                      Text(
                        'Contact a veterinarian directly',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
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
                        Text(
                          'Chat',
                          style: const TextStyle(
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
                      color: const Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Call',
                          style: const TextStyle(
                            color: Colors.white,
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
    // Use a default number or get from config
    const phoneNumber = '256700123456'; // Replace with actual number
    const url = 'https://wa.me/$phoneNumber?text=Hello%20Doctor%2C%20I%20need%20assistance%20with%20my%20animal%20health%20issue.';
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      // Show error or fallback
    }
  }

  void _launchPhoneCall() async {
    const phoneNumber = 'tel:+256700123456'; // Replace with actual number
    try {
      await launchUrl(Uri.parse(phoneNumber));
    } catch (e) {
      // Show error or fallback
    }
  }
}

// ─────────────────────────────────────────────────────────────────
// AI CHART SCREEN (truncated for space - keep existing implementation)
// ─────────────────────────────────────────────────────────────────
class AIChartScreen extends StatefulWidget {
  const AIChartScreen({super.key});

  @override
  State<AIChartScreen> createState() => _AIChartScreenState();
}

class _AIChartScreenState extends State<AIChartScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _weeklyData = [
    {'day': 'Mon', 'cases': 12, 'recovered': 8},
    {'day': 'Tue', 'cases': 19, 'recovered': 14},
    {'day': 'Wed', 'cases': 15, 'recovered': 11},
    {'day': 'Thu', 'cases': 25, 'recovered': 18},
    {'day': 'Fri', 'cases': 22, 'recovered': 20},
    {'day': 'Sat', 'cases': 30, 'recovered': 24},
    {'day': 'Sun', 'cases': 18, 'recovered': 16},
  ];

  final List<Map<String, dynamic>> _diseaseDistribution = [
    {'name': 'FMD', 'count': 42, 'color': Colors.red},
    {'name': 'Mastitis', 'count': 35, 'color': Colors.orange},
    {'name': 'Newcastle', 'count': 28, 'color': Colors.blue},
    {'name': 'Brucellosis', 'count': 18, 'color': Colors.deepPurple},
    {'name': 'Coccidiosis', 'count': 15, 'color': Colors.teal},
    {'name': 'Others', 'count': 9, 'color': Colors.grey},
  ];

  final List<Map<String, dynamic>> _animalBreakdown = [
    {'type': 'Cattle', 'cases': 52, 'color': const Color(0xFF2E7D32)},
    {'type': 'Goat', 'cases': 31, 'color': Colors.orange},
    {'type': 'Sheep', 'cases': 24, 'color': Colors.blue},
    {'type': 'Pig', 'cases': 18, 'color': Colors.pink},
    {'type': 'Poultry', 'cases': 22, 'color': Colors.amber[700]!},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxCases = _weeklyData.map((e) => e['cases'] as int).reduce((a, b) => a > b ? a : b).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          children: [
            Icon(Icons.analytics_rounded, size: 22),
            SizedBox(width: 10),
            Text(
              'AI Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Diseases'),
            Tab(text: 'Animals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(maxCases),
          _buildDiseasesTab(),
          _buildAnimalsTab(),
        ],
      ),
    );
  }

  // ── Overview Tab ──────────────────────────────────────────────
  Widget _buildOverviewTab(double maxCases) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard('Total Cases', '147', Icons.cases_rounded, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('Recovered', '121', Icons.trending_up_rounded, Colors.green)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatCard('High Risk', '23', Icons.warning_rounded, Colors.red)),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard('AI Accuracy', '94%', Icons.auto_awesome_rounded, Colors.deepPurple)),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weekly Trend',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cases vs Recoveries this week',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${maxCases.toInt()}', style: TextStyle(fontSize: 9, color: Colors.grey[500])),
                          Text('${(maxCases / 2).toInt()}', style: TextStyle(fontSize: 9, color: Colors.grey[500])),
                          Text('0', style: TextStyle(fontSize: 9, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _weeklyData.map((data) {
                            final cases = (data['cases'] as int).toDouble();
                            final recovered = (data['recovered'] as int).toDouble();
                            final caseHeight = (cases / maxCases) * 140;
                            final recoveredHeight = (recovered / maxCases) * 140;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 140,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: caseHeight,
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Container(
                                        width: 12,
                                        height: recoveredHeight,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF2E7D32).withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  data['day'],
                                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegend('Cases', Colors.red.withOpacity(0.7)),
                    const SizedBox(width: 20),
                    _buildLegend('Recovered', const Color(0xFF2E7D32).withOpacity(0.7)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recovery Rate',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.82,
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0xFF2E7D32), Colors.green[400]!],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      '82%',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '121 out of 147 cases recovered successfully',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Diseases Tab ─────────────────────────────────────────────
  Widget _buildDiseasesTab() {
    final total = _diseaseDistribution.fold<int>(0, (sum, e) => sum + (e['count'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Disease Distribution',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$total total cases across all diseases',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                ..._diseaseDistribution.map((disease) {
                  final count = disease['count'] as int;
                  final color = disease['color'] as Color;
                  final fraction = count / total;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              disease['name'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1F36),
                              ),
                            ),
                            Text(
                              '$count (${(fraction * 100).toStringAsFixed(0)}%)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Stack(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            FractionallySizedBox(
                              widthFactor: fraction,
                              child: Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Severity Breakdown',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSeverityChip('Critical', '8', Colors.deepPurple),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityChip('Severe', '15', Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityChip('Medium', '52', Colors.orange),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildSeverityChip('Mild', '72', Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Animals Tab ──────────────────────────────────────────────
  Widget _buildAnimalsTab() {
    final total = _animalBreakdown.fold<int>(0, (sum, e) => sum + (e['cases'] as int));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cases by Animal Type',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Distribution of $total cases across livestock',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 20),
                ..._animalBreakdown.map((animal) {
                  final count = animal['cases'] as int;
                  final color = animal['color'] as Color;
                  final fraction = count / total;
                  final icons = {
                    'Cattle': Icons.pets,
                    'Goat': Icons.pets,
                    'Sheep': Icons.sports_handball,
                    'Pig': Icons.pets,
                    'Poultry': Icons.egg,
                  };
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            icons[animal['type']] ?? Icons.pets,
                            size: 18,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    animal['type'],
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1A1F36),
                                    ),
                                  ),
                                  Text(
                                    '$count cases',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Stack(
                                children: [
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: fraction,
                                    child: Container(
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: color,
                                        borderRadius: BorderRadius.circular(4),
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
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red.withOpacity(0.08),
                  Colors.orange.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.red.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.warning_rounded, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'AI Risk Assessment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1F36),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRiskRow('Cattle', 'High', Colors.red),
                _buildRiskRow('Goat', 'Medium', Colors.orange),
                _buildRiskRow('Sheep', 'Medium', Colors.orange),
                _buildRiskRow('Pig', 'Low', Colors.green),
                _buildRiskRow('Poultry', 'High', Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── Helper Widgets ───────────────────────────────────────────

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSeverityChip(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskRow(String animal, String level, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              animal,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1F36),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              level,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}