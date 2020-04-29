import 'package:awesome_project/views/menu/description_page.dart';
import 'package:awesome_project/views/menu/update_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/admin_bottom_navigation.dart';
import 'new_item.dart';


/// This is  the main menu list  class
/// This Class will act as the main dashboard for admin.
/// admin menu list by IT17104654
class MenuList extends StatefulWidget {

  final String title;

  MenuList({Key key, this.title}) : super(key : key);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {


  /// After clicking the add item floating button
  /// This method will navigate user to add item page
  void toAddItem(){
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Item(),
            fullscreenDialog: true
        )
    );
  }

  /// Method for delele data in a single touch
  deleteData(snapshot, index) async {
    await Firestore.instance.runTransaction((Transaction myTransaction) async {
      await myTransaction.delete(snapshot.data.documents[index].reference);
    });
    _showDialog();
  }

  /// Method show the dialog after deleting an item
  /// Delete confirmation
  /// This is a flutter defined functon
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

  /// Inbuilt build method
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
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
              image: AssetImage('assets/images/dark_back.jpg'),
              fit: BoxFit.fill),
        ),
        child: StreamBuilder(
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
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
                                  padding: EdgeInsets.only(top: 5 ,left: 0.0),
                                  child: FloatingActionButton.extended(
                                    heroTag: null,
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DescriptionPage(
                                                      id: title),
                                              fullscreenDialog: true
                                          )
                                      );
                                    },
                                    label: Text('View'),
                                    icon: Icon(Icons.remove_red_eye),
                                    backgroundColor: Colors.orange,
                                  ),
                                ),



                                Padding(
                                    padding:  EdgeInsets.all(7.0),
                                    child:  Row(
                                      children: <Widget>[

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Rs. ${mypost['price']}',
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 18.0,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold
                                              )
                                          ),
                                        ),

                                        Spacer(),

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
                                          padding: EdgeInsets.all(1.0),
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
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: (){
          toAddItem();
        },
        child: Icon(Icons.add,color: Colors.white ),
        backgroundColor: Colors.green,
      ),

      bottomNavigationBar: AdminBottomNavigation(input: 0),
    );
  }

}

