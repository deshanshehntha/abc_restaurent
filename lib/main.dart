import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'views/auth/login.dart';
import 'views/auth/register.dart';
import 'views/menu/admin_menu_list.dart';
import 'views/menu/customer_menu_list.dart';
import 'views/menu/new_item.dart';
import 'views/user/user_profile.dart';
import 'views/menu/update_menu_item.dart';
import 'views/menu/description_page.dart';
import 'views/order/order_list.dart';

/// This is  the main class of the appication
/// This class contains the routers and
/// splash screens

/// Main routes of the application
void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => MyApp(),
  },
));

/// Main class of the application This contains the splash screen too
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String uid;
  String type;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  loadUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if( user.uid != null ){
      print("user not null");

      await Firestore.instance.collection("user").document(user.uid).get()
          .then((DocumentSnapshot doc){

        setState(() {
          uid = user.uid;
          type = doc.data['type'];
        });

        print(type);

      });

    }else{
      print("user null");
    }

  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new MaterialApp(
        title: 'Flutter Post App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.amberAccent),
        home: uid == null ? Register() : type == "admin" ?  MenuList() : CustomerMenuList(),
      ),

      title: new Text(
        'Abc Resturant',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 70.0,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.amber,
        ),
        textAlign: TextAlign.center,
      ),

      imageBackground: new AssetImage("assets/images/background.jpg"),
      backgroundColor: Colors.amber,
      styleTextUnderTheLoader: new TextStyle(),
      loaderColor: Colors.amber,
    );
  }
}



//'/': (context) => MyApp(),