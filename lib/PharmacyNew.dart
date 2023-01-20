import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_notify/native_notify.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'PharmacyOrdersDetails.dart';
import 'package:untitled/PharHomePage.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'PharmacyLogin.dart';



class PharmacyNewO extends StatefulWidget {
  final pharmacyId;
  const PharmacyNewO(this.pharmacyId);
  @override
  PharmacyNew createState() => PharmacyNew();
}

class PharmacyNew extends State<PharmacyNewO>
  with TickerProviderStateMixin {

  String filter = '';
  int _selectedTab = 0;
  bool noOrder = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController =
    TabController(length: 5, vsync: this, initialIndex: 0);
    _tabController.animateTo(_selectedTab);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(children: [
          //Header
          Container(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
          ///App logo
          Container(
            child: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                                  child: IconButton(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                                    iconSize: 40,
                                    color: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PharHomePage()));
                                    }, icon: Icon(Icons.keyboard_arrow_left),),
                                ),

                          Container(
                              child:  IconButton(
                                onPressed: (){
                                  Widget cancelButton = TextButton(
                                    child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                    onPressed:  () {
                                      doUserLogout();
                                    },
                                  );
                                  Widget continueButton = TextButton(
                                    child: Text("No", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                    onPressed:  () {
                                      Navigator.of(context).pop();
                                    },
                                  );
                                  // set up the AlertDialog
                                  AlertDialog alert = AlertDialog(
                                    title: Text("Are you sure you want to log out?", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
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
                                  Icons.logout_outlined ,color: Colors.white, size: 30,
                                ),
                              )

                          ),
                        ]),
                    SizedBox(
                      height: 20,
                    ),
                    ///Filter tabs
                    TabBar(
                        onTap: (index) {
                          //
                          setState(
                                () {
                              _selectedTab = index;
                              if (_selectedTab == 0){
                                noOrder = true;
                                filter = '';
                              }
                              if (_selectedTab == 1){
                                noOrder = true;
                                filter = 'New';
                              }
                              if (_selectedTab == 2){
                                noOrder = true;
                                filter = 'Waiting';
                              }
                              if (_selectedTab == 3){
                                noOrder = true;
                                filter = 'Under preparation';
                              }
                              if (_selectedTab == 4){
                                noOrder = true;
                                filter = 'Ready for pick up';
                              }
                            },
                          );
                        },
                        isScrollable:
                        true, //if tabs are a lot we can scroll them
                        controller: _tabController,
                        labelColor: Colors
                            .grey[900], //color of active tab
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(
                            icon: Text(
                              'All',
                              style: TextStyle(
                                  fontFamily: "Lato",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17),
                            ),
                          ),
                          Tab(
                            icon: Text('New',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                          Tab(
                            icon: Text('Waiting',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                          Tab(
                            icon: Text('Under preparation',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                          Tab(
                            icon: Text('Ready for pick up',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                        ]),
                    SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: size.height - 150,
                            width: size.width,
                            child: Column(children: [
                              Expanded(
                                  child: FutureBuilder<List<ParseObject>>(
                                      future: GetNewOrders(widget.pharmacyId),
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
                                            }
                                            else {
                                              return ListView.builder(
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: snapshot.data!.length,
                                                  itemBuilder: (context, index) {
                                                    final newOrder = snapshot.data![index];
                                                    final orderId = newOrder.get('OrderId').objectId;
                                                    var OrderStatus = newOrder.get('OrderStatus')!;
                                                    final orderCreatedDate = newOrder.get("createdAt").toString();
                                                    final orderdate = orderCreatedDate.substring(0,11);
                                                    final orderTime = orderCreatedDate.substring(10,19);
                                                    ///If order is accepted from the pharmacy display as waitong for customer confirmation
                                                    if(OrderStatus == 'Accepted'){
                                                      OrderStatus = 'Waiting';//Pending
                                                    }
                                                    if(OrderStatus.contains(filter)){
                                                      noOrder = false;
                                                    }
                                                    return  (OrderStatus.contains(filter))?
                                                    GestureDetector(
                                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PharmacyOrdersDetailsPage(orderId,OrderStatus,widget.pharmacyId))),
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
                                                                                  Text('New order',
                                                                                    maxLines: 2,
                                                                                    softWrap: true,
                                                                                    style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700 ,
                                                                                        background: Paint()
                                                                                          ..strokeWidth = 25.0
                                                                                          ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                                                          ..style = PaintingStyle.stroke
                                                                                          ..strokeJoin = StrokeJoin.round
                                                                                    ),),
                                                                                  SizedBox(height: 15,),
                                                                                  Container(
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: <Widget>[
                                                                                        Text(
                                                                                          'Order ID: $orderId',
                                                                                          style: TextStyle(
                                                                                              fontFamily: "Lato",
                                                                                              fontSize: 17,
                                                                                              color: Colors.black,
                                                                                              fontWeight: FontWeight.w600),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(right: 8, top: 4),
                                                                                    child: Text(
                                                                                      "Date: $orderdate \nTime:$orderTime",
                                                                                      maxLines: 2,
                                                                                      softWrap: true,
                                                                                      style: TextStyle(
                                                                                          fontFamily: "Lato",
                                                                                          fontSize: 19,
                                                                                          fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(right: 8, top: 4),
                                                                                    child: Text(
                                                                                      "Order status: $OrderStatus",
                                                                                      maxLines: 2,
                                                                                      softWrap: true,
                                                                                      style: TextStyle(
                                                                                          fontFamily: "Lato",
                                                                                          fontSize: 19,
                                                                                          fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                  ),
                                                                                  ///If order under preparation show update status button
                                                                                  (filter == 'Under preparation')?
                                                                                  Column(
                                                                                      children:[
                                                                                        Center(
                                                                                          child: ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: HexColor('#c7a1d1'),
                                                                                            ),
                                                                                            child:Text("Ready for pick up",style:
                                                                                            TextStyle(
                                                                                                fontFamily: 'Lato',
                                                                                                fontSize: 15,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Colors.white)),
                                                                                            onPressed: (){
                                                                                              Widget cancelButton = TextButton(
                                                                                                child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                onPressed:  () async {
                                                                                                  if (await RPUOrder(orderId)) {
                                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyNewO(widget.pharmacyId)));
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                      content: Text("Order status for order number $orderId has been updated",
                                                                                                        style: TextStyle(fontSize: 20),),
                                                                                                      duration: Duration(milliseconds: 3000),
                                                                                                    ));
                                                                                                  };
                                                                                                },
                                                                                              );
                                                                                              Widget continueButton = TextButton(
                                                                                                child: Text("No", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                onPressed:  () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              );
                                                                                              // set up the AlertDialog
                                                                                              AlertDialog alert = AlertDialog(
                                                                                                title: RichText(
                                                                                                  text: TextSpan(
                                                                                                    text: '''Are you sure you want to update status for order $orderId?
                                                                                                           ''',
                                                                                                    style: TextStyle(color: Colors.black, fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
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
                                                                                          ),
                                                                                        ),
                                                                                      ]):Container(),
                                                                                  ///If order ready for pick up show update status button
                                                                                  (filter == 'Ready for pick up')?
                                                                                  Column(
                                                                                      children:[
                                                                                        Center(
                                                                                          child: ElevatedButton(
                                                                                            style: ElevatedButton.styleFrom(
                                                                                              backgroundColor: HexColor('#c7a1d1'),
                                                                                            ),
                                                                                            child:Text("Order collected",style:
                                                                                            TextStyle(
                                                                                                fontFamily: 'Lato',
                                                                                                fontSize: 15,
                                                                                                fontWeight: FontWeight.bold,
                                                                                                color: Colors.white)),
                                                                                            onPressed: (){
                                                                                              Widget cancelButton = TextButton(
                                                                                                child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                onPressed:  () async {
                                                                                                  if (await collectedOrder(orderId)) {
                                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyNewO(widget.pharmacyId)));
                                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                                      content: Text("Order status for order number $orderId has been updated",
                                                                                                        style: TextStyle(fontSize: 20),),
                                                                                                      duration: Duration(milliseconds: 3000),
                                                                                                    ));
                                                                                                  };
                                                                                                },
                                                                                              );
                                                                                              Widget continueButton = TextButton(
                                                                                                child: Text("No", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                                onPressed:  () {
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                              );
                                                                                              // set up the AlertDialog
                                                                                              AlertDialog alert = AlertDialog(
                                                                                                title: RichText(
                                                                                                  text: TextSpan(
                                                                                                    text: '''Are you sure you want to update status for order $orderId?
                                                                                                           ''',
                                                                                                    style: TextStyle(color: Colors.black, fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ),
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
                                                                                          ),
                                                                                        ),
                                                                                      ]):Container()
                                                                                ])))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )))
                                                    ///When its the last iteration of displaying orders and no order matched filter yet display this message
                                                        :(noOrder && index == snapshot.data!.length-1)?
                                                    Center(
                                                        child:Column(
                                                            children:[
                                                              Icon(Icons.pending_actions_outlined,color: Colors.black45,size: 30,),
                                                              Text("No $filter orders yet.",style: TextStyle(
                                                                  fontFamily: "Lato",
                                                                  fontSize: 18,
                                                                  color: Colors.black45,
                                                                  fontWeight: FontWeight.w700),)
                                                            ]
                                                        )
                                                    ):Container();
                                                  } );
                                            } }
                                      })

                              )]),
                          ),)),
                  ]),
            ),)
          ,])
        ,),
    );
  }


  ///Get pharmacy new orders
  Future<List<ParseObject>> GetNewOrders(pharmacyId) async{
    final QueryBuilder<ParseObject> queryNewOrders1 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryNewOrders1.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryNewOrders1.whereEqualTo('OrderStatus', 'New');

    final QueryBuilder<ParseObject> queryNewOrders2 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryNewOrders2.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryNewOrders2.whereEqualTo('OrderStatus', 'Accepted');


    final QueryBuilder<ParseObject> queryNewOrders3 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryNewOrders3.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryNewOrders3.whereEqualTo('OrderStatus', 'Under preparation');


    final QueryBuilder<ParseObject> queryNewOrders4 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryNewOrders4.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryNewOrders4.whereEqualTo('OrderStatus', 'Ready for pick up');

    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [queryNewOrders1, queryNewOrders2, queryNewOrders3, queryNewOrders4],
    );

      var orderId;

      //Query customer current orders
      final QueryBuilder<ParseObject> query1 =
      QueryBuilder<ParseObject>(ParseObject('Orders'));
      query1.whereEqualTo('OrderStatus','Under processing');

      ///Query orders that are under processing and check if the order passed the time then make order declined
      var allDeclined;
      var orderCreatedAt;

      final query1Response = await query1.query();
      if (query1Response.success && query1Response.results != null) {
        for (var order in query1Response.results!) {
          allDeclined = true;
          orderId = order.objectId;
          orderCreatedAt = order.get('createdAt');
          final QueryBuilder<ParseObject> parseQuery = QueryBuilder<
              ParseObject>(
              ParseObject('PharmaciesList'));
          parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')
            ..objectId = orderId).toPointer());
          final parseQueryResponse = await parseQuery.query();


          ///Check if all pharmacies declined the order
          for (var o in parseQueryResponse.results!) {
            if (o.get('OrderStatus') != 'Declined') {
              allDeclined = false;
            }
          }

          ///For customer If all pharmacies declined the order before time passes make order declined for customer
          if (allDeclined) {
            var update = order..set('OrderStatus', 'Declined');
            final ParseResponse parseResponse = await update.save();
          }

          ///*********Time code

          ///If order not declined and the customer didn't select a pharmacy check time
          if (!allDeclined) {
            String d1 = (DateTime.now())
                .subtract(Duration(hours: 3))
                .toString();
            String d2 = (orderCreatedAt.add(Duration(minutes: 200))).toString();
            d1 = d1.substring(0, 19);
            d2 = d2.substring(0, 19);

            DateTime date1 = DateTime.parse(d1);
            DateTime date2 = DateTime.parse(d2);

            ///If time passed make order status declined for customer +
            ///order status cancelled for pharmacies who accepted or didn't reply
            if (date1.isAfter(date2)) {
              ///For pharmacies
              for (var o in parseQueryResponse.results!) {
                ///If pharmacy declined order leave as declined for that pharmacy
                ///If pharmacy didn't reply make order cancelled for that pharmacy
                if (o.get('OrderStatus') != 'Declined') {
                  var update = o..set('OrderStatus', 'Cancelled');
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
    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  ///Update order from under preparation to ready for pick up
  Future<bool> RPUOrder(orderId) async {
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = orderId ).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacy
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var pharmacy = o as ParseObject;
        if (pharmacy.get('PharmacyId')
            .objectId == widget.pharmacyId) {
          var update = pharmacy..set('OrderStatus', 'Ready for pick up');
          final ParseResponse parseResponse = await update.save();
        }
      }
      //change order status for customer
        final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(
            ParseObject('Orders'));
        parseQuery2.whereEqualTo('objectId', orderId);

        final apiResponse2 = await parseQuery2.query();

        if (apiResponse2.success && apiResponse2.results != null) {
          for (var o in apiResponse2.results!) {
            var object = o as ParseObject;
            var update = object..set('OrderStatus', 'Ready for pick up');
            var customerId = object.get('Customer_id').objectId;
            NativeNotify.sendIndieNotification(2338, 'dX0tKYd2XD2DOtsUirIumj', customerId, 'Tiryaq', 'Your order number $orderId is ready for pick up', '', '');
            final ParseResponse parseResponse = await update.save();
          }
        }
        return true;
    }
    return false;
  }

  ///Update order from ready for pick up to collected
  Future<bool> collectedOrder(orderId) async {
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = orderId ).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacy
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var pharmacy = o as ParseObject;
        if (pharmacy
            .get('PharmacyId')
            .objectId == widget.pharmacyId) {
          var update = pharmacy..set('OrderStatus', 'Collected');
          final ParseResponse parseResponse = await update.save();
        }
      }
      final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(
          ParseObject('Orders'));
      parseQuery2.whereEqualTo('objectId', orderId);

      final apiResponse2 = await parseQuery2.query();

      //change order status for customer
      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results!) {
          var object = o as ParseObject;
          var update = object..set('OrderStatus', 'Collected');
          final ParseResponse parseResponse = await update.save();
        }
      }
      return true;
    }
    return false;
  }

  void showError(String errorMessage) {
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PharmacyLogin()));
      });
    } else {
      showError(response.error!.message);
    }
  }
}
