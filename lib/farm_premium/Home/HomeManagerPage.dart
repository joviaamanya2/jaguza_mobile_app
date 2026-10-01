import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Tasks/ChatsPage.dart';
import '../utils/Helper.dart';

class HomeManagerPage extends StatefulWidget{
  @override
  State<HomeManagerPage> createState() {
    return _HomeManagerPage();
  }
  
}

class _HomeManagerPage extends State<HomeManagerPage>{

  var menus = [
    {"name": "Animal Registry","drawable":"icons8_registry_100" , "message":"Register,View & Edit animal Information", "icon": Icons.home, "route": "/animals", },
    {"name": "Financial Records","drawable":"icons8_income_100" , "message":"Record and Analysis daily farm incomes & Expenses", "icon": Icons.home, "route": "/financial"},
    {"name": "Health Management", "drawable":"icons8_need_attention_100" ,"message":"Follow up on the health records and observations on farm", "icon": Icons.personal_injury, "route": "/treatment"},
    {"name": "Paddock Management","drawable":"icons8_paddock_100" , "message":"Manage your animals groupings" , "icon": Icons.home, "route": "/paddocks"},
    {"name": "Feeds", "drawable":"icons8_cow_100" ,"message":"Keep track of the feeds mixture ratios for better follow-up", "icon": Icons.home, "route": "/feeds"},
    {"name": "Farm Requests","drawable":"jaguza_icon_logo" , "message":"Make farm request demands to farm owner", "icon": Icons.home, "route": "/farm-requests"},
    {"name": "Milking Records","drawable":"icons8_milk_100" , "message":"Record daily milking records", "icon": Icons.home, "route": "/milking-home"},
    {"name": "Tasks","drawable":"icons8_tasks_100" , "message":"Duties assign to the people working on the farm", "icon": Icons.home, "route": "/tasks"},
    {"name": "Contacts","drawable":"icons8_contact_100" , "message":"These are the people on the farm", "icon": Icons.home, "route": "/contacts"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manager Farm"),),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, menus[index]["route"] as String);
                      },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:  Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("lib/assets/farm_premium/${menus[index]["drawable"]}.png", width: 40, height: 40,),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text( menus[index]["name"] as String ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                Text( menus[index]["message"] as String, style: TextStyle(fontSize: 12), ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10,),
                          Icon(Icons.chevron_right)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chat_bubble_outline_outlined, color: Colors.white,size: 15,),
                SizedBox(width: 5,),
                InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(tag: "farm"  , ))),
                    child: Container(
                        padding: EdgeInsets.all(4),
                        child: Text("Farm Chat/Talk", style: TextStyle(color: Colors.white),))),
              ],),
          )
        ],
      ),
    );
  }
}