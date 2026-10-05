import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

class OthersPage extends StatefulWidget {
  dynamic task;
  OthersPage({super.key, required this.task});

  @override
  State<OthersPage> createState() => _OthersPageState( task: task);
}

class _OthersPageState extends State<OthersPage> {

  dynamic task;
  _OthersPageState({required this.task});

  var task_contacts = [];
  var task_header;

  @override
  void initState() {
    super.initState();
    task_header = task["contact"];
    task_contacts = task["task_contacts"];

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Others Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Headed by',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child:
              (task_header == null) ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("No Contact allocated", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold), )),
              ) :
              Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Display As: ${task_header["display_as"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                      Text("Title: ${task_header["title"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor ),),
                      Text("Phone Number: ${task_header["phone_number"] ?? ""}", style: TextStyle(fontSize: 12),),
                      if(task_header["address"] != null)
                        Text("Address: ${task_header["address"]+", "+"${task_header["city"]}" ?? ""}", style: TextStyle(fontSize: 12),),
                      Text("Email: ${task_header["email"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold ),),
                      Text("Type: ${task_header["type"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor ),),
                      Text("Comment: ${task_header["comment"] ?? ""}", style: TextStyle(fontSize: 12 ),),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Others',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
          
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: task_contacts.length,
                itemBuilder: (context, index) {

                  var treatment = task_contacts[index]["contact"];

                  return Card(
                    child:  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("${treatment["first_name"] ?? ""} ${treatment["last_name"] ?? ""} (${treatment["title"] ?? ""})", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                        Divider(),
                        Text("Phone Number: ${treatment["phone_number"] ?? ""}", style: TextStyle(fontSize: 12),),
                        if(treatment["address"] != null)
                                        Text("Address: ${treatment["address"]+", "+"${treatment["city"]}" ?? ""}", style: TextStyle(fontSize: 12),),
                                        Text("Type: ${treatment["type"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor ),),
                                        ],
                                        ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

