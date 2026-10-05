import 'package:jaguza_app/farm_premium/FarmRequests/AddFarmRequestsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmRequestsPage extends StatefulWidget{
  const FarmRequestsPage({super.key});

  @override
  State<FarmRequestsPage> createState() {
    return _FarmRequestsPage();
  }

}

class _FarmRequestsPage extends State<FarmRequestsPage>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequests();
  }

  var requests = [];
  var showRequestsProgress = false;

  initRequests() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    print(farmId);

    var path = "get_farm_request";
    var data = {
      "farm_id": farmId,
    };
    void onProgress(progress){
      setState(() {
        showRequestsProgress = progress;
      });
    }
    void onSuccess(data){
      print("treatment");
      print(data);
      setState(() {
        requests = data;
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
      appBar: AppBar(title: Text("Farm Needs/Requests"),),
      body: Column(
        children: [
          if (showRequestsProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (requests.isEmpty && !showRequestsProgress)
            Center(child: Text("No requests yet")),

          Expanded(
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, index){
                var request = requests[index];
                return GestureDetector(
                  onTap: (){
                    dialogToCompleteAndRemoveRequest(request);
                  },
                  child: Container(
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
                                  Text(request["comment"] ?? "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                                  Text("Status: ${request["status"] ?? ""}", style: TextStyle(fontSize: 12),),
                                  Text("Created On: ${makeDateShorter(request["created_at"] ?? "")}", style: TextStyle(fontSize: 11, color: secondaryColor), textAlign: TextAlign.end,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            addRequest();
          },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addRequest() async {
    var refresh = await  Navigator.push(context, MaterialPageRoute(builder: (context) => AddFarmRequestsPage() ) );
    if (refresh == true) {
      initRequests();
    }
  }

  void dialogToCompleteAndRemoveRequest(request) {
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          content: Text("Menu"),
          actions: [
            TextButton(
              onPressed: (){
                update_farm_request(request);
                Navigator.pop(context);
              },
              child: Text("Mark as Completed"),
            ),
            TextButton(
              onPressed: (){
delete_farm_request(request);
Navigator.pop(context);
              },
              child: Text("Remove",style: TextStyle(color: Colors.red),),
            ),

            //cancel
            TextButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text("Cancel", style: TextStyle(color: Colors.grey),),
            ),
          ],
        );
      }
    );
  }

  Future<void> update_farm_request(request) async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("update_farm_request", {
      "farm_id": farmId,
      "request_id": request["id"],
      "status" : "completed"
    }, (progress){
      setState(() {
        showRequestsProgress = progress;
      });
    }, (response){
      setState(() {
        if( response["status_code"] == 200 ){
          var statusMessage = response["status_message"];
          showSnackBar(context, statusMessage);
          initRequests();
        } else {

        }
      });}, (){
      print("Error:");
    });

  }
  Future<void> delete_farm_request(request) async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");

    requestAPI("delete_farm_request", {
      "farm_id": farmId,
      "request_id": request["id"],
    }, (progress){
      setState(() {
        showRequestsProgress = progress;
      });
    }, (response){
      setState(() {
        if( response["status_code"] == 200 ){
          var statusMessage = response["status_message"];
          showSnackBar(context, statusMessage);
          initRequests();
        } else {

        }
      });}, (){
      print("Error:");
    });

  }
}