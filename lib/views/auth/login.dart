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

  void getLoggedUser() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    print('Signed in user  ${user.uid} ');
  }

  @override
  void initState() {

    super.initState();

    getLoggedUser();

  }

  void toRegister(){
    Navigator.pushNamed(context, '/register');
  }

  void validateAndSubmit() async {
    if(validateAndSave()){

      try{
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user; // get the firebase user from the AuthResult

        print('Signed in ${user.uid} ');

        Navigator.of(context).pop();
        Navigator.pushNamed(context, '/menu_list');
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
      body:  Container(
        padding: EdgeInsets.all(16.0),
        child:  Form(
          key : formKey,
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

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

              RaisedButton(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20.0
                  ),
                ),

                onPressed: validateAndSubmit,
              ),

              RaisedButton(
                child: Text(
                  'Create an account',
                  style: TextStyle(
                      fontSize: 20.0
                  ),
                ),

                onPressed: toRegister,
              )

            ],
          ),
        ),
      ),
    );
  }
}
