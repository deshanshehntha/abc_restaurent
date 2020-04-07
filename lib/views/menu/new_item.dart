import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'menu_list.dart';


class Item extends StatefulWidget {
  Item();

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<Item> {
  String title, subtitle, image;

  getTitle(title) {
    this.title = title;
  }

  getSubtitle(subtitle) {
    this.subtitle = subtitle;
  }

  getImage(image) {
    this.image = image;
  }
  
  createData() {
    DocumentReference ds = Firestore.instance.collection("post").document(title);
    Map<String,dynamic> tasks = {
      "title" : title,
      "subtitle" : subtitle,
      "image" : image,
    };
    ds.setData(tasks).whenComplete(() {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => MenuList(),
              fullscreenDialog: true
          )
      );
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
            height: MediaQuery.of(context).size.width - 80,
            child: ListView(
              children: <Widget>[
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
                    onChanged: (String image) {
                      getImage(image);
                    },
                    decoration: InputDecoration(labelText: "Image"),
                  ),
                )
              ],
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
