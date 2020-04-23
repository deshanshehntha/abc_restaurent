import 'dart:io';
import 'package:awesome_project/views/navbar/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';

class DescriptionPage extends StatefulWidget {
  final String id;

  DescriptionPage({this.id});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<DescriptionPage> {
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

  @override
  void initState() {
    super.initState();
    loadItemData();
  }

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
      });
      print("title: ${doc.data['title']} ");
      print("subtitile : ${doc.data['subtitile']} ");
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    title,
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
                  child: Image.network(image),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    subtitle,
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
                    description,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                  ),
                ),
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
