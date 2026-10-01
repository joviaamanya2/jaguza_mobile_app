import 'package:jaguza_app/farm_premium/Treatment/AddTreatmentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class TreatmentPage extends StatefulWidget{
  @override
  State<TreatmentPage> createState() {
    return _TreatmentPage();
  }

}

class _TreatmentPage extends State<TreatmentPage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTreatment();
  }

  var treatments = [];
  var showTreatmentProgress = false;

  initTreatment() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");
    print(farm_id);

    var path = "get_treatments";
    var data = {
      "farm_id": farm_id,
    };
    var onProgress = (progress){
      setState(() {
        showTreatmentProgress = progress;
      });
    };
    var onSuccess = (data){
      print("treatment");
      print(data);
      setState(() {
        treatments = data;
      });
    };
    var onError = (){
      print("Error:");
    };
    requestAPI(path, data, onProgress, onSuccess, onError);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Health Management"),),
      body: Column(
        children: [
          if (showTreatmentProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (treatments.length == 0 && !showTreatmentProgress)
            Center(child: Text("No treatments yet")),

          Expanded(
            child: ListView.builder(
              itemCount: treatments.length,
              itemBuilder: (context, index){
                var treatment = treatments[index];
                return Container(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: primaryColor,
                          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                          child: Row(
                            children: [
                              Expanded(child: Text(makeDateShorter(treatment["date"] ?? "") , style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),)),
                              if( treatment["administered_by"] != null)
                                Text("By: " + (treatment["administered_by"]["first_name"] ?? "") + " " + (treatment["administered_by"]["last_name"] ?? "") + " (" + (treatment["administered_by"]["title"] ?? "") + ")" , style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            if( treatment["animal"] != null)
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Animal:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text("${treatment["animal"]["name"] ?? ""} ${treatment["animal"]["tag_id"] ?? ""} (${ treatment["animal"]["sex"] ?? ""})")),
                                  ],
                                )),
                            if( treatment["preset"] != null)
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Category:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text("${treatment["preset"]["name"] ?? ""}")),
                                  ],
                                )),
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Diagnosis:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text(treatment["diagnosis"] ?? "")),
                                  ],
                                )),
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Medication:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text(treatment["medication"] ?? "")),
                                  ],
                                )),
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Dosage:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text(treatment["dosage"] ?? "")),
                                  ],
                                )),
                            Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Comment:", style: TextStyle(fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Expanded(child: Text(treatment["comment"] ?? "")),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addTreatment();
        },

        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addTreatment() async {
    var refresh =  await  Navigator.push(context, MaterialPageRoute(builder: (context) => AddTreatmentPage() ) );
    if(refresh == true) {
      initTreatment();
    }

  }
}