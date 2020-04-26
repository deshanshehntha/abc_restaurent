import 'package:awesome_project/views/auth/register.dart';
import 'package:awesome_project/views/menu/admin_menu_list.dart';
import 'package:awesome_project/views/menu/customer_menu_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final formKey = new GlobalKey<FormState>();

  String email;
  String password;
  String uid;
  String type;

  redirectUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    if( user.uid != null ){
      print("user not null");

      await Firestore.instance.collection("user").document(user.uid).get()
          .then((DocumentSnapshot doc){

        setState(() {
          uid = user.uid;
          type = doc.data['type'];
        });

        if( type == "admin" ){
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => MenuList()
              )
          );
        }else{
          Navigator.of(context).pop();
          Navigator.push(context,
              MaterialPageRoute(
                  builder: (context) => CustomerMenuList()
              )
          );
        }

      });

    }else{
      print("user null");
    }

  }

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



  @override
  void initState() {

    super.initState();

  }

  void toRegister(){
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Register()
        )
    );

  }

  void validateAndSubmit() async {
    if(validateAndSave()){

      try{
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user; // get the firebase user from the AuthResult

        print('Signed in ${user.uid} ');

        redirectUser();
      }catch(e){
        print('Exception : $e' );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title : Text('Login'),
        elevation: 0,
      ),
      body:  SingleChildScrollView(
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
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[

                  Container(
                    margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
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
                            "Login",
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
                    margin: EdgeInsets.fromLTRB(0, 18, 0, 150),
                    padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                    child: RaisedButton(
                      color: Colors.black54,
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      onPressed: toRegister,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Create a new Account",
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
        )
      )
    );
  }
}
