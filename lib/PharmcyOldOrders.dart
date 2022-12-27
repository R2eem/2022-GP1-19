import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'PharmacyNewOrders.dart';
import 'PharmacyOrdereDetails.dart';
import 'package:untitled/widgets/header_widget.dart';






class PharmcyOldOrdersPage extends StatefulWidget {

  const PharmcyOldOrdersPage();
  @override
  PharmcyOldOrders createState() => PharmcyOldOrders();
}

class PharmcyOldOrders extends State<PharmcyOldOrdersPage>with TickerProviderStateMixin  {
  int _selectedIndex = 1;
  bool pharmacyPgaeNotEmpty = false;
  int NoOfLocation = 0;
  String loc ="";
  var PharmacyOrderStatusFromDB="";
  var pharmcyID="";
  int _selectedTab = 0 ;
  String orderStatus ='';




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController=
    TabController(length: 12, vsync: this, initialIndex: 0 );
    _tabController.animateTo(_selectedTab);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Stack(children: [

            // FutureBuilder<ParseUser?>(
            //     future: getUser(),
            //     builder: (context, snapshot) {
            //       switch (snapshot.connectionState) {
            //         case ConnectionState.none:
            //         case ConnectionState.waiting:
            //           return Center(
            //             child: Container(
            //                 width: 50,
            //                 height: 50,
            //                 child: CircularProgressIndicator()),
            //           );
            //         default:
            //           if (snapshot.hasError) {
            //             return Center(
            //               child: Text("Error..."),
            //             );
            //           }
            //           if (!snapshot.hasData) {
            //             return Center(
            //               child: Text("No Data..."),
            //             );
            //           } else {
            //             var userId = snapshot.data!.objectId;
            //             //Get user from pharmcy table
            //             return FutureBuilder<List>(
            //                 future: currentuser(userId),
            //                 builder: (context, snapshot) {
            //                   switch (snapshot.connectionState) {
            //                     case ConnectionState.none:
            //                     case ConnectionState.waiting:
            //                       return Center(
            //                         child: Container(
            //                             margin: EdgeInsets.only(top: 100),
            //                             width: 0,
            //                             height: 0,
            //                             child: CircularProgressIndicator()),
            //                       );
            //                     default:
            //                       if (snapshot.hasError) {
            //                         return Center(
            //                           child: Text("Error..."),
            //                         );
            //                       }
            //                       if (!snapshot.hasData) {
            //                         return Center(
            //                           child: Text("No Data..."),
            //                         );
            //                       } else {
            //                         return ListView.builder(
            //                             padding: EdgeInsets.only(top: 10.0),
            //                             scrollDirection: Axis.vertical,
            //                             shrinkWrap: true,
            //                             itemCount: snapshot.data!.length,
            //                             itemBuilder: (context, index) {
            //                               //Get Parse Object Values
            //                               final user = snapshot.data![index];
            //                               pharmcyID =
            //                               user.get<String>('objectId')!;
            //                               return Container();
            //                             });
            //                       }
            //                   }
            //                 });
            //           }
            //       }
            //     }),
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

                                TabBar(onTap: (index){ //
                                  setState(() {
                                    _selectedTab = index;
                                    if(_selectedTab == 0)
                                      orderStatus = 'Collected';
                                    if(_selectedTab == 1)
                                      orderStatus ='Cancelled';
                                    if(_selectedTab == 2)
                                      orderStatus = 'Rejected';
                                  },);},
                                    isScrollable: true,//if thr tabs are alot we can scroll them
                                    controller: _tabController,
                                    labelColor: Colors.grey[900],// the tab is clicked on now color
                                    unselectedLabelColor: Colors.grey,
                                    tabs: [
                                      Tab(icon: Text('Collected' ,style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                                      Tab(icon: Text('Cancelled', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                                      Tab(icon: Text('Rejected', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                                    ]),
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
                                                return pharmacyPgaeNotEmpty
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

                                                      PharmacyOrderStatusFromDB = OrdersTable.get("PharmcyOrderStatus");

                                                      var customerId = OrdersTable.get("Customer_id").toString();
                                                      customerId=customerId.substring(36,46);
                                                      final orderCreatedDate = OrdersTable.get("createdAt").toString();

                                                      final orderdate = orderCreatedDate.substring(0,11);
                                                      final orderTime = orderCreatedDate.substring(10,19);

                                                      return ((PharmacyOrderStatusFromDB.toLowerCase().contains(orderStatus.toLowerCase())))
                                                          ?  GestureDetector(
                                                          onTap: () => Navigator.of(context)
                                                              .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PharmacyOrdereDetailsPage(customerId,OrderId))),
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
                                                                                    Text(
                                                                                      "$PharmacyOrderStatusFromDB",
                                                                                      maxLines: 2,
                                                                                      softWrap: true,
                                                                                      style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700 ,
                                                                                          background: Paint()
                                                                                            ..strokeWidth = 25.0
                                                                                            ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                                                            ..style = PaintingStyle.stroke
                                                                                            ..strokeJoin = StrokeJoin.round
                                                                                      ),),
                                                                                    SizedBox(
                                                                                      height: 15,
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.only(right: 8, top: 4),
                                                                                      child: Text(
                                                                                        "Date: $orderdate \nTime:$orderTime",

                                                                                        maxLines: 2,
                                                                                        softWrap: true,
                                                                                        style: TextStyle(fontFamily: "Lato", fontSize: 19, fontWeight: FontWeight.w700),
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
                                                                  )))
                                                          : Container();


                                                    } )

                                                //If LocationNotEmpty is false; Location is empty show this message
                                                    : Container();
                                              } }
                                        })

                                )]),
                            ),)),
                    ]),
              ),)
            ,])
          ,),

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
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PharmcyNewOrdersPage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PharmcyOldOrdersPage()));
                    }
                    // else if (_selectedIndex == 2) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
                    // } else if (_selectedIndex == 3) {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    // }
                  }),
                )))
    );

  }



  // //Function to get current logged in user
  // Future<ParseUser?> getUser() async {
  //   var currentUser = await ParseUser.currentUser() as ParseUser?;
  //   return currentUser;
  // }
  //
  // //Function to get current user from pharmcy table
  // Future<List> currentuser(userId) async {
  //   QueryBuilder<ParseObject> queryCustomers =
  //   QueryBuilder<ParseObject>(ParseObject('Pharmacist'));
  //   queryCustomers.whereContains('user', userId);
  //   final ParseResponse apiResponse = await queryCustomers.query();
  //   if (apiResponse.success && apiResponse.results != null) {
  //     return apiResponse.results as List<ParseObject>;
  //   } else {
  //     return [];
  //   }
  // }




  //recive orders
  Future<List<ParseObject>> GetOrders() async {

    final QueryBuilder<ParseObject> Orders =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    Orders.orderByDescending("createdAt");

    final apiResponse = await Orders.query();

    if (apiResponse.success && apiResponse.results != null) {
      //If query have objects then set true
      pharmacyPgaeNotEmpty=true;

      return apiResponse.results as List<ParseObject>;
    } else {
      //If query have no object then set false
      pharmacyPgaeNotEmpty=false;
      return [];
    }
  }




}


