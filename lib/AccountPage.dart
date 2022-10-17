import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AccountPage(),
  ));
}

class AccountPage extends StatefulWidget {
  @override
  Account createState() => Account();
}

class Account extends State<AccountPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[]
        ),
      ),
        bottomNavigationBar: Container(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: GNav(
    gap: 8,
    padding: const EdgeInsets.all(10),
    tabs:  [
    GButton(icon: Icons.home,),
    GButton(icon: Icons.shopping_cart,),
    GButton(icon: Icons.shopping_bag,),
    GButton(icon: Icons.account_circle,)
    ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) => setState(() {
          _selectedIndex = index;
          if(_selectedIndex == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
          else if(_selectedIndex == 1){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
          else if(_selectedIndex == 2){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
        }) ),
    ),
   )
  );
  }
}