import 'package:flutter/material.dart';
import 'views/menu/admin_menu_list.dart';
import 'views/auth/login.dart';
import 'views/auth/register.dart';
import 'views/menu/new_item.dart';
import 'views/user/user_profile.dart';
import 'views/menu/customer_menu_list.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/menu_list',

  routes: {
    '/' : (context) => MyApp(),
    '/menu_list' : (context) => MyApp(),
    '/login' : (context) => Login(),
    '/register' : (context) => Register(),
    '/new_item' : (context) => Item(),
    '/user_profile' : (context) => UserProfile(),
    '/customer_menus_list' : (context) => CustomerMenuList()
  },

));

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Post App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.amberAccent),
      home: MenuList(title: 'Flutter Post'),
    );
  }
}

