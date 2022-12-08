import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'PresLocation.dart';
import 'Location.dart';
import 'Settings.dart';

class CartPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const CartPage(this.customerId);
  @override
  Cart createState() => Cart();
}

class Cart extends State<CartPage> {
  int _selectedIndex = 1;
  String searchString = "";
  //We will consider the cart empty
  bool cartNotEmpty = false;
  int cartItemNum = 0;
  num TotalPrice  = 0;
  bool presRequired = false;
  int numOfPres = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Stack(children: [
              //Header
              Container(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
              //Controls app logo
              Container(
                  child: SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Image.asset(
                                  'assets/logoheader.png',
                                  fit: BoxFit.contain,
                                  width: 110,
                                  height: 80,
                                ),
                              ),
                              //Controls Cart page title
                              Container(
                                margin: EdgeInsets.fromLTRB(70, 13, 0, 0),
                                child: Text(
                                  'Cart',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 27,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ]),
                            SizedBox(
                              height: 20,
                            ),
                            //Controls cart page display
                            SingleChildScrollView(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      height: 620,
                                      width: size.width,
                                      child: Column(children: [
                                        Expanded(
                                          //Get cart medications for customer
                                            child: FutureBuilder<List<ParseObject>>(
                                                future:
                                                getCustomerCart(), //Will change cartNotEmpty value
                                                builder: (context, snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState.waiting:
                                                      return Center(
                                                        child: Container(
                                                            width: 200,
                                                            height: 10,
                                                            child:
                                                            LinearProgressIndicator()),
                                                      );
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Text("Error..."),
                                                        );
                                                      }
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: Text("No Data..."),
                                                        );
                                                      } else {
                                                        //If cartNotEmpty true then display medications
                                                        return cartNotEmpty
                                                            ? ListView.builder(
                                                            scrollDirection:
                                                            Axis.vertical,
                                                            itemCount:
                                                            snapshot.data!.length,
                                                            itemBuilder:
                                                                (context, index) {
                                                              //Get Parse Object Values
                                                              //Get customer medications from cart table
                                                              cartItemNum = snapshot
                                                                  .data!
                                                                  .length; //Save number of medications in customer cart
                                                              final customerCart =
                                                              snapshot.data![index];
                                                              final medId = customerCart
                                                                  .get('medication')!;
                                                              final quantity =
                                                              customerCart.get<num>(
                                                                  'Quantity')!;
                                                              //Get customer medications information from Medications table
                                                              return FutureBuilder<
                                                                  List<
                                                                      ParseObject>>(
                                                                  future: getCustomerCartMed(
                                                                      medId), //Send medications id that exist in customer cart
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    switch (snapshot
                                                                        .connectionState) {
                                                                      case ConnectionState
                                                                          .none:
                                                                      case ConnectionState
                                                                          .waiting:
                                                                        return Center(
                                                                          child:
                                                                          Container(
                                                                            width: 50,
                                                                            height: 50,
                                                                          ),
                                                                        );
                                                                      default:
                                                                        if (snapshot
                                                                            .hasError) {
                                                                          return Center(
                                                                            child: Text(
                                                                                "Error..."),
                                                                          );
                                                                        }
                                                                        if (!snapshot
                                                                            .hasData) {
                                                                          return Center(
                                                                            child: Text(
                                                                                "No Data..."),
                                                                          );
                                                                        } else {
                                                                          return ListView
                                                                              .builder(
                                                                              scrollDirection: Axis
                                                                                  .vertical,
                                                                              shrinkWrap:
                                                                              true,
                                                                              physics:
                                                                              ClampingScrollPhysics(),
                                                                              itemCount: snapshot
                                                                                  .data!
                                                                                  .length,
                                                                              itemBuilder:
                                                                                  (context, index) {
                                                                                //Get Parse Object Values
                                                                                //Get medication information from Medications table
                                                                                final medGet =
                                                                                snapshot.data![index];
                                                                                final TradeName = medGet.get<String>('TradeName')!;
                                                                                final ScientificName = medGet.get<String>('ScientificName')!;
                                                                                final Publicprice = medGet.get<num>('Publicprice')!;
                                                                                final legalStatus = medGet.get<String>('LegalStatus')!;
                                                                                if ((legalStatus.compareTo('Prescription')==0)){
                                                                                  presRequired = true;
                                                                                  numOfPres++;
                                                                                }
                                                                                //Save quantity value in counter
                                                                                num counter = quantity;
                                                                                TotalPrice =  num.parse((TotalPrice + (Publicprice*counter)).toStringAsFixed(2));
                                                                                return StatefulBuilder(
                                                                                    builder: (BuildContext context, StateSetter setState) =>
                                                                                    //Delete medication from cart
                                                                                    Dismissible(
                                                                                        key: UniqueKey(),
                                                                                        background: Container(
                                                                                            alignment: Alignment.centerRight,
                                                                                            padding: EdgeInsets.symmetric(horizontal: 30),
                                                                                            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                            decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                            child: Icon(
                                                                                              Icons.delete_outline,
                                                                                              size: 40,
                                                                                              semanticLabel: 'Delete',
                                                                                              color: Colors.red,
                                                                                            )),
                                                                                        direction: DismissDirection.endToStart,
                                                                                        confirmDismiss: (DismissDirection direction) async {
                                                                                          //Deletion confirmation dialog
                                                                                          return await showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AlertDialog(
                                                                                                title: Text("Are you sure you wish to delete this item?",
                                                                                                    style: TextStyle(
                                                                                                      fontFamily: 'Lato',
                                                                                                      fontSize: 20,
                                                                                                    )),
                                                                                                actions: <Widget>[
                                                                                                  TextButton(
                                                                                                    onPressed: () => Navigator.of(context).pop(true),
                                                                                                    child: const Text("Delete", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                  ),
                                                                                                  TextButton(
                                                                                                    onPressed: () => Navigator.of(context).pop(false),
                                                                                                    child: const Text("Cancel", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                  ),
                                                                                                ],
                                                                                              );
                                                                                            },
                                                                                          );
                                                                                        },
                                                                                        //If deletion confirmed call delete function
                                                                                        onDismissed: (direction) async {
                                                                                          //Send medication id and the quantity of it
                                                                                          if (await deleteCartMed(medId, quantity, Publicprice, legalStatus)) {
                                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                              content: Text(
                                                                                                "$TradeName deleted from your cart",
                                                                                                style: TextStyle(fontSize: 20),
                                                                                              ),
                                                                                              duration: Duration(milliseconds: 3000),
                                                                                            ));
                                                                                          }
                                                                                          //If no medications left in cart reload page to show empty message
                                                                                          //Value will be changed in deleteCartMed function
                                                                                          if (cartItemNum == 0) {
                                                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(widget.customerId)));
                                                                                          }
                                                                                        },
                                                                                        //Controls medications display
                                                                                        child: Stack(
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  Expanded(
                                                                                                    child: Container(
                                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                                      child: Column(
                                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: <Widget>[
                                                                                                          Container(
                                                                                                            padding: EdgeInsets.only(right: 8, top: 4),
                                                                                                            child: Text(
                                                                                                              TradeName,
                                                                                                              maxLines: 2,
                                                                                                              softWrap: true,
                                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700),
                                                                                                            ),
                                                                                                          ),
                                                                                                          SizedBox(height: 6),
                                                                                                          Text(
                                                                                                            ScientificName,
                                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black),
                                                                                                          ),
                                                                                                          Container(
                                                                                                            child: Row(
                                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                              children: <Widget>[
                                                                                                                Text(
                                                                                                                  '$Publicprice SAR  x$counter',
                                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                ),
                                                                                                                //Increment and decrement of medication
                                                                                                                Padding(
                                                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                                                  child: Row(
                                                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                    children: <Widget>[
                                                                                                                      CircleAvatar(
                                                                                                                          backgroundColor: HexColor('#e8cafc'),
                                                                                                                          child: IconButton(
                                                                                                                              onPressed: () {
                                                                                                                                //Call decrement function
                                                                                                                                //Send medication id. customer id and the counter after modification
                                                                                                                                decrement(medId, widget.customerId, counter!, Publicprice );
                                                                                                                                setState(() {
                                                                                                                                  //Modify the counter
                                                                                                                                  if (counter > 1) {
                                                                                                                                    counter--;
                                                                                                                                  }
                                                                                                                                });
                                                                                                                              },
                                                                                                                              icon: const Icon(
                                                                                                                                Icons.remove,
                                                                                                                                color: Colors.black,
                                                                                                                                size: 24.0,
                                                                                                                              ))),
                                                                                                                      Container(
                                                                                                                        padding: const EdgeInsets.only(bottom: 2, right: 12, left: 12),
                                                                                                                        child: Text(
                                                                                                                          '$counter',
                                                                                                                          style: TextStyle(fontFamily: "Lato", fontSize: 22, color: Colors.black),
                                                                                                                        ),
                                                                                                                      ),
                                                                                                                      CircleAvatar(
                                                                                                                          backgroundColor: HexColor('#fad2fc'),
                                                                                                                          child: IconButton(
                                                                                                                              onPressed: () {
                                                                                                                                //Call increment function
                                                                                                                                //Send medication id. customer id and the counter after modification
                                                                                                                                increment(medId, widget.customerId, counter! ,Publicprice);
                                                                                                                                setState(() {
                                                                                                                                  counter++;
                                                                                                                                });
                                                                                                                              },
                                                                                                                              icon: const Icon(
                                                                                                                                Icons.add,
                                                                                                                                color: Colors.black,
                                                                                                                                size: 24.0,
                                                                                                                              ))),
                                                                                                                    ],
                                                                                                                  ),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    flex: 100,
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )));
                                                                              });
                                                                        }
                                                                    }
                                                                  });
                                                            })
                                                        //If cartnotEmpty is false; cart is empty show this message
                                                            : Container(
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                //mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  Text(
                                                                    'Your cart is empty',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                        "Lato",
                                                                        fontSize: 20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                                  ),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                    children: [
                                                                      Text(
                                                                        'Click',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            "Lato",
                                                                            fontSize: 20,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () {
                                                                          Navigator.of(
                                                                              context)
                                                                              .push(MaterialPageRoute(
                                                                              builder:
                                                                                  (context) =>
                                                                                  CategoryPage()));
                                                                        },
                                                                        child: Text(
                                                                          'here',
                                                                          style: TextStyle(
                                                                              fontFamily:
                                                                              "Lato",
                                                                              fontSize:
                                                                              20,
                                                                              fontWeight:
                                                                              FontWeight
                                                                                  .w700,
                                                                              color: Theme.of(
                                                                                  context)
                                                                                  .accentColor),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        'to browse our app',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                            "Lato",
                                                                            fontSize: 20,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .w700),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]));
                                                      }
                                                  }
                                                }))
                                      ]),
                                    ))),
                            SizedBox(
                              height: 15,
                            ),
                          ]))),
            ])),
        //Button continue
        persistentFooterButtons: [
          Text('Continue',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          CircleAvatar(
              backgroundColor: Colors.purple.shade300,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Location(widget.customerId, TotalPrice, presRequired)));

                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 24.0,
                  ))),
        ],
        //Bottom navigation bar
        bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(10),
                  tabs: [
                    GButton(
                        icon: Icons.home,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.shopping_bag,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.settings,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(widget.customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(widget.customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(widget.customerId)));
                    }
                  }),
                ))));
  }

  //Get customer medications from cart table
  Future<List<ParseObject>> getCustomerCart() async {
    //Query customer cart
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      //If query have objects then set true
      cartNotEmpty = true;
      return apiResponse.results as List<ParseObject>;
    } else {
      //If query have no object then set false
      cartNotEmpty = false;
      return [];
    }
  }

  //Get customer's medication information from Medications table
  Future<List<ParseObject>> getCustomerCartMed(medIdCart) async {
    final QueryBuilder<ParseObject> customerCartMed =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    customerCartMed.whereEqualTo('objectId', medIdCart.objectId);
    final apiResponse = await customerCartMed.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Delete medication from cart function
  //Quantity will be used in next sprint
  Future<bool> deleteCartMed(medId, Quantity, Publicprice, legalStatus) async {
    //Query the medication from customers' cart
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', medId.toPointer());
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        final object = o as ParseObject;
        TotalPrice = num.parse((TotalPrice - (Publicprice*Quantity)).toStringAsFixed(2));
        if(legalStatus.compareTo('Prescription')==0){
          if(numOfPres==1){
            presRequired = false;
          }
          else{
            numOfPres--;
            print(numOfPres);
          }
        }
        //Delete medication
        object.delete();
        //Decrement number of medications in customer table
        cartItemNum = cartItemNum - 1;
        return true;
      }
    }
    return false;
  }

  //Increment medication quantity
  Future<void> increment(objectId, customerId, Quantity, Publicprice ) async {
    var medInCart;
    //Query the medication from customers' cart
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', objectId.toPointer());
    final apiResponse = await parseQuery.query();

    //Get as a single object
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        TotalPrice = num.parse((TotalPrice + Publicprice).toStringAsFixed(2));
      }
      //Update quantity in database
      var incrementQuantity = medInCart..set('Quantity', ++Quantity);
      await incrementQuantity.save();
    }
  }

  //Decrement medication quantity
  Future<void> decrement(medId, customerId, Quantity, Publicprice ) async {
    var medInCart;
    //Query the medication from customers' cart
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', medId.toPointer());
    final apiResponse = await parseQuery.query();

    //Get as a single object
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        TotalPrice = num.parse((TotalPrice - Publicprice).toStringAsFixed(2));
      }

      //Update quantity in database If quantity not 1
      if (Quantity != 1) {
        var decrementQuantity = medInCart..set('Quantity', --Quantity);
        await decrementQuantity.save();
      }
      //If quantity is 1 show message
      if (Quantity == 1) {
        Widget okButton = TextButton(
          child: Text("Ok",
              style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        );
        // set up the AlertDialog
        AlertDialog alert = AlertDialog(
          title: Text(
            "Swipe to the left if you want to delete this medication",
            style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 20,
            ),
          ),
          actions: [
            okButton,
          ],
        );
        // show the dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
      }
    }
  }
}