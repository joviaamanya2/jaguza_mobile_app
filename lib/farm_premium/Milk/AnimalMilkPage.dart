import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class AnimalMilkPage extends StatefulWidget{

  dynamic animal;
  AnimalMilkPage( this.animal, {super.key} );

  @override
  State<AnimalMilkPage> createState() {
    return _AnimalMilkPage(animal);
  }

}

class _AnimalMilkPage extends State<AnimalMilkPage>{

  var animal;
  _AnimalMilkPage( this.animal );

  @override
  void initState() {
    super.initState();
    print(animal);
    getMilk();
  }

  var selectedDay = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animal Milk"),),
      body:
          showProgress ?
          Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            ),
          ) :
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    var milkRecord = records[index];

                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedDay = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${index+1}"),
                                    Expanded(child: Center(child: Text( milkRecord["milk_date"] , style: TextStyle(fontWeight: FontWeight.bold),))),
                                    Text("${milkRecord["milk_today"]}"),
                                    if(selectedDay > 0  )
                                      if( records[selectedDay]["milk_today"] >= records[selectedDay-1]["milk_today"] )
                                        Icon(Icons.arrow_drop_up, color: primaryColor,)
                                      else
                                        Icon(Icons.arrow_drop_down, color: Colors.red,)
                                    else
                                      Icon(Icons.arrow_drop_up, color: primaryColor,)
                                  ],
                                ),
                                if(selectedDay == index)
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                            itemCount: milkRecord["milk_records"].length,
                                            itemBuilder: (context, index) {
                                              var x = milkRecord["milk_records"][index];
                                              return Container(
                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                margin: EdgeInsets.only(right: 10),
                                                child: Column(
                                                  children: [
                                                    Text("${x["session"] ?? ".."}"),
                                                    Text("${x["quantity"] ?? ".."}", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ) ;
                  },
                ),
      ),
    );
  }



  bool showProgress = false;
  var records = [];

  getMilk() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    requestAPI("get_animal_milk", {
      "farm_id": farmId,
      "animal_id":animal["id"]
    }, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      print(response);
      setState(() {
        records = response;
      });
    },(){});
  }
}