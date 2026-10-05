import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPaddockPage extends StatefulWidget{
  const AddPaddockPage({super.key});

  @override
  State<AddPaddockPage> createState() {
    return _AddPaddockPage();
  }

}

class _AddPaddockPage extends State<AddPaddockPage>{

  final _formKey = GlobalKey<FormState>();
  var _name = "";
  var _color = "";
  final _boundary = "";

  /*PaddockColor("blue","#2196f3"),
            PaddockColor("red","#f44336"),
            PaddockColor("green","#4caf50"),
            PaddockColor("black","#212121"),
            PaddockColor("yellow","#ffeb3b"),
            PaddockColor("purple","#9c27b0"),
            PaddockColor("pink","#e91e63"),
            PaddockColor("indigo","#3f51b5"),
            PaddockColor("teal","#009688"),
            PaddockColor("lime","#cddc39"),
            PaddockColor("orange","#ff9800"),
            PaddockColor("brown","#795548"),*/
  var paddockColors = [
    {"name":"Blue","color":"#2196f3"},
    {"name":"Red","color":"#f44336"},
    {"name":"Green","color":"#4caf50"},
    {"name":"Black","color":"#212121"},
    {"name":"Yellow","color":"#ffeb3b"},
    {"name":"Purple","color":"#9c27b0"},
    {"name":"Pink","color":"#e91e63"},
    {"name":"Indigo","color":"#3f51b5"},
    {"name":"Teal","color":"#009688"},
    {"name":"Lime","color":"#cddc39"},
    {"name":"Orange","color":"#ff9800"},
    {"name":"Brown","color":"#795548"},
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Paddock"),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(children: [

                        artyTechTextInput("Name", (value){
                          _name = value;
                        }),

                        //get color names
                        artyTechDropDown("Color", _color, paddockColors.map((e) => e["name"]).toList() , (name){
                          setState(() {
                            _color = name;
                          });
                        }),

                        _loading ? Center(child: CircularProgressIndicator(),) :
                        artyTechButtonOvalFilled("Save Paddock", (){
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

  var _loading = false;
  Future<void> action() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("create_paddock", {
      "farm_id": farmId,
      "name": _name,
      "color": paddockColors.firstWhere((element) => element["name"] == _color)["color"],
      "boundary" : ""
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
}