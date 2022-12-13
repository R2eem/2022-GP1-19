import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Cart.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';


class OrderDetailsPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  final String orderId;
  const OrderDetailsPage(this.customerId, this.orderId);
  @override
  OrderDetails createState() => OrderDetails();
}

class OrderDetails extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
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
                                ]),
    ])))])));
  }

}