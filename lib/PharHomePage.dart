import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_notify/native_notify.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/PharmacyNew.dart';
import 'package:untitled/PharmacySettings.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'PharmacyOld.dart';
import 'PharmacyLogin.dart';


class PharHomePage extends StatefulWidget {
  const PharHomePage({Key? key}): super(key:key);
  @override
  PharmacyHome createState() => PharmacyHome();
}

class PharmacyHome extends State<PharHomePage> {
  int _selectedIndex = 0;
  var pharmacyId;

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
            ///App logo and page title
            Container(
                child: SafeArea(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                          SizedBox(height: 35,),
                          //Get user from user table
                          FutureBuilder<ParseUser?>(
                              future: getUser(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Center(
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          child: CircularProgressIndicator()),
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
                                      var userId = snapshot.data!.objectId;
                                      //Get user from pharmacist table
                                      return FutureBuilder<List>(
                                          future: currentuser(userId),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.none:
                                              case ConnectionState.waiting:
                                                return Center(
                                                  child: Container(
                                                      margin: EdgeInsets.only(top: 100),
                                                      width: 0,
                                                      height: 0,
                                                      child: CircularProgressIndicator()),
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
                                                      padding: EdgeInsets.only(top: 10.0),
                                                      scrollDirection: Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount: snapshot.data!.length,
                                                      itemBuilder: (context, index) {
                                                        //Get Parse Object Values
                                                        final user = snapshot.data![index];
                                                        pharmacyId = user.get<String>('objectId')!;
                                                        NativeNotify.registerIndieID(pharmacyId);
                                                        final pharmacyName = user.get('PharmacyName')!;
                                                        return Container(
                                                          padding: EdgeInsets.only(left: 40),
                                                          child: Text(
                                                            "$pharmacyName,",
                                                            style: TextStyle(
                                                                shadows: [
                                                                  Shadow(
                                                                    offset: Offset(2.0, 2.0), //position of shadow
                                                                    blurRadius: 6.0, //blur intensity of shadow
                                                                    color: Colors.black.withOpacity(0.8), //color of shadow with opacity
                                                                  ),],
                                                                fontFamily: "Lato",
                                                                fontSize: 35,
                                                                color: Colors.purple.shade100,
                                                                fontWeight: FontWeight.w700),
                                                          ),
                                                        );
                                                      });
                                                }
                                            }
                                          });
                                    }
                                }
                              }),
                          SizedBox(height: 35,),
                          ///Categories navigation buttons
                          Center(child: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PharmacyNewO(pharmacyId)));
                                  },
                                  child: Card(
                                    elevation: 7,
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        width: 300,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  HexColor('#e9c3fa'),
                                                  HexColor('#fac3f5')
                                                ])),
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Column(
                                              children: [
                                                Image.asset('assets/thumbnail_iconNew.png',
                                                  fit: BoxFit.contain,
                                                  width: 150,
                                                  height: 150,
                                                ),
                                                Text(
                                                  "Active orders",
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    color: HexColor(
                                                        '#884bbd'),
                                                    fontSize: 28,
                                                    fontWeight: FontWeight
                                                        .bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )),
                                  )),
                              SizedBox(height: 40,),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PharmacyOldO(pharmacyId)));
                                  },
                                  child: Card(
                                    elevation: 7,
                                    child: Container(
                                        padding: EdgeInsets.all(8),
                                        width: 300,
                                        height: 200,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: [
                                                  HexColor('#e9c3fa'),
                                                  HexColor('#fac3f5')
                                                ])),
                                        child: Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Column(
                                              children: [
                                                Image.asset('assets/thumbnail_iconOld.png',
                                                  fit: BoxFit.contain,
                                                  width: 150,
                                                  height: 150,),
                                                Text(
                                                  "Inactive orders",
                                                  style: TextStyle(
                                                    fontFamily: "Lato",
                                                    color: HexColor(
                                                        '#884bbd'),
                                                    fontSize: 28,
                                                    fontWeight: FontWeight
                                                        .bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                        )),
                                  )),
                            ],
                          )
                          )]))),
          ])),
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
                        icon: Icons.settings,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PharHomePage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacySettingsPage(pharmacyId)));
                    }
                  }),
                )))
    );}

  ///Function to get current logged in user
  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  ///Function to get current user from Pharmacist table
  Future<List> currentuser(userId) async {
    QueryBuilder<ParseObject> queryCustomers =
    QueryBuilder<ParseObject>(ParseObject('Pharmacist'));
    queryCustomers.whereContains('user', userId);
    final ParseResponse apiResponse = await queryCustomers.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  void showError(String errorMessage) {
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
      showError(response.error!.message);
    }
  }
}