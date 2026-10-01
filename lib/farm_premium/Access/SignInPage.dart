import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Access/ForgotPasswordPage.dart';
import 'package:jaguza_app/farm_premium/Access/SignUpPage.dart';
import 'package:jaguza_app/farm_premium/Home/HomeOwnerPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

import '../Farm/FarmsPage.dart';

class SignInPage extends StatefulWidget{
  @override
  State<SignInPage> createState() {
    return _SignInPage();
  }

}

class _SignInPage extends State<SignInPage>{

  var _formKey = GlobalKey<FormState>();

  String? email;
  String? password;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(35),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Container(
                  width: 120,
                  height: 120,decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(image: AssetImage(appIcon))
                ),
                ),

                SizedBox(height: 20,),

                Text("Welcome to ${appName.toUpperCase()} Management platform. Please login to your registered farm account", textAlign: TextAlign.center,),

                Form(
                        key: _formKey,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(children: [

                            jaguzaTextField("Email", (value){
                              email=value;
                            }, prefixIcon: Icons.email, keyboardType: TextInputType.emailAddress),
                            jaguzaTextField("Password", (value){
                              password=value;
                            }, prefixIcon: Icons.lock, keyboardType: TextInputType.visiblePassword),

                            SizedBox(height: 10,),

                            showProgress ? Container(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator()) :
                            jaguzaButton("Login", (){
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
                                action();
                                 //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeOwnerPage() ) );
                              }
                            }),
                        ],),
                        ),
                      ),


                GestureDetector(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Forgot Password ?"),
                ), onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage() ) );
                },),

                SizedBox(height: 40,),
                GestureDetector(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage() ) );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("New Here? Create an Account", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),)
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  var showProgress = false;
  void action() {
    requestAPI( "login", {
      "username": email,
      "password": password
    }, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      if(response["status_code"] == 200){
        savePersonInPreference(response["user"]);
        Navigator.push(context, MaterialPageRoute(builder: (context) => FarmsPage() ) );
      }else{
        showSnackBar(context, response["status_message"]);
      }
    }, (){

    }
    );
  }
}