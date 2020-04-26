import 'dart:collection';

import 'package:awesome_project/views/navbar/customer_bottom_navigation.dart';
import 'package:awesome_project/views/order/order_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../navbar/admin_bottom_navigation.dart';
import 'new_item.dart';
import '../order/cart.dart';
import '../../util/Generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerMenuList extends StatefulWidget {

  @override
  _CustomerMenuListState createState() => _CustomerMenuListState();
}

class _CustomerMenuListState extends State<CustomerMenuList> {

  String title;
  int quantity;
  int cartQuantity;
  double netTotal;

  Cart cartObj = new Cart();

  Map<String, Cart> cart = new Map<String, Cart>();

  List<Cart> cartList = new List<Cart>();

  @override
  void initState() {
    super.initState();

    cartQuantity = 0;
    quantity = 0;
    netTotal = 0;
  }

  void toAddItem(){

    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => Item(),
            fullscreenDialog: true
        )
    );
  }

  addOrder() async{
    ///fetch the user
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //generate the timestamp
    int timestamp = new DateTime.now().millisecondsSinceEpoch;

    ///Initialize Generator class instance to get the date and time
    Generator gen = new Generator();

    DocumentReference ds = Firestore.instance.collection("user").document(user.uid).collection("order").document(timestamp.toString());
    Map<String,dynamic> newOrder = {
      "orderDate" : gen.getCurrentDate(),
      "orderTime" : gen.getCurrentTime(),
      "total" : netTotal,
    };
    
    ds.setData(newOrder).whenComplete((){
      print("Saved");
    });
  }

  loadMapToList(){

    cartList.clear();
    netTotal = 0;

    cart.forEach((key,value)=>(
      cartList.add(value)
    ));

    ///get the total of the cart
    cart.forEach((key,value)=>(
      netTotal += value.getTotal()

    ));

    print( cartList );
    print(netTotal);
  }

  void saveItemToWishlist(){
    print(title);
  }

  updateCart( String itemTitle, Cart newCart ){

    setState(() {
      cart[itemTitle] = newCart;
      title = "";
      quantity = 0;
    });

  }

  deleteItemFromCart( String key ){
    setState(() {
      cart.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text("ABC Resturant", style: TextStyle()),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.hamburger),
            iconSize: 20.0,
            color: Colors.black54,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) => OrderList(),

                  )
              );
            },
          ),
        ],
      ),
      body: DecoratedBox(
       position: DecorationPosition.background,
          decoration: BoxDecoration(
            color: Colors.red,
            image: DecorationImage(
                image: AssetImage('assets/images/orderback.jpg'),
                fit: BoxFit.cover),
          ),
        child:StreamBuilder(
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

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
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
                                                Icons.favorite
                                            ), //
                                            textColor: Colors.redAccent,// `Icon` to display
                                            label: Text(
                                              'Order',
                                              style: TextStyle(

                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                title = mypost['title'];
                                              });
                                              displayItemAdd(context, double.parse(mypost['price']));
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



      floatingActionButton: FloatingActionButton.extended(
        label: Text(
            cartQuantity.toString()
        ),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: (){
          loadMapToList();
          showSingleOrder(context);
        }
      ),

      bottomNavigationBar: CustomerBottomNavigation(input : 0 ),
    );
  }

    showSingleOrder(BuildContext context) {
      Size size = MediaQuery.of(context).size;
      return showDialog(
          context: context,
          builder: (context) {
            return Scaffold(


              body:DecoratedBox(
                position: DecorationPosition.background,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        image: AssetImage('assets/images/orderback.jpg'),
                        fit: BoxFit.cover),
                  ),
                child:Column(

                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Your Order",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        border: TableBorder.all(),
                        children:
                        cartList.map((singleCart)=> TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(singleCart.getTitle()),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text("x " + singleCart.getQuantity().toString()),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(singleCart.getTotal().toString()),
                                ),
                              ),
                              TableCell(
                                child: FlatButton(
                                  color: Colors.white,
                                  child: Icon(Icons.delete_outline),
                                  textColor: Colors.redAccent,// `Icon` to display
                                  onPressed: () {
                                    deleteItemFromCart(singleCart.getTitle());
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ]
                        )).toList(),
                      ),
                    ),

                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Net Total : Rs. " + netTotal.toString(),
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    FlatButton.icon(
                      color: Colors.green,
                      icon: Icon(
                          Icons.done_outline
                      ), //
                      textColor: Colors.white,// `Icon` to display
                      label: Text(
                          'Confirm Order'
                      ),
                      onPressed: () {
                        addOrder();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ),


            );
          });
    }

  displayItemAdd( BuildContext context, double amount ) async{
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Enter quantiy for $title'),


            content: Column(
              mainAxisSize: MainAxisSize.min,

              children: <Widget>[

                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Quantity'
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  validator: (
                          (value)=> value.isEmpty ? 'Quantity cannot be empty ' : null
                  ),

                  initialValue: quantity.toString(),
                  onChanged: (value) => quantity = int.parse(value),
                ),


                Row(
                  children: <Widget>[
                    FlatButton(
                      child: new Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    FlatButton(
                      child:  Text( "Add"),
                      onPressed: () {

                        Cart newCart = new Cart();

                        newCart.setTitle(title);
                        newCart.setQuantity(quantity);
                        newCart.setAmount(amount);
                        newCart.setTotal(quantity * amount);

                        setState(() {
                          cartQuantity += quantity;
                        });

                        updateCart( title, newCart);
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )

              ],
            ),

          );
        });
  }
}
