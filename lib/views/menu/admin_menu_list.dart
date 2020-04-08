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
                  return Stack(
                    children: [

                       Card(
                        child: new Column(
                          children: <Widget>[

                            Text('${mypost['title']}',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                )
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