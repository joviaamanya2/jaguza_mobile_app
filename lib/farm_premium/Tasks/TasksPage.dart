import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Tasks/OthersPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/Helper.dart';
import 'ChatsPage.dart';

class TasksPage extends StatefulWidget{
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() {
    return _TasksPage();
  }

}

class _TasksPage extends State<TasksPage>{



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequests();
  }

  var tasks = [];
  var showTasksProgress = false;

  initRequests() async {
    var prefs = await SharedPreferences.getInstance();
    var farmId = prefs.getInt("farm_id");
    print(farmId);

    var path = "get_tasks";
    var data = {
      "farm_id": farmId,
    };
    void onProgress(progress){
      setState(() {
        showTasksProgress = progress;
      });
    }
    void onSuccess(data){
      print("treatment");
      print(data);
      setState(() {
        tasks = data;
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
      appBar: AppBar(title: Text("Tasks"),),
      body: Column(
        children: [
          if (showTasksProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (tasks.isEmpty && !showTasksProgress)
            Center(child: Text("No tasks yet")),

          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index){
                var task = tasks[index];

                var taskContacts = [];
                taskContacts = task["task_contacts"];

                print(task["task_contacts"]);
                print(task["task_contacts"]);

                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Text("${index+1}. "),
                          Expanded(child: Text(task["name"] ?? "", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: (task["completed"] ?? "") == "yes" ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: (task["completed"] ?? "") == "yes" ? Text("Done", style: TextStyle(color: Colors.white, fontSize: 12),) : Text("Pending", style: TextStyle(color: Colors.white, fontSize: 12),)),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    if( task["details"] != null )
                                    Text(task["details"] ?? "", style: TextStyle( fontSize: 12),),
                                    Text("Priority: ${task["priority"] ?? ""}", style: TextStyle(fontSize: 12),),
                                    Text("Category: ${task["category"] ?? ""}", style: TextStyle(fontSize: 12),),

                                    if(task["picture"] != null)
                                    GestureDetector(
                                        onTap: (){
                                            var pictureUrl = task["picture_url"] ?? "";
                                            //open url from browser
                                            _launchUrlLink(pictureUrl);
                                        },
                                        child: Text("Open Attachment: ${task["picture"] ?? ""}", style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold),)),

                                    Divider(),

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Created On", style: TextStyle(fontSize: 11, color: secondaryColor)),
                                              Text(makeDateShorter(task["created_at"] ?? ""), style: TextStyle(fontSize: 11, color: Colors.black)),
                                            ],
                                          ),
                                        ),Expanded(
                                          child: Column(
                                            children: [
                                              Text("Reminder On", style: TextStyle(fontSize: 11, color: secondaryColor)),
                                              Text((task["reminder_date"] ?? ""), style: TextStyle(fontSize: 11, color: Colors.black)),
                                            ],
                                          ),
                                        ),Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text("Due Date", style: TextStyle(fontSize: 11, color: secondaryColor)),
                                              Text((task["due_date"] ?? ""), style: TextStyle(fontSize: 11, color: Colors.black)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    if(task["contact"] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(right:8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Divider(),
                                          Text("Headed By", style: TextStyle(fontSize: 12),),
                                          Text("Name: ${task["contact"]["display_as"] ?? ""} (${task["contact"]["title"] ?? ""})", style: TextStyle(fontSize: 12),),
                                          Text("Phone: ${task["contact"]["phone_number"] ?? ""}", style: TextStyle(fontSize: 12),),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => OthersPage(task: task,)));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Row(
                                          children: [
                                            Text("Others People (${ taskContacts.length })", style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),),
                                            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.red,),
                                          ],
                                        ),
                                      ),
                                    ),
                                     SizedBox(height: 10,),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(Icons.chat_bubble_outline_outlined, color: Colors.white,size: 15,),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChatsPage(tag: "task-${ task["id"] }"  , ))),
                child: Container(
                    padding: EdgeInsets.all(4),
                    child: Text("Chat/Talk", style: TextStyle(color: Colors.white),))),
            ],),
          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
         
        ],
      ),
    
    );
  }

  Future<void> _launchUrlLink(String urlLink) async {
    final Uri url = Uri.parse(urlLink);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}