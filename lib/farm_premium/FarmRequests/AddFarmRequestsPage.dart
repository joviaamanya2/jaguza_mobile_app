import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFarmRequestsPage extends StatefulWidget{
  @override
  State<AddFarmRequestsPage> createState() {
    return _AddFarmRequestsPage();
  }

}

class _AddFarmRequestsPage extends State<AddFarmRequestsPage>{

  var _formKey = GlobalKey<FormState>();
  var _comment = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Farm Requests"),),
      body: Column(
        children: [
        Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Comment/Message", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),),
                    ),
                    artyTechTextArea("Comment", (value){
                      _comment = value;
                    }),

                    _loading ? Center(child: CircularProgressIndicator(),) :
                    artyTechButtonOvalFilled("Send Request", (){
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
    );
  }

  var _loading = false;
  Future<void> action() async {

    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");
    var path = "create_farm_request";
    var data = {
      "comment": _comment,
      "farm_id": farm_id
    };
    onProgress(progress){
      setState(() {
        _loading = progress;
      });
    }
    onSuccess(response){
      setState(() {
        if( response["status_code"] == 200 ){
          var status_message = response["status_message"];
          showSnackBar(context, status_message);
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