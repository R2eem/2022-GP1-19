import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'PharmacyNew.dart';
import 'PharmacyLogin.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'common/theme_helper.dart';

class PharmacyOrdersDetailsPage extends StatefulWidget {
  final String orderId;
  final String orderStatus;
  final String pharmacyId;
  const PharmacyOrdersDetailsPage(this.orderId, this.orderStatus, this.pharmacyId);
  @override
  PharmacyOrdereDetails createState() => PharmacyOrdereDetails();
}

class checkBoxState{
  String medID;
  String quantity;
  bool value;


  checkBoxState({
    required this.medID,
    required this.quantity,
    this.value = false,
  });
}

class PharmacyOrdereDetails extends State<PharmacyOrdersDetailsPage> {
  bool presRequired = false;
  List medList = [];
  List medicationsList2 = [];
  Set _saved = Set();
  FocusNode textSecondFocusNode = new FocusNode();// when focusing on the note field
  TextEditingController noteDescriptionController = new TextEditingController(); // to get the text written in note field
  bool value = false;

  @override
  void dispose() {
    noteDescriptionController.dispose();
    super.dispose();
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    'Orders Details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 27,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.bold),
                                  ),
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
                          SizedBox(height: 55,),
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
                                      /* return Center(
                                          child: Container(
                                              width: 50,
                                              height: 50,
                                              child:
                                              CircularProgressIndicator()),
                                        );*/
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
                                                ""),
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
                                                final OrderStatus = customerCurrentOrders.get('OrderStatus')!;
                                                final TotalPrice = customerCurrentOrders.get('TotalPrice')!;
                                                final medicationsList = customerCurrentOrders.get('MedicationsList')!;
                                                for (int i = 0; i < medicationsList[0].length; i++) {
                                                  medList.add(
                                                      checkBoxState(
                                                        medID:medicationsList[0][i]['medId'].toString(),
                                                        quantity: medicationsList[0][i]['quantity'].toString(),
                                                      )
                                                  );}
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

                                                                      SizedBox(height: 5,),
                                                                      ///customer name and phone number
                                                                      FutureBuilder<ParseObject>(
                                                                          future: getCustomerDetails(),
                                                                          builder: (context, snapshot) {
                                                                            switch (snapshot.connectionState) {
                                                                              case ConnectionState.none:
                                                                              case ConnectionState.waiting:
                                                                              /* return Center(
                                                                                  child: Container(
                                                                                      width: 200,
                                                                                      height: 5,
                                                                                      child:
                                                                                      LinearProgressIndicator()),
                                                                                );*/
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
                                                                                        ""),
                                                                                  );
                                                                                } else {
                                                                                  return  ListView.builder(
                                                                                      shrinkWrap: true,
                                                                                      scrollDirection: Axis.vertical,
                                                                                      itemCount: 1,
                                                                                      itemBuilder: (context, index) {
                                                                                        final CustomerInfo = snapshot.data!;
                                                                                        final FisrtName = CustomerInfo.get<String>('Firstname')!;
                                                                                        final LastName = CustomerInfo.get<String>('Lastname')!;
                                                                                        final PhoneNumber = CustomerInfo.get<String>('Phonenumber')!;

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
                                                                                                          Text('Phone number : $PhoneNumber',style: TextStyle(
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
                                                                      SizedBox(height: 20,),

                                                                      ///Show initial total price for new, cancelled or declined orders
                                                                      if((widget.orderStatus == 'New') || (widget.orderStatus == 'Cancelled') || (widget.orderStatus == 'Declined'))
                                                                      Column(

                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children:[
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
                                                                          SizedBox(height: 20,),
                                                                          Text('List of medication:' ,style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 19,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700),),
                                                                          SizedBox(height: 10,),
                                                                      for (int i = 0; i < medicationsList[0].length; i++) ...[
                                                                        FutureBuilder<List<ParseObject>>(
                                                                            future: getMedDetails(medicationsList[0][i]['medId'].toString()),
                                                                            builder: (context, snapshot) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.none:
                                                                                case ConnectionState.waiting:
                                                                                /*return Center(
                                                                                    child: Container(
                                                                                        width: 200,
                                                                                        height: 5,
                                                                                        child:
                                                                                        LinearProgressIndicator()),
                                                                                  );*/
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
                                                                                          ""),
                                                                                    );
                                                                                  } else {
                                                                                    return  ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: snapshot.data!.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          final medDetails = snapshot.data![index];
                                                                                          final Tradename = medDetails.get('TradeName')!;
                                                                                          final quantity = medicationsList[0][i]['quantity'];
                                                                                          final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                                                                          final Strength = medDetails.get<num>('Strength')!;
                                                                                          final StrengthUnit = medDetails.get<String>('StrengthUnit')!;
                                                                                          if(value != medList[i].value){
                                                                                            value = medList[i].value;
                                                                                          }
                                                                                          // to display  medication list in checkbox
                                                                                          return StatefulBuilder(
                                                                                            builder: (BuildContext context, StateSetter setState) =>
                                                                                            (widget.orderStatus == 'New')?
                                                                                            CheckboxListTile(
                                                                                              controlAffinity: ListTileControlAffinity.leading,
                                                                                              value: this.value,
                                                                                              onChanged: (bool? value) {
                                                                                                setState(() {
                                                                                                  this.value = value!;
                                                                                                });
                                                                                                changeValue(medList[i].medID, value);
                                                                                              },
                                                                                              title: Row(
                                                                                                children:[
                                                                                                  Expanded(
                                                                                                    child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children:[
                                                                                                          Text('$quantity X  $Tradename' ,style: TextStyle(
                                                                                                              fontFamily: "Lato",
                                                                                                              fontSize: 17,
                                                                                                              color: Colors.black,
                                                                                                              fontWeight: FontWeight.w600),
                                                                                                            maxLines: 2,),
                                                                                                          Text('$ProductForm $Strength $StrengthUnit' ,style: TextStyle(
                                                                                                              fontFamily: "Lato",
                                                                                                              fontSize: 15,
                                                                                                              color: Colors.black,
                                                                                                              fontWeight: FontWeight.w500),)
                                                                                                        ]
                                                                                                    ),)
                                                                                                ],
                                                                                              ),
                                                                                            ): Card(
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                        padding: EdgeInsets.all(5),
                                                                                                        width: size.width,
                                                                                                        color: Colors.grey.shade200,
                                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                          Text(
                                                                                                            '$quantity X  $Tradename ',
                                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            '$ProductForm $Strength $StrengthUnit',
                                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                          )
                                                                                                        ]))
                                                                                                  ],
                                                                                                ))
                                                                                          );
                                                                                        });
                                                                                  }
                                                                              }}
                                                                        ),],]),

                                                                      ///If order status is after accepting from the pharmacy
                                                                      if(widget.orderStatus == 'Waiting' || widget.orderStatus == 'Under preparation' || widget.orderStatus == 'Ready for pick up' || widget.orderStatus == 'Collected' )
                                                                                              Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children:[
                                                                                                  FutureBuilder<String>(
                                                                                        future: getTotalPrice(),
                                                                                        builder: (context, snapshot) {
                                                                                          switch (snapshot.connectionState) {
                                                                                            case ConnectionState.none:
                                                                                            case ConnectionState.waiting:
                                                                                              return Center(
                                                                                                child: Container(width: 200, height: 5, child: LinearProgressIndicator()),
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
                                                                                                    shrinkWrap: true,
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    itemCount: 1,
                                                                                                    itemBuilder: (context, index) {
                                                                                                      final totalPrice = snapshot.data!;
                                                                                                      return  Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                  Container(
                                                                                                    padding: EdgeInsets.all(5),
                                                                                                    alignment: Alignment.center,
                                                                                                    width: size.width,
                                                                                                    child:
                                                                                                    Text('Total price: $totalPrice SAR' ,style: TextStyle(
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
                                                                                                        ],
                                                                                                      );
                                                                                                    });
                                                                                              }
                                                                                          }
                                                                                        }),
                                                                                                  SizedBox(height: 20,),
                                                                                                  Text('List of medication:' ,style: TextStyle(
                                                                                                      fontFamily: "Lato",
                                                                                                      fontSize: 19,
                                                                                                      color: Colors.black,
                                                                                                      fontWeight: FontWeight.w700),),
                                                                                                  SizedBox(height: 10,),
                                                                                                  FutureBuilder<List<ParseObject>>(
                                                                                                    future: getMedList(),
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
                                                                                                                  final medicationsListStatus = medDetails.get('MedicationsList')!;
                                                                                                                  return Column( children:[
                                                                                                                    for (int i = 0; i < medicationsListStatus[0].length; i++) ...[
                                                                                                                      FutureBuilder<List<ParseObject>>(
                                                                                                                          future: getMedDetails(medicationsListStatus[0][i]['medId2'].toString()),
                                                                                                                          builder: (context, snapshot) {
                                                                                                                            switch (snapshot.connectionState) {
                                                                                                                              case ConnectionState.none:
                                                                                                                              case ConnectionState.waiting:
                                                                                                                                /*return Center(
                                                                                                                                  child: Container(
                                                                                                                                      width: 200,
                                                                                                                                      height: 5,
                                                                                                                                      child:
                                                                                                                                      LinearProgressIndicator()),
                                                                                                                                );*/
                                                                                                                              default:
                                                                                                                                if (snapshot.hasError) {
                                                                                                                                  return Center(
                                                                                                                                    child: Text(
                                                                                                                                        ""),
                                                                                                                                  );
                                                                                                                                }
                                                                                                                                if (!snapshot.hasData) {
                                                                                                                                  return Center(
                                                                                                                                    child: Text(
                                                                                                                                        ""),
                                                                                                                                  );
                                                                                                                                } else {
                                                                                                                                  return  ListView.builder(
                                                                                                                                      shrinkWrap: true,
                                                                                                                                      scrollDirection: Axis.vertical,
                                                                                                                                      itemCount: snapshot.data!.length,
                                                                                                                                      itemBuilder: (context, index) {
                                                                                                                                        final medDetails = snapshot.data![index];
                                                                                                                                        final medications = medDetails.get('TradeName')!;
                                                                                                                                        final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                                                                                                                        final Strength = medDetails.get<num>('Strength')!;
                                                                                                                                        final StrengthUnit = medDetails.get<String>('StrengthUnit')!;

                                                                                                                                        return Card(
                                                                                                                                            child: Column(
                                                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                              children:[
                                                                                                                                                (medicationsListStatus[0][i]['isChecked'] == true)?
                                                                                                                                                Container(
                                                                                                                                                    padding: EdgeInsets.all(5),
                                                                                                                                                    width: size.width,
                                                                                                                                                    color: Colors.grey.shade200,
                                                                                                                                                    child:
                                                                                                                                                    Column(
                                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                        children:[
                                                                                                                                                          Row(

                                                                                                                                                              children:[
                                                                                                                                                                Icon(Icons.check,color: HexColor('#2b872d'),size: 30,),
                                                                                                                                                                Text('${medicationsListStatus[0][i]['quantity']} x $medications ' ,style: TextStyle(
                                                                                                                                                                    fontFamily: "Lato",
                                                                                                                                                                    fontSize: 17,
                                                                                                                                                                    color: Colors.black,
                                                                                                                                                                    fontWeight: FontWeight.w600),
                                                                                                                                                                  maxLines: 2,),
                                                                                                                                                              ]),
                                                                                                                                                          Text('$ProductForm $Strength $StrengthUnit' ,style: TextStyle(
                                                                                                                                                              fontFamily: "Lato",
                                                                                                                                                              fontSize: 15,
                                                                                                                                                              color: Colors.black,
                                                                                                                                                              fontWeight: FontWeight.w500),
                                                                                                                                                            maxLines: 2,)
                                                                                                                                                        ]
                                                                                                                                                    )
                                                                                                                                                ):Container(),
                                                                                                                                                (medicationsListStatus[0][i]['isChecked'] == false)?
                                                                                                                                                Container(
                                                                                                                                                    padding: EdgeInsets.all(5),
                                                                                                                                                    width: size.width,
                                                                                                                                                    color: Colors.grey.shade200,
                                                                                                                                                    child:
                                                                                                                                                    Column(
                                                                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                                                        children:[
                                                                                                                                                          Row(
                                                                                                                                                              children:[
                                                                                                                                                                Icon(Icons.close,color: HexColor('#bd2717'),size: 30,),
                                                                                                                                                                Text('${medicationsListStatus[0][i]['quantity']} x $medications ' ,style: TextStyle(
                                                                                                                                                                    fontFamily: "Lato",
                                                                                                                                                                    fontSize: 17,
                                                                                                                                                                    color: Colors.black,
                                                                                                                                                                    fontWeight: FontWeight.w600),
                                                                                                                                                                  maxLines: 2,),
                                                                                                                                                              ]),
                                                                                                                                                          Text('$ProductForm $Strength $StrengthUnit' ,style: TextStyle(
                                                                                                                                                              fontFamily: "Lato",
                                                                                                                                                              fontSize: 15,
                                                                                                                                                              color: Colors.black,
                                                                                                                                                              fontWeight: FontWeight.w500),
                                                                                                                                                            maxLines: 2,)
                                                                                                                                                        ]
                                                                                                                                                    )
                                                                                                                                                ):Container(),
                                                                                                                                              ],
                                                                                                                                            )
                                                                                                                                        );
                                                                                                                                      });
                                                                                                                                }
                                                                                                                            }}
                                                                                                                      )]]);
                                                                                                                });
                                                                                                          }
                                                                                                      }}
                                                                                                ),
                                                                                                ]
                                                                                            ),


                                                                      SizedBox(height: 20,),
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
                                                                            SizedBox(height: 20,),
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
                                                                      SizedBox(height: 15,),
                                                                      if(widget.orderStatus != ("New"))
                                                                        FutureBuilder<ParseObject>(
                                                                            future: getNote(),
                                                                            builder: (context, snapshot) {
                                                                              switch (snapshot.connectionState) {
                                                                                case ConnectionState.none:
                                                                                case ConnectionState.waiting:
                                                                                /* return Center(
                                                                                    child: Container(
                                                                                        width: 200,
                                                                                        height: 5,
                                                                                        child:
                                                                                        LinearProgressIndicator()),
                                                                                  );*/
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
                                                                                          ""),
                                                                                    );
                                                                                  } else {
                                                                                    return  ListView.builder(
                                                                                        shrinkWrap: true,
                                                                                        scrollDirection: Axis.vertical,
                                                                                        itemCount: 1,
                                                                                        itemBuilder: (context, index) {
                                                                                          final orderDetail = snapshot.data!;
                                                                                          var note = orderDetail.get("Note");
                                                                                          if(note == ''){
                                                                                            note = 'No note';
                                                                                          }
                                                                                          final time = orderDetail.get("Time");
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
                                                                                                            Text('Note:' ,style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.w600),),
                                                                                                            Text('$note' ,style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,),),
                                                                                                            SizedBox(height: 10,),
                                                                                                            Text('Order is expected to be ready at:' ,style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,
                                                                                                                fontWeight: FontWeight.w600),),
                                                                                                            Text('$time' ,style: TextStyle(
                                                                                                                fontFamily: "Lato",
                                                                                                                fontSize: 17,
                                                                                                                color: Colors.black,),),
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
                                                                      if(widget.orderStatus.contains("New"))
                                                                        Text('Note: ' ,style: TextStyle(
                                                                            fontFamily: "Lato",
                                                                            fontSize: 19,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w700),),
                                                                      if(widget.orderStatus.contains("New"))
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(top: 1),
                                                                          child: Container(
                                                                            margin: EdgeInsets.all(1),
                                                                            height: 5 * 20.0,
                                                                            child: TextField(
                                                                              maxLines: 2,
                                                                              maxLength: 100,
                                                                              keyboardType: TextInputType.text,
                                                                              controller: noteDescriptionController,
                                                                              decoration: InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Enter your note here.',
                                                                                hintStyle: TextStyle(
                                                                                  fontSize: 15.00,
                                                                                  color: Colors.grey,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      if(widget.orderStatus.contains("New"))
                                                                        Text('Expected Time for order to be ready: ' ,style: TextStyle(
                                                                            fontFamily: "Lato",
                                                                            fontSize: 17,
                                                                            color: Colors.black,
                                                                            fontWeight: FontWeight.w700),),
                                                                      if(widget.orderStatus.contains("New"))
                                                                          ElevatedButton(
                                                                            style: ElevatedButton.styleFrom(backgroundColor: HexColor('#c7a1d1'),
                                                                            ),
                                                                            onPressed: _selectDate,
                                                                            child: Text('SELECT TIME',
                                                                                style: TextStyle(
                                                                                    fontFamily: 'Lato',
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    color: Colors.white)),
                                                                          ),
                                                                      SizedBox(height: 8),
                                                                      if(widget.orderStatus.contains("New") && date != '')
                                                                        Text(
                                                                          'Selected time: $date ${_time.format(context)}',
                                                                        ),
                                                                      if(widget.orderStatus.contains("New"))
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
                                                                                        bool emptyOrNot= false;
                                                                                        for (int i = 0; i < medList.length; i++) {
                                                                                          if (medList[i].value == true ){
                                                                                            emptyOrNot = true;
                                                                                          }
                                                                                        }
                                                                                        Widget cancelButton = TextButton(
                                                                                          child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                          onPressed:  () {
                                                                                              SendToCustomer("Accepted",widget.pharmacyId,noteDescriptionController.text);
                                                                                              Navigator.of(context).pop();
                                                                                          }
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
                                                                                        if(emptyOrNot == false){
                                                                                          showError2();
                                                                                        }
                                                                                        else if(date == ''){
                                                                                          showError3();
                                                                                        }
                                                                                        else {
                                                                                          // show the dialog
                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (
                                                                                                BuildContext context) {
                                                                                              return alert;
                                                                                            },
                                                                                          );
                                                                                        }
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
                                                                                              SendToCustomer("Declined",widget.pharmacyId,noteDescriptionController.text);
                                                                                              Navigator.of(context).pop();
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

  //Get medications of the selected pharmacy
  Future<List<ParseObject>> getMedList() async {
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId',(ParseObject('Orders')..objectId = widget.orderId ).toPointer());
    parseQuery1.whereEqualTo('OrderStatus', 'Under preparation');

    final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery2.whereEqualTo('OrderId',(ParseObject('Orders')..objectId = widget.orderId ).toPointer());
    parseQuery2.whereEqualTo('OrderStatus', 'Ready for pick up');

    final QueryBuilder<ParseObject> parseQuery3 = QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery3.whereEqualTo('OrderId',(ParseObject('Orders')..objectId = widget.orderId ).toPointer());
    parseQuery3.whereEqualTo('OrderStatus', 'Collected');

    final QueryBuilder<ParseObject> parseQuery4 = QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery4.whereEqualTo('OrderId',(ParseObject('Orders')..objectId = widget.orderId ).toPointer());
    parseQuery4.whereEqualTo('OrderStatus', 'Accepted');


    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [parseQuery1, parseQuery2, parseQuery3, parseQuery4],
    );

    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Function to get customer details
  Future<ParseObject> getCustomerDetails() async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject('Orders'));
    parseQuery.whereEqualTo('objectId', widget.orderId);
    var object;
    var customerId;
    var customer;
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        object = o as ParseObject;
        customerId = object.get('Customer_id').objectId;
      }
      final QueryBuilder<ParseObject> customerDetails = QueryBuilder<ParseObject>(
          ParseObject('Customer'));
      customerDetails.whereEqualTo('objectId', customerId);

      final apiResponse2 = await customerDetails.query();

      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results!) {
          customer = o as ParseObject;
          return customer;
        }
      }
    }
    return null!;
  }

  //Get total price
  Future<String> getTotalPrice() async {
    num totalPrice = 0;

    final QueryBuilder<ParseObject> parseQuery1 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery1.whereEqualTo('OrderStatus', 'Under preparation');

    final QueryBuilder<ParseObject> parseQuery2 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery2.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery2.whereEqualTo('OrderStatus', 'Ready for pick up');

    final QueryBuilder<ParseObject> parseQuery3 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery3.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery3.whereEqualTo('OrderStatus', 'Collected');

    final QueryBuilder<ParseObject> parseQuery4 =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery4.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery4.whereEqualTo('OrderStatus', 'Accepted');

    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [parseQuery1, parseQuery2, parseQuery3, parseQuery4],
    );

    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        List med = object.get('MedicationsList');

        for (int i = 0; i < med[0].length; i++) {
          if (med[0][i]['isChecked'] == true) {
            final QueryBuilder<ParseObject> parseQuery =
            QueryBuilder<ParseObject>(ParseObject('Medications'));
            parseQuery.whereEqualTo('objectId', med[0][i]['medId2']);

            final apiResponse2 = await parseQuery.query();
            if (apiResponse.success && apiResponse.results != null) {
              for (var o in apiResponse2.results!) {
                var object = o as ParseObject;
                num price = object.get('Publicprice');
                num quantity = num.parse(med[0][i]['quantity']);
                totalPrice = totalPrice + (price * quantity);
              }
            }
          }
        }
      }
    } else {
      return '';
    }
    return totalPrice.toStringAsFixed(2);
  }

  // function to send if the order is accepted or declined to the customer
  Future<void> SendToCustomer(orderStatus,pharmacyId ,note) async {
    //Store customer medications in list
    for (int i = 0; i < medList.length; i++) {
      var medications = {
        'medId2': medList[i].medID,
        'quantity': medList[i].quantity,
        'isChecked': medList[i].value,
      };

      var contain = medicationsList2.where((element) => element['medId2'] == medList[i].medID);
      if (contain.isEmpty) {
        medicationsList2.add(medications);
      }
    }
    var object;
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId =pharmacyId).toPointer());
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = widget.orderId).toPointer());

    //Get as a single object
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        object = o as ParseObject;
      }
    }
    String date = _date.toString();
    date = date.substring(0,11);
    String time = '$date ${_time.format(context)}';
    //Update the information in pharmacyList table
    var todo = object
      ..set('OrderStatus',orderStatus)
      ..set('Note',note)
      ..set('Time',time)
      ..setAddUnique('MedicationsList', medicationsList2);

    final ParseResponse parseResponse = await todo.save();
    if (parseResponse.success) {
      //If the update succeed call showSuccess function
      showSuccess(pharmacyId);
    } else {
      //If update fails cal showError function
      showError(parseResponse.error!.message);
    }
  }

  Future<ParseObject> getNote() async {
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('PharmacyId', (ParseObject('Pharmacist')..objectId =widget.pharmacyId).toPointer());
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = widget.orderId).toPointer());

    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        return object;
      }
    }
    return null!;
  }

  void changeValue(medId, value){
    for(int i = 0; i < medList.length; i++){
      print(medList[i].medID == (medId));
      if(medList[i].medID == (medId)){
        medList[i].value = value;
      }
    }
  }

  //Time picker
  TimeOfDay _time = TimeOfDay(hour: 12, minute: 00);

  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  //Date picker
  DateTime _date = DateTime(2023, 1, 20);
  String date = '';

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2023, 1),
      lastDate: DateTime(2023, 12),
      helpText: 'Select a date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
        date = _date.toString();
        date = date.substring(0,11);
        _selectTime();
      });
    }
  }

  //Function called when updating order status is successful
  //Show message for 3 seconds then navigate to setting page
  void showSuccess(pharmacyId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool manuallyClosed = false;
          Future.delayed(Duration(seconds: 3)).then((_) {
            if (!manuallyClosed) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyNewO(pharmacyId)));
            }
          });
          return AlertDialog(
              content: Text('Order status is changed !', style: TextStyle(fontFamily: 'Lato', fontSize: 20,)));

        });
  }

  //Function called when updating order status  is not successful
  //Show Alertdialog and wait for user interaction
  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("order status changing failed!", style: TextStyle(fontFamily: 'Lato', fontSize: 20)),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok",style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

    //alert message to tell the pharmacy he must check at least one medication before clicking accept
    //Show Alertdialog and wait for user interaction
    void showError2() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("you have to check at least one medication before accepting the order", style: TextStyle(fontFamily: 'Lato', fontSize: 20)),
            actions: <Widget>[
              new TextButton(
                child: const Text("Ok",style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  //alert message to tell the pharmacy he must enter time before clicking accept
  //Show Alertdialog and wait for user interaction
  void showError3() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Please select time", style: TextStyle(fontFamily: 'Lato', fontSize: 20)),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok",style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showErrorLogOut(String errorMessage) {
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
      showErrorLogOut(response.error!.message);
    }
  }
}
