import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';


class CartPage extends StatefulWidget {
  final String customerId;
  const CartPage(this.customerId);
  @override
  Cart createState() => Cart();
}

class Cart extends State<CartPage> {
  int _selectedIndex = 1;
  String searchString = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
          height: 150,
          child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
        ),
        Container(
        child: SafeArea(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Image.asset(
      'assets/logoheader.png',
        fit: BoxFit.contain,
        width: 110,
        height: 80,
      ),
    ),
    SizedBox(height: 55,),
    ]))),

        ])
      ),
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
                    icon: Icons.shopping_cart,iconActiveColor:Colors.purple.shade200,iconSize: 30
                ),
                GButton(
                    icon: Icons.shopping_bag,iconActiveColor:Colors.purple.shade200,iconSize: 30
                ),
                GButton(
                    icon: Icons.settings,iconActiveColor:Colors.purple.shade200,iconSize: 30
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) => setState(() {
                _selectedIndex = index;
                if (_selectedIndex == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                } else if (_selectedIndex == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(widget.customerId)));
                } else if (_selectedIndex == 2) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(widget.customerId)));
                } else if (_selectedIndex == 3) {
                 // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                }
              }),
            ))));}

  Future<List<ParseObject>> getMedicationId() async {
    QueryBuilder<ParseObject> queryMedication =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    queryMedication.whereEqualTo('customer',(ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final ParseResponse apiResponse = await queryMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<List<ParseObject>> getMedicationss(String id) async {
    QueryBuilder<ParseObject> queryMedication =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryMedication.whereEqualTo('objectId', id);
    final ParseResponse apiResponse = await queryMedication.query();
    print(apiResponse.results);
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


}