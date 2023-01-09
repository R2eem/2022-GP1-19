import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_notify/native_notify.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';

import 'PharmacyLogin.dart';
import 'PharmacyOrdereDetails.dart';



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
          //Controls app logo
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
                            child: IconButton(padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                              iconSize: 40,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
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
                    //Filter tabs
                    TabBar(
                        onTap: (index) {
                          //
                          setState(
                                () {
                              _selectedTab = index;
                              if (_selectedTab == 0)
                                filter = '';
                              if (_selectedTab == 1)
                                filter = 'Accept/Decline';
                              if (_selectedTab == 2)
                                filter = 'Waiting';
                              if (_selectedTab == 3)
                                filter = 'Under preparation';
                              if (_selectedTab == 4)
                                filter = 'Ready for pick up';
                            },
                          );
                        },
                        isScrollable:
                        true, //if the tabs are a lot we can scroll them
                        controller: _tabController,
                        labelColor: Colors
                            .grey[900], // the tab is clicked on now color
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
                            icon: Text('Accept/Decline',
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
                                      future: GetNewOrders(widget.pharmacyId), //Will change LocationNotEmpty value
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
                                                    final distance = newOrder.get('Distance')!;
                                                    final orderCreatedDate = newOrder.get("createdAt").toString();
                                                    final orderdate = orderCreatedDate.substring(0,11);
                                                    final orderTime = orderCreatedDate.substring(10,19);
                                                    if(OrderStatus == 'Accepted'){
                                                      OrderStatus = 'Waiting';//Pending
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
                                                                                                      content: Text("Order status for order $orderId has been updated",
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
                                                                                                      content: Text("Order status for order $orderId has been updated",
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
                                                                ))):Container();
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


  //Get pharmacy new orders
  Future<List<ParseObject>> GetNewOrders(pharmacyId) async{
    final QueryBuilder<ParseObject> queryNewOrders1 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryNewOrders1.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryNewOrders1.whereEqualTo('OrderStatus', 'Accept/Decline');

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
    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<bool> RPUOrder(orderId) async {
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = orderId ).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacies
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var pharmacy = o as ParseObject;
        if (pharmacy
            .get('PharmacyId')
            .objectId == widget.pharmacyId) {
          var update = pharmacy..set('OrderStatus', 'Ready for pick up');
          final ParseResponse parseResponse = await update.save();
        }
      }
        final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(
            ParseObject('Orders'));
        parseQuery2.whereEqualTo('objectId', orderId);

        final apiResponse2 = await parseQuery2.query();

        //change order status for pharmacy
        if (apiResponse2.success && apiResponse2.results != null) {
          for (var o in apiResponse2.results!) {
            var object = o as ParseObject;
            var update = object..set('OrderStatus', 'Ready for pick up');
            var customerId = object.get('Customer_id').objectId;
            NativeNotify.sendIndieNotification(2338, 'dX0tKYd2XD2DOtsUirIumj', customerId, 'Tiryaq', 'Your order $orderId is ready for pick up', '', '');
            final ParseResponse parseResponse = await update.save();
          }
        }
        return true;
    }
    return false;
  }

  Future<bool> collectedOrder(orderId) async {
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = orderId ).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacies
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

      //change order status for pharmacy
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
