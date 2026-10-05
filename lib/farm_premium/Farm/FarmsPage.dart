import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Home/HomeOwnerPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmsPage extends StatefulWidget{
  const FarmsPage({super.key});

  @override
  State<FarmsPage> createState() {
    return _FarmsPage();
  }

}

class _FarmsPage extends State<FarmsPage>{

  var filteredFarms = [];
  var farms = [];


  @override
  void initState() {
    super.initState();
    initFarms();
  }

  final _formKey = GlobalKey<FormState>();
  String? searchText = "";

  searchAction(){
    setState(() {
      filteredFarms = farms.where((element) => element["farm"]["name"].toString().toLowerCase().contains(searchText!.toLowerCase()) || element["farm"]["address"].toString().toLowerCase().contains(searchText!.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose a Farm"),),
      body: Column(
        children: [


          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(children: [

                Expanded(
                  child: jaguzaTextField("Search by Address or Name", (value){
                    searchText = value;
                  }),
                ),

                InkWell(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      searchAction();
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


          showProgress ? Center(
            child: Container(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator()),
          ) : Container(),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                        itemCount: filteredFarms.length,
                        itemBuilder: (context, index) {
                          var farm = filteredFarms[index];
                          return InkWell(
                            onTap: (){
                              openFarm(farm);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8)
                              ),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(5),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(4),
                                    width: 35,
                                    height: 35,
                                    child: Image(image: AssetImage("lib/assets/farm_premium/jaguza_icon_logo.png")),
                                  ),
                                  SizedBox(width: 10,),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(farm["farm"]["name"].toString() ?? "", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(farm["farm"]["address"].toString() ?? ""),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }

  bool showProgress = false;
  initFarms() async {
    var prefs = await SharedPreferences.getInstance();
    var personId = prefs.getInt("person_id");
    requestAPI("get_farms", {"person_id":"$personId"}, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      setState(() {
        farms = response;
        filteredFarms = farms;
      });
    }, (){});
    

  }

  openFarm(farm) async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = farm["farm_id"];

    prefs.setInt("farm_id", farmId);
    prefs.setString("farm_name", farm["farm"]["name"]);
    prefs.setString("farm_address", farm["farm"]["address"]);

     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOwnerPage() ) );
  }
}