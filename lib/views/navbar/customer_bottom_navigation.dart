import 'package:awesome_project/views/menu/admin_menu_list.dart';
import 'package:awesome_project/views/menu/customer_menu_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../menu/new_item.dart';
import '../user/user_profile.dart';
import '../auth/login.dart';

class CustomerBottomNavigation extends StatefulWidget {

  final int input;

  CustomerBottomNavigation({Key key, this.input}) : super(key : key);

  @override
  _CustomerBottomNavigationState createState() => _CustomerBottomNavigationState( input );
}

class _CustomerBottomNavigationState extends State<CustomerBottomNavigation> {

  int currIndex = 0;

  _CustomerBottomNavigationState( int input ){
    print(input);

    currIndex = input;
  }

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
              builder: (context) => CustomerMenuList(),
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
