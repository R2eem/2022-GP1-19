import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/PrescriptionCategory.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'OrderedMedList.dart';
import 'Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Settings.dart';
import 'package:geocoder2/geocoder2.dart';

import 'medDetails.dart';





class PharmcyOrdersPage extends StatefulWidget {
  const PharmcyOrdersPage();
  @override
  PharmcyOrders createState() => PharmcyOrders();
}

class PharmcyOrders extends State<PharmcyOrdersPage> {
  int _selectedIndex = 0;
  bool LocationPageNotEmpty = false;
  int NoOfLocation = 0;
  String loc ="";
  var OrderStatus="complete";
  String medID="RaR20HREPJ";




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
                        //Controls location page title
                        Container(
                          margin: EdgeInsets.fromLTRB(30, 13, 0, 0),
                          child: Text(
                            'Orders',
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
                                    child: FutureBuilder<List<ParseObject>>(
                                        future:
                                        GetOrders(), //Will change LocationNotEmpty value
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
                                                  child: Text("Error3..."),
                                                );
                                              }
                                              if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text("No Data..."),
                                                );
                                              } else {
                                                return LocationPageNotEmpty
                                                    ? ListView.builder(
                                                    scrollDirection:
                                                    Axis.vertical,
                                                    itemCount:
                                                    snapshot.data!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      //Get Parse Object Values
                                                      //Get customer locations from Locations table
                                                      NoOfLocation = snapshot
                                                          .data!
                                                          .length; //Save number of Locations
                                                      final OrdersTable =
                                                      snapshot.data![index];
                                                      final OrderId = OrdersTable
                                                          .get('objectId')!;
                                                      //ParseFile press = OrdersTable.get<ParseFile>("Prescription")!;

                                                      OrderStatus = OrdersTable.get("OrderStatus");
                                                      var customerID = "ZHHasUGbW4";
                                                      // OrdersTable.get("Customer_id").toString();
                                                      // customerID=customerID.substring(36,46);
                                                       final orderCreatedDate = OrdersTable.get("createdAt").toString();

                                                      final orderdate = orderCreatedDate.substring(0,11);
                                                      final orderTime = orderCreatedDate.substring(10,19);

                                                         return  GestureDetector(
                                                          onTap: () => Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              OrderedMedListPage(customerID))),
                                                              child:StatefulBuilder(
                                                                  builder: (BuildContext context, StateSetter setState) =>
                                                                      Stack( //display Locations cards
                                                                        children: <Widget>[
                                                                          Container(
                                                                            margin: EdgeInsets.only(left: 16, right: 16, top: 20),
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
                                                                                        if(OrderStatus.contains("Under processing") || OrderStatus.contains("Accepted")  || OrderStatus.contains("Ready"))
                                                                                          Text(
                                                                                            "New order",
                                                                                            maxLines: 2,
                                                                                            softWrap: true,
                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700 ,
                                                                                                background: Paint()
                                                                                                  ..strokeWidth = 25.0
                                                                                                  ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                                                                  ..style = PaintingStyle.stroke
                                                                                                  ..strokeJoin = StrokeJoin.round
                                                                                            ),),
                                                                                        if(OrderStatus.contains("Under processing") || OrderStatus.contains("Accepted")  || OrderStatus.contains("Ready"))
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                        if(OrderStatus.contains("Under processing") || OrderStatus.contains("Accepted")  || OrderStatus.contains("Ready"))
                                                                                          Container(
                                                                                            padding: EdgeInsets.only(right: 8, top: 4),
                                                                                            child: Text(
                                                                                              "Date: $orderdate \nTime:$orderTime",

                                                                                              maxLines: 2,
                                                                                              softWrap: true,
                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 19, fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          ),
                                                                                        if(OrderStatus.contains("Under processing") || OrderStatus.contains("Accepted")  || OrderStatus.contains("Ready"))
                                                                                          Container(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: <Widget>[
                                                                                                Text(
                                                                                                  '$OrderStatus ',
                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.green, fontWeight: FontWeight.w600),
                                                                                                ),
                                                                                                //Increment and decrement of medication
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        if(OrderStatus.contains("Completed") || OrderStatus.contains("Cancelled"))
                                                                                          Text(
                                                                                            "Old order",
                                                                                            maxLines: 2,
                                                                                            softWrap: true,
                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700 ,
                                                                                                background: Paint()
                                                                                                  ..strokeWidth = 25.0
                                                                                                  ..color =  Colors.grey.withOpacity(0.5)
                                                                                                  ..style = PaintingStyle.stroke
                                                                                                  ..strokeJoin = StrokeJoin.round
                                                                                            ),),
                                                                                        if(OrderStatus.contains("Completed") || OrderStatus.contains("Cancelled"))
                                                                                          SizedBox(
                                                                                            height: 15,
                                                                                          ),
                                                                                        if(OrderStatus.contains("Completed") || OrderStatus.contains("Cancelled"))
                                                                                          Container(
                                                                                            padding: EdgeInsets.only(right: 8, top: 4),
                                                                                            child: Text(
                                                                                              "Date: $orderdate \nTime:$orderTime",

                                                                                              maxLines: 2,
                                                                                              softWrap: true,
                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 19, fontWeight: FontWeight.w700),
                                                                                            ),
                                                                                          ),
                                                                                        if(OrderStatus.contains("Completed") || OrderStatus.contains("Cancelled"))
                                                                                          Container(
                                                                                            child: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                              children: <Widget>[
                                                                                                Text(
                                                                                                  '$OrderStatus ',
                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.red, fontWeight: FontWeight.w600),
                                                                                                ),
                                                                                                //Increment and decrement of medication
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

                                                    } )

                                                //If LocationNotEmpty is false; Location is empty show this message
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
                                                            'You do not have saved locations',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                "Lato",
                                                                fontSize: 20,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                          ),
                                                        ]));
                                              } }
                                        })

                                )]),
                            ),)),
                    ]),
              ),)
            ,])
          ,),

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
        //                 icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.shopping_cart,iconActiveColor:Colors.purple.shade200,iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.shopping_bag,iconActiveColor:Colors.purple.shade200,iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.settings,iconActiveColor:Colors.purple.shade200,iconSize: 30
        //             ),
        //           ],
        //           selectedIndex: _selectedIndex,
        //           // onTabChange: (index) => setState(() {
        //           //   _selectedIndex = index;
        //           //   if (_selectedIndex == 0) {
        //           //     Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
        //           //   } else if (_selectedIndex == 1) {
        //           //     Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
        //           //   } else if (_selectedIndex == 2) {
        //           //     Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
        //           //   } else if (_selectedIndex == 3) {
        //           //     Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
        //           //   }
        //           // }),
        //         )))
    );

  }


  //recive orders
  Future<List<ParseObject>> GetOrders() async {
    final QueryBuilder<ParseObject> Orders =
    QueryBuilder<ParseObject>(ParseObject('Orders'));

    final apiResponse = await Orders.query();

    if (apiResponse.success && apiResponse.results != null) {
      //If query have objects then set true
      LocationPageNotEmpty=true;

      return apiResponse.results as List<ParseObject>;
    } else {
      //If query have no object then set false
      LocationPageNotEmpty=false;
      return [];
    }
  }




}


