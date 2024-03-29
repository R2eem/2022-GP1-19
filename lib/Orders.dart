import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Cart.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'LoginPage.dart';
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
  int numOfItems = 0;
  DateTime dateForTimer = DateTime.now();
  var _countdownTime = 0;


  //Check orders time
  Future<void> timer(orderId) async {
    var orderCreatedAt;
    var orderStatus;
    var accepted = false;
    var extraTime = 0;

    //Query order details
    final QueryBuilder<ParseObject> order =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    order.whereEqualTo('objectId', orderId);

    final apiResponse = await order.query();

    //Check pharmacy list for the order
    if (apiResponse.success && apiResponse.results != null) {
      for (var order in apiResponse.results!) {
        orderCreatedAt = order.get('createdAt');
        orderStatus = order.get('OrderStatus');
        final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
            ParseObject('PharmaciesList'));
        parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')
          ..objectId = orderId).toPointer());
        final parseQueryResponse = await parseQuery.query();

        ///If no registered pharmacies, then decline order immediately
        if(parseQueryResponse.results == null ){
          var o = order..set('OrderStatus', 'Declined');
          o.save();
          break;
        }

        ///Check if any pharmacy accepted the order
        for (var pharmaciesList in parseQueryResponse.results!) {
          if (pharmaciesList.get('OrderStatus') == 'Accepted') {
            accepted = true;
          }
        }
        if (accepted) {
          ///Time with extra time if order accepted from pharmacies
          extraTime = 15;
          String d3 = (orderCreatedAt.add(Duration(minutes: (30 + extraTime)))).toString();
          d3 = d3.substring(0, 19);
          dateForTimer = DateTime.parse(d3);
        }
        else {
          ///Original time 30 minutes
          String d2 = (orderCreatedAt.add(Duration(minutes: (30)))).toString();
          d2 = d2.substring(0, 19);
          dateForTimer = DateTime.parse(d2);
        }
      }
    }
    _countdownTime = dateForTimer.add(Duration(hours: 3)).millisecondsSinceEpoch;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailsPage(widget.customerId, orderId, true, _countdownTime, orderStatus)));
  }

  ///To check order status before displaying
  @override
  void initState() {
    super.initState();
    checkOrders();
  }


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
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.asset(
                                      'assets/logoheader.png',
                                      fit: BoxFit.contain,
                                      width: 110,
                                      height: 80,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                      child: IconButton(
                                        onPressed: () {
                                          Widget cancelButton = TextButton(
                                            child: Text("Yes", style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black)),
                                            onPressed: () {
                                              doUserLogout();
                                            },
                                          );
                                          Widget continueButton = TextButton(
                                            child: Text("No", style: TextStyle(
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
                                                "Are you sure you want to log out?",
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 20,)),
                                            content: Text(""),
                                            actions: [
                                              cancelButton,
                                              continueButton,
                                            ],
                                          );
                                          // show the dialog
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.logout_outlined,
                                          color: Colors.white, size: 30,
                                        ),
                                      )

                                  )
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
                                            child: FutureBuilder<List<ParseObject>>  (
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
                                                            physics: ClampingScrollPhysics(),
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
                                                                  onTap: () =>  timer(OrderId),
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
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child:  FutureBuilder<List<ParseObject>> (
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
                                                                  Text("You don't have previous orders.",style: TextStyle(
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
                                                            physics: ClampingScrollPhysics(),
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
                                                                  onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetailsPage(widget.customerId, OrderId!, false, 0, 'PreviousOrder'))),
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
                        iconSize: 30,
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

  //Check orders status
  Future<void> checkOrders() async {
    ///Query orders that are under processing and check if the order passed the time then make order declined
    var orderId;
    var allDeclined;
    var orderCreatedAt;
    var accepted = false;
    var extraTime = 0;

  final QueryBuilder<ParseObject> query1 =
  QueryBuilder<ParseObject>(ParseObject('Orders'));
  query1.whereEqualTo('Customer_id',
  (ParseObject('Customer')
  ..objectId = widget.customerId).toPointer());
  query1.whereEqualTo('OrderStatus','Under processing');

    final query1Response = await query1.query();
    if (query1Response.success && query1Response.results != null) {
      for (var order in query1Response.results!) {
        allDeclined = true;
        orderId = order.objectId;
        orderCreatedAt = order.get('createdAt');
        final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
            ParseObject('PharmaciesList'));
        parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')
          ..objectId = orderId).toPointer());
        final parseQueryResponse = await parseQuery.query();

        ///If no registered pharmacies, then decline order immediately
        if(parseQueryResponse.results == null ){
          var o = order..set('OrderStatus', 'Declined');
          o.save();
          break;
        }

        ///Check if all pharmacies declined the order
        for (var pharmaciesList in parseQueryResponse.results!) {
          if (pharmaciesList.get('OrderStatus') != 'Declined') {
            allDeclined = false;
          }
        }

        ///Check if any pharmacy accepted the order
        for (var pharmaciesList in parseQueryResponse.results!) {
          if (pharmaciesList.get('OrderStatus') == 'Accepted') {
            accepted = true;
          }
        }
        if (accepted) {
          extraTime = 15;
        }


        ///For customer If all pharmacies declined the order before time passes make order declined for customer
        if (allDeclined) {
          var update = order..set('OrderStatus', 'Declined');
          final ParseResponse parseResponse = await update.save();
        }

        ///*********Time code

        ///If order not declined and customer didn't select a pharmacy check time
        if (!allDeclined) {
          String d1 = (DateTime.now()).subtract(Duration(hours: 3)).toString();
          ///Original time 30 minutes
          String d2 = (orderCreatedAt.add(Duration(minutes: (30)))).toString();
          ///Time with extra time if order accepted from pharmacies
          String d3 = (orderCreatedAt.add(Duration(minutes: (30 + extraTime)))).toString();
          d1 = d1.substring(0, 19);
          d2 = d2.substring(0, 19);
          d3 = d3.substring(0, 19);
          DateTime date1 = DateTime.parse(d1);
          DateTime date2 = DateTime.parse(d2);
          DateTime date3 = DateTime.parse(d3);
          ///If there is acceptance from pharmacies and original time passed +
          ///cancel order only for pharmacies who didn't reply
          if (accepted && date1.isAfter(date2)) {
            ///For pharmacies
            for (var pharmaciesList in parseQueryResponse.results!) {
              ///If pharmacy declined or accepted order leave as it is for that pharmacy
              ///If pharmacy didn't reply make order cancelled for that pharmacy
              if (pharmaciesList.get('OrderStatus') != 'Declined') {
                if (pharmaciesList.get('OrderStatus') != 'Accepted') {
                  var update = pharmaciesList..set('OrderStatus', 'Cancelled');
                  final ParseResponse parseResponse = await update.save();
                }
              }
            }
            ///Update time, add extra time
            date2 = date3;
          }
          ///If time passed make order status declined for customer +
          ///order status cancelled for pharmacies who accepted or didn't reply
          if (date1.isAfter(date2)) { //date2 here either will be original or with extra time
            ///For pharmacies
            for (var pharmaciesList in parseQueryResponse.results!) {
              ///If pharmacy declined order leave as declined for that pharmacy
              ///If pharmacy didn't reply make order cancelled for that pharmacy
              if (pharmaciesList.get('OrderStatus') != 'Declined') {
                var update = pharmaciesList..set('OrderStatus', 'Cancelled');
                final ParseResponse parseResponse = await update.save();
              }
            }
            ///For customer
            var update = order..set('OrderStatus', 'Declined');
            final ParseResponse parseResponse = await update.save();
          }
          ///End of time code
        }
      }
    }
}

  //Get customer current orders from orders table
  Future<List<ParseObject>> getCustomerCurrentOrders() => Future.delayed(Duration(seconds: 2), () async {

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

    final QueryBuilder<ParseObject> query3 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query3.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
    query3.whereEqualTo('OrderStatus','Under preparation');
    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("Orders"),
      [query1, query2, query3],
    )..orderByDescending('createdAt');
    final apiResponse = await mainQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  });

  //Get customer previous orders from orders table
  ///Wait for current orders to appear so if any orders become declined will appear in this query
  Future<List<ParseObject>> getCustomerPreviousOrders() => Future.delayed(Duration(seconds: 3), () async {
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
    query2.whereEqualTo('OrderStatus','Collected');
    final QueryBuilder<ParseObject> query3 =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    query3.whereEqualTo('Customer_id',
        (ParseObject('Customer')
          ..objectId = widget.customerId).toPointer());
    query3.whereEqualTo('OrderStatus','Declined');
    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("Orders"),
      [query1, query2, query3],
    )..orderByDescending('createdAt');
    final apiResponse = await mainQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  });


  void showErrorLogout(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log out failed!", style: TextStyle(fontFamily: 'Lato', fontSize: 20,color: Colors.red)),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },

    );
  }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } else {
      showErrorLogout(response.error!.message);
    }
  }
}
