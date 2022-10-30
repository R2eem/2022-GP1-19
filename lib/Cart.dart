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


class CartPage extends StatefulWidget {
  final String customerId;
  const CartPage(this.customerId);
  @override
  Cart createState() => Cart();
}

class Cart extends State<CartPage> {
  int _selectedIndex = 1;
  String searchString = "";
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
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Image.asset(
                                'assets/logoheader.png',
                                fit: BoxFit.contain,
                                width: 110,
                                height: 80,
                              ),
                            ),
                            Align(
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
                                                    return ListView.builder(
                                                        padding: EdgeInsets.only(top: 10.0,bottom: 20.0),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: snapshot.data!.length,
                                                        itemBuilder: (context, index) {
                                                          //Get Parse Object Values
                                                          final customerCart = snapshot.data![index];
                                                          final medId = customerCart.get('medication')!;
                                                          final quantity = customerCart.get<num>('Quantity')!;
                                                          return  FutureBuilder<List<ParseObject>>(
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
                                                                        child: Text("Error..."),
                                                                      );
                                                                    }
                                                                    if (!snapshot.hasData) {
                                                                      return Center(
                                                                        child: Text("No Data..."),
                                                                      );
                                                                    } else {
                                                                      return ListView.builder(
                                                                          scrollDirection: Axis.vertical,
                                                                          shrinkWrap: true,
                                                                          padding: EdgeInsets.only(top: 10.0,bottom: 20.0),
                                                                          itemCount: snapshot.data!.length,
                                                                          itemBuilder: (context, index) {
                                                                            //Get Parse Object Values
                                                                            final medGet = snapshot.data![index];
                                                                            final TradeName = medGet.get<String>('TradeName')!;
                                                                            final ScientificName = medGet.get<String>('ScientificName')!;
                                                                            final Publicprice = medGet.get<num>('Publicprice')!;
                                                                            return  SingleChildScrollView(
                                                                                child:
                                                                                StatefulBuilder(
                                                                                    builder: (BuildContext context, StateSetter setState)=>
                                                                                        Dismissible(
                                                                                            key: UniqueKey(),
                                                                                            background: Container(color: Colors.red,child: Icon(Icons.delete,size: 30, semanticLabel: 'Delete',color: Colors.white,)),
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
                                                                                            onDismissed: (direction){
                                                                                              deleteCartMed(medId);
                                                                                            },

                                                                                            child:Card(
                                                                                                elevation: 3,
                                                                                                color: Colors.white,
                                                                                                child: Column(
                                                                                                    children:[
                                                                                                      ListTile(
                                                                                                        title: Text(TradeName,style: TextStyle(
                                                                                                            fontFamily: "Lato",
                                                                                                            fontSize: 20,
                                                                                                            fontWeight: FontWeight.w700),),
                                                                                                        subtitle: Text('$ScientificName , $Publicprice SAR',style: TextStyle(
                                                                                                            fontFamily: "Lato",
                                                                                                            fontSize: 17,
                                                                                                            color: Colors.black),),
                                                                                                        trailing: Text('$quantity'),
                                                                                                      ),
                                                                                                    ] )))));
                                                                          });
                                                                    }
                                                                }
                                                              });
                                                        });
                                                  }
                                              }
                                            }))
                                  ]),
                                ))
                          ]))),
            ])
        ),
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
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_cart,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_bag,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.settings,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(widget.customerId)));
                    }
                  }),
                ))));
  }


  Future<List<ParseObject>> getCustomerCart() async {
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer', (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


  Future<List<ParseObject>> getCustomerCartMed(medId) async {
    final QueryBuilder<ParseObject> customerCartMed =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    customerCartMed.whereEqualTo('objectId', medId.objectId);
    final apiResponse = await customerCartMed.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<bool> deleteCartMed(medId) async{
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Cart'));
    parseQuery.whereEqualTo('medication', medId.toPointer());
    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        final object = o as ParseObject;
        object.delete();
        return true;
      }
    }
    return false;
  }
}