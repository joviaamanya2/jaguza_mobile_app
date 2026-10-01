import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Milk/AnimalMilkPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class AnimalsPreviewPage extends StatefulWidget{

  dynamic animal;
  AnimalsPreviewPage({this.animal});

  @override
  State<AnimalsPreviewPage> createState() {
    return _AnimalsPreviewPage(animal: animal);
  }

}

class _AnimalsPreviewPage extends State<AnimalsPreviewPage>{

  dynamic animal;
  _AnimalsPreviewPage({this.animal});

  @override
  void initState() {
    super.initState();
    setupAnimal();
    getMilk();
    if (_hasSensor()) getRfidStatus();
  }

  bool _hasSensor() {
    var s = animal["sensor_id"];
    return s != null && s != "sensor_id" && s != "";
  }

  // ── RFID state ──────────────────────────────────────────────
  bool _rfidLoading = false;
  // "seen_today" | "not_seen_today" | "never_seen" | null
  String? _rfidState;
  String? _rfidMessage;
  String? _rfidLastSeenAt;
  List<dynamic> _rfidRecords = [];
  dynamic _rfidLastRecord;

  void getRfidStatus() {
    setState(() => _rfidLoading = true);
    requestGetAPI(
      "animal_rfid_device_statuses/last_seen",
      {"sensor_id": animal["sensor_id"].toString()},
      (progress) {},
      (response) {
        setState(() {
          _rfidLoading = false;
          _rfidMessage = response["message"];
          if (response["success"] == true) {
            _rfidState = "seen_today";
            _rfidRecords = response["records"] is List ? response["records"] : [];
          } else if (response["last_record"] != null) {
            _rfidState = "not_seen_today";
            _rfidLastSeenAt = response["last_seen_at"];
            _rfidLastRecord = response["last_record"];
          } else {
            _rfidState = "never_seen";
          }
        });
      },
      () {
        setState(() {
          _rfidLoading = false;
          _rfidState = "never_seen";
          _rfidMessage = "Failed to load RFID data.";
        });
      },
    );
  }
  // ────────────────────────────────────────────────────────────

  bool showProgress = false;
  dynamic milk_object;
  getMilk() async {
    var prefs = await SharedPreferences.getInstance();

    var farm_id = prefs.getInt("farm_id");
    requestAPI("get_animal_milk_by_date", {
      "animal_id": animal["id"],
      "farm_id": farm_id,
    }, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      print(response);
      setState(() {
        milk_object = response;

      });
    },(){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animal Profile"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: picture_url != "" ? NetworkImage(picture_url) : AssetImage("lib/assets/farm_premium/jaguza_icon_logo.png") as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: primaryColor,
                child: Row(
                  children: [
                    Expanded(child: Text("Animal Details", style: TextStyle(color: Colors.white, fontSize: 13 ),)),
                    Text("TAG ID: ${animal["tag_id"].toString()}", style: TextStyle(color: Colors.white, fontSize: 13 , fontWeight: FontWeight.bold),),
                  ],
                )
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Column(children: [
                Row(children: [
                  Text("Given Name:"),
                  SizedBox(width: 5,),
                  Text( animal["name"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
                Row(children: [
                  Text("Date of Birth:"),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text( animal["date_of_birth"].toString() , style: TextStyle(fontWeight: FontWeight.bold),),
                      Text( getReadableAge(animal["date_of_birth"].toString()).toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],),
                Row(children: [
                  Text("Gender:"),
                  SizedBox(width: 5,),
                  Text(animal["sex"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
                Row(children: [
                  Text("Weight:"),
                  SizedBox(width: 5,),
                  Text( animal["weight"].toString() , style: TextStyle(fontWeight: FontWeight.bold),),
                ],),
                Row(children: [
                  Text("Breed Type:"),
                  SizedBox(width: 5,),
                  Text( animal["animal_breed"]["name"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
                Row(children: [
                  Text("Sensor Device:"),
                  SizedBox(width: 5,),
                  Text( animal["sensor_id"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
                Row(children: [
                  Text("Paddock:"),
                  SizedBox(width: 5,),
                  Text( animal["paddock"]["name"] .toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
                Row(children: [
                  Text("Description:"),
                  SizedBox(width: 5,),
                  Text( animal["description"].toString(), style: TextStyle(fontWeight: FontWeight.bold),)
                ],),
              ],),
            ),

            if (_hasSensor()) _buildRfidStatusCard(),

            if( animal["sex"] == "female" )
            Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    color: secondaryColor.withOpacity(0.5),
                    child: Text("Milking", style: TextStyle(color: Colors.white, fontSize: 13 ),)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Quantity Today: "),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text( milk_object == null ? "" : milk_object["milk_today"].toString(), style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalMilkPage( animal ) ) );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("Explore", style: TextStyle(color: Colors.blue),),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),




            Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: primaryColor,
                child: Text("Father", style: TextStyle(color: Colors.white, fontSize: 13 ),)),

            father == null ? Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("No Father Information"),
            )) :
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Column(
                children: [
                  Row(children: [
                    Text("Tag Label:"),
                    SizedBox(width: 5,),
                    Text( father["tag_id"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                  ],),
                  Row(children: [
                    Text("Given Name:"),
                    SizedBox(width: 5,),
                    Text(father["name"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                  ],),
                ],
              ),
            ),

            Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                color: primaryColor,
                child: Text("Mother", style: TextStyle(color: Colors.white, fontSize: 13 ),)),


            mother == null ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("No Mother Information")),
            ) :
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Column(
                children: [
                  Row(children: [
                    Text("Tag Label:"),
                    SizedBox(width: 5,),
                    Text(mother["tag_id"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                  ],),
                  Row(children: [
                    Text("Given Name:"),
                    SizedBox(width: 5,),
                    SizedBox(width: 5,),
                    Text(mother["name"].toString() , style: TextStyle(fontWeight: FontWeight.bold),)
                  ],),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRfidStatusCard() {
    Color badgeColor;
    String badgeText;

    if (_rfidLoading) {
      badgeColor = Colors.grey;
      badgeText = "Loading…";
    } else if (_rfidState == "seen_today") {
      badgeColor = Colors.green;
      badgeText = "Seen Today";
    } else if (_rfidState == "not_seen_today") {
      badgeColor = Colors.orange;
      badgeText = "Not Seen Today";
    } else if (_rfidState == "never_seen") {
      badgeColor = Colors.red;
      badgeText = "Never Seen";
    } else {
      badgeColor = Colors.grey;
      badgeText = "Loading…";
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Row(
              children: [
                Icon(Icons.sensors, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text("RFID Status",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(badgeText,
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: EdgeInsets.all(12),
            child: _buildRfidBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildRfidBody() {
    if (_rfidLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_rfidState == "seen_today") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rfidBanner(Colors.green.shade50, Colors.green, Icons.check_circle_outline, _rfidMessage ?? ""),
          SizedBox(height: 10),
          // Table header
          _rfidTableRow(["Captured At", "Reader", "Temp", "Humidity", "Session"], isHeader: true),
          Divider(height: 1),
          ..._rfidRecords.map((rec) {
            var session = (rec["animal_session"] != null) ? rec["animal_session"]["name"] ?? "—" : "—";
            return _rfidTableRow([
              rec["captured_at"]?.toString() ?? "—",
              rec["reader"]?.toString() ?? "—",
              "${rec["temperature"] ?? "—"} °C",
              "${rec["humidity"] ?? "—"} %",
              session,
            ]);
          }).toList(),
        ],
      );
    }

    if (_rfidState == "not_seen_today") {
      var rec = _rfidLastRecord;
      var session = (rec != null && rec["animal_session"] != null) ? rec["animal_session"]["name"] ?? "—" : "—";
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rfidBanner(Colors.orange.shade50, Colors.orange, Icons.access_time, _rfidMessage ?? ""),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _rfidInfoChip("Last Seen", _rfidLastSeenAt ?? "—"),
              if (rec != null) _rfidInfoChip("Reader", rec["reader"]?.toString() ?? "—"),
              if (rec != null) _rfidInfoChip("Session", session),
              if (rec != null) _rfidInfoChip("Temperature", "${rec["temperature"] ?? "—"} °C"),
              if (rec != null) _rfidInfoChip("Humidity", "${rec["humidity"] ?? "—"} %"),
            ],
          ),
        ],
      );
    }

    // never_seen or error
    return _rfidBanner(Colors.red.shade50, Colors.red, Icons.cancel_outlined, _rfidMessage ?? "Never detected.");
  }

  Widget _rfidBanner(Color bg, Color iconColor, IconData icon, String message) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(message, style: TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _rfidTableRow(List<String> cells, {bool isHeader = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: cells.map((cell) {
          return Expanded(
            child: Text(
              cell,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                color: isHeader ? Colors.grey.shade700 : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _rfidInfoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  var pictures = [];
  var picture_url = "";
  dynamic father;
  dynamic mother;
  void setupAnimal() {

    print( animal );

    pictures = animal["pictures"];
    father = animal["father"];
    mother = animal["mother"];
    if (pictures.length > 0) {
      picture_url = "${imageUrl}${pictures[0]["picture"]}";
    }

  }



String? getReadableAge(String? date) {
    print( date );

  if (date == null) return null;

  if (date == "null") return null;

  DateTime date1 = DateTime.parse(date);
  DateTime date2 = DateTime.now();
  int months = DateUtils.monthDelta(date1, date2);

  double years = (months / 12).toDouble();
  String formattedYears = years.toStringAsFixed(1);

  return "$months Month(s) $formattedYears Year(s)";
}

}