import 'package:awesome_project/views/menu/description_page.dart';
import 'package:awesome_project/views/menu/update_menu_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/bottom_navigation.dart';
import 'new_item.dart';

class MenuList extends StatefulWidget {

  final String title;

  MenuList({Key key, this.title}) : super(key : key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {

  void toAddItem(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Item(),
            fullscreenDialog: true
        )
    );
  }

  deleteData(snapshot, index) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.data.documents[index].reference);
    });
    _showDialog();
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete Confirmation"),
          content: new Text("Item Deleted"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.bars),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => Item(),
                    fullscreenDialog: true
                )
            );
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
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('post').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Text( "Loading ... "),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot mypost = snapshot.data.documents[index];
                  String title = "";
                  title = mypost['title'];
                  return Stack(
                    children: [

                      Card(
                        child: new Column(
                          children: <Widget>[

                            GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DescriptionPage(
                                                id: title),
                                        fullscreenDialog: true
                                    )
                                );
                              },
                              child: Text('${mypost['title']}',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),

                            SizedBox(
                              height: 5,
                            ),

                            Image.network('${mypost['image']}'),

                            SizedBox(
                              height: 8,
                            ),

                            Text('${mypost['subtitle']}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.italic
                                )
                            ),

                            Padding(
                                padding:  EdgeInsets.all(7.0),
                                child:  Row(
                                  children: <Widget>[

                                    Padding(
                                      padding:  EdgeInsets.all(7.0),
                                      child:FlatButton.icon(
                                        color: Colors.white,
                                        icon: Icon(
                                            Icons.edit
                                        ), //
                                        textColor: Colors.blueAccent,// `Icon` to display
                                        label: Text(
                                            'Edit'
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UpdateItem(
                                                          id: title),
                                                  fullscreenDialog: true
                                              )
                                          );
                                        },
                                      ),
                                    ),

                                    Padding(
                                      padding:  EdgeInsets.all(7.0),
                                      child:FlatButton.icon(
                                        color: Colors.white,
                                        icon: Icon(
                                            Icons.delete_forever
                                        ), //
                                        textColor: Colors.redAccent,// `Icon` to display
                                        label: Text(
                                            'Delete'
                                        ),
                                        onPressed: () {
                                          deleteData(snapshot, index);
                                        },
                                      ),
                                    ),


                                  ],
                                )),


                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          toAddItem();
        },
        child: Icon(Icons.add,color: Colors.white),
        backgroundColor: Colors.blue[600],
      ),

      bottomNavigationBar: BottomNavigation(),
    );
  }

}

/*
  children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 350.0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Material(
                            color: Colors.white,
                            elevation: 14.0,
                            shadowColor: Color(0x802196F3),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                      child: Image.network('${mypost['image']}',
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(height: 10.0),
                                    Text('${mypost['title']}',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 10.0),
                                    Text('${mypost['subtitle']}',
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
 */

