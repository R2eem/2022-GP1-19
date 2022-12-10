import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Cart.dart';
import 'Orders.dart';
import 'Settings.dart';
import 'common/theme_helper.dart';
import 'package:untitled/CategoryPage.dart';
import 'dart:async';
import 'CategoryPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'PresLocation.dart';



class SavedLocations extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _SavedLocations();
  }
}

class _SavedLocations extends State<SavedLocations>{
  int _selectedIndex = 3;
  final controllerEditEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var customerId;

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
  //Controls Cart page title
  Container(
  margin: EdgeInsets.fromLTRB(70, 13, 0, 0),
  child: Text(
  'My Locations',
  textAlign: TextAlign.center,
  style: TextStyle(
  fontFamily: 'Lato',
  fontSize: 27,
  color: Colors.white70,
  fontWeight: FontWeight.bold),
),
  ),
],
),
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
        getCustomerLocations(), //Will change cartNotEmpty value
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
    }
    }
    }
      ),
      ),
      ],
    ),
    ),
    ),
  ],
  ),
    ],
    ),
    ),
),
  ],
    ),
    ),

  );
}
}

//Get customer locations from locations table
Future<List<ParseObject>> getCustomerLocations() async {
  //Query customer cart
  final QueryBuilder<ParseObject> customerCart =
  QueryBuilder<ParseObject>(ParseObject('Cart'));
  customerCart.whereEqualTo('customer',
      (ParseObject('Customer')..objectId = widget.customerId).toPointer());
  final apiResponse = await customerCart.query();

  if (apiResponse.success && apiResponse.results != null) {
    //If query have objects then set true
    cartNotEmpty = true;
    return apiResponse.results as List<ParseObject>;
  } else {
    //If query have no object then set false
    cartNotEmpty = false;
    return [];
  }
}
}