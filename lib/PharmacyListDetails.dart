import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'PharmacyNew.dart';
import 'PharmacyLogin.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'common/theme_helper.dart';

class PharmacyListDetailsPgae extends StatefulWidget {
  final String orderId;
  final String orderStatus;
  final String pharmacyId;
  const PharmacyListDetailsPgae(this.orderId, this.orderStatus, this.pharmacyId);
  @override
  PharmacyListDetails createState() => PharmacyListDetails();
}

class checkBoxState{
  String medID;
  bool value;


  checkBoxState({
    required this.medID,
    this.value = false,
  });
}

class PharmacyListDetails extends State<PharmacyListDetailsPgae> {
  bool presRequired = false;
  List medList = [];
  List medicationsList2 = [];
  Set _saved = Set();
  bool value = false;


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
                              ]),
                          SizedBox(height: 55,),
                          SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),

                          ),
                        ]))),
          ])),
    );
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

  // function to send if the order is accepted or declined to the customer
  Future<void> SendToCustomer(orderStatus,pharmacyId ,note) async {
    //Store customer medications in list
    for (int i = 0; i < medList.length; i++) {
      var medications = {
        'medId2': medList[i].medID,
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
    //Update the information in pharmacyList table
    var todo = object
      ..set('OrderStatus',orderStatus)
      ..set('Note',note)
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