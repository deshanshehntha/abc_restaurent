import 'package:awesome_project/views/menu/admin_menu_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../menu/new_item.dart';
import '../user/user_profile.dart';
import '../auth/login.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int currIndex = 0;
  final List<Widget> children = [];

  void signOutUser() async{
    await FirebaseAuth.instance.signOut();
  }

  void onTappedBar(int index){
    setState(() {
      currIndex = index;
    });

    switch(index){
      case 0 :  Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MenuList(),
              fullscreenDialog: true
          )
      );
      break;

      case 1 :   Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => UserProfile(),
              fullscreenDialog: true
          )
      );
      break;

      case 2 :  signOutUser();
      Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => Login(),

          )
      );
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      onTap: onTappedBar,
      currentIndex: currIndex,
      items: [

        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          title: Text(
              "Menu"
          ),

        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(
                "Account"
            )
        ),

        BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            title: Text(
                "Sign Out"
            )
        )
      ],
    );
  }
}
