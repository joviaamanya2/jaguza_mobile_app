import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() {
    return _SignUpPage();
  }
  
}

class _SignUpPage extends State<SignUpPage>{
  
  final _formKey = GlobalKey<FormState>();

  var username;
  var email;
  var phone_number;
  var farm_name;
  var country;
  var farm_physical_address;
  var password;
  
  var showProgress = false;
  signUpAction() async {
    //check username, email, password and farm_name, cannot be enpty
    if(username == null || username == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Username cannot be empty"),));
      return;
    }
    if(email == null || email == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email cannot be empty"),));
      return;
    }
    if(farm_name == null || farm_name == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Farm Name cannot be empty"),));
      return;
    }
    if(country == null || country == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Country cannot be empty"),));
      return;
    }
    if(password == null || password == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Password cannot be empty"),));
      return;
    }



    setState(() {
      showProgress = true;
    });

    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    requestAPI("user_registration", {
      "name": username,
      "username": username,
      "email": email,
      "phone_number": phone_number,
      "farm_name": farm_name,
      "country": country,
      "farm_physical_address": farm_physical_address,
      "farm_address": farm_physical_address,
      "password": hashedPassword,
    }, (progress){
      setState(() {
        showProgress = progress;
      });
    }, (response){
      print(response);
      if(response["status_code"] == 200){
        Navigator.pushReplacementNamed(context, "/login");
      }
    }, (){
      setState(() {
        showProgress = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred, please try again later"),));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Welcome to the Family, Start by filling the details below to create an account"),
        SizedBox(height: 20,),
            Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
        
                        Text("User Information", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor ), textAlign: TextAlign.start,),
                        Divider(),
                        jaguzaTextField("Username", (value){ username = value; }, prefixIcon: Icons.person),
                        jaguzaTextField("Email", (value){ email = value; }, prefixIcon: Icons.email, keyboardType: TextInputType.emailAddress),
                        SizedBox(height: 20,),
                        Text("Farm Information", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor ), textAlign: TextAlign.start,),
                        Divider(),
                        jaguzaTextField("Farm Name", (value){ farm_name = value; }, prefixIcon: Icons.home),
                        jaguzaTextField("Country", (value){ country = value; }, prefixIcon: Icons.location_city),
                        jaguzaTextField("Farm Physical Address", (value){ farm_physical_address = value; }, prefixIcon: Icons.location_on),
                        jaguzaTextField("Password", (value){ password = value; }, prefixIcon: Icons.lock, keyboardType: TextInputType.visiblePassword),

                        SizedBox(height: 10,),
                        showProgress ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator(),),
                        ) :
                        jaguzaButton("Submit", (){
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState?.save();
                            //action();
                            signUpAction();
                          }
                        })
        
                    ],),
                    ),
                  ),
          ],),
        ),
      ),
    );
  }
}