import 'dart:async';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:geopoint/geopoint.dart';
import 'package:geolocator/geolocator.dart';

import 'common/theme_helper.dart';
import 'medDetails.dart';





class SavedLocationPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const SavedLocationPage(this.customerId);
  @override
  Locations createState() => Locations();
}

class Locations extends State<SavedLocationPage> {
  int _selectedIndex = 3;
  var customerId;
  bool LocationPageNotEmpty = false;
  int NoOfLocation = 0;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
      child: Stack(children: [
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
                      child: Text("Error1..."),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("No Data..."),
                    );
                  } else {
                    var userId = snapshot.data!.objectId;
                    //Get user from customer table
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
                                  child: Text("Error2..."),
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
                                      customerId =
                                      user.get<String>('objectId')!;
                                      return Container();
                                    });
                              }
                          }
                        });
                  }
              }
            }),

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
                    //Controls location page title
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 13, 0, 0),
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
                  ]),
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
                                   getSavedLocations(), //Will change LocationNotEmpty value
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
                                           child: Text("Error3..."),
                                         );
                                       }
                                       if (!snapshot.hasData) {
                                         return Center(
                                           child: Text("No Data..."),
                                         );
                                       } else {
                                         return LocationPageNotEmpty
                                            ? ListView.builder(
                                              scrollDirection:
                                              Axis.vertical,
                                              itemCount:
                                             snapshot.data!.length,
                                             itemBuilder:
                                            (context, index) {
                                              //Get Parse Object Values
                                              //Get customer locations from Locations table
                                              NoOfLocation = snapshot
                                                  .data!
                                                  .length; //Save number of Locations
                                              final LocationTable =
                                              snapshot.data![index];
                                              final LocID = LocationTable
                                                  .get('objectId')!;
                                              ParseGeoPoint Location = LocationTable
                                                  .get<ParseGeoPoint>('SavedLocations')!;



                                       return StatefulBuilder(
                                                  builder: (BuildContext context, StateSetter setState) =>
                                                  //Delete Locations from Location table
                                                  Dismissible(
                                                      key: UniqueKey(),
                                                      background: Container(
                                                          alignment: Alignment.centerRight,
                                                          padding: EdgeInsets.symmetric(horizontal: 30),
                                                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                          decoration: BoxDecoration(color: Colors.red[100], borderRadius: BorderRadius.all(Radius.circular(16))),
                                                          child: Icon(
                                                            Icons.delete_outline,
                                                            size: 40,
                                                            semanticLabel: 'Delete',
                                                            color: Colors.red,
                                                          )),
                                                      direction: DismissDirection.endToStart,
                                                      confirmDismiss: (DismissDirection direction) async {
                                                        //Deletion confirmation dialog
                                                        return await showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text("Are you sure you wish to delete this Location?",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Lato',
                                                                    fontSize: 20,
                                                                  )),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(true),
                                                                  child: const Text("Delete", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                  child: const Text("Cancel", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      //If deletion confirmed call delete function
                                                      onDismissed: (direction) async {
                                                        //Send location id
                                                        if (await deleteCartMed(LocID)) {
                                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text(
                                                              "the Location is deleted",
                                                              style: TextStyle(fontSize: 20),
                                                            ),
                                                            duration: Duration(milliseconds: 3000),
                                                          ));
                                                        }
                                                        //If no location left in location page reload page to show empty message
                                                        if (NoOfLocation == 0) {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SavedLocationPage(widget.customerId)));
                                                        }
                                                      },

                                         child:Stack( //display Locations cards
                                         children: <Widget>[
                                           Container(
                                             margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                             child: Row(
                                               children: <Widget>[
                                                 Expanded(
                                                   child: Container(
                                                     padding: const EdgeInsets.all(8.0),
                                                     child: Column(
                                                       mainAxisSize: MainAxisSize.max,
                                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                       children: <Widget>[
                                                         Container(
                                                           padding: EdgeInsets.only(right: 8, top: 4),
                                                           child: Text(
                                                             "$Location",

                                                             maxLines: 2,
                                                             softWrap: true,
                                                             style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700),
                                                           ),
                                                         ),
                                                         SizedBox(height: 6),
                                                       ],
                                                     ),
                                                   ),
                                                   flex: 100,
                                                 )
                                               ],
                                             ),
                                           ),
                                         ],
                                       ),),);

                                       } )




                                     //If LocationNotEmpty is false; Location is empty show this message
                                         : Container(
                                     child: Column(
                                     crossAxisAlignment:
                                     CrossAxisAlignment
                                         .center,
                                     //mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                     SizedBox(
                                     height: 20,
                                     ),
                                     Text(
                                     'You do not have saved locations',
                                     style: TextStyle(
                                     fontFamily:
                                     "Lato",
                                     fontSize: 20,
                                     fontWeight:
                                     FontWeight
                                         .w700),
                                     ),
                                     ]));
                                         } }
                                    })

                              )]),
                        ),)),
                ]),
          ),)
        ,])
        ,),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(customerId)));
                    }
                  }),
                )))
    );

  }

  //Function to get current logged in user
  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  //Function to get current user from Customer table
  Future<List> currentuser(userId) async {
    QueryBuilder<ParseObject> queryCustomers =
    QueryBuilder<ParseObject>(ParseObject('Customer'));
    queryCustomers.whereContains('user', userId);
    final ParseResponse apiResponse = await queryCustomers.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }


  //Get customer's locations  from Locations table
  Future<List<ParseObject>> getSavedLocations() async {
    // var locationtable = ParseObject('Locations')
    //   ..set('SavedLocations',ParseGeoPoint(latitude: -20.2523818, longitude: -40.2665611))
    //   ..set('customer',
    //       (ParseObject('Customer')..objectId = customerId).toPointer());
    // await locationtable.save();
    final QueryBuilder<ParseObject> SavedLocations =
    QueryBuilder<ParseObject>(ParseObject('Locations'));
    SavedLocations.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());

    final apiResponse = await SavedLocations.query();

    if (apiResponse.success && apiResponse.results != null) {
      //If query have objects then set true
      LocationPageNotEmpty=true;

      return apiResponse.results as List<ParseObject>;
    } else {
      //If query have no object then set false
      LocationPageNotEmpty=false;
      return [];
    }
  }





  //Delete location from locations table
  Future<bool> deleteCartMed(LocID) async {
    //Query the location from locations table
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('Locations'));
    parseQuery.whereEqualTo('objectId', LocID);
    final apiResponse1 = await parseQuery.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        final object = o as ParseObject;
        //Delete location
        object.delete();
        //Decrement number of location in location table
        NoOfLocation = NoOfLocation - 1;
        return true;
      }
    }
    return false;
  }


}


