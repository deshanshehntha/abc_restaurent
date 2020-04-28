import 'dart:io';
import 'package:awesome_project/views/navbar/admin_bottom_navigation.dart';
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
        "description": description,
        "price": price
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
      resizeToAvoidBottomPadding: true,
      body: SingleChildScrollView(


        child:DecoratedBox(

        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
          image: AssetImage('assets/images/item_add_bg.jpg'),
          fit: BoxFit.contain),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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

                        margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                        padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),

                        child: RaisedButton(
                          color: Colors.amberAccent,
                          padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                          onPressed: () {
                            chooseImage();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.add_photo_alternate
                              ),
                              Text(
                                "Upload Image",
                                style: TextStyle(
                                    fontSize: 15.0,
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
                        margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                        padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                        child: TextFormField(
                          onChanged: (String title) {
                            setTitle(title);
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Title",
                              filled: true,
                              hoverColor: Colors.grey,
                              fillColor: Colors.white,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              prefixIcon: new Icon(Icons.title)

                          ),

                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                        padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                        child: TextFormField(
                          onChanged: (String subtitle) {
                            setSubtitle(subtitle);
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Subtitle",
                              filled: true,
                              hoverColor: Colors.grey,
                              fillColor: Colors.white,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              prefixIcon: new Icon(Icons.text_fields)

                          ),

                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                        padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                        child: TextFormField(
                          onChanged: (String description) {
                            setDescription(description);
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Description",
                              filled: true,
                              hoverColor: Colors.grey,
                              fillColor: Colors.white,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              prefixIcon: new Icon(Icons.textsms)

                          ),

                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
                        padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                        child: TextFormField(
                          onChanged: (String price) {
                            setPrice(price);
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              hintText: "Price",
                              filled: true,
                              hoverColor: Colors.grey,
                              fillColor: Colors.white,
                              focusColor: Colors.grey,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              prefixIcon: new Icon(Icons.monetization_on)

                          ),

                        ),
                      ),

                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
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
                        ),

                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

      ),
    );
  }


  Widget _myAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(FontAwesomeIcons.bars),
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
