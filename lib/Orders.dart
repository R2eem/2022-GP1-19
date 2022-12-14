import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Cart.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'OrderDetails.dart';
import 'Settings.dart';


class OrdersPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const OrdersPage(this.customerId);
  @override
  Orders createState() => Orders();
}

class Orders extends State<OrdersPage> {
  int _selectedIndex = 2;
  int orderNum = 1;
  bool currentOrders = true;
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
              //Controls app logo and page title
              Container(
                  child: SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Image.asset('assets/logoheader.png',
                                      fit: BoxFit.contain,
                                      width: 110,
                                      height: 80,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(50, 13, 0, 0),
                                    child: Text('Orders', textAlign: TextAlign
                                        .center, style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 27,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),),
                                  ),
                                ]),
                            SizedBox(height: 55,),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0),
                              child:Text('Current Orders', textAlign: TextAlign
                                  .center, style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold)),),

                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                            child: FutureBuilder<List<ParseObject>>(
                                                future: getCustomerCurrentOrders(),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState
                                                        .waiting:
                                                      return Center(
                                                        child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            child:
                                                            CircularProgressIndicator()),
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
                                                      }
                                                      if(snapshot.data!.length == 0){
                                                        return Center(
                                                             child:Column(
                                                               children:[
                                                                 Icon(Icons.shopping_cart_outlined,color: Colors.black45,size: 30,),
                                                                 Text("You don't have orders now.",style: TextStyle(
                                                                     fontFamily: "Lato",
                                                                     fontSize: 18,
                                                                     color: Colors.black45,
                                                                     fontWeight: FontWeight.w700),)
                                                               ]
                                                             )
                                                        );
                                                      }
                                                        else {
                                                        return  ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.vertical,
                                                            itemCount: snapshot.data!.length,
                                                            itemBuilder: (context, index) {
                                                              final customerCurrentOrders = snapshot.data![index];
                                                              final OrderId = customerCurrentOrders.get('objectId');
                                                              final CreatedDate = customerCurrentOrders.get('createdAt')!;
                                                              final OrderStatus = customerCurrentOrders.get('OrderStatus')!;
                                                              final TotalPrice = customerCurrentOrders.get('TotalPrice')!;

                                                              return  GestureDetector(
                                                                //Navigate to order details page
                                                                  onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailsPage(widget.customerId, OrderId!, true))),
                                                                  //Order card information
                                                                  child: Card(
                                                                      elevation: 3,
                                                                      color: Colors.white,
                                                                      child: ClipPath(
                                                                             child: Container(
                                                                                   decoration: BoxDecoration(
                                                                                     border: Border(
                                                                                       left: BorderSide(color: Colors.purple.shade200, width:5),
                                                                                       bottom: BorderSide(color: Colors.grey, width: 3),
                                                                                     ),
                                                                                   ),
                                                                      child: Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                                      child:  Row(
                                                                          children:[
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children:[
                                                                                Text('Order ID:  $OrderId',style: TextStyle(
                                                                                    fontFamily: "Lato",
                                                                                    fontSize: 19,
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w600),),
                                                                                Text((CreatedDate).toString().substring(0,(CreatedDate).toString().indexOf(' ')) ,style: TextStyle(
                                                                                    fontFamily: "Lato",
                                                                                    fontSize: 18,
                                                                                    color: Colors.black54,
                                                                                    fontWeight: FontWeight.w700),),
                                                                                Text(OrderStatus ,style: TextStyle(
                                                                                    fontFamily: "Lato",
                                                                                    fontSize: 17,
                                                                                    color: Colors.black45,
                                                                                    fontWeight: FontWeight.w700),),
                                                                                SizedBox(height: 10),
                                                                              ]),
                                                                                Spacer(),
                                                                                Text('$TotalPrice SAR',style: TextStyle(
                                                                                    fontFamily: "Lato",
                                                                                    fontSize: 19,
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w600),),
                                                                                Spacer(),
                                                                                Icon(Icons.arrow_forward_ios_rounded, color: Colors.black45, size: 30)
                                                                              ]) )))));
                                                            });
                                                      }
                                                  }
                                                })
                                    ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0),
                              child:Text('Previous Orders', textAlign: TextAlign
                                  .center, style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold)),),
                            SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child:  FutureBuilder<List<ParseObject>>(
                                                future: getCustomerPreviousOrders(),
                                                builder: (context, snapshot) {
                                                  switch (snapshot
                                                      .connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState
                                                        .waiting:
                                                      return Center(
                                                        child: Container(
                                                            width: 50,
                                                            height: 50,
                                                            child:
                                                            CircularProgressIndicator()),
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
                                                      } if(snapshot.data!.length == 0){
                                                        return Center(
                                                            child:Column(
                                                                children:[
                                                                  Icon(Icons.shopping_cart_outlined,color: Colors.black45,size: 30,),
                                                                  Text("You don't have orders now.",style: TextStyle(
                                                                      fontFamily: "Lato",
                                                                      fontSize: 18,
                                                                      color: Colors.black45,
                                                                      fontWeight: FontWeight.w700),)
                                                                ]
                                                            )
                                                        );
                                                      }
                                                      else {
                                                        return  ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection: Axis.vertical,
                                                            itemCount: snapshot.data!.length,
                                                            itemBuilder: (context, index) {
                                                              final customerCurrentOrders = snapshot.data![index];
                                                              final OrderId = customerCurrentOrders.get('objectId');
                                                              final CreatedDate = customerCurrentOrders.get('createdAt')!;
                                                              final OrderStatus = customerCurrentOrders.get('OrderStatus')!;
                                                              final Prescription = customerCurrentOrders.get('Prescription')!;
                                                              final TotalPrice = customerCurrentOrders.get('TotalPrice')!;

                                                              return  GestureDetector(
                                                                //Navigate to order details page
                                                                  onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailsPage(widget.customerId, OrderId!, false))),
                                                                  //Order card information
                                                                  child: Card(
                                                                      elevation: 3,
                                                                      color: Colors.white,
                                                                      child: ClipPath(
                                                                          child: Container(
                                                                              decoration: BoxDecoration(
                                                                                border: Border(
                                                                                  left: BorderSide(color: Colors.purple.shade200, width:5),
                                                                                  bottom: BorderSide(color: Colors.grey, width: 3),
                                                                                ),
                                                                              ),
                                                                              child: Padding(padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                                                                  child:  Row(
                                                                                      children:[
                                                                                        Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children:[
                                                                                              Text('Order ID:  $OrderId',style: TextStyle(
                                                                                                  fontFamily: "Lato",
                                                                                                  fontSize: 19,
                                                                                                  color: Colors.black,
                                                                                                  fontWeight: FontWeight.w600),),
                                                                                              Text((CreatedDate).toString().substring(0,(CreatedDate).toString().indexOf(' ')) ,style: TextStyle(
                                                                                                  fontFamily: "Lato",
                                                                                                  fontSize: 18,
                                                                                                  color: Colors.black54,
                                                                                                  fontWeight: FontWeight.w700),),
                                                                                              Text(OrderStatus ,style: TextStyle(
                                                                                                  fontFamily: "Lato",
                                                                                                  fontSize: 17,
                                                                                                  color: Colors.black45,
                                                                                                  fontWeight: FontWeight.w700),),
                                                                                              SizedBox(height: 10),
                                                                                            ]),
                                                                                        Spacer(),
                                                                                        Text('$TotalPrice SAR',style: TextStyle(
                                                                                            fontFamily: "Lato",
                                                                                            fontSize: 19,
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.w600),),
                                                                                        Spacer(),
                                                                                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.black45, size: 30)
                                                                                      ]) )))));
                                                            });
                                                      }
                                                  }
                                                }))
                          ]))),
            ])),

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
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.receipt_long,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.settings,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) =>
                      setState(() {
                        _selectedIndex = index;
                        if (_selectedIndex == 0) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                        } else if (_selectedIndex == 1) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(widget.customerId)));
                        } else if (_selectedIndex == 2) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(widget.customerId)));
                        } else if (_selectedIndex == 3) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(widget.customerId)));
                        }
                      }),
                ))));
  }

  //Get customer current orders from orders table
  Future<List<ParseObject>> getCustomerCurrentOrders() async {

    //Query customer current orders
    final QueryBuilder<ParseObject> query1 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query1.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
        query1.whereEqualTo('OrderStatus','Under processing');
    final QueryBuilder<ParseObject> query2 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query2.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
        query2.whereEqualTo('OrderStatus','Ready for pick up');
    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("Orders"),
      [query1, query2],
    )..orderByDescending('createdAt');
    final apiResponse = await mainQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Get customer previous orders from orders table
  Future<List<ParseObject>> getCustomerPreviousOrders() async {
    //Query customer cart
    final QueryBuilder<ParseObject> query1 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query1.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
    query1.whereEqualTo('OrderStatus','Cancelled');
    final QueryBuilder<ParseObject> query2 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query2.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
    query2.whereEqualTo('OrderStatus','Completed');
    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("Orders"),
      [query1, query2],
    )..orderByDescending('createdAt');
    final apiResponse = await mainQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}
