import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/bottom_navigation.dart';
import 'new_item.dart';

class CustomerMenuList extends StatefulWidget {

  @override
  _CustomerMenuListState createState() => _CustomerMenuListState();
}

class _CustomerMenuListState extends State<CustomerMenuList> {

  String title;
  String imageUrl;
  String onDate;
  String onTime;

  void toAddItem(){

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Item(),
            fullscreenDialog: true
        )
    );
  }

  void saveItemToWishlist(){
    print(title);
    print(imageUrl);
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[

                                    Padding(
                                      padding:  EdgeInsets.all(7.0),
                                      child:FlatButton.icon(
                                        color: Colors.white,
                                        icon: Icon(
                                            Icons.favorite
                                        ), //
                                        textColor: Colors.redAccent,// `Icon` to display
                                        label: Text(
                                            'Add to Wishlist',
                                          style: TextStyle(

                                          ),
                                        ),
                                        onPressed: () {

                                          setState(() {
                                            title = mypost['title'];
                                            imageUrl = mypost['image'];
                                          });

                                          saveItemToWishlist();
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

      bottomNavigationBar: BottomNavigation(),
    );
  }
}
