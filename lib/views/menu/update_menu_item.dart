import 'dart:io';
import 'package:awesome_project/views/navbar/bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'admin_menu_list.dart';
import 'package:image_picker/image_picker.dart';

class UpdateItem extends StatefulWidget {
  final String id;

  UpdateItem({this.id});

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateItem> {
  String title, subtitle, image, description, price;
  bool isImageLoaded = false;
  File imageFile;

  setTitle(title) {
    this.title = title;
  }

  setSubtitle(subtitle) {
    this.subtitle = subtitle;
  }

  setImage(image) {
    this.image = image;
  }

  setDescription(description) {
    this.description = description;
  }

  setPrice(price) {
    this.price = price;
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
        description = doc.data['description'];
        price = doc.data['price'];
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
        child: Column(
          children: <Widget>[
            _myAppBar(),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 10,
              child: ListView(
                children: <Widget>[
                  Container(
                    // padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Image.network(image),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: TextField(
                        onChanged: (String title) {
                          setTitle(title);
                        },
                        decoration: InputDecoration(labelText: title),
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
                        decoration: InputDecoration(labelText: subtitle),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: TextField(
                      onChanged: (String description) {
                        setDescription(description);
                      },
                      decoration: InputDecoration(labelText: description),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16.0, right: 16.0),
                      child: TextField(
                        onChanged: (String price) {
                          setPrice(price);
                        },
                        decoration: InputDecoration(labelText: price),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom,
                  ),
                  SizedBox(
                    height: 30,
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
