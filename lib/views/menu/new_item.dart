import 'dart:io';
import 'package:awesome_project/views/navbar/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Item extends StatefulWidget {
  Item();

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<Item> {
  String title, subtitle, image, description;
  bool isImageLoaded = false;
  File imageFile;

  getTitle(title) {
    this.title = title;
  }

  getSubtitle(subtitle) {
    this.subtitle = subtitle;
  }

  getImage(image) {
    this.image = image;
  }

  getDescription(description) {
    this.description = description;
  }

  Future chooseImage() async{
    await ImagePicker.pickImage(source: ImageSource.gallery).then((img){
      setState(() {
        image = img.path;
        isImageLoaded = true;
        imageFile = img;
      });
    });
  }


  createData() async{

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('chats/${image.split('/').last}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask.onComplete;
    print('File Uploaded');

    storageReference.getDownloadURL().then((fileURL) {

      DocumentReference ds = Firestore.instance.collection("post").document(title);
      Map<String,dynamic> tasks = {
        "title" : title,
        "subtitle" : subtitle,
        "image" : fileURL,
        "description": description
      };
      ds.setData(tasks).whenComplete(() {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => MenuList(),
                fullscreenDialog: true
            )
        );
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: ListView(
              children: <Widget>[

                isImageLoaded ?
                Container(
                    child: isImageLoaded ? Image.asset(image) : null
                )
                :
                Container(

                ),

                Container(
                   // padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: FlatButton.icon(
                      color: Colors.white,
                      icon: Icon(Icons.add_photo_alternate), //`Icon` to display
                      label: Text(
                          'Upload image'
                      ),
                      onPressed: () {
                        chooseImage();
                      },
                    ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String title) {
                      getTitle(title);
                    },
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String subtitle) {
                      getSubtitle(subtitle);
                    },
                    decoration: InputDecoration(labelText: "Subtitle"),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String description) {
                      getDescription(description);
                    },
                    decoration: InputDecoration(labelText: "Description"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    RaisedButton(
                      color: Colors.redAccent,
                      onPressed: () {
                        createData();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                )

              ],
            ),
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }


  Widget _myAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.bars),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Container(
        alignment: Alignment.center,
        child: Text("ABC Resturant", style: TextStyle()),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(FontAwesomeIcons.hamburger),
          iconSize: 20.0,
          color: Colors.white,
          onPressed: null,
        ),
      ],
    );
  }
}
