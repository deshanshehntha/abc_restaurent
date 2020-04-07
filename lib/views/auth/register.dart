import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void toLogin(){
    Navigator.pushNamed(context, '/login');
  }

  void validateAndSubmit() async {
    if(validateAndSave()){

      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user; // get the firebase user from the AuthResult

        print('Signed in ${user.uid} ');

        saveUserDetails(user.uid);
      }catch(e){
        print('Exception : $e' );
      }

    }
  }


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title : Text('Register'),
        elevation: 0,
      ),
      body:  Container(
        padding: EdgeInsets.all(16.0),
        child:  Form(
          key : formKey,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[


              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Firstname'
                ),
                validator: (
                        (value)=> value.isEmpty ? 'Firstname cannot be empty ' : null
                ),

                onSaved: (value) => firstName = value.trim(),
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Lastname'
                ),
                validator: (
                        (value)=> value.isEmpty ? 'Lastname cannot be empty ' : null
                ),

                onSaved: (value) => lastName = value.trim(),
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email'
                ),
                validator: (
                        (value)=> value.isEmpty ? 'Email cannot be empty ' : null
                ),

                onSaved: (value) => email = value.trim(),
              ),


              TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Password',
                ),
                validator: (
                        (value)=> value.isEmpty ? 'Paswword cannot be empty ' : null
                ),
                onSaved: (value) => password = value.trim(),
                obscureText: true,
              ),

              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Telephone'
                ),
                validator: (
                        (value)=> value.isEmpty ? 'Telephone cannot be empty ' : null
                ),

                onSaved: (value) => telephone = value.trim(),
              ),

              RaisedButton(
                child: Text(
                  'Register',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),

                onPressed: validateAndSubmit,
              ),

              RaisedButton(
                child: Text(
                  'Login to Account',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),

                onPressed: toLogin,
              )

            ],
          ),
        ),
      ),
    );
  }
}
