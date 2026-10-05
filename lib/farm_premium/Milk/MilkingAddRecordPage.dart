import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Animals/AnimalsListPage.dart';

class MilkingAddRecordPage extends StatefulWidget{
  const MilkingAddRecordPage({super.key});

  @override
  State<MilkingAddRecordPage> createState() {
    return _MilkingAddRecordPage();
  }
  
}

class _MilkingAddRecordPage extends State<MilkingAddRecordPage> {

  var _date;
  var _time;
  var _quantity;
  var _milking_period = "Morning";

  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    _date = "${now.year}-${now.month}-${now.day}";
    _time = "${now.hour}:${now.minute}:${now.second}";
  }

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Milk Record"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Milking Date", style: TextStyle(
                          color: mainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      margin: EdgeInsets.all(smallMargin),
                      decoration: boxDecoration,
                      width: double.infinity,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () =>
                            helperSelectDate(context, (value) {
                              setState(() {
                                _date = value;
                              });
                            }),
                        decoration: inputDecoration("Date").copyWith(
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        controller: TextEditingController(text: _date),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a date.";
                          }
                          return null;
                        },
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Pick Milked Animals", style: TextStyle(
                          color: mainColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),),
                    ),

                    GestureDetector(
                      onTap: () {
                        selectAnimal();
                      },
                      child: Container(
                        decoration: boxDecoration,
                        margin: EdgeInsets.all(smallMargin),
                          padding: EdgeInsets.all(7),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.search),
                                  if (_animal_id.isEmpty)
                                  Text("Select Animal", style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.orange),),
                                ],
                              ),
                              if( _animal_id.isNotEmpty )
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$_animal_name ($_animal_sex)", style: TextStyle(
                                      fontWeight: FontWeight.bold),),
                                  Text(_animal_tag_id),
                                ],
                              ),
                              Spacer(),
                              Icon(Icons.chevron_right, color: mainColor,)
                            ],
                          )),
                    ),


                    artyTechDropDown("Milking Period", _milking_period,
                        ["Morning", "Afternoon", "Evening"], (value) {
                          setState(() {
                            _milking_period = value;
                          });
                        }),

                    artyTechTextInput("Quantity", (value) {
                      _quantity = value;
                    }, prefixIcon: Icons.numbers,
                        keyboardType: TextInputType.number),

                    if (_loading)
                      Center(child: CircularProgressIndicator())
                    else
                    artyTechButtonOvalFilled("Submit", () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        action();
                      }
                    })
                  ],),
              ),
            ),
          ],
        ),
      ),
    );
  }

  var _animal_name = "";
  var _animal_id = "";
  var _animal_tag_id = "";
  var _animal_sex = "";

  selectAnimal() async {
    var animal = await Navigator.push(context, MaterialPageRoute(
        builder: (context) => AnimalsListPage(select_animal: true,)));
    if (animal != null) {
      setState(() {
        _animal_name = animal["name"];
        _animal_id = "${animal["id"]}";
        _animal_tag_id = animal["tag_id"];
        _animal_sex = animal["sex"];
      });
    }
  }

  var _loading = false;
  Future<void> action() async {

    if( _animal_id.isEmpty ){
      showSnackBar(context, "Please select an animal.");
      return;
    }

    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    var path = "create_milking";
    var data = {
      "animal_id": _animal_id,
      "quantity": _quantity,
      "session": _milking_period,
      "farm_id": farmId
    };
    onProgress(progress){
      setState(() {
        _loading = progress;
      });
    }
    onSuccess(response){
      setState(() {
        if( response["status_code"] == 200 ){
          var statusMessage = response["status_message"];
          showSnackBar(context, statusMessage);
          Navigator.pop(context,true);
        } else {

        }
      });
    }
    onError(){
      print("Error:");
    }
    requestAPI(path, data, onProgress, onSuccess, onError);





  }

}