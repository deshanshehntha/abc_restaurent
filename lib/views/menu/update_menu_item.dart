import 'dart:io';
import 'package:awesome_project/views/navbar/admin_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';


/// This is  the update menu item class
/// created by IT17104654
class UpdateItem extends StatefulWidget {

  /// This class has parameter id
  ///  This id is document titile
  final String id;

  UpdateItem({this.id});

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}


class _UpdateTaskState extends State<UpdateItem> {

  ///  variables for the update post
  String title, subtitle, image, description, price;
  bool isImageLoaded = false;
  File imageFile;

  ///  setter for title
  setTitle(title) {
    this.title = title;
  }

  ///  setter for subtitle
  setSubtitle(subtitle) {
    this.subtitle = subtitle;
  }

  ///  setter for image
  setImage(image) {
    this.image = image;
  }

  ///  setter for description
  setDescription(description) {
    this.description = description;
  }

  ///  setter for price
  setPrice(price) {
    this.price = price;
  }


  ///  image picker
  Future chooseImage() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((img) {
      setState(() {
        image = img.path;
        isImageLoaded = true;
        imageFile = img;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadItemData();
  }

  ///  Load the data according to the id paased from the list
  loadItemData() async {
    print("id");

    await Firestore.instance
        .collection("post")
        .document(widget.id)
        .get()
        .then((DocumentSnapshot doc) {
      setState(() {
        title = doc.data['title'];
        subtitle = doc.data['subtitle'];
        image = doc.data['image'];
        description = doc.data['description'];
        price = doc.data['price'];
      });
      print("title: ${doc.data['title']} ");
      print("subtitile : ${doc.data['subtitile']} ");
    });
  }

  ///  Update the data based on title
  createData() async {
    DocumentReference ds =
    Firestore.instance.collection("post").document(title);
    Map<String, dynamic> tasks = {
      "title": title,
      "subtitle": subtitle,
      "description": description,
      "price": price
    };
    ds.updateData(tasks).whenComplete(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenuList(), fullscreenDialog: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,

      body: SingleChildScrollView(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.red,
              image: DecorationImage(
                  image: AssetImage('assets/images/orderback.jpg'),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: <Widget>[
                _myAppBar(),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.amber.withOpacity(0.7),
                  ),
                  child: Column(
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: image != null ? Image.network( image) : Image( image : AssetImage('assets/images/main_logo.png'),  width: 90,  height: 90, ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextField(
                            onChanged: (String title) {
                              setTitle(title);
                            },
                            decoration: InputDecoration(labelText: title != null ? title : "" ),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextField(
                            onChanged: (String subtitle) {
                              setSubtitle(subtitle);
                            },
                            decoration: InputDecoration(labelText: subtitle != null ? subtitle : ""  ,
                              focusColor: Colors.black,
                              hoverColor: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: TextField(
                          onChanged: (String description) {
                            setDescription(description);
                          },
                          decoration: InputDecoration(labelText: description != null ? description : ""  ,
                              focusColor: Colors.black,
                              hoverColor: Colors.black,
                              hintStyle: TextStyle(
                                  color: Colors.black
                              )),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          child: TextField(
                            onChanged: (String price) {
                              setPrice(price);
                            },
                            decoration: InputDecoration(labelText: price != null ? price : "" ,
                                focusColor: Colors.black,
                                hoverColor: Colors.black,
                                hintStyle: TextStyle(
                                    color: Colors.black
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom,
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
          )
      ),
    );
  }

  /// app bar fot the top of the screen
  Widget _myAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.bars),

      ),
      title: Container(
        alignment: Alignment.center,
        child: Text("Update Menu Item", style: TextStyle()),
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