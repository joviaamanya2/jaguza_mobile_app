import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

class MilkingAnimalsPage extends StatefulWidget{

  dynamic date;
  dynamic records;

  MilkingAnimalsPage({this.date, this.records});

  @override
  State<MilkingAnimalsPage> createState() {
    return _MilkingAnimalsPage( date: date, records: records );
  }
  
}

class _MilkingAnimalsPage extends State<MilkingAnimalsPage>{

  dynamic date;
  dynamic records;

  _MilkingAnimalsPage({this.date, this.records});

  var milks = [];

  @override
  void initState() {
    super.initState();
    milks = records;
    initMilk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Records (${date})")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Container( padding: EdgeInsets.all(7), color: primaryColor, child: Text("COW NAME", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),))),
                Expanded(child: Container( padding: EdgeInsets.all(7),color: CupertinoColors.lightBackgroundGray, child: Text("TAG ID", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),))),
                Container(
                    width: 60,
                    child: Container( padding: EdgeInsets.all(7),color: secondaryColor, child: Text("QTY", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),textAlign: TextAlign.center,))),
              ],
            ),
            Expanded(

              child: ListView.builder(
                        itemCount: animals.length,
                        itemBuilder: (context, index) {
                          var animal = animals[index];
                          var total_quantity = milks.where((element) => element["animal_id"] == animal["id"]).map( (e) => double.tryParse(e["quantity"] ?? '0') ?? 0.0 ).fold(0.0, (value, element) => value + element);
                          return Container(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Expanded(child: Container( child: Text( animal["name"] ?? ".." ))),
                                      Expanded(child: Container( child: Text(animal["tag_id"] ?? ".."))),
                                      Container(
                                          width: 60,
                                          child: Container( child: Text( total_quantity.toString() ,textAlign: TextAlign.center,))),
                                    ],
                                  ),
                                ),
                                Divider(color: secondaryColor,height: 1,),
                              ],
                            ),
                          );
                        },
                      ),
            ),


            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              padding: EdgeInsets.all(10),
              child:Column(children: [
              Row(
                children: [
                  Text("Total Cows:", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text(total_cows.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: secondaryColor),),
                ],
              ),
              Divider(),
              Row(
                children: [
                  Text("Total Milk Quantity:", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  Text(total_quantity.toString(), style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),
                ],
              )
            ],),)


          ],
        ),
      ),
    );
  }

  dynamic total_quantity = 0;
  dynamic total_cows = 0;


  var animals = [];
  var animals_ids = [];

  void initMilk() {
    if(records.length > 0){
      total_cows = records.map( (e) => e["animal_id"] ).toSet().length;
      total_quantity = records.map( (e) => double.tryParse(e["quantity"] ?? '0') ?? 0.0 ).fold(0.0, (value, element) => value + element);

      //get out all animal objects
      var animals_with_dups = records.map( (e) => e["animal"] );
      //loop through the ids
      animals_with_dups.forEach((element) {
        if(animals_ids.contains(element["id"])){
          //do nothing
        } else {
          animals.add(element);
          animals_ids.add(element["id"]);
        }
      });
      //
    } else {
      total_cows = 0;
      total_quantity = 0;
    }
  }
}