import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Animals/AnimalsListPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'AddPaddockPage.dart';

class PaddocksListPage extends StatefulWidget{
  const PaddocksListPage({super.key});

  @override
  State<PaddocksListPage> createState() {
    return _PaddocksListPage();
  }
  
}

class _PaddocksListPage extends State<PaddocksListPage>{

  var paddocks = [];
  var filteredPaddocks = [];

  @override
  void initState() {
    super.initState();
    getPaddocks();
  }

  final _formKey = GlobalKey<FormState>();

  String? searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Paddocks List"),),
      body: Column(children: [

        Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [

              Expanded(
                child: jaguzaTextField("Search by Tag or Name", (value){
                  searchText = value;
                }),
              ),

              InkWell(
                onTap: (){
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    seachAction();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search),
                ),
              )
            ],),
          ),
        ),

        showProgress ? CircularProgressIndicator() : Container(),

        //grid view
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              childAspectRatio: 1.4
            ),
            itemCount: filteredPaddocks.length,
            itemBuilder: (context, index) {
              var paddock = filteredPaddocks[index];
              var colorHex = paddock["color"]; //#3f51b5
              var color = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
              return InkWell(
                onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalsListPage(paddock: paddock,) ) );
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/assets/farm_premium/icons8_cow_100.png", width: 40, height: 40,),
                  Text( paddock["name"], style: TextStyle(fontWeight: FontWeight.bold, ),),
                  Text( paddock["number_of_animals"].toString() , style: TextStyle(color: color),)
                                        ],),
                ),
              );
            },
          ),
        )



      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addPaddock();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  bool showProgress = false;
  void getPaddocks() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    var path = "get_paddocks";
    var data = {
      "farm_id": farmId
    };
    void onProgress(progress){
      setState(() {
        showProgress = progress;
      });
    }
    void onSuccess(response){
      setState(() {
        paddocks = response;
        filteredPaddocks = paddocks;
      });
    }
    void onError(){
      print("Error: ");
    }
    requestAPI(path, data, onProgress, onSuccess, onError);

  }

  void seachAction() {
    setState(() {
      if (searchText == "") {
        filteredPaddocks = paddocks;
        return;
      }
      filteredPaddocks = paddocks.where((element) => element["name"].toString().contains(searchText!)).toList();
    });
  }


  Future<void> addPaddock() async {
    var refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddPaddockPage()));
    if(refresh == true) {
      getPaddocks();
    }
  }
}