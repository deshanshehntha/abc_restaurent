import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UpdateItem extends StatefulWidget {
  final String id;

  UpdateItem({this.id});

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateItem> {
  String title, subtitle, image;
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
      });
      print("title: ${doc.data['title']} ");
      print("subtitile : ${doc.data['subtitile']} ");
    });
  }

  createData() async {
    DocumentReference ds =
        Firestore.instance.collection("post").document(title);
    Map<String, dynamic> tasks = {
      "title": title,
      "subtitle": subtitle,
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
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          _myAppBar(),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 200,
            child: ListView(
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Image.network(image),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String title) {
                      getTitle(title);
                    },
                    decoration: InputDecoration(labelText: title),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: TextField(
                    onChanged: (String subtitle) {
                      getSubtitle(subtitle);
                    },
                    decoration: InputDecoration(labelText: subtitle),
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
