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
  initialRoute: '/customer_menus_list',
  routes: {

    '/menu_list': (context) => MyApp(),
    '/login': (context) => Login(),
    '/register': (context) => Register(),
    '/new_item': (context) => Item(),
    '/user_profile': (context) => UserProfile(),
    '/customer_menus_list': (context) => CustomerMenuList(),
    '/updateItem': (context) => UpdateItem(),
    '/description_page': (context) => DescriptionPage(),
    '/orders': (context) => OrderList()

  },
));

/// Main class of the application This contains the splash screen too
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 4,
      navigateAfterSeconds: new MaterialApp(
        title: 'Flutter Post App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.amberAccent),
        home: Register(),
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