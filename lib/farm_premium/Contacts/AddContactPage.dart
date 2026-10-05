import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class AddContactPage extends StatefulWidget{
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() {
    return _AddContactPage();
  }

}

class _AddContactPage extends State<AddContactPage>{

  final _formKey = GlobalKey<FormState>();

  var _loading = false;


  //display_as, first_name, last_name, title,periodic_payment,comment,type,address,phone_number,status
  var _display_as = "";
  var _first_name = "";
  var _last_name = "";
  var _title = "";
  var _periodic_payment = "";
  var _comment = "";
  var _type = "";
  var _address = "";
  var _phone_number = "";
  final _status = "active";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Contact"),),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(children: [

                          //display_as, first_name, last_name, title,periodic_payment,comment,type,address,phone_number,status
                          artyTechTextInput("Display As", (value){
                            _display_as = value;
                          }),

                          artyTechTextInput("First Name", (value){
                            _first_name = value;
                          }),

                          artyTechTextInput("Last Name", (value){
                            _last_name = value;
                          }),

                          artyTechTextInput("Title", (value){
                            _title = value;
                          }),

                          artyTechTextInput("Periodic Payment", (value){
                            _periodic_payment = value;
                          }),

                          artyTechTextInput("Comment", (value){
                            _comment = value;
                          }),

                          artyTechTextInput("Type", (value){
                            _type = value;
                          }),

                          artyTechTextInput("Address", (value){
                            _address = value;
                          }),

                          artyTechTextInput("Phone Number", (value){
                            _phone_number = value;
                          }),


                          _loading ? Center(child: CircularProgressIndicator(),) :
                          artyTechButtonOvalFilled("Save Contact", (){
                            _formKey.currentState?.save();
                            action();

                          }),

                      ],),
                      ),
                    ),
              ],),
        )
      ),
    );
  }

  Future<void> action() async {

    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("create_contact", {
      "farm_id": farmId,
      "display_as": _display_as,
      "first_name": _first_name,
      "last_name": _last_name,
      "title": _title,
      "periodic_payment": _periodic_payment,
      "comment": _comment,
      "type": _type,
      "address": _address,
      "phone_number": _phone_number,
      "status": _status
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