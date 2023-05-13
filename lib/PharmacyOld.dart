import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/PharHomePage.dart';
import 'PharmacyOrdersDetails.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'PharmacyLogin.dart';
import 'PharmacySettings.dart';


class PharmacyOldO extends StatefulWidget {
  final pharmacyId;
  const PharmacyOldO(this.pharmacyId);
  @override
  PharmacyOld createState() => PharmacyOld();
}

class PharmacyOld extends State<PharmacyOldO>
    with TickerProviderStateMixin {

  String filter = '';
  int _selectedTab = 0;
  bool noOrder = true;
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TabController _tabController =
    TabController(length: 4, vsync: this, initialIndex: 0);
    _tabController.animateTo(_selectedTab);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
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
                        children: [
                          Container(
                            child: IconButton(
                              iconSize: 40,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PharHomePage()));
                              }, icon: Icon(Icons.keyboard_arrow_left),),
                          ),
                          Spacer(),
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
                      height: 30,
                    ),
                    ///Filter tabs
                    TabBar(
                        onTap: (index) {
                          //
                          setState(
                                () {
                              _selectedTab = index;
                              if (_selectedTab == 0){
                                filter = '';
                                noOrder = true;
                              }
                              if (_selectedTab == 1){
                                filter = 'Cancelled';
                                noOrder = true;
                              }
                              if (_selectedTab == 2){
                                filter = 'Collected';
                                noOrder = true;
                              }
                              if (_selectedTab == 3){
                                filter = 'Declined';
                                noOrder = true;
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
                            icon: Text('Cancelled',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                          Tab(
                            icon: Text('Collected',
                                style: TextStyle(
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17)),
                          ),
                          Tab(
                            icon: Text('Declined',
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
                                      future: GetOldOrders(widget.pharmacyId),
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
                                            if(snapshot.data!.length==0){
                                              return Center(
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
                                              );
                                            }
                                            else {
                                              return ListView.builder(
                                                  physics: ClampingScrollPhysics(),
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: snapshot.data!.length,
                                                  itemBuilder: (context, index) {
                                                    final newOrder = snapshot.data![index];
                                                    final orderId = newOrder.get('OrderId').objectId;
                                                    final OrderStatus = newOrder.get('OrderStatus')!;
                                                    final orderCreatedDate = newOrder.get("createdAt").toString();
                                                    final orderdate = orderCreatedDate.substring(0,11);
                                                    final orderTime = newOrder.get("createdAt").add(Duration(hours: 3)).toString().substring(10,19);
                                                    if(OrderStatus.contains(filter)){
                                                      noOrder = false;
                                                    }
                                                    return  (OrderStatus.contains(filter))?
                                                       GestureDetector(
                                                           onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PharmacyOrdersDetailsPage(orderId, OrderStatus, widget.pharmacyId))),
                                                        child: StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState) =>
                                                                Stack( //display Locations cards
                                                                  children: <Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets.only(top: 20),
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
                                                                                      ]))),
                                                                          Icon(Icons.arrow_forward_ios_rounded, color: Colors.black45, size: 30)
                                                                        ],
                                                                      ),
                                                                    ),],)
                                                                ))
                                                    ///When its last iteration of displaying orders and no order matched filter yet display this message
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

                              ), SizedBox(height: 100,)]),
                          ),)),
             ]),
            ),)
          ,])
        ,),
        //Bottom navigation bar
      bottomNavigationBar:
      SizedBox( height: 70,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30,),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings, size: 30),
                label: '',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.purple.shade200,
            unselectedItemColor: Colors.black,
            selectedFontSize: 0.0,
            unselectedFontSize: 0.0,
            onTap: (index) => setState(() {
              _selectedIndex = index;
              if (_selectedIndex == 0) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PharHomePage()));
              } else if (_selectedIndex == 1) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacySettingsPage(widget.pharmacyId)));
              }
            }),
          )),
    );
  }


  ///Get pharmacy new orders
  Future<List<ParseObject>> GetOldOrders(pharmacyId) async{
    final QueryBuilder<ParseObject> queryOldOrders1 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryOldOrders1.whereEqualTo('PharmacistId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryOldOrders1.whereEqualTo('OrderStatus', 'Cancelled');

    final QueryBuilder<ParseObject> queryOldOrders2 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryOldOrders2.whereEqualTo('PharmacistId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryOldOrders2.whereEqualTo('OrderStatus', 'Collected');


    final QueryBuilder<ParseObject> queryOldOrders3 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    queryOldOrders3.whereEqualTo('PharmacistId',
        (ParseObject('Pharmacist')..objectId = pharmacyId).toPointer());
    queryOldOrders3.whereEqualTo('OrderStatus', 'Declined');


    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [queryOldOrders1, queryOldOrders2, queryOldOrders3],
    );
    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PharmacyLogin()));
      });
    } else {
      showErrorLogout(response.error!.message);
    }
  }
}