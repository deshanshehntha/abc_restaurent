///Student ID : IT17103732
///Name : Silva N.P.S
///Register class that performs all the registration of user activities

import 'package:awesome_project/views/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../menu/customer_menu_list.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final formKey = new GlobalKey<FormState>();

  String firstName;
  String lastName;
  String email;
  String password;
  String telephone;

  ///function to validate the form
  ///returns false if the validation conditions are not met
  bool validateAndSave(){
    final form = formKey.currentState;

    if( form.validate() ){
      form.save();
      return true;
      print('Form is valid $email and $password ');
    }else{
      print('Form is invalid $email and $password ');
      return false;
    }
  }

  ///function to redirect to Login Page
  void toLogin(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Login()
        )
    );
  }

  ///function to create the user account with email and password
  void validateAndSubmit() async {
    if(validateAndSave()){

      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user; /// get the firebase user from the AuthResult

        print('Signed in ${user.uid} ');

        saveUserDetails(user.uid); ///store the respective data after registering

        Navigator.of(context).pop();
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => CustomerMenuList()
            )
        );

      }catch(e){
        print('Exception : $e' );
      }

    }
  }

  ///function to save the user data into the Firebase Firestore
  void saveUserDetails(String uid ) async{
    DocumentReference docRef =  await Firestore.instance.collection("user").document(uid);

    Map<String,dynamic> userMap = {
      "firstName" : firstName,
      "lastName" : lastName,
      "telephone" : telephone,
      "type" : "customer"
    };

    docRef.setData(userMap).whenComplete((){
      Navigator.of(context).pop();
      Navigator.pushNamed(context, '/menu_list');
    });
  }

  ///Flutter build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title : Text('Register'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
                image: AssetImage('assets/images/intro_background.jpg'),
                fit: BoxFit.fill),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child:  Form(
              key : formKey,
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 90, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),

                      child: Image(
                        image : AssetImage('assets/images/main_logo.png'),
                        width: 90,
                        height: 90,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "First Name",
                            filled: true,
                            hoverColor: Colors.grey,
                            fillColor: Colors.white,
                            focusColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            prefixIcon: new Icon(Icons.person_pin)

                        ),

                        validator: (
                                (value)=> value.isEmpty ? 'Firstname cannot be empty ' : null
                        ),

                        onSaved: (value) => firstName = value.trim(),

                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Last Name",
                            filled: true,
                            hoverColor: Colors.grey,
                            fillColor: Colors.white,
                            focusColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            prefixIcon: new Icon(Icons.person_pin)

                        ),

                        validator: (
                                (value)=> value.isEmpty ? 'Last cannot be empty ' : null
                        ),

                        onSaved: (value) => lastName = value.trim(),

                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            filled: true,
                            hoverColor: Colors.grey,
                            fillColor: Colors.white,
                            focusColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            prefixIcon: new Icon(Icons.mail)

                        ),

                        validator: (
                                (value)=> value.isEmpty ? 'Email cannot be empty ' : null
                        ),

                        onSaved: (value) => email = value.trim(),

                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            filled: true,
                            hoverColor: Colors.grey,
                            fillColor: Colors.white,
                            focusColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            prefixIcon: new Icon(Icons.vpn_key)

                        ),

                        validator: (
                                (value)=> value.isEmpty ? 'Password cannot be empty ' : null
                        ),

                        onSaved: (value) => password = value.trim(),
                        obscureText: true,
                      ),
                    ),


                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Telephone",
                            filled: true,
                            hoverColor: Colors.grey,
                            fillColor: Colors.white,
                            focusColor: Colors.grey,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            prefixIcon: new Icon(Icons.phone)

                        ),

                        validator: (
                                (value)=> value.isEmpty ? 'Telephone cannot be empty ' : null
                        ),

                        onSaved: (value) => telephone = value.trim(),

                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: RaisedButton(
                        color: Colors.amberAccent,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        onPressed: validateAndSubmit,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color : Colors.black54,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        shape: StadiumBorder(),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      child: RaisedButton(
                        color: Colors.black54,
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        onPressed: toLogin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Login to Account",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color : Colors.white,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        shape: StadiumBorder(),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
      )
    );
  }
}
