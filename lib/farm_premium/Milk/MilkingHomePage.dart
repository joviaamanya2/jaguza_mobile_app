import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Milk/MilkingAnimalsPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MilkingAddRecordPage.dart';

class MilkingHomePage extends StatefulWidget{
  @override
  State<MilkingHomePage> createState() {
    return _MilkingHomePage();
  }
  
}

class _MilkingHomePage extends State<MilkingHomePage>{

  @override
  void initState() {
    super.initState();
    var value = DateTime.now();
    selected_date = "${value?.year}-${value?.month}-${value?.day}";
    getMilk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Milking Record"),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          GestureDetector(
            onTap: (){
               addMilkRecord();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Row(children: [
                Container(
                  width: 30, height: 30,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/farm_premium/icons8_milk_100.png"),
                      fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Text("Add Milk Record", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
                Spacer(),
                Icon(Icons.add_circle_outline,size: 30, color: Colors.white)
              ],),
            ),
          ),





          Container(
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Text("View Milk Records by Date", style: TextStyle(fontSize: 12),)),
          Container(

            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10)
            ),
            child: GestureDetector(
              onTap: (){
                pickDate(context);
              },
              child: Row(
                children: [
                  Text("Pick Date:"),
                  SizedBox(width: 10,),
                  Expanded(child: Text(selected_date, style: TextStyle(fontWeight: FontWeight.bold,),)),
                  Icon(Icons.date_range)
                ],
              ),
            ),
          ),

          showProgress ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator(),),
          ) :

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child:Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text("Total Qantity")),
                    Text( total_quantity.toString() ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  ],
                ),
                Divider(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text("Milked Cows")),
                    Text(total_cows.toString(), style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  ],
                ),
                GestureDetector(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => MilkingAnimalsPage( date : selected_date, records : records ) ) );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("View Milked Cows", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],),
            ),),
          )
        ],
      ),
    );
  }

  void pickDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(Duration(days: 1))
    ).then((value) => setState(() {
      selected_date = "${value?.year}-${value?.month}-${value?.day}";
      getMilk();
    }));
  }

  dynamic selected_date;
  dynamic total_quantity = 0;
  dynamic total_cows = 0;



  bool showProgress = false;
  var records = [];

  getMilk() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");
    requestAPI("get_milking_by_date", {
      "farm_id": farm_id,
      "date": selected_date
    }, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      print(response);

      records = response;

      setState(() {
        if(records.length > 0){
          print(  records.map( (e) => e["animal_id"] ).toSet() );
          total_cows = records.map( (e) => e["animal_id"] ).toSet().length;
          total_quantity = records.map( (e) => double.tryParse(e["quantity"] ?? '0') ?? 0.0 ).fold(0.0, (value, element) => value + element);
        } else {
          total_cows = 0;
          total_quantity = 0;
        }
      });
    },(){});
  }

  Future<void> addMilkRecord() async {
    var refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => MilkingAddRecordPage() ) );
    if(refresh == true){
      getMilk();
    }
  }

}