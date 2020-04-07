import 'package:flutter/material.dart';
import 'views/menu/menu_list.dart';

void main() => runApp(MaterialApp(

  initialRoute: '/menu_list',

  routes: {
    '/' : (context) => MyApp(),
    '/menu_list' : (context) => MyApp()
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

