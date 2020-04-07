
import 'package:flutter/material.dart';
import 'views/menu/menu_list.dart';
import 'views/auth/login.dart';
import 'views/auth/register.dart';
import 'views/menu/new_item.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/login',

  routes: {
    '/' : (context) => MyApp(),
    '/menu_list' : (context) => MyApp(),
    '/login' : (context) => Login(),
    '/register' : (context) => Register(),
    '/new_item' : (context) => Item()
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

