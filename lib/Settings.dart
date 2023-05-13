import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/SavedLocation.dart';
import 'AccountPage.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Orders.dart';
import 'main.dart';


class SettingsPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const SettingsPage(this.customerId);
  @override
  Settings createState() => Settings();
}

class Settings extends State<SettingsPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body:SingleChildScrollView(
          child: Stack(children: [
            //Header
            Container(
              height: 150,
              child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
            ),
            ///App logo and page title
            Container(
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                'assets/logoheader.png',
                                fit: BoxFit.contain,
                                width: 110,
                                height: 80,
                              ),
                            ),
                            ///Controls Cart page title
                            Container(
                              margin: EdgeInsets.fromLTRB(size.width/7, size.height/100,0, 0),
                              child: Text(
                                'Settings',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 27,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
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

                            )
                          ]),
                      SizedBox(height: 80,),
                      ///Controls settings page display
                      Container(
                        child:Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.fromLTRB(32.0, 8.0, 32.0, 16.0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          child:Column(
                            children: <Widget>[
                              //My account
                              ListTile(
                                leading:Icon(Icons.person , color: Colors.purple.shade200, size: 30,) ,
                                title: Text("My Account" ,style: TextStyle(fontFamily: 'Lato',fontSize: 22, color: Colors.black)),
                                trailing: Icon(Icons.keyboard_arrow_right, size: 30,),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(widget.customerId)));
                                },
                                contentPadding: EdgeInsets.fromLTRB(20, 10, 14, 10),
                              ),
                              _buildDriver(),//Design
                              //My locations
                              ListTile(
                                leading:Icon(Icons.location_on , color: Colors.purple.shade200, size: 30,) ,
                                title: Text("My Locations",style: TextStyle(fontFamily: 'Lato',fontSize: 22, color: Colors.black)),
                                trailing: Icon(Icons.keyboard_arrow_right, size: 30),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SavedLocationPage(widget.customerId)));
                                },
                                contentPadding: EdgeInsets.fromLTRB(20, 10, 14, 10),
                              ),

                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                    ]),
              ),
            ),
          ]),
        ),
        //Bottom navigation bar
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
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30,
                    ),
                    GButton(
                        icon: Icons.receipt_long, iconActiveColor:Colors.purple.shade200,iconSize: 30
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(widget.customerId)));
                    }
                  }),
                )))
    );
  }

  ///Show error message function
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

  ///User logout function
  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      showErrorLogout(response.error!.message);
    }
  }
}

//Design
Container _buildDriver(){
  return Container(
    margin:const EdgeInsets.symmetric(horizontal: 8.0),
    width: double.infinity,
    height: 1.0,
    color: Colors.grey.shade400,
  );
}