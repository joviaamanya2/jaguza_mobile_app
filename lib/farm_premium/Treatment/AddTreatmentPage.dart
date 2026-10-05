import 'package:jaguza_app/farm_premium/Contacts/ContactsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Animals/AnimalsListPage.dart';
import '../utils/Helper.dart';

class AddTreatmentPage extends StatefulWidget{
  const AddTreatmentPage({super.key});

  @override
  State<AddTreatmentPage> createState() {
    return _AddTreatmentPage();
  }

}

class _AddTreatmentPage extends State<AddTreatmentPage>{

  final _formKey = GlobalKey<FormState>();

  var _loading = false;


  var _date;
  var _time;
  var _diagnosis = "";
  var _treatment = "";
  var _remarks = "";
  var _dosage = "";

  @override
  void initState() {
    super.initState();

    var now = DateTime.now();
    _date = "${now.year}-${now.month}-${now.day}";
    _time = "${now.hour}:${now.minute}:${now.second}";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Treatment"),),
      body: SingleChildScrollView(child: Column(
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
                        child: Text("Treatment Date", style: TextStyle(
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
                        child: Text("Pick Animal", style: TextStyle(
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


                      artyTechTextInput("Diagnosis", (value){
                        _diagnosis = value;
                      }),

                      artyTechTextInput("Treatment", (value){
                        _treatment = value;
                      }),

                      artyTechTextInput("Dosage", (value){
                        _dosage = value;
                      }),

                      artyTechTextInput("Remarks", (value){
                        _remarks = value;
                      }),

                      GestureDetector(
                        onTap: (){
                          selectPerson();
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.all(smallMargin),
                          decoration: boxDecoration,
                          padding: EdgeInsets.all(smallMargin),
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text("Administered By", style: TextStyle(
                                color: mainColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),),
                            (_person_id.isNotEmpty) ? Text("$_person_name ($_person_title)") :
                            Text("Select Person")
                          ],
                        ),),
                      ),


                      _loading ? Center(child: CircularProgressIndicator(),) :
                      artyTechButtonOvalFilled("Save Record", (){
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          action();
                        }
                      }),
                  ],),
                  ),
                ),
        ],
      )),
    );
  }

  Future<void> action() async {

    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("create_treatment", {
      "farm_id": farmId,
      "animal_id": _animal_id,
      "time": _time,
      "date": _date,
      "diagnosis": _diagnosis,
      "dosage": _dosage,
      "medication": _treatment,
      "comment": _remarks,
      "administered_by_id": _person_id
    }, (progress){
      setState(() {
        _loading = progress;
      });
    }, (response){
      setState(() {
        if( response["status_code"] == 200 ){
          var statusMessage = response["status_message"];
          showSnackBar(context, statusMessage);
          Navigator.pop(context,true);
        } else {

        }
      });}, (){
      print("Error:");
    });
  }

  var _person_name = "";
  var _person_title = "";
  var _person_id = "";
  Future<void> selectPerson() async {
    var person = await  Navigator.push(context, MaterialPageRoute(builder: (context) => ContactsPage(select_contact: true) ) );
    if( person != null ){
      print(person);
      setState(() {
        _person_name = person["display_as"];
        _person_title = person["title"];
        _person_id = "${person["id"]}";
      });
    }
  }
}