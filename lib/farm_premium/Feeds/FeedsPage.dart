import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';

class Feedspage extends StatefulWidget{
  const Feedspage({super.key});

  @override
  State<Feedspage> createState() {
    return _Feedspage();
  }

}

class _Feedspage extends State<Feedspage>{



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initTreatment();
  }

  var feeds = [];
  var showFeedsProgress = false;

  initTreatment() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    print(farmId);

    var path = "get_feeds";
    var data = {
      "farm_id": farmId,
    };
    void onProgress(progress){
      setState(() {
        showFeedsProgress = progress;
      });
    }
    void onSuccess(data){
      print("treatment");
      print(data);
      setState(() {
        feeds = data;
      });
    }
    void onError(){
      print("Error:");
    }
    requestAPI(path, data, onProgress, onSuccess, onError);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feeds"),),
      body: Column(
        children: [
          if (showFeedsProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (feeds.isEmpty && !showFeedsProgress)
            Center(child: Text("No feeds yet")),

          Expanded(
            child: ListView.builder(
              itemCount: feeds.length,
              itemBuilder: (context, index){
                var treatment = feeds[index];
                return Container(
                  padding: EdgeInsets.all(4),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${index+1}"),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(treatment["name"] ?? "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                                Divider(),
                                Text("Ingredients", style: TextStyle(color: primaryColor, fontSize: 12),),
                                SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                            primary: false,
                                            shrinkWrap: true,
                                            itemCount: treatment["mtr"].length,
                                            itemBuilder: (context, index) {
                                              var mtr = treatment["mtr"][index];
                                              return Row(
                                                children: [
                                                  Text(">"),
                                                  SizedBox(width: 5,),
                                                  Text("${mtr["feed_item"]["name"]} ${mtr["quantity"]} ${mtr["feed_item"]["units"]}", style: TextStyle(fontSize: 12),),
                                                ],
                                              );
                                            },
                                          ),
                                ),

                                Text("Created On: ${makeDateShorter(treatment["created_at"] ?? "")}", style: TextStyle(fontSize: 11, color: secondaryColor), textAlign: TextAlign.end,),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}