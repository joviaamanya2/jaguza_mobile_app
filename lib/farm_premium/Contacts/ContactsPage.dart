import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/Helper.dart';
import 'AddContactPage.dart';

class ContactsPage extends StatefulWidget{

  var select_contact = false;
  ContactsPage({this.select_contact = false});

  @override
  State<ContactsPage> createState() {
    return _ContactsPage();
  }

}

class _ContactsPage extends State<ContactsPage>{

  var select_contact = false;
  _ContactsPage({this.select_contact = false});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initRequests();
  }

  var contacts = [];
  var showContactsProgress = false;

  initRequests() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");
    print(farm_id);

    var path = "get_contacts";
    var data = {
      "farm_id": farm_id,
    };
    var onProgress = (progress){
      setState(() {
        showContactsProgress = progress;
      });
    };
    var onSuccess = (data){
      print("treatment");
      print(data);
      setState(() {
        contacts = data;
      });
    };
    var onError = (){
      print("Error:");
    };
    requestAPI(path, data, onProgress, onSuccess, onError);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts"),),
      body: Column(
        children: [
          if (showContactsProgress)
            Center(child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularProgressIndicator(),
            )),

          if (contacts.length == 0 && !showContactsProgress)
            Center(child: Text("No contacts yet")),

          Expanded(
            child: ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index){
                var treatment = contacts[index];
                print(treatment['periodic_payment']);
                return GestureDetector(
                  onTap: (){
                    if(widget.select_contact){
                      Navigator.pop(context, treatment);
                    }
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
                              child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Display As: ${treatment["display_as"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                                      Text("Title: ${treatment["title"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor ),),
                                      Text("Phone Number: ${treatment["phone_number"] ?? ""}", style: TextStyle(fontSize: 12),),
                                      if(treatment["address"] != null)
                                      Text("Address: ${treatment["address"]+", "+"${treatment["city"]}" ?? ""}", style: TextStyle(fontSize: 12),),
                                    Text("Email: ${treatment["email"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold ),),
                                      Text("Type: ${treatment["type"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor ),),
                                Text("Comment: ${treatment["comment"] ?? ""}", style: TextStyle(fontSize: 12 ),),
                             Padding(
                               padding: const EdgeInsets.symmetric(vertical: 8.0),
                               child: Divider(
                                color: Colors.black,
                                height: 10,
                                thickness: 1,
                                indent: 0,
                                endIndent: 0,
                               ),
                             ),
                  Text("Record: ${treatment["status"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: secondaryColor ),),


                              Text("Amount: ${treatment["periodic_payment"] ?? ""}", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: secondaryColor ),)


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
          addContact();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> addContact() async {
    var refresh = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddContactPage()));
    if(refresh != null){
      initRequests();
    }
  }
}