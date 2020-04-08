import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  String firstName;
  String lastName;
  String telephone;
  String imageUrl;
  String uid;


  //edit section
  String editFirstName;
  String editLastName;
  String editTelephone;
  /*
  Choose the image
   */
  Future chooseImage() async{
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image){
      uploadImage(image);
    });
  }

  /*
  Upload the image to the firebase storage
   */
  Future uploadImage(File img ) async{
    StorageReference storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pics/${img.path.split('/').last}');

    print('profile_pics/${img.path.split('/').last}');

    StorageUploadTask uploadTask = storageRef.putFile(img);

    await uploadTask.onComplete;
    print("File Uploaded");

    //Get the imnage url after uploading
    storageRef.getDownloadURL().then((url){
      updateProfilePic(url);
      print(url);
    });
  }

  /*
  Update the firebase records
   */
  Future updateProfilePic( String imgUrl ) async{

    DocumentReference docRef =  await Firestore.instance.collection("user").document(uid);

    Map<String,dynamic> userMap = {
      "imageUrl" : imgUrl
    };

    docRef.updateData(userMap).whenComplete((){
      loadUserData();
      print("save successfull");
    });
  }

  /*
  Update firstname and lastname of user
   */
  Future updateUserName() async{

    DocumentReference docRef = await Firestore.instance.collection("user").document(uid);

    if( editFirstName == null ){
      editFirstName = firstName;
    }

    if( editLastName == null ){
      editLastName = lastName;
    }

    Map<String,dynamic> userMap = {
      "firstName" : editFirstName,
      "lastName" : editLastName
    };

    docRef.updateData(userMap).whenComplete((){
      loadUserData();
      print("save successfull");
    });

  }

  /*
  Update the telephone number of user
   */
  Future updateTelephone() async{

    DocumentReference docRef = await Firestore.instance.collection("user").document(uid);

    Map<String,dynamic> userMap = {
      "telephone" : editTelephone,
    };

    docRef.updateData(userMap).whenComplete((){
      loadUserData();
      print("save successfull");
    });

  }

  @override
  void initState() {
    super.initState();

    loadUserData();
  }

  void loadUserData() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance.collection("user").document(user.uid).get()
    .then((DocumentSnapshot doc){

      setState(() {
        firstName = doc.data['firstName'];
        lastName = doc.data['lastName'];
        telephone = doc.data['telephone'];
        imageUrl = doc.data['imageUrl'];
        uid = user.uid;
      });
      print("First name : ${doc.data['firstName' ]} "  );
      print("Image Url : ${doc.data['imageUrl' ]} "  );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "User Account",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        backgroundColor: Colors.blue[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 90,
                  backgroundImage : imageUrl == null ?   NetworkImage('https://picsum.photos/200') : NetworkImage(imageUrl)
                ),

                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FlatButton.icon(
                    color: Colors.white,
                    icon: Icon(Icons.add_photo_alternate), //`Icon` to display
                    label: Text(
                        'Upload your image'
                    ),
                    onPressed: () {
                      chooseImage();
                    },
                  ),
                ),

                /*
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'SourceSansPro',
                    color: Colors.red[400],
                    letterSpacing: 2.5,
                  ),
                ),

                 */
                SizedBox(
                  height: 20.0,
                  width: 200,
                  child: Divider(
                    color: Colors.teal[100],
                  ),
                ),
                Text("Tap on the fields that you want to edit"),
                Card(
                    color: Colors.white,
                    margin:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.person_pin,
                        color: Colors.teal[900],
                      ),
                      title: Text(
                        '$firstName $lastName',
                        style:
                        TextStyle(fontSize: 20.0),
                      ),
                      onTap: ()=> displayNameEditDialog(context),
                    )),
                Card(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.teal[900],
                    ),
                    title: Text(
                      '$telephone',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () => displayTelephoneEditDialog(context),
                  ),

                )
              ],
            ),
          ),
        ),

    );

  }

  onTap(){
    print('Tapped');
  }

  displayTelephoneEditDialog( BuildContext context ) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Update your telephone number'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Telephone'
                  ),
                  validator: (
                          (value)=> value.isEmpty ? 'Telephone cannot be empty ' : null
                  ),

                  initialValue: telephone,
                  onChanged: (value) => editTelephone = value.trim() ,
                ),


                Row(
                  children: <Widget>[
                    FlatButton(
                      child: new Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    FlatButton(
                      child:  Text( "Update"),
                      onPressed: () {
                        updateTelephone();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )

              ],
            ),
          );
        });
  }

  displayNameEditDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Update your name'),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Firstname'
                  ),
                  validator: (
                          (value)=> value.isEmpty ? 'Firstname cannot be empty ' : null
                  ),
                  initialValue: firstName,
                  onChanged: (value) => editFirstName = value.trim() ,
                ),


                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Lastname'
                  ),
                  validator: (
                          (value)=> value.isEmpty ? 'Lastname cannot be empty ' : null
                  ),
                  initialValue: lastName,
                  onChanged: (value) => editLastName = value.trim() ,
                ),


                Row(
                  children: <Widget>[
                    FlatButton(
                      child: new Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    FlatButton(
                      child:  Text( "Update"),
                      onPressed: () {
                        updateUserName();
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )

              ],
            ),
          );
        });
  }
}
