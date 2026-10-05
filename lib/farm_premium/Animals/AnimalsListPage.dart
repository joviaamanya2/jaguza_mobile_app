import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Animals/AnimalsPreviewPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Tasks/ChatsPage.dart';

class AnimalsListPage extends StatefulWidget{

  dynamic paddock;
  dynamic group;
  List<dynamic>? animalIds;
  bool? select_animal = false;
  AnimalsListPage({super.key, this.paddock,this.group,this.animalIds,this.select_animal});

  @override
  State<AnimalsListPage> createState() {
    return _AnimalsListPage(paddock: paddock,group: group,animalIds: animalIds,select_animal: select_animal);
  }

}

class _AnimalsListPage extends State<AnimalsListPage>{

  dynamic paddock;
  dynamic group;
  List<dynamic>? animalIds;
  bool? select_animal = false;
  _AnimalsListPage({this.paddock,this.group,this.animalIds,this.select_animal});

  var title = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      if (paddock != null) {
        title = paddock["name"];
      } else if (group != null) {
        title = group["name"];
      } else if (animalIds != null) {
        title = "Not Around Today";
      } else{
        title = "Animals List";
      }
    });
    getAnimals();
  }

  final _formKey = GlobalKey<FormState>();

  var animals = [];
  var filteredAnimals = [];

  var searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title),),
      body: Column(
        children: [
          Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(children: [

                      Expanded(
                        child: jaguzaTextField("Search Name", (value){
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

          
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text("Count: ${animals.length}", style: TextStyle(fontSize: 14),)),
          
          Expanded(
            child: ListView.builder(
                      itemCount: filteredAnimals.length,
                      itemBuilder: (context, index) {


                        var pictures = [];
                        var pictureUrl = "";
                        var animal = filteredAnimals[index];

                        var hasSensorID = ( animal["sensor_id"] != null && animal["sensor_id"] != "sensor_id" && animal["sensor_id"] != "" );

                        pictures = animal["pictures"];
                        if (pictures.isNotEmpty) {
                          pictureUrl = "$imageUrl${pictures[0]["picture"]}";
                        }

                        return InkWell(
                          onTap: (){
                            if (select_animal == true) {
                              Navigator.pop(context, animal);
                              return;
                            }

                            Navigator.push(context, MaterialPageRoute(builder: (context) => AnimalsPreviewPage(animal: animal,) ) );
                          },
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Row(
                                  children: [

                                    if( hasSensorID )
                                    Container(
                                      margin: EdgeInsets.only(right: 1),
                                      width: 8,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(5),
                                        )
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(hasSensorID ? 0 : 5),
                                          right: Radius.circular(5),
                                        ),
                                        image: DecorationImage(
                                          image: pictureUrl == "" ? AssetImage("lib/assets/farm_premium/jaguza_icon_logo.png") : NetworkImage(pictureUrl),
                                          fit: BoxFit.cover
                                        )
                                      ),
                                      width: 60,
                                      height: 60,
                                    ),
                                    SizedBox(width: 8,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${animal["tag_id"]} (${animal["name"]??""})".replaceAll("()", ""), style: TextStyle(fontWeight: FontWeight.bold),),
                                          Text("${animal["animal_breed"]["name"]}", style: TextStyle(color: primaryColor,fontSize: 12),),
                                          Row(
                                            children: [
                                              Container(
                                                //width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.chat_bubble_outline_outlined, color: Colors.white,size: 12,),
                                                    SizedBox(width: 2,),
                                                    InkWell(
                                                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(tag: "animal-${ animal["id"] }"  , ))),
                                                        child: Container(
                                                            padding: EdgeInsets.all(4),
                                                            child: Text("Chat/Talk", style: TextStyle(color: Colors.white,fontSize: 11),))),
                                                  ],),
                                              ),
                                              //Expanded(child: Text("${animal["name"]??""}", style: TextStyle(fontSize: 12),)),
                                              //SizedBox(width: 10,),
                                              Spacer(),
                                              Text("${animal["sex"]}".toUpperCase(), style: TextStyle(fontSize: 12),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8,),
                                    Icon(Icons.arrow_forward)
                                  ],
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  var showProgress = false;
  void getAnimals() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    var path = "get_animals";
    var data = {
      "farm_id": farmId
    };
    onProgress(progress){
      setState(() {
        showProgress = progress;
      });
    }
    onSuccess(response){
      setState(() {
        if (paddock != null) {
          animals = response.where((element) => element["paddock_id"] ==
              paddock["id"]).toList();
        } else if (group != null) {
          animals = response.where((element) => element["group_id"] ==
              group["id"]).toList();
        } else if (animalIds != null && animalIds!.isNotEmpty) {
          animals = response.where((element) =>
              animalIds!.contains(element["id"])).toList();
        } else {
          animals = response;
        }
        filteredAnimals = animals;
      });
    }
    onError(){
      print("Error:");
    }
    requestAPI(path, data, onProgress, onSuccess, onError);

  }

  void seachAction() {
    setState(() {
      if (searchText == "") {
        filteredAnimals = animals;
        return;
      }
      filteredAnimals = animals.where((element) => element["tag_id"].toString().contains(searchText) || element["name"].toString().contains(searchText)).toList();
    });
  }
}