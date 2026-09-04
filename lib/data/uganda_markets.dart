/// Curated reference data for livestock and produce markets across Uganda.
///
/// The app prefers live data from the backend (`ApiService.getMarkets` /
/// `getMarketPrices`). This file is the offline fallback so the Prices and
/// Markets tabs always have something real to show.
///
/// Coordinates are town / trading-centre level (good enough to rank markets by
/// distance at national scale). Schedules reflect the commonly known auction or
/// opening days; always confirm locally before travelling.
library;

class UgandaMarket {
  final String name;
  final String district;

  /// One of: Central, Eastern, Northern, Western.
  final String region;
  final double lat;
  final double lng;

  /// Human readable trading schedule, e.g. "Cattle auction: Tue & Fri".
  final String schedule;

  /// What is traded here, e.g. ["Cattle", "Goats", "Produce"].
  final List<String> trades;

  const UgandaMarket({
    required this.name,
    required this.district,
    required this.region,
    required this.lat,
    required this.lng,
    required this.schedule,
    required this.trades,
  });
}

/// Major markets grouped loosely by region. Livestock auction markets are
/// prioritised, plus the main central market of each large town.
const List<UgandaMarket> kUgandaMarkets = [
  // ---------------- CENTRAL ----------------
  UgandaMarket(
    name: 'St. Balikuddembe (Owino) Market',
    district: 'Kampala',
    region: 'Central',
    lat: 0.3079,
    lng: 32.5730,
    schedule: 'Open daily',
    trades: ['Produce', 'Poultry', 'Foodstuffs'],
  ),
  UgandaMarket(
    name: 'Nakasero Market',
    district: 'Kampala',
    region: 'Central',
    lat: 0.3163,
    lng: 32.5822,
    schedule: 'Open daily',
    trades: ['Produce', 'Dairy', 'Foodstuffs'],
  ),
  UgandaMarket(
    name: 'Nakawa Market',
    district: 'Kampala',
    region: 'Central',
    lat: 0.3288,
    lng: 32.6156,
    schedule: 'Open daily',
    trades: ['Produce', 'Poultry', 'Foodstuffs'],
  ),
  UgandaMarket(
    name: 'Kalerwe Market',
    district: 'Kampala',
    region: 'Central',
    lat: 0.3556,
    lng: 32.5722,
    schedule: 'Open daily',
    trades: ['Produce', 'Poultry', 'Foodstuffs'],
  ),
  UgandaMarket(
    name: 'Bweyogerere Livestock Market',
    district: 'Wakiso',
    region: 'Central',
    lat: 0.3639,
    lng: 32.6786,
    schedule: 'Livestock: Mon & Thu',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Nsangi Market',
    district: 'Wakiso',
    region: 'Central',
    lat: 0.2814,
    lng: 32.4744,
    schedule: 'Market day: Wed',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Lyantonde Livestock Market',
    district: 'Lyantonde',
    region: 'Central',
    lat: -0.4047,
    lng: 31.1583,
    schedule: 'Cattle auction: Tue & Fri',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Ssembabule Cattle Market',
    district: 'Sembabule',
    region: 'Central',
    lat: -0.0806,
    lng: 31.4569,
    schedule: 'Cattle auction: Sat',
    trades: ['Cattle', 'Goats'],
  ),
  UgandaMarket(
    name: 'Masaka Central Market (Nyendo)',
    district: 'Masaka',
    region: 'Central',
    lat: -0.3411,
    lng: 31.7361,
    schedule: 'Open daily; livestock on Sat',
    trades: ['Cattle', 'Goats', 'Produce', 'Poultry'],
  ),
  UgandaMarket(
    name: 'Mubende Central Market',
    district: 'Mubende',
    region: 'Central',
    lat: 0.5589,
    lng: 31.3956,
    schedule: 'Open daily; livestock on Thu',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Mityana Market',
    district: 'Mityana',
    region: 'Central',
    lat: 0.4175,
    lng: 32.0428,
    schedule: 'Open daily',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Luweero Market',
    district: 'Luwero',
    region: 'Central',
    lat: 0.8497,
    lng: 32.4736,
    schedule: 'Open daily',
    trades: ['Poultry', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Mpigi Market',
    district: 'Mpigi',
    region: 'Central',
    lat: 0.2272,
    lng: 32.3131,
    schedule: 'Market day: Fri',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),

  // ---------------- WESTERN ----------------
  UgandaMarket(
    name: 'Kasenyi Livestock Market',
    district: 'Mbarara',
    region: 'Western',
    lat: -0.6469,
    lng: 30.6558,
    schedule: 'Cattle auction: Wed & Sat',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Mbarara Central Market',
    district: 'Mbarara',
    region: 'Western',
    lat: -0.6072,
    lng: 30.6545,
    schedule: 'Open daily',
    trades: ['Produce', 'Dairy', 'Poultry'],
  ),
  UgandaMarket(
    name: 'Rushere Cattle Market',
    district: 'Kiruhura',
    region: 'Western',
    lat: -0.1953,
    lng: 30.7856,
    schedule: 'Cattle auction: Thu',
    trades: ['Cattle', 'Dairy'],
  ),
  UgandaMarket(
    name: 'Sanga Cattle Market',
    district: 'Kiruhura',
    region: 'Western',
    lat: -0.1000,
    lng: 30.8500,
    schedule: 'Cattle auction: Tue',
    trades: ['Cattle', 'Goats'],
  ),
  UgandaMarket(
    name: 'Rwentobo Cattle Market',
    district: 'Ntungamo',
    region: 'Western',
    lat: -0.9800,
    lng: 30.2200,
    schedule: 'Cattle auction: Mon & Fri',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Ishaka Market',
    district: 'Bushenyi',
    region: 'Western',
    lat: -0.5406,
    lng: 30.1439,
    schedule: 'Open daily; livestock on Sat',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Fort Portal Central Market',
    district: 'Kabarole',
    region: 'Western',
    lat: 0.6710,
    lng: 30.2750,
    schedule: 'Open daily',
    trades: ['Produce', 'Goats', 'Poultry'],
  ),
  UgandaMarket(
    name: 'Hoima Central Market',
    district: 'Hoima',
    region: 'Western',
    lat: 1.4356,
    lng: 31.3436,
    schedule: 'Open daily',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Masindi Central Market',
    district: 'Masindi',
    region: 'Western',
    lat: 1.6744,
    lng: 31.7150,
    schedule: 'Open daily',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Kabale Central Market',
    district: 'Kabale',
    region: 'Western',
    lat: -1.2489,
    lng: 29.9899,
    schedule: 'Open daily',
    trades: ['Goats', 'Sheep', 'Produce'],
  ),
  UgandaMarket(
    name: 'Kasese Central Market',
    district: 'Kasese',
    region: 'Western',
    lat: 0.1833,
    lng: 30.0833,
    schedule: 'Open daily',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Ibanda Market',
    district: 'Ibanda',
    region: 'Western',
    lat: -0.1339,
    lng: 30.4986,
    schedule: 'Open daily; livestock on Wed',
    trades: ['Cattle', 'Dairy', 'Goats'],
  ),

  // ---------------- EASTERN ----------------
  UgandaMarket(
    name: 'Mbale Central Market',
    district: 'Mbale',
    region: 'Eastern',
    lat: 1.0806,
    lng: 34.1750,
    schedule: 'Open daily',
    trades: ['Produce', 'Poultry', 'Goats'],
  ),
  UgandaMarket(
    name: 'Jinja Central Market',
    district: 'Jinja',
    region: 'Eastern',
    lat: 0.4372,
    lng: 33.2039,
    schedule: 'Open daily',
    trades: ['Produce', 'Poultry', 'Dairy'],
  ),
  UgandaMarket(
    name: 'Iganga Central Market',
    district: 'Iganga',
    region: 'Eastern',
    lat: 0.6092,
    lng: 33.4686,
    schedule: 'Open daily; livestock on Tue',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Busia Border Market',
    district: 'Busia',
    region: 'Eastern',
    lat: 0.4661,
    lng: 34.0917,
    schedule: 'Open daily',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Tororo Central Market',
    district: 'Tororo',
    region: 'Eastern',
    lat: 0.6928,
    lng: 34.1811,
    schedule: 'Open daily',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Soroti Central Market',
    district: 'Soroti',
    region: 'Eastern',
    lat: 1.7147,
    lng: 33.6111,
    schedule: 'Open daily; livestock on Sat',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Kumi Livestock Market',
    district: 'Kumi',
    region: 'Eastern',
    lat: 1.4606,
    lng: 33.9364,
    schedule: 'Cattle auction: Wed',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Kamuli Central Market',
    district: 'Kamuli',
    region: 'Eastern',
    lat: 0.9472,
    lng: 33.1197,
    schedule: 'Open daily',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Pallisa Market',
    district: 'Pallisa',
    region: 'Eastern',
    lat: 1.1450,
    lng: 33.7092,
    schedule: 'Market day: Thu',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Kapchorwa Market',
    district: 'Kapchorwa',
    region: 'Eastern',
    lat: 1.4008,
    lng: 34.4517,
    schedule: 'Open daily',
    trades: ['Dairy', 'Sheep', 'Produce'],
  ),

  // ---------------- NORTHERN ----------------
  UgandaMarket(
    name: 'Gulu Main Market',
    district: 'Gulu',
    region: 'Northern',
    lat: 2.7747,
    lng: 32.2990,
    schedule: 'Open daily; livestock on Sat',
    trades: ['Cattle', 'Goats', 'Produce', 'Poultry'],
  ),
  UgandaMarket(
    name: 'Lira Main Market',
    district: 'Lira',
    region: 'Northern',
    lat: 2.2350,
    lng: 32.9097,
    schedule: 'Open daily; livestock on Sat',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Arua Main Market',
    district: 'Arua',
    region: 'Northern',
    lat: 3.0203,
    lng: 30.9108,
    schedule: 'Open daily',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Moroto Livestock Market',
    district: 'Moroto',
    region: 'Northern',
    lat: 2.5289,
    lng: 34.6614,
    schedule: 'Cattle auction: Fri',
    trades: ['Cattle', 'Goats', 'Sheep', 'Camels'],
  ),
  UgandaMarket(
    name: 'Kotido Livestock Market',
    district: 'Kotido',
    region: 'Northern',
    lat: 3.0011,
    lng: 34.1331,
    schedule: 'Cattle auction: Wed',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Namalu Cattle Market',
    district: 'Nakapiripirit',
    region: 'Northern',
    lat: 1.8167,
    lng: 34.6167,
    schedule: 'Cattle auction: Tue',
    trades: ['Cattle', 'Goats', 'Sheep'],
  ),
  UgandaMarket(
    name: 'Kitgum Main Market',
    district: 'Kitgum',
    region: 'Northern',
    lat: 3.2783,
    lng: 32.8867,
    schedule: 'Open daily',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
  UgandaMarket(
    name: 'Adjumani Market',
    district: 'Adjumani',
    region: 'Northern',
    lat: 3.3778,
    lng: 31.7908,
    schedule: 'Open daily',
    trades: ['Goats', 'Poultry', 'Produce'],
  ),
  UgandaMarket(
    name: 'Nebbi Main Market',
    district: 'Nebbi',
    region: 'Northern',
    lat: 2.4783,
    lng: 31.0894,
    schedule: 'Open daily',
    trades: ['Goats', 'Produce', 'Poultry'],
  ),
  UgandaMarket(
    name: 'Apac Market',
    district: 'Apac',
    region: 'Northern',
    lat: 1.9739,
    lng: 32.5375,
    schedule: 'Open daily; livestock on Thu',
    trades: ['Cattle', 'Goats', 'Produce'],
  ),
];

/// Month the indicative price ranges below were last reviewed.
const String kReferencePricesUpdated = 'September 2026';

class MarketPrice {
  final String item;

  /// Cattle, Goats, Sheep, Pigs, Poultry, Dairy, Feed.
  final String category;
  final int low;
  final int high;
  final String unit;

  /// "up", "down", "stable" or null when unknown.
  final String? trend;

  const MarketPrice({
    required this.item,
    required this.category,
    required this.low,
    required this.high,
    required this.unit,
    this.trend,
  });
}

/// Indicative farm-gate / market price ranges (UGX) used only when the live
/// price feed is unavailable. Reviewed [kReferencePricesUpdated].
const List<MarketPrice> kReferencePrices = [
  MarketPrice(
    item: 'Friesian heifer (in-calf)',
    category: 'Cattle',
    low: 2500000,
    high: 4000000,
    unit: 'per animal',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Crossbred dairy cow',
    category: 'Cattle',
    low: 2000000,
    high: 3200000,
    unit: 'per animal',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Ankole / local cow',
    category: 'Cattle',
    low: 1200000,
    high: 2200000,
    unit: 'per animal',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Mature bull (beef)',
    category: 'Cattle',
    low: 1800000,
    high: 3500000,
    unit: 'per animal',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Local goat (mature)',
    category: 'Goats',
    low: 150000,
    high: 280000,
    unit: 'per goat',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Boer / crossbred goat',
    category: 'Goats',
    low: 300000,
    high: 650000,
    unit: 'per goat',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Sheep (mature)',
    category: 'Sheep',
    low: 150000,
    high: 250000,
    unit: 'per sheep',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Pig – weaner (8 weeks)',
    category: 'Pigs',
    low: 90000,
    high: 150000,
    unit: 'per piglet',
    trend: 'down',
  ),
  MarketPrice(
    item: 'Pig – mature (~80kg live)',
    category: 'Pigs',
    low: 400000,
    high: 650000,
    unit: 'per pig',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Broiler (live, ~2kg)',
    category: 'Poultry',
    low: 22000,
    high: 32000,
    unit: 'per bird',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Layer (point of lay)',
    category: 'Poultry',
    low: 20000,
    high: 28000,
    unit: 'per bird',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Local chicken (mature)',
    category: 'Poultry',
    low: 25000,
    high: 40000,
    unit: 'per bird',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Eggs',
    category: 'Poultry',
    low: 11000,
    high: 14000,
    unit: 'per tray (30)',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Fresh milk – farm gate',
    category: 'Dairy',
    low: 1200,
    high: 1800,
    unit: 'per litre',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Fresh milk – retail',
    category: 'Dairy',
    low: 2500,
    high: 3800,
    unit: 'per litre',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Broiler feed',
    category: 'Feed',
    low: 130000,
    high: 170000,
    unit: 'per 50kg bag',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Layer mash',
    category: 'Feed',
    low: 120000,
    high: 160000,
    unit: 'per 50kg bag',
    trend: 'up',
  ),
  MarketPrice(
    item: 'Pig grower feed',
    category: 'Feed',
    low: 90000,
    high: 130000,
    unit: 'per 50kg bag',
    trend: 'stable',
  ),
  MarketPrice(
    item: 'Maize bran',
    category: 'Feed',
    low: 40000,
    high: 60000,
    unit: 'per 50kg bag',
    trend: 'stable',
  ),
];
