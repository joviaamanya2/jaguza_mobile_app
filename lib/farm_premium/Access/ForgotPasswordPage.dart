import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

class ForgotPasswordPage extends StatefulWidget{
  @override
  State<ForgotPasswordPage> createState() {
    return _ForgotPasswordPage();
  }
  
}

class _ForgotPasswordPage extends State<ForgotPasswordPage>{

  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password"),),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("Please provide email address that was used during account creation to check for your jaguza farm account."),
            jaguzaTextField("Email", (value){
              email = value;
            }),
            jaguzaButton("CHECK ACCOUNT", (){
              print("Email: $email");
            }),
          ],
        ),
      ),
    );
  }
}