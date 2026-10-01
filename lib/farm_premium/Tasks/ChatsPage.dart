import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsPage extends StatefulWidget {

  String? tag;
  ChatsPage({this.tag});

  @override
  _ChatsPageState createState() => _ChatsPageState(  tag: tag);
}

class _ChatsPageState extends State<ChatsPage> {

  String? tag;
  _ChatsPageState({this.tag});

  final TextEditingController _controller = TextEditingController();

  var _loading_comment = false;
  Future<void> _addComment() async {
    var prefs = await SharedPreferences.getInstance();
    var person_name = prefs.getString("person_name");
    var farm_id = prefs.getInt("farm_id");


    if (_controller.text.isNotEmpty) {

      //farm_id, tag, user_id, user_name, message,

        requestAPI("create_chat", {
          "farm_id": farm_id,
          "tag": tag,
          "user_id": person_id,
          "user_name": person_name,
          "message": _controller.text,
        }, (loading){
          setState(() {
            _loading_comment = loading;
          });
        }, (response){
          setState(() {
            _controller.text = "";
            getChats();
          });
        }, (){});

    }
  }


  @override
  void initState() {
    super.initState();
    getChats();
  }

  var person_id = 0;
  var chats = [];
  var _loading = false;
  getChats() async {
    var prefs = await SharedPreferences.getInstance();
    var farm_id = prefs.getInt("farm_id");
    person_id = prefs.getInt("person_id") ?? 0;

    var path = "get_chats";
    var data = {
      "tag": tag,
      "farm_id": farm_id,
    };
    var onProgress = (progress){
      setState(() {
        _loading = progress;
      });
    };
    var onSuccess = (data){
      setState(() {
        chats = data;
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
      appBar: AppBar(
        title: Text('Chats ($tag)'),
      ),
      body: Column(
        children: [
          Expanded(
            child:
            _loading ?
            Center(child: CircularProgressIndicator(),) :
            ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                var chat = chats[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                  child: Column(
                    crossAxisAlignment:  person_id == chat["user_id"] ? CrossAxisAlignment.end :  CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          child: Text( chat["user_name"] ?? "", style: TextStyle(color: Colors.white, fontSize: 10,), )),
                      Text( chat["message"] ?? "" , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15 ),),
                      Text( formatLaravelTime(chat["created_at"] ?? "") , style: TextStyle(fontSize: 10),),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0,left: 12,right: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                _loading_comment ?
                CircularProgressIndicator() :
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.send,size: 20, color: Colors.white, )),
                  onTap: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}