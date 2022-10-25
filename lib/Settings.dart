import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'AccountPage.dart';
import 'CategoryPage.dart';
import 'NonPrescriptionCategory.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'common/theme_helper.dart';
import 'main.dart';


class SettingsPage extends StatefulWidget {
  @override
  Settings createState() => Settings();
}

class Settings extends State<SettingsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:SingleChildScrollView(
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
                      child: Image.asset(
                        'assets/logoheader.png',
                        fit: BoxFit.contain,
                        width: 100,
                        height: 70,
                      ),
                    ),

                    SizedBox(height: 1),

                    Container(
                      child: Text('Settings', style: TextStyle(
                        fontFamily: "Mulish",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
                    ),

                    SizedBox(height: 80,),

                    Container(
                      child:Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.fromLTRB((32.0), 8.0, 32.0, 16.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child:Column(
                          children: <Widget>[

                            ListTile(
                              leading:Icon(Icons.person , color: Colors.purple.shade200) ,
                              title: Text("My Account" ,style: TextStyle(fontSize: 19, color: Colors.black)),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
                              },
                            ),
                            _buildDriver(),
                            ListTile(
                              leading:Icon(Icons.location_on , color: Colors.purple.shade200) ,
                              title: Text("Saved Locations",style: TextStyle(fontSize: 19, color: Colors.black)),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
                              },
                            ),

                          ],
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child:Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton.icon(
                          style: ThemeHelper().buttonStyle(),

                          onPressed: (){
                            Widget cancelButton = TextButton(
                              child: Text("No"),
                              onPressed:  () {
                                Navigator.of(context).pop();
                              },
                            );
                            Widget continueButton = TextButton(
                              child: Text("Yes"),
                              onPressed:  () {
                                doUserLogout();
                              },
                            );
                            // set up the AlertDialog
                            AlertDialog alert = AlertDialog(
                              title: Text("Are you sure you want to log out from your account?"),
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
                          }, icon: Icon(Icons.logout_outlined ,color: Colors.white,), label: Text('LOGOUT' ,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        ),
                      ),),









                  ]),
            ),
          ),
        ]),
      ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                gap: 8,
                padding: const EdgeInsets.all(10),
                tabs: [
                  GButton(icon: Icons.home, iconActiveColor:  Colors.purple.shade200,iconSize: 35,),
                  GButton(icon: Icons.shopping_cart, iconActiveColor:  Colors.purple.shade200,  iconSize: 35,),
                  GButton(icon: Icons.shopping_bag, iconActiveColor:  Colors.purple.shade200,iconSize: 35, ),
                  GButton(icon: Icons.settings,iconActiveColor:  Colors.purple.shade200,iconSize: 35, ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) => setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  } else if (_selectedIndex == 1) {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  } else if (_selectedIndex == 2) {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  }
                })),
          ),
        )
    );


  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
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
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      showError(response.error!.message);
    }
  }
}

Container _buildDriver(){
  return Container(
    margin:const EdgeInsets.symmetric(horizontal: 8.0),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}





