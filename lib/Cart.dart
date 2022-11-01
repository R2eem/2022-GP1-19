import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'common/theme_helper.dart';

class CartPage extends StatefulWidget {
  final String customerId;
  const CartPage(this.customerId);
  @override
  Cart createState() => Cart();
}

class Cart extends State<CartPage> {
  int _selectedIndex = 1;
  String searchString = "";
  num TotalPrice = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Stack(children: [
          Container(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
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
                SizedBox(height: 20,),
                SingleChildScrollView(
                    child:Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 620,
                      width: size.width,
                      child: Column(children: [
                        Expanded(
                            child: FutureBuilder<List<ParseObject>>(
                                future: getCustomerCart(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: Container(
                                            width: 200,
                                            height: 10,
                                            child: LinearProgressIndicator()),
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
                                        TotalPrice = 0;
                                        return  ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              //Get Parse Object Values
                                              final customerCart = snapshot.data![index];
                                              final medId = customerCart.get('medication')!;
                                              final quantity = customerCart.get<num>('Quantity')!;
                                              return FutureBuilder<List<ParseObject>>(
                                                  future: getCustomerCartMed(medId),
                                                  builder: (context, snapshot) {
                                                    switch (snapshot.connectionState) {
                                                      case ConnectionState.none:
                                                      case ConnectionState.waiting:
                                                        return Center(
                                                          child: Container(
                                                            width: 50,
                                                            height: 50,
                                                          ),
                                                        );
                                                      default:
                                                        if (snapshot.hasError) {
                                                          return Center(
                                                            child: Text(
                                                                "Error..."),
                                                          );
                                                        }
                                                        if (!snapshot.hasData) {
                                                          return Center(
                                                            child: Text(
                                                                "No Data..."),
                                                          );
                                                        } else {
                                                          return ListView.builder(
                                                                  scrollDirection: Axis.vertical,
                                                                  shrinkWrap: true,
                                                                  physics: ClampingScrollPhysics(),
                                                                  itemCount: snapshot.data!.length,
                                                                  itemBuilder: (context, index) {
                                                                    //Get Parse Object Values
                                                                    final medGet = snapshot.data![index];
                                                                    final TradeName = medGet.get<String>('TradeName')!;
                                                                    final ScientificName = medGet.get<String>('ScientificName')!;
                                                                    final Publicprice = medGet.get<num>('Publicprice')!;
                                                                    num counter = quantity;
                                                                    TotalPrice = (Publicprice*quantity) + TotalPrice;
                                                                    TotalPrice = num.parse(TotalPrice.toStringAsFixed(2));
                                                                    return StatefulBuilder(
                                                                                    builder: (BuildContext context, StateSetter setState)=>
                                                                                        Dismissible(
                                                                                            key: UniqueKey(),
                                                                                            background: Container(
                                                                                              alignment: Alignment.centerRight,
                                                                                              padding: EdgeInsets.symmetric(horizontal: 30),
                                                                                                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                                decoration: BoxDecoration(
                                                                                                    color: Colors.red[100],
                                                                                                    borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                                child: Icon(
                                                                                                  Icons.delete_outline,
                                                                                                  size: 40,
                                                                                                  semanticLabel: 'Delete'
                                                                                                  ,color: Colors.red,)),
                                                                                            direction: DismissDirection.endToStart,
                                                                                            confirmDismiss: (DismissDirection direction) async {
                                                                                              return await showDialog(
                                                                                                context: context,
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    title:  Text("Are you sure you wish to delete this item?", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                          onPressed: () => Navigator.of(context).pop(true),
                                                                                                        child: const Text("DELETE", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                        onPressed: () => Navigator.of(context).pop(false),
                                                                                                        child: const Text("CANCEL", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                            onDismissed: (direction) async {
                                                                                              if(await deleteCartMed(medId, quantity)){
                                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                  content: Text("$TradeName deleted from your cart", style:  TextStyle(fontSize: 20),),
                                                                                                  duration: Duration(milliseconds: 3000),
                                                                                                ));
                                                                                              }

                                                                                            },

                                                                                            child:
                                                                                                Stack(
                                                                                                        children: <
                                                                                                            Widget>[
                                                                                                          Container(
                                                                                                            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                                            decoration: BoxDecoration(
                                                                                                                color: Colors.white,
                                                                                                                borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                                            child:
                                                                                                                Row(
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
                                                                                                                            style: TextStyle(
                                                                                                                            fontFamily: "Lato",
                                                                                                                            fontSize: 20,
                                                                                                                            fontWeight: FontWeight.w700),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        SizedBox(height: 6),
                                                                                                                        Text(
                                                                                                                          ScientificName,
                                                                                                                          style: TextStyle(
                                                                                                                              fontFamily: "Lato",
                                                                                                                              fontSize: 17,
                                                                                                                              color: Colors.black),
                                                                                                                        ),
                                                                                                                        Container(
                                                                                                                          child: Row(
                                                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                            children: <Widget>[
                                                                                                                              Text(
                                                                                                                                '$Publicprice SAR',
                                                                                                                                style: TextStyle(
                                                                                                                                    fontFamily: "Lato",
                                                                                                                                    fontSize: 17,
                                                                                                                                    color: Colors.black,
                                                                                                                                    fontWeight: FontWeight.w600),
                                                                                                                              ),
                                                                                                                              Padding(
                                                                                                                                padding: const EdgeInsets.all(0.0),
                                                                                                                                child: Row(
                                                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                  children: <Widget>[
                                                                                                                                    CircleAvatar(
                                                                                                                                      backgroundColor: HexColor('#e8cafc'),
                                                                                                                                     child:IconButton(onPressed: () {
                                                                                                                                      decrement(medId, widget.customerId,counter!);
                                                                                                                                      setState(() {
                                                                                                                                        if(counter>1){
                                                                                                                                          TotalPrice;
                                                                                                                                          counter--;
                                                                                                                                        }
                                                                                                                                      });
                                                                                                                                    }, icon: const Icon(Icons.remove,color: Colors.black,
                                                                                                                                      size: 24.0,))),
                                                                                                                                    Container(
                                                                                                                                      padding: const EdgeInsets.only(bottom: 2, right: 12, left: 12),
                                                                                                                                      child: Text(
                                                                                                                                        '$counter',style: TextStyle(
                                                                                                                                          fontFamily: "Lato",
                                                                                                                                          fontSize: 22,
                                                                                                                                          color: Colors.black),
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                CircleAvatar(
                                                                                                                                    backgroundColor: HexColor('#fad2fc'),
                                                                                                                                    child:IconButton(onPressed: () {
                                                                                                                                      increment(medId, widget.customerId,counter!);
                                                                                                                                      setState(() {
                                                                                                                                        counter++;
                                                                                                                                      });
                                                                                                                                    }, icon: const Icon(Icons.add,color: Colors.black,
                                                                                                                                      size: 24.0,))),
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
                                            });
                                      }
                                  }
                                }))
                      ]),
                    ))),
                        SizedBox(height: 15,),]))),
            ])),

        persistentFooterButtons: [
          Text('Continue',style: TextStyle(fontFamily: 'Lato',fontSize: 25, fontWeight: FontWeight.bold, )),
          CircleAvatar(
            backgroundColor: Colors.purple.shade300,
              child:IconButton(onPressed: () {
                setState(() {
                });
              }, icon: const Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,
                size: 24.0,))),
        ],
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
                      }
                    else if (_selectedIndex == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(widget.customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersPage()));
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

  Future<List<ParseObject>> getCustomerCart() async {
    final QueryBuilder<ParseObject> customerCart =
        QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

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

  Future<bool> deleteCartMed(medId, Quantity) async {
    print('ooo');
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', medId.toPointer());
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        final object = o as ParseObject;
        object.delete();
        return true;
      }
    }
    return false;
  }

  Future<void> increment(objectId, customerId, Quantity) async {
    var medInCart;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', objectId.toPointer());
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        medInCart = o as ParseObject;
      }

      var incrementQuantity = medInCart..set('Quantity', ++Quantity);
      await incrementQuantity.save();
      final apiResponse2 = await ParseObject('Medications').get(objectId);

      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results) {
          final object = o as ParseObject;
          TotalPrice = TotalPrice + object.get('Publicprice');
          TotalPrice = num.parse(TotalPrice.toStringAsFixed(2));
        }
      }
    }
  }

  Future<void> decrement(objectId, customerId, Quantity) async {
    var medInCart;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    parseQuery.whereEqualTo('medication', objectId.toPointer());
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        medInCart = o as ParseObject;
      }
      if (Quantity != 1) {
        var decrementQuantity = medInCart..set('Quantity', --Quantity);
        await decrementQuantity.save();
        final apiResponse2 = await ParseObject('Medications').get(objectId);

        if (apiResponse2.success && apiResponse2.results != null) {
          for (var o in apiResponse2.results) {
            final object = o as ParseObject;
            TotalPrice = TotalPrice - object.get('Publicprice');
            TotalPrice = num.parse(TotalPrice.toStringAsFixed(2));
          }
        }
      }

  }
  }
}