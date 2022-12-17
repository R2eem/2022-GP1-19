import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Location.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'PresAttach.dart';
import 'Settings.dart';
import 'Location.dart';

class OrderedMedListPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const OrderedMedListPage(this.customerId);
  @override
  OrderedMedList createState() => OrderedMedList();
}

class OrderedMedList extends State<OrderedMedListPage> {
  int _selectedIndex = 0;
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
                                margin: EdgeInsets.fromLTRB(15, 13, 0, 0),
                                child: Text(
                                  'Order Details',
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
                                                            return ListView.builder(
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
                            SizedBox(
                              height: 15,
                            ),
                          ]))),
            ])),
        //Button continue
        persistentFooterButtons: [
          if(cartItemNum != 0)
            Text('Continue',
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
          if(cartItemNum !=0)
            CircleAvatar(
                backgroundColor: Colors.purple.shade300,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Location(widget.customerId, TotalPrice, presRequired)));//PresLocation(widget.customerId, TotalPrice, presRequired)));

                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 24.0,
                    ))),
        ],
        //Bottom navigation bar
        // bottomNavigationBar: Container(
        //     color: Colors.white,
        //     child: Padding(
        //         padding:
        //         const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        //         child: GNav(
        //           gap: 8,
        //           padding: const EdgeInsets.all(10),
        //           tabs: [
        //             GButton(
        //                 icon: Icons.home,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30),
        //             GButton(
        //                 icon: Icons.shopping_cart,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30),
        //             GButton(
        //                 icon: Icons.shopping_bag,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30),
        //             GButton(
        //                 icon: Icons.settings,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30),
        //           ],
        //           selectedIndex: _selectedIndex,
        //           onTabChange: (index) => setState(() {
        //             _selectedIndex = index;
        //             if (_selectedIndex == 0) {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => CategoryPage()));
        //             } else if (_selectedIndex == 1) {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           OrderedMedListPage(widget.customerId)));
        //             } else if (_selectedIndex == 2) {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           OrdersPage(widget.customerId)));
        //             } else if (_selectedIndex == 3) {
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) =>
        //                           SettingsPage(widget.customerId)));
        //             }
        //           }),
        //         )))
    );
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

      return apiResponse.results as List<ParseObject>;
    } else {
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


}