import 'package:flutter/material.dart';
import 'package:jaguza_app/services/api_service.dart';

class WeatherUpdatesScreen extends StatefulWidget {
  const WeatherUpdatesScreen({super.key});

  @override
  State<WeatherUpdatesScreen> createState() => _WeatherUpdatesScreenState();
}

class _WeatherUpdatesScreenState extends State<WeatherUpdatesScreen> {
  int _selectedTab = 0;
  String _selectedCountry = 'Uganda';
  String _selectedLocation = 'Kampala';
  Map<String, dynamic>? _serverWeather;
  bool _isLoadingWeather = false;

  final List<String> _countries = [
    'Uganda', 'Kenya', 'Tanzania', 'Rwanda',
    'Burundi', 'South Sudan', 'Ethiopia', 'DRC Congo',
  ];

  final Map<String, String> _countryCapitals = {
    'Uganda': 'Kampala', 'Kenya': 'Nairobi', 'Tanzania': 'Dodoma',
    'Rwanda': 'Kigali', 'Burundi': 'Bujumbura', 'South Sudan': 'Juba',
    'Ethiopia': 'Addis Ababa', 'DRC Congo': 'Kinshasa',
  };

  DateTime get _now => DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() => _isLoadingWeather = true);
    try {
      final response = await ApiService().getWeather(_selectedLocation);
      if (mounted) {
        setState(() {
          _serverWeather = Map<String, dynamic>.from(response);
        });
      }
    } catch (_) {
      // The curated forecast remains available when no server observation exists.
    } finally {
      if (mounted) setState(() => _isLoadingWeather = false);
    }
  }

  String _dayName(int daysFromNow) {
    final d = _now.add(Duration(days: daysFromNow));
    const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return names[d.weekday - 1];
  }

  List<WeatherDay> get _weeklyForecast {
    final data = _weeklyData[_selectedCountry] ?? _weeklyData['Uganda']!;
    return List.generate(5, (i) {
      final idx = (i + 1) % 7;
      return WeatherDay(
        day: _dayName(i + 1),
        icon: data[idx].icon,
        condition: data[idx].condition,
        highTemp: data[idx].highTemp,
        lowTemp: data[idx].lowTemp,
      );
    });
  }

  List<WeatherDay> get _hourlyForecast {
    return _hourlyData[_selectedCountry] ?? _hourlyData['Uganda']!;
  }

  List<LivestockRecommendation> get _livestockRecs {
    return _allRecs[_selectedCountry] ?? _allRecs['Uganda']!;
  }

  WeatherDay get _todayData {
    final data = _weeklyData[_selectedCountry] ?? _weeklyData['Uganda']!;
    final weather = _serverWeather;
    if (weather != null) {
      final condition = '${weather['condition'] ?? data[_now.weekday - 1].condition}';
      final temperature = int.tryParse('${weather['temperature'] ?? ''}') ??
          data[_now.weekday - 1].highTemp;
      return WeatherDay(
        day: 'Today',
        icon: _weatherIcon(condition),
        condition: condition,
        highTemp: temperature,
        lowTemp: data[_now.weekday - 1].lowTemp,
      );
    }
    return data[_now.weekday - 1];
  }

  IconData _weatherIcon(String condition) {
    final value = condition.toLowerCase();
    if (value.contains('rain') || value.contains('storm')) return Icons.grain_rounded;
    if (value.contains('cloud')) return Icons.cloud_rounded;
    return Icons.wb_sunny_rounded;
  }

  String get _humidityText => _serverWeather == null
      ? '65%'
      : '${_serverWeather!['humidity'] ?? 65}%';

  String get _windText => _serverWeather == null
      ? '12 km/h'
      : '${_serverWeather!['wind_speed'] ?? 12} km/h';

  static const Map<String, List<WeatherDay>> _weeklyData = {
    'Uganda': [
      WeatherDay(day: 'Mon', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 29, lowTemp: 18),
      WeatherDay(day: 'Tue', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 28, lowTemp: 17),
      WeatherDay(day: 'Wed', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 26, lowTemp: 16),
      WeatherDay(day: 'Thu', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 24, lowTemp: 15),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 17),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 30, lowTemp: 19),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 25, lowTemp: 16),
    ],
    'Kenya': [
      WeatherDay(day: 'Mon', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 26, lowTemp: 15),
      WeatherDay(day: 'Tue', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 23, lowTemp: 14),
      WeatherDay(day: 'Wed', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 22, lowTemp: 13),
      WeatherDay(day: 'Thu', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 24, lowTemp: 14),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 16),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 28, lowTemp: 17),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 25, lowTemp: 15),
    ],
    'Tanzania': [
      WeatherDay(day: 'Mon', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 32, lowTemp: 22),
      WeatherDay(day: 'Tue', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 33, lowTemp: 23),
      WeatherDay(day: 'Wed', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 31, lowTemp: 21),
      WeatherDay(day: 'Thu', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 28, lowTemp: 20),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 30, lowTemp: 21),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 34, lowTemp: 24),
      WeatherDay(day: 'Sun', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 33, lowTemp: 23),
    ],
    'Rwanda': [
      WeatherDay(day: 'Mon', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 24, lowTemp: 14),
      WeatherDay(day: 'Tue', icon: Icons.grain_rounded, condition: 'Light Rain', highTemp: 22, lowTemp: 13),
      WeatherDay(day: 'Wed', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 21, lowTemp: 12),
      WeatherDay(day: 'Thu', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 23, lowTemp: 13),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 25, lowTemp: 14),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 26, lowTemp: 15),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 23, lowTemp: 14),
    ],
    'Burundi': [
      WeatherDay(day: 'Mon', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 17),
      WeatherDay(day: 'Tue', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 25, lowTemp: 16),
      WeatherDay(day: 'Wed', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 23, lowTemp: 15),
      WeatherDay(day: 'Thu', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 22, lowTemp: 14),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 26, lowTemp: 16),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 28, lowTemp: 18),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 24, lowTemp: 16),
    ],
    'South Sudan': [
      WeatherDay(day: 'Mon', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 38, lowTemp: 25),
      WeatherDay(day: 'Tue', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 37, lowTemp: 24),
      WeatherDay(day: 'Wed', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 36, lowTemp: 24),
      WeatherDay(day: 'Thu', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 34, lowTemp: 23),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 37, lowTemp: 25),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 39, lowTemp: 26),
      WeatherDay(day: 'Sun', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 38, lowTemp: 25),
    ],
    'Ethiopia': [
      WeatherDay(day: 'Mon', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 25, lowTemp: 10),
      WeatherDay(day: 'Tue', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 23, lowTemp: 9),
      WeatherDay(day: 'Wed', icon: Icons.grain_rounded, condition: 'Light Rain', highTemp: 20, lowTemp: 8),
      WeatherDay(day: 'Thu', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 24, lowTemp: 10),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 26, lowTemp: 11),
      WeatherDay(day: 'Sat', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 12),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 22, lowTemp: 9),
    ],
    'DRC Congo': [
      WeatherDay(day: 'Mon', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 28, lowTemp: 20),
      WeatherDay(day: 'Tue', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 27, lowTemp: 19),
      WeatherDay(day: 'Wed', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 29, lowTemp: 20),
      WeatherDay(day: 'Thu', icon: Icons.grain_rounded, condition: 'Rainy', highTemp: 26, lowTemp: 19),
      WeatherDay(day: 'Fri', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 30, lowTemp: 21),
      WeatherDay(day: 'Sat', icon: Icons.grain_rounded, condition: 'Storm', highTemp: 25, lowTemp: 19),
      WeatherDay(day: 'Sun', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 28, lowTemp: 20),
    ],
  };

  static const Map<String, List<WeatherDay>> _hourlyData = {
    'Uganda': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Clear', highTemp: 18, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 26, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 29, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 25, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 21, lowTemp: 0),
    ],
    'Kenya': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Clear', highTemp: 15, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 19, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 23, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 26, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 18, lowTemp: 0),
    ],
    'Tanzania': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Clear', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 31, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 32, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 28, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 24, lowTemp: 0),
    ],
    'Rwanda': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Misty', highTemp: 14, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 18, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.grain_rounded, condition: 'Rain', highTemp: 24, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 20, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 16, lowTemp: 0),
    ],
    'Burundi': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Clear', highTemp: 17, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 25, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 27, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 23, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 19, lowTemp: 0),
    ],
    'South Sudan': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Hot', highTemp: 25, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 32, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.wb_sunny_rounded, condition: 'Very Hot', highTemp: 37, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 38, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.wb_sunny_rounded, condition: 'Hot', highTemp: 33, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Warm', highTemp: 28, lowTemp: 0),
    ],
    'Ethiopia': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Cool', highTemp: 10, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 17, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 22, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.wb_sunny_rounded, condition: 'Sunny', highTemp: 25, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 20, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Clear', highTemp: 14, lowTemp: 0),
    ],
    'DRC Congo': [
      WeatherDay(day: '6 AM', icon: Icons.wb_twilight_rounded, condition: 'Cloudy', highTemp: 20, lowTemp: 0),
      WeatherDay(day: '9 AM', icon: Icons.grain_rounded, condition: 'Rain', highTemp: 24, lowTemp: 0),
      WeatherDay(day: '12 PM', icon: Icons.grain_rounded, condition: 'Rain', highTemp: 27, lowTemp: 0),
      WeatherDay(day: '3 PM', icon: Icons.cloud_rounded, condition: 'Cloudy', highTemp: 28, lowTemp: 0),
      WeatherDay(day: '6 PM', icon: Icons.grain_rounded, condition: 'Rain', highTemp: 24, lowTemp: 0),
      WeatherDay(day: '9 PM', icon: Icons.nights_stay_rounded, condition: 'Cloudy', highTemp: 22, lowTemp: 0),
    ],
  };

  static const Map<String, List<LivestockRecommendation>> _allRecs = {
    'Uganda': [
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 90, tips: 'Ideal conditions for outdoor grazing. Ensure shade is available.'),
      LivestockRecommendation(name: 'Poultry Ventilation', icon: Icons.air_rounded, suitability: 75, tips: 'Moderate heat — keep coop ventilated and provide cool water.'),
      LivestockRecommendation(name: 'Pig Cooling', icon: Icons.water_drop_rounded, suitability: 70, tips: 'Warm weather ahead. Consider wallowing areas for pigs.'),
      LivestockRecommendation(name: 'Dairy Production', icon: Icons.local_drink_rounded, suitability: 82, tips: 'Good conditions for milk production. Increase water intake.'),
    ],
    'Kenya': [
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 72, tips: 'Cloudy conditions. Grazing is fine but watch for rain.'),
      LivestockRecommendation(name: 'Poultry Shelter', icon: Icons.home_rounded, suitability: 85, tips: 'Keep poultry sheltered. Rain expected in coming days.'),
      LivestockRecommendation(name: 'Feed Storage', icon: Icons.inventory_2_rounded, suitability: 80, tips: 'Store feed in dry conditions. Moisture levels rising.'),
      LivestockRecommendation(name: 'Dairy Production', icon: Icons.local_drink_rounded, suitability: 78, tips: 'Cool weather favors production. Maintain regular schedule.'),
    ],
    'Tanzania': [
      LivestockRecommendation(name: 'Heat Management', icon: Icons.thermostat_rounded, suitability: 60, tips: 'Very high temperatures. Provide extra water and shade for all livestock.'),
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 65, tips: 'Grazing best in early morning or late evening only.'),
      LivestockRecommendation(name: 'Poultry Ventilation', icon: Icons.air_rounded, suitability: 55, tips: 'Critical ventilation needed. Use fans and keep coops open.'),
      LivestockRecommendation(name: 'Water Supply', icon: Icons.water_drop_rounded, suitability: 50, tips: 'Double water supply. Animals will drink significantly more.'),
    ],
    'Rwanda': [
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 80, tips: 'Cool and cloudy. Good for grazing despite light rain risk.'),
      LivestockRecommendation(name: 'Poultry Care', icon: Icons.pets_rounded, suitability: 85, tips: 'Mild conditions ideal for poultry. No extra measures needed.'),
      LivestockRecommendation(name: 'Dairy Production', icon: Icons.local_drink_rounded, suitability: 88, tips: 'Cool weather is excellent for milk production.'),
      LivestockRecommendation(name: 'Feed Storage', icon: Icons.inventory_2_rounded, suitability: 70, tips: 'Rain expected. Ensure all feed is stored under cover.'),
    ],
    'Burundi': [
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 88, tips: 'Sunny and warm. Good conditions for outdoor grazing.'),
      LivestockRecommendation(name: 'Poultry Ventilation', icon: Icons.air_rounded, suitability: 74, tips: 'Warm temperatures. Ensure adequate ventilation in coops.'),
      LivestockRecommendation(name: 'Goat Farming', icon: Icons.pets_rounded, suitability: 86, tips: 'Ideal weather for goats. Good for browsing and grazing.'),
      LivestockRecommendation(name: 'Water Supply', icon: Icons.water_drop_rounded, suitability: 78, tips: 'Increase water availability due to warm conditions.'),
    ],
    'South Sudan': [
      LivestockRecommendation(name: 'Heat Stress Alert', icon: Icons.warning_rounded, suitability: 35, tips: 'Extreme heat. Keep all livestock in shade during peak hours.'),
      LivestockRecommendation(name: 'Water Supply', icon: Icons.water_drop_rounded, suitability: 30, tips: 'Critical: Double or triple normal water supply immediately.'),
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 40, tips: 'Grazing only before 8 AM or after 5 PM. Avoid midday sun.'),
      LivestockRecommendation(name: 'Poultry Care', icon: Icons.pets_rounded, suitability: 45, tips: 'Use wet cloths and fans. Heat stroke risk is very high.'),
    ],
    'Ethiopia': [
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 92, tips: 'Pleasant warm weather. Excellent conditions for grazing.'),
      LivestockRecommendation(name: 'Sheep & Goats', icon: Icons.pets_rounded, suitability: 90, tips: 'Ideal conditions. Livestock will thrive in this weather.'),
      LivestockRecommendation(name: 'Dairy Production', icon: Icons.local_drink_rounded, suitability: 88, tips: 'Comfortable temperatures support good milk yields.'),
      LivestockRecommendation(name: 'Poultry Ventilation', icon: Icons.air_rounded, suitability: 85, tips: 'Mild weather. Standard ventilation is sufficient.'),
    ],
    'DRC Congo': [
      LivestockRecommendation(name: 'Shelter Needed', icon: Icons.home_rounded, suitability: 55, tips: 'Rain expected. Ensure all livestock have dry shelter.'),
      LivestockRecommendation(name: 'Cattle Grazing', icon: Icons.agriculture_rounded, suitability: 60, tips: 'Limit grazing. Wet pastures increase disease risk.'),
      LivestockRecommendation(name: 'Feed Storage', icon: Icons.inventory_2_rounded, suitability: 50, tips: 'Protect all feed from rain. Mold risk is high.'),
      LivestockRecommendation(name: 'Disease Prevention', icon: Icons.health_and_safety_rounded, suitability: 65, tips: 'Wet conditions favor parasites. Increase deworming.'),
    ],
  };

  void _showCountryPicker() {
    final scheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(ctx).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Select Country',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: _countries.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected = country == _selectedCountry;
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: isSelected ? const Color(0xFFE3F2FD) : Colors.transparent,
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1976D2) : const Color(0xFFF3F8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.flag_rounded,
                        color: isSelected ? Colors.white : const Color(0xFF1976D2),
                        size: 20,
                      ),
                    ),
                    title: Text(
                      country,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? const Color(0xFF1976D2) : scheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      _countryCapitals[country] ?? '',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: Color(0xFF1976D2), size: 22)
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                        _selectedLocation = _countryCapitals[country] ?? country;
                      });
                      _loadWeather();
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = _todayData;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weather Updates',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.location_on_rounded, size: 12, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        _selectedLocation,
                        style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1976D2).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _selectedCountry,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF1976D2),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(25, 118, 210, 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.public_rounded, size: 14, color: Color(0xFF1976D2)),
                    SizedBox(width: 4),
                    Text(
                      'Country',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, size: 22),
            color: const Color(0xFF1976D2),
            onPressed: () {
              _loadWeather();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Weather updated'),
                  backgroundColor: Color(0xFF1976D2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: Column(
          children: [
            _buildMainWeatherCard(today),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 12),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return Column(
          children: _weeklyForecast.map((day) => _buildForecastCard(day)).toList(),
        );
      case 1:
        return _buildHourlyForecast();
      case 2:
        return _buildAnalytics();
      default:
        return const SizedBox();
    }
  }

  Widget _buildMainWeatherCard(WeatherDay today) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(21, 101, 192, 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(today.icon, size: 46, color: Colors.white),
              ),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${today.highTemp}°',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    today.condition,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_formatDate(_now), style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(_formatTime(_now), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.air, size: 16, color: Colors.white70),
                    SizedBox(width: 6),
                    Text('Breezy', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniWeatherTile('High', '${today.highTemp}°'),
                _buildMiniWeatherTile('Low', '${today.lowTemp}°'),
                _buildMiniWeatherTile('Humidity', _humidityText),
                _buildMiniWeatherTile('Wind', _windText),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 85,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _weeklyForecast.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final day = _weeklyForecast[index];
                return Container(
                  width: 70,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day.day, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Icon(day.icon, color: Colors.white, size: 18),
                      const SizedBox(height: 4),
                      Text('${day.highTemp}°', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniWeatherTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }

  Widget _buildTabBar() {
    final labels = ['Weekly', 'Hourly', 'Analytics'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isActive = _selectedTab == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1976D2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF1976D2),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildForecastCard(WeatherDay day) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(day.icon, size: 20, color: const Color(0xFF1565C0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(day.day, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                const SizedBox(height: 4),
                Text(day.condition, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${day.highTemp}°', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 2),
              Text('${day.lowTemp}°', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyForecast() {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hourly forecast', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
          const SizedBox(height: 14),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _hourlyForecast.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final hour = _hourlyForecast[index];
                return Container(
                  width: 72,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F8FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hour.day, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(25, 118, 210, 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(hour.icon, color: const Color(0xFF1565C0), size: 18),
                      ),
                      const SizedBox(height: 6),
                      Text('${hour.highTemp}°', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalytics() {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 18, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Livestock Weather Impact', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 14),
              Row(
                children: [
                  _buildAnalyticsCard(icon: Icons.thermostat_rounded, label: 'Heat Stress', value: 'Low', change: 'Safe', isPositive: true),
                  const SizedBox(width: 10),
                  _buildAnalyticsCard(icon: Icons.grass_rounded, label: 'Grazing', value: 'Good', change: 'Optimal', isPositive: true),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildAnalyticsCard(icon: Icons.water_drop_rounded, label: 'Water Need', value: 'High', change: '+15%', isPositive: true),
                  const SizedBox(width: 10),
                  _buildAnalyticsCard(icon: Icons.air_rounded, label: 'Ventilation', value: 'Adequate', change: 'Normal', isPositive: true),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Livestock Recommendations', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: scheme.onSurface)),
              const SizedBox(height: 6),
              Text('Based on current weather in $_selectedCountry.', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
              const SizedBox(height: 14),
              ..._livestockRecs.map((item) => _buildLivestockRec(item)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsCard({
    required IconData icon,
    required String label,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F8FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: const Color(0xFF1976D2)),
                const SizedBox(width: 4),
                Expanded(child: Text(label, style: TextStyle(fontSize: 10, color: scheme.onSurfaceVariant, fontWeight: FontWeight.w600))),
              ],
            ),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: scheme.onSurface)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(isPositive ? Icons.check_circle_rounded : Icons.warning_rounded, size: 10, color: isPositive ? scheme.primary : const Color(0xFFF57C00)),
                const SizedBox(width: 2),
                Text(change, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: isPositive ? scheme.primary : const Color(0xFFF57C00))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLivestockRec(LivestockRecommendation item) {
    final scheme = Theme.of(context).colorScheme;
    final color = item.suitability >= 80
        ? scheme.primary
        : item.suitability >= 70
            ? const Color(0xFFF57C00)
            : scheme.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: const Color.fromRGBO(0, 0, 0, 0.03), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(0x1F),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, size: 18, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: scheme.onSurface)),
                const SizedBox(height: 2),
                Text(item.tips, style: TextStyle(fontSize: 11, color: scheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(0x1F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('${item.suitability}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return '${days[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final h = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final m = date.minute.toString().padLeft(2, '0');
    return '$h:$m ${date.hour >= 12 ? 'PM' : 'AM'}';
  }
}

class WeatherDay {
  final String day;
  final IconData icon;
  final String condition;
  final int highTemp;
  final int lowTemp;

  const WeatherDay({required this.day, required this.icon, required this.condition, required this.highTemp, required this.lowTemp});
}

class LivestockRecommendation {
  final String name;
  final IconData icon;
  final int suitability;
  final String tips;

  const LivestockRecommendation({required this.name, required this.icon, required this.suitability, required this.tips});
}
