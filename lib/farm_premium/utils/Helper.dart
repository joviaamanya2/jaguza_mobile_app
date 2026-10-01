
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

String appIcon = "lib/assets/farm_premium/jaguza_logo.png";
String appName = "JaguzaPremium";
Color primaryColor = Color(0xFF27ae60);
Color secondaryColor = Color(0xFFf5b041);
Color bgColor = Color(0xFFfbfcfc);



//String appName = "Blessed Love Farm";
//String appIcon = "assets/blessed-love-farm-masajja-icon.jpg";
//Color primaryColor = Color(0xFF18caea);
//Color secondaryColor = Color(0xFFf5b041);
//Color bgColor = Color(0xFFd2eef3);


var boxDecoration = BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(5),);
InputDecoration inputDecoration(String hintText){
  return InputDecoration(
    contentPadding: const EdgeInsets.all(4),
    hintText: hintText,
    isDense: true,
    border: const OutlineInputBorder( borderSide: BorderSide.none, ), filled: false, // Needed to respect the background color
  );
}

Widget jaguzaButton(String text, Function() onPressed){
  return  GestureDetector(
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.all(4),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text( text, textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black ),),
    ),
    onTap: (){
      onPressed();
    },
  );
}

Widget jaguzaTextField(String text,  Function(String) onSaved,{ IconData? prefixIcon, keyboardType = TextInputType.text}){
  return Container(
    margin: EdgeInsets.all(1),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
          child: Text("$text", style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold),),
        ),
        Container(
          decoration: boxDecoration,
          width: double.infinity,
          child: TextFormField(
            decoration: inputDecoration("Type $text here").copyWith(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon,) : null,
            ),
            keyboardType: keyboardType,
            onSaved: (value){
              onSaved(value!);
            },
          ),
        ),
      ],
    ),
  );
}





void showSnackBar(BuildContext context, String message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void logoutPerson(context) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setBool("is_user_logged_in", false);
  Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
}

void savePersonInPreference(person) async {
  var preferences = await SharedPreferences.getInstance();
  preferences.setBool("is_user_logged_in", true);
  preferences.setInt("person_id", person["id"] as int);
  preferences.setString("person_name", person["name"] as String? ?? "");
  preferences.setString("person_email_address", person["email_address"] as String? ?? "");
  preferences.setString("person_created_at", person["created_at"] as String? ?? "");
}

String formatLaravelTime(String created_at){
  var date = DateTime.parse(created_at);
  return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
}


String formatNumberWithCommas(String number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(int.parse(number));
}

String makeDateShorter(String date){
  try {
    var dateObj = DateTime.parse(date);
    return "${dateObj.day}/${dateObj.month}/${dateObj.year}";
  } catch (e) {
    return date;
  }
  }

















 var baseUrl = "https://backend.jaguzalivestockug.com/api/";
 var imageUrl = "https://backend.jaguzalivestockug.com/images/";



void requestAPI( String path, data, Function(bool) onProgress, Function(dynamic) onSuccess, Function() onError){
  final dio = Dio();

  onProgress(true);
  dio.post(baseUrl + path, data: data )
      .then((response) {
    print(response.data);
    onProgress(false);
    onSuccess(response.data);
  }).catchError((error){
    print(error);
    onError();
  });

}

void requestGetAPI(String path, Map<String, dynamic> params, Function(bool) onProgress, Function(dynamic) onSuccess, Function() onError) {
  final dio = Dio();
  onProgress(true);
  dio.get(baseUrl + path, queryParameters: params)
      .then((response) {
    onProgress(false);
    onSuccess(response.data);
  }).catchError((error) {
    onProgress(false);
    onError();
  });
}


Future<void> _launchUrlLink(String url_link) async {
  final Uri _url = Uri.parse(url_link);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}


















var APP_URL_BASE  = "https://weedo.cresteddevelopers.com/api/";
var APP_URL_FILE  = "https://weedo.cresteddevelopers.com/images/";

var skip_verification = true;

var mainColorDark = Color(0xFFd1711a);
var subColor = Color(0xFF9747FF);
var minorColor = Color(0xFF203868);
var headerColor = Color(0xFFFABA4A);
var otibeeBlue = Color(0xFF2980b9);


var mainColor = Color(0xff151515);
var popColor = Color(0xffdd1e1e);

//measurements
var smallMargin = 5.0;


Future<String> getSharedPreference(String key) async {
  var preferences =  await SharedPreferences.getInstance();
  return preferences.getString(key) ?? "";
}




void saveToken(token,token_type) async {
  print("Saving person in preference");
  var preferences = await SharedPreferences.getInstance();
  preferences.setBool("is_user_logged_in", true);

  preferences.setString("token", token);
  preferences.setString("token_type", token_type);
}



computeProductDiscountPercentage( product) {
  var price = double.parse(product['price']);
  var oldPrice = product['old_price'];
  var discount = 0.0;

  if (oldPrice > price) {
    discount = ((oldPrice - price) / oldPrice) * 100;
  }

  return discount.round();

}



String getDurationFromNow(String dateTimeString) {
  // Define the date format
  DateFormat dateTimeFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");

  // Parse the input date string
  DateTime pastDateTime = dateTimeFormatter.parse(dateTimeString);
  DateTime now = DateTime.now();

  // Calculate the duration
  Duration duration = now.difference(pastDateTime);

  // Return appropriate time ago string
  if (duration.inDays >= 30) {
    int months = (duration.inDays / 30).floor();
    return "$months months ago";
  } else if (duration.inDays >= 1) {
    return "${duration.inDays} days ago";
  } else if (duration.inHours >= 1) {
    return "${duration.inHours} hours ago";
  } else if (duration.inMinutes >= 1) {
    return "${duration.inMinutes} minutes ago";
  } else {
    return "${duration.inSeconds} seconds ago";
  }
}




Widget artyTechButtonFilled(String text, Function() onPressed){
  return GestureDetector(
    onTap: onPressed,
    child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(13),
        margin: EdgeInsets.all(smallMargin),
        child: Center(child: Text(text, style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold, fontSize: 17),))),
  );
}

Widget artyTechButtonOvalFilled(String text, Function() onPressed){
  return GestureDetector(
    onTap: onPressed,
    child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        width: double.infinity,
        decoration: BoxDecoration(
          color: mainColor,
          border: Border.all(color: mainColor, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.all(10),
        child: Text(text, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)),
  );
}

artyTechPickPicture( BuildContext context, Function(String) onSuccess) async {

  /*
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>

            //add ios permissions
            */

  finishPicking(String path) async {
    if(path == ""){
      onSuccess("");
      return;
    }

    // The standalone app cropped to a square here; the Jaguza app has no
    // image_cropper dependency, so the picked image is passed through as-is.
    onSuccess(path);
  }

  final ImagePicker _picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Picture'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                await _picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  finishPicking(image.path);
                } else {
                  finishPicking("");
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  finishPicking(image.path);
                } else {
                  finishPicking("");
                }
              },
            ),
          ],
        ),
      );
    },
  );
}


final formatCurrency = NumberFormat.currency(locale: "en_US", symbol: "UGX", decimalDigits: 0);


Widget artyTechTextInput(String text,  Function(String) onSaved,{ IconData? prefixIcon, keyboardType = TextInputType.text, String? currentValue }){
  return Container(
    margin: EdgeInsets.all(smallMargin),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
          child: Wrap(
            children: [
              Text("$text", style: TextStyle(color: mainColor, fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              if( currentValue != null )
                Text("Current: $currentValue", style: TextStyle(fontSize: 12, color : Colors.green ),),
            ],
          ),
        ),
        Container(
          decoration: boxDecoration,
          width: double.infinity,
          child: TextFormField(
            decoration: inputDecoration("Type $text here").copyWith(
              prefixIcon: prefixIcon != null ? Icon(prefixIcon,) : null,
            ),
            keyboardType: keyboardType,
            onSaved: (value){
              onSaved(value!);
            },
          ),
        ),
      ],
    ),
  );
}


Widget artyTechDropDown(String text, String current,  dynamic items , Function(String) onSaved,{ IconData? prefixIcon, keyboardType = TextInputType.text, String? currentValue }){
  var children = [];
  children = items;
  return Container(
    margin: EdgeInsets.all(smallMargin),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
          child: Wrap(
            children: [
              Text("$text", style: TextStyle(color: mainColor, fontSize: 15, fontWeight: FontWeight.bold),),
              SizedBox(width: 5,),
              if( currentValue != null )
                Text("Current: $currentValue", style: TextStyle(fontSize: 12, color : Colors.green ),),
            ],
          ),
        ),

        ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: (){
                        current = children[index];
                        onSaved(current!);
                      },
                      child: Container(
                          decoration: boxDecoration,
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(2),
                          width: double.infinity,
                          child: Row(
                            children: [
                              if(current == children[index])
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.check, color: Colors.orange,size: 23,),
                                ),
                              Text(children[index]),
                            ],
                          )),
                    );
                  },
                ),




      ],
    ),
  );
}

Widget artyTechTextArea(String text,  Function(String) onSaved){
  return Container(
    height: 100,
    margin: EdgeInsets.all(smallMargin),
    decoration: boxDecoration,
    width: double.infinity,
    child: TextFormField(

      maxLines: 5,
      decoration: inputDecoration(text),
      onSaved: (value){
        onSaved(value!);
      },
    ),
  );
}

Widget artyTechErrorWidget(String text){
  return Center(child: Text(text, style: TextStyle(color: Colors.red),),);
}

Widget artyTechButtonOvalStroke(String text, Function() onPressed){
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: mainColor, width: 2),
      ),
      padding: EdgeInsets.all(10),
      child: Text(text, style: TextStyle(color: mainColor, fontWeight: FontWeight.bold, fontSize: 16),), alignment: Alignment.center,),
  );
}


String requestFile(String path){
  if(path.startsWith("http")){
    return path;
  }
  return APP_URL_FILE + path;
}

Future<void> artyRequestAPI( String path, data, Function(bool) onProgress, Function(dynamic) onSuccess, Function(dynamic) onError, {String method = "POST"}) async {
  var dio;
  var full_path = "";

  //if path starts with http
  if (path.startsWith("http")) {
    full_path = path;
  } else {
    full_path = APP_URL_BASE + path;
  }

  /*var pref = await SharedPreferences.getInstance();
  var token = pref.getString("token") ?? "";
  var options = Options(
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
    headers: {
      "Authorization": "Bearer $token",
    },);
*/
  try {
    print(full_path);

    onProgress(true);
    if (method == "POST") {
      dio = Dio().post(
        full_path, data: FormData.fromMap(data),);
    } else if (method == "GET") {
      dio = Dio().get(full_path, queryParameters: data);
    } else if (method == "PUT") {
      dio = Dio().put(full_path, data: data);
    } else if (method == "DELETE") {
      dio = Dio().delete(full_path, data: data);
    }

    var response = await dio;

    //print(response.data);
    onProgress(false);
    print(response.data);
    onSuccess(response.data);

  } on DioException catch (error) {
    onProgress(false);
    //print(error.message);
    print(error.type);
    print(error.response?.data);
    onError(error.response?.data);

  }
}

Color hexToColor(String color) {
  String hexColor = color.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor; // Add default alpha value
  }
  return Color(int.parse(hexColor, radix: 16));
}

BoxDecoration borderBoxDecoration(){
  return BoxDecoration(
    border: Border.all(color: Colors.grey, width: 1),
    borderRadius: BorderRadius.circular(5),
  );
}

helperSelectDate(BuildContext context, Function(String) onDate ) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (pickedDate != null) {
    String _date = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    onDate(_date);
  }
}


