import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Financial/FinancialPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Animals/AnimalsListPage.dart';
import '../Groups/GroupsListPage.dart';
import '../Paddocks/PaddocksListPage.dart';
import 'HomeManagerPage.dart';

class HomeOwnerPage extends StatefulWidget {
  @override
  State<HomeOwnerPage> createState() {
    return _HomeOwnerPage();
  }
}

class _HomeOwnerPage extends State<HomeOwnerPage> {
  var managers = [];

  @override
  void initState() {
    super.initState();

    initializeFarm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showProgress)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          color: primaryColor,
                          backgroundColor: primaryColor.withOpacity(0.2),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  _buildAnimalStatsCard(),
                  const SizedBox(height: 16),
                  _buildQuickActions(),

                  const SizedBox(height: 16),
                  _buildMilkCard(),
                  const SizedBox(height: 16),
                  _buildFinancialCards(),
                  const SizedBox(height: 16),
                  _buildManagersCard(),
                  const SizedBox(height: 16),
                  _buildManagerViewButton(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () => Navigator.pushNamed(context, "/profile"),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              farm_name ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              getDateToday(),
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, primaryColor.withOpacity(0.75)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: primaryColor),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required String label,
    required String value,
    Color? bg,
    VoidCallback? onTap,
  }) {
    Widget chip = Container(
      decoration: BoxDecoration(
        color: bg ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: chip,
      );
    }
    return chip;
  }

  Widget _buildAnimalStatsCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Farm Animals", Icons.pets),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(label: "Total", value: total.toString()),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  label: "Cows",
                  value: cows.toString(),
                  bg: primaryColor.withOpacity(0.08),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  label: "Bulls",
                  value: bulls.toString(),
                  bg: primaryColor.withOpacity(0.08),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  label: "Calves",
                  value: calves.toString(),
                  bg: primaryColor.withOpacity(0.08),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildSectionHeader("Animal Tagging", Icons.local_offer_outlined),
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  label: "Tagged",
                  value: animals_tagged.toString(),
                  bg: primaryColor.withOpacity(0.1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AnimalsListPage()),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  label: "Not Tagged",
                  value: animals_not_tagged.toString(),
                  bg: Colors.orange.withOpacity(0.1),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AnimalsListPage()),
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AnimalsListPage()),
            ),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View All Animals",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 14, color: primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: "Paddocks",

                value: paddocks.toString(),
                icon: Icons.landscape,
                color: Colors.teal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PaddocksListPage()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                title: "Groups / Herds",
                value: groups.toString(),
                icon: Icons.group_work,
                color: Colors.deepPurple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GroupsListPage()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildActionCard(
                title: "Animal Tracking",
                value: "0",
                icon: Icons.gps_fixed,
                color: Colors.indigo,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNotAroundCard(),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildActionCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Icon(icon, color: color, size: 24),
            //const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Row(children: [
              if (value.isNotEmpty) ...[
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
              Row(
                children: [
                  Text("View", style: TextStyle(color: color, fontSize: 11)),
                  const SizedBox(width: 2),
                  Icon(Icons.arrow_forward, size: 11, color: color),
                ],
              ),
            ],),

          ],
        ),
      ),
    );
  }

  Widget _buildNotAroundCard() {
    const color = Colors.red;
    final hasData = rfidDetectable > 0;

    String updatedTime = "";
    if (rfidLastUpdated != null) {
      try {
        final dt = DateTime.parse(rfidLastUpdated!).toLocal();
        updatedTime = "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
      } catch (_) {}
    }

    return InkWell(
      onTap: () {
        if (rfidNotDetectedIds.isEmpty) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimalsListPage(animalIds: rfidNotDetectedIds),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Not Around Today",
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              hasData ? rfidMissing.toString() : "-",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            if (hasData) ...[
              const SizedBox(height: 2),
              Text(
                "$rfidDetected / $rfidDetectable detected",
                style: TextStyle(color: color.withOpacity(0.75), fontSize: 10),
              ),
            ],
            if (updatedTime.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                "At $updatedTime",
                style: TextStyle(color: color.withOpacity(0.6), fontSize: 10),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                Text("View", style: TextStyle(color: color, fontSize: 11)),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward, size: 11, color: color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilkCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Daily Milk Records", Icons.water_drop_outlined),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Total",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${milk_today} L",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatChip(
                  label: "Milked",
                  value: milked_animals.toString(),
                  bg: primaryColor.withOpacity(0.08),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  label: "Not Milked",
                  value: not_milked_animals.toString(),
                  bg: Colors.orange.withOpacity(0.08),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCards() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FinancialPage()),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green.shade600, size: 20),
                      const Spacer(),
                      Icon(Icons.arrow_forward, size: 13, color: Colors.green.shade400),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Income",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency.format(income ?? 0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FinancialPage()),
            ),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.2)),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.trending_down, color: Colors.red.shade600, size: 20),
                      const Spacer(),
                      Icon(Icons.arrow_forward, size: 13, color: Colors.red.shade400),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Expenses",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    formatCurrency.format(expenses ?? 0),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManagersCard() {
    final List<Color> managerColors = [
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.teal.shade400,
      Colors.orange.shade400,
      Colors.green.shade600,
      Colors.deepOrange.shade400,
    ];

    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSectionHeader("Farm Manager(s)", Icons.manage_accounts),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  managers.length.toString(),
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          managers.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      "No managers assigned",
                      style: TextStyle(color: Colors.grey.shade500),
                    ),
                  ),
                )
              : SizedBox(
                  height: 115,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: managers.length,
                    itemBuilder: (context, index) {
                      var manager = managers[index];
                      final color = managerColors[index % managerColors.length];
                      final name = manager["name"] as String? ?? "";
                      return Container(
                        width: 155,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: color.withOpacity(0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: color,
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              manager["phone_number"] ?? "",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(Icons.call, size: 12, color: color),
                                const SizedBox(width: 3),
                                Text(
                                  "Call Manager",
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
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

  Widget _buildManagerViewButton() {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeManagerPage()),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.dashboard_outlined, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Manager Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: child,
    );
  }

  int? farm_id;
  String? farm_name;
  String? farm_address;

  initializeFarm() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      farm_id = prefs.getInt("farm_id");
      farm_address = prefs.getString("farm_address");
      farm_name = prefs.getString("farm_name");
      getDashboard();
      getRfidToday();
    });
  }

  int? cows = 0;
  int? bulls = 0;
  int? total = 0;
  int? calves = 0;
  int? income = 0;
  int? expenses = 0;
  int? paddocks = 0;
  int? groups = 0;
  int? animals_tagged = 0;
  int? animals_not_tagged = 0;
  int? not_milked_animals = 0;
  int? milked_animals = 0;
  String? milk_today = "0.0";

  int rfidMissing = 0;
  int rfidDetected = 0;
  int rfidDetectable = 0;
  String? rfidLastUpdated;
  List<dynamic> rfidNotDetectedIds = [];

  bool showProgress = false;

  getDashboard() async {
    requestAPI(
      "get_dashboard",
      {"farm_id": "$farm_id"},
      (progress) {
        setState(() {
          showProgress = progress;
        });
      },
      (response) {
        setState(() {
          cows = response["cows"];
          bulls = response["bulls"];
          total = response["total"];
          calves = response["calves"];
          income = response["income"];
          expenses = response["expenses"];
          paddocks = response["paddocks"];
          groups = response["groups"] ?? 0;
          animals_tagged = response["animals_tagged"];
          animals_not_tagged = response["animals_not_tagged"];
          not_milked_animals = response["not_milked_animals"];
          milked_animals = response["milked_animals"];
          milk_today = response["milk_today"].toString();
          managers = response["managers"];
        });
      },
      () {},
    );
  }

  getRfidToday() {
    requestGetAPI(
      "animal_rfid_sessions/today",
      {"farm_id": "$farm_id"},
      (progress) {},
      (response) {
        if (response is Map && response["status"] == "success") {
          var data = response["data"];
          if (data is List && data.isNotEmpty) {
            var latest = data.last;
            setState(() {
              rfidMissing = latest["missing_animals"] ?? 0;
              rfidDetected = latest["total_detected"] ?? 0;
              rfidDetectable = latest["total_detectable"] ?? 0;
              rfidLastUpdated = latest["updated_at"];
              rfidNotDetectedIds = latest["animals_not_detected"] is List
                  ? latest["animals_not_detected"]
                  : [];
            });
          }
        }
      },
      () {},
    );
  }

  String getDateToday() {
    var date = DateTime.now();
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${months[date.month - 1]} ${date.day}, ${date.year}";
  }
}
