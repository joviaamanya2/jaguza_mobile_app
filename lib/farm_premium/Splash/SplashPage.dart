import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaguza_app/farm_premium/Access/SignInPage.dart';
import 'package:jaguza_app/farm_premium/Farm/FarmsPage.dart';
import 'package:jaguza_app/farm_premium/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget{
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() {
    return _SplashPage();
  }

}

class _SplashPage extends State<SplashPage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: bgColor,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(image: AssetImage(appIcon))
                      ),
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 20,),
                    const Text("Farm management & Tracking solution"),
                    GestureDetector(
                      onTap: (){
                        nextScreen();
                      },
                      child: Container(
                        margin: EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Continue", style: TextStyle(color: Colors.white),),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, size: 15, color: Colors.white,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Powered by", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.all(4),
                  width: 35,
                  height: 35,
                  child: Image(image: AssetImage("lib/assets/farm_premium/jaguza_icon_logo.png")),
                ),
                const Text("JAGUZA TECH", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              ],
            ),
          ],
        ),
      ),
    );
  }

  nextScreen() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("is_user_logged_in") == true ) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FarmsPage()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }
}