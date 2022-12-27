import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geocoding/geocoding.dart';

import 'common/theme_helper.dart';

class PharmacyOrdereDetailsPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  final String orderId;
  const PharmacyOrdereDetailsPage(this.customerId,this.orderId);
  @override
  PharmacyOrdereDetails createState() => PharmacyOrdereDetails();
}

class PharmacyOrdereDetails extends State<PharmacyOrdereDetailsPage> {
  int _selectedIndex = 2;
  bool presRequired = false;
  bool _isChecked = false;
  var pharmacyOrderStatus="";
  var orderStatus="";
  var orderNote="";
  var orderNoteController=TextEditingController();


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
                                    child: IconButton(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      iconSize: 40,
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      }, icon: Icon(Icons.keyboard_arrow_left),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(65, 33, 0, 0),
                                    child: Text('Order details',
                                      textAlign: TextAlign.center, style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 27,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ]),
                            SizedBox(height: 50,),
                            SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: FutureBuilder<List<ParseObject>>(
                                    future: getOrderDetails(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
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
                                          } else {
                                            return  ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: snapshot.data!.length,
                                                itemBuilder: (context, index) {
                                                  final customerCurrentOrders = snapshot.data![index];
                                                  final OrderId = customerCurrentOrders.get('objectId');
                                                  final CreatedDate = customerCurrentOrders.get('createdAt')!;
                                                  orderStatus = customerCurrentOrders.get('OrderStatus')!;
                                                  pharmacyOrderStatus = customerCurrentOrders.get('PharmcyOrderStatus')!;
                                                  orderNote= customerCurrentOrders.get('OrderNote')!;
                                                   orderNoteController = TextEditingController(text: orderNote);
                                                  final TotalPrice = customerCurrentOrders.get('TotalPrice')!;
                                                  final medicationsList = customerCurrentOrders.get('MedicationsList')!;

                                                  var prescription = null;
                                                  if(customerCurrentOrders.get('Prescription') != null){
                                                    presRequired = true;
                                                    prescription = customerCurrentOrders.get<ParseFile>('Prescription')!;
                                                  }
                                                  return Card(
                                                      elevation: 3,
                                                      color: Colors.white,
                                                      child: ClipPath(
                                                          child: Container(

                                                              child: Padding(padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                                                  child:  Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children:[
                                                                        Text('Order placed at  ' + (CreatedDate).toString().substring(0,(CreatedDate).toString().indexOf(' ')),style: TextStyle(
                                                                            fontFamily: "Lato",
                                                                            fontSize: 19,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w600),),
                                                                        //SizedBox(height: 5,),
                                                                        ///customer name and phone number
                                                                        FutureBuilder<List>(
                                                                            future: getCustomerDetails(),
                                                                            builder: (context, snapshot) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.none:
                                                                                case ConnectionState.waiting:
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
                                                                                    return  ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: 1,
                                                                                        itemBuilder: (context, index) {
                                                                                          final CustomerInfo = snapshot.data![index];
                                                                                          final FisrtName = CustomerInfo.get<String>('Firstname')!;
                                                                                          final LastName = CustomerInfo.get<String>('Lastname')!;
                                                                                          final PhoneNumner = CustomerInfo.get<String>('Phonenumber')!;
                                                                                          return Card(
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children:[
                                                                                                  Container(
                                                                                                      padding: EdgeInsets.all(5),
                                                                                                      width: size.width,
                                                                                                      color: Colors.grey[100],
                                                                                                      child:
                                                                                                      Column(
                                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                          children:[
                                                                                                            Text('Customer\'s Information:' ,style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.w600),),
                                                                                                            Text('Full name :  $FisrtName  $LastName',style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.w600),),
                                                                                                            Text('Phone number : $PhoneNumner',style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.w600),),
                                                                                                          ]
                                                                                                      )
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                          );
                                                                                        });
                                                                                  }
                                                                              }}
                                                                        ),
                                                                        SizedBox(height: 15,),
                                                                        Container(
                                                                          padding: EdgeInsets.all(5),
                                                                          alignment: Alignment.center,
                                                                          width: size.width,
                                                                          child:
                                                                          Text('Total price: $TotalPrice SAR' ,style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 18,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700,
                                                                              background: Paint()
                                                                            ..strokeWidth = 25.0
                                                                            ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                                            ..style = PaintingStyle.stroke
                                                                            ..strokeJoin = StrokeJoin.round),
                                                                          ),
                                                                        ),
                                                                        SizedBox(height: 15,),
                                                                        Text('List of medication:' ,style: TextStyle(
                                                                            fontFamily: "Lato",
                                                                            fontSize: 19,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w700),),
                                                                        SizedBox(height: 5,),
                                                                        for (int i = 0; i < medicationsList[0].length; i++) ...[
                                                                          FutureBuilder<List<ParseObject>>(
                                                                              future: getMedDetails(medicationsList[0][i]['medId'].toString()),
                                                                              builder: (context, snapshot) {
                                                                                switch (snapshot.connectionState) {
                                                                                  case ConnectionState.none:
                                                                                  case ConnectionState.waiting:
                                                                                    return Center(
                                                                                      child: Container(
                                                                                          width: 200,
                                                                                          height: 5,
                                                                                          child:
                                                                                          LinearProgressIndicator()),
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
                                                                                      return  ListView.builder(
                                                                                          shrinkWrap: true,
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: snapshot.data!.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            final medDetails = snapshot.data![index];
                                                                                            final medications = medDetails.get('TradeName')!;
                                                                                            final quantity = medicationsList[0][i]['quantity'];
                                                                                            final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                                                                            final Strength = medDetails.get<num>('Strength')!;
                                                                                            final StrengthUnit = medDetails.get<String>('StrengthUnit')!;


                                                                                           return StatefulBuilder(
                                                                                            builder: (BuildContext context, StateSetter setState) =>
                                                                                            Stack(
                                                                                            children: <Widget>[
                                                                                            Container(
                                                                                            margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                            child: Row(
                                                                                            children: <Widget>[
                                                                                            Center(
                                                                                            child:Checkbox(
                                                                                            value: _isChecked,
                                                                                            onChanged: (bool? checkvalue){
                                                                                            setState((){
                                                                                            _isChecked=checkvalue!;
                                                                                            });
                                                                                            },

                                                                                            ),

                                                                                            ),
                                                                                              Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children:[
                                                                                                    Text('$quantity X  $medications ' ,style: TextStyle(
                                                                                                        fontFamily: "Lato",
                                                                                                        fontSize: 17,
                                                                                                        color: Colors.black,
                                                                                                        fontWeight: FontWeight.w600),),
                                                                                                    Text('$ProductForm $Strength $StrengthUnit' ,style: TextStyle(
                                                                                                        fontFamily: "Lato",
                                                                                                        fontSize: 15,
                                                                                                        color: Colors.black,
                                                                                                        fontWeight: FontWeight.w500),)
                                                                                                  ]
                                                                                              ),

                                                                                            ],
                                                                                            ),
                                                                                            ),
                                                                                            ],
                                                                                            ));
                                                                                          });
                                                                                    }
                                                                                }}
                                                                          ),],
                                                                        SizedBox(height: 10,),
                                                                        presRequired ?
                                                                        Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                            children:[
                                                                              Text('Prescription: ' ,style: TextStyle(
                                                                                  fontFamily: "Lato",
                                                                                  fontSize: 19,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w700),),
                                                                              Text(' click to view the image' ,style: TextStyle(
                                                                                  fontFamily: "Lato",
                                                                                  fontSize: 14,
                                                                                  color: Colors.black54,
                                                                                  fontWeight: FontWeight.w700),),
                                                                              FullScreenWidget(
                                                                                child:Container(
                                                                                  height: 100,
                                                                                  width: 100,
                                                                                  child:Image.network(
                                                                                    prescription!.url!,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(height: 10,),
                                                                            ])
                                                                            :Column(
                                                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                            children:[
                                                                              Text('Prescription: ' ,style: TextStyle(
                                                                                  fontFamily: "Lato",
                                                                                  fontSize: 19,
                                                                                  color: Colors.black,
                                                                                  fontWeight: FontWeight.w700),),
                                                                              Text('No prescription attached' ,style: TextStyle(
                                                                                  fontFamily: "Lato",
                                                                                  fontSize: 18,
                                                                                  color: Colors.black54,
                                                                                  fontWeight: FontWeight.w700),),
                                                                            ]),
                                                                        //SizedBox(height: 20,),


                                                                        if(pharmacyOrderStatus.contains("New Order"))
                                                                          Container
                                                                            (
                                                                            child:Card(
                                                                                color:  Colors.grey[100],
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.all(8.0),
                                                                                  child: TextFormField(
                                                                              autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                              keyboardType: TextInputType.text,
                                                                              controller:  orderNoteController,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "Enter reason of declining the order",
                                                                                  hintStyle: TextStyle(fontFamily: 'Lato', fontSize: 16.0, color: Colors.grey[800]),
                                                                              ) ,
                                                                            ),),
                                                                          ),
                                                                            decoration: BoxDecoration(boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.grey.withOpacity(0.2),
                                                                                blurRadius: 3,
                                                                                offset: const Offset(0, 1),
                                                                              )
                                                                            ]),
                                                                          ),














                                                                          Padding(
                                                                            padding: EdgeInsets.only(top:1),
                                                                           child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children:<Widget>[

                                                                                Padding(
                                                                                padding: EdgeInsets.only(right:5 ,top:10,),
                                                                                  child:Container(
                                                                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                                    child:ElevatedButton(
                                                                                      style: ThemeHelper().buttonStyle(),
                                                                                      onPressed: (){
                                                                                        Widget cancelButton = TextButton(
                                                                                          child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                          onPressed:  () {
                                                                                            // doUserLogout(); send notification  and chnage customer and pharmcay status
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
                                                                                          title: Text("Are you sure you want to Accept this order?", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
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
                                                                                      }, child: Text('Accept'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                                    ),
                                                                                  ),),
                                                                                 Padding(
                                                                                 padding: EdgeInsets.only(left:5 , top:10),
                                                                                  child:Container(
                                                                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                                    child: ElevatedButton(
                                                                                      style: ThemeHelper().buttonStyle(),
                                                                                      onPressed: (){
                                                                                        Widget cancelButton = TextButton(
                                                                                          child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                          onPressed:  () {
                                                                                            // doUserLogout(); send notification  and chnage customer and pharmcay status
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
                                                                                          title: Text("Are you sure you want to Decline this order?", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
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
                                                                                      }, child: Text('Decline'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                                    ),
                                                                                  )),

                                                                                ]),








                                                                          ),
                                                                      ]) ))));
                                                });

                                          }
                                      }
                                    })
                            ),
                          
                            
                            
                            
                            
                            
                            
                            
                            
                            
                          ]))),
            ])),

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
        //                 iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.shopping_cart,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.receipt_long,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30
        //             ),
        //             GButton(
        //                 icon: Icons.settings,
        //                 iconActiveColor: Colors.purple.shade200,
        //                 iconSize: 30
        //             ),
        //           ],
        //           selectedIndex: _selectedIndex,
        //           onTabChange: (index) =>
        //               setState(() {
        //                 _selectedIndex = index;
        //                 if (_selectedIndex == 0) {
        //                   Navigator.push(context, MaterialPageRoute(
        //                       builder: (context) => CategoryPage()));
        //                 } else if (_selectedIndex == 1) {
        //                   Navigator.push(context, MaterialPageRoute(
        //                       builder: (context) =>
        //                           CartPage(widget.customerId)));
        //                 } else if (_selectedIndex == 2) {
        //                   Navigator.push(context, MaterialPageRoute(
        //                       builder: (context) =>
        //                           OrdersPage(widget.customerId)));
        //                 } else if (_selectedIndex == 3) {
        //                   Navigator.push(context, MaterialPageRoute(
        //                       builder: (context) =>
        //                           SettingsPage(widget.customerId)));
        //                 }
        //               }),
        //         )))
    );
  }

  //Get customer current orders from orders table
  Future<List<ParseObject>> getOrderDetails() async {
    //Query order details
    final QueryBuilder<ParseObject> order =
    QueryBuilder<ParseObject>(ParseObject('Orders'));
    order.whereEqualTo('objectId', widget.orderId);

    final apiResponse = await order.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
  //Function to get medication details
  Future<List<ParseObject>> getMedDetails(medicationsList) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Medications'));
    parseQuery.whereEqualTo('objectId', medicationsList);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  //Function to get customer details
  Future<List> getCustomerDetails() async {
    var object;
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject('Customer'));
    parseQuery.whereEqualTo('objectId', widget.customerId);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }



}