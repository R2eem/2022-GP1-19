import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/main.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';
import 'package:untitled/PharmacySignUp.dart';


class PharHomePage extends StatefulWidget {
  const PharHomePage({Key? key}): super(key:key);
  @override
  Login createState() => Login();
}

class Login extends State<PharHomePage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 250;
  bool _isVisible = false;
  bool isLoggedIn = false;
  var PharmacistId;

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
                              children:[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Image.asset('assets/logoheader.png',
                                    fit: BoxFit.contain,
                                    width: 110,
                                    height: 80,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(50, 13, 0, 0),
                                  child: Text("", textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 27, color: Colors.white70, fontWeight: FontWeight.bold),),
                                ),]),
                          SizedBox(height: 55,),
                        ])))])),
      //Bottom navigation bar
    );}}