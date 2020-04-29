import 'dart:io';
import 'package:awesome_project/views/navbar/admin_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';


/// This is  the Description page
/// created by IT17104654
class DescriptionPage extends StatefulWidget {

  /// This class has parameter id
  ///  This id is document titile
  final String id;

  DescriptionPage({this.id});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<DescriptionPage> {

  ///  variables for bind the data
  String title, subtitle, image, description;

  bool isImageLoaded = false;
  File imageFile;

  ///  setter for title
  getTitle(title) {
    this.title = title;
  }

  ///  setter for subtitle
  getSubtitle(subtitle) {
    this.subtitle = subtitle;
  }

  ///  setter for image
  getImage(image) {
    this.image = image;
  }

  ///  setter for description
  getDescription(description) {
    this.description = description;
  }

  ///  load the data in the start
  @override
  void initState() {
    super.initState();
    loadItemData();
  }

  ///  load the data from firestore
  loadItemData() async {
    print("id");
    print("The id : " + widget.id);


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
      });
      print("title: ${doc.data['title']} ");
      print("subtitile : ${doc.data['subtitile']} ");
    });
  }


  ///  Build the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: DecoratedBox(
          position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
                image: AssetImage('assets/images/dark_back.jpg'),
                fit: BoxFit.cover),
          ),
          child:Column(
            children: <Widget>[
              _myAppBar(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 200,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        title != null ?  title : "",

                        style: TextStyle(
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2
                              ..color = Colors.amber),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: image != null ?  Image.network(image) : Text("No image to display")
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        subtitle != null ? subtitle : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            foreground: Paint()
                              ..style = PaintingStyle.fill
                              ..strokeWidth = 1
                              ..color = Colors.orange),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Text(
                        description != null ? description : "",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            fontStyle: FontStyle.italic,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }

  /// app bar to show in the top
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
        child: Text("Description", style: TextStyle()),
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