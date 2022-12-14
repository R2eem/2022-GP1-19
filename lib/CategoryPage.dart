import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Cart.dart';
import 'package:untitled/medDetails.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';

class CategoryPage extends StatefulWidget {
  @override
  Category createState() => Category();
}

class Category extends State<CategoryPage> {
  int _selectedIndex = 0;
  String searchString = "";
  var customerId;
  bool searchNotEmpty = true;
  bool alwaysTrue = true;
  num counter = 200;
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
                        child: Text("Error..."),
                      );
                    }
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("No Data..."),
                      );
                    } else {
                      var userId = snapshot.data!.objectId;
                      var email = snapshot.data!.emailAddress;
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
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.asset(
                    'assets/logoheader.png',
                    fit: BoxFit.contain,
                    width: 110,
                    height: 80,
                  ),
                ),
                SizedBox(
                  height: 55,
                ),
                //Controls category page display
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 620,
                      width: size.width,
                      child: Column(children: [
                        //Search bar
                        Material(
                            elevation: 4,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: TextField(
                              //Whenever value in text field changes set state
                              onChanged: (value) {
                                setState(() {
                                  searchString = value;
                                });
                              },
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 19),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: 'Search by Scientific or Trade name',
                                prefixIcon: Icon(Icons.search),
                                prefixIconColor: Colors.pink[100],
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        //Categories navigation buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          PrescriptionCategory(customerId)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      width: 150,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        HexColor('#e9c3fa'),
                                        HexColor('#fac3f5')
                                      ])),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Prescription Medication",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            color: HexColor('#884bbd'),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NonPrescriptionCategory(customerId)));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      width: 150,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                        HexColor('#e9c3fa'),
                                        HexColor('#fac3f5')
                                      ])),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Non-Prescription Medication",
                                          style: TextStyle(
                                            fontFamily: "Lato",
                                            color: HexColor('#884bbd'),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //Medications list diplay
                        Expanded(
                            //Get medications
                            child: FutureBuilder<List<ParseObject>>(
                                future: getMedication(),
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
                                        counter = 200;
                                        return ListView.builder(
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 20.0),
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              //Get Parse Object Values
                                              //Get medication information from Medications table
                                              final medGet =
                                                  snapshot.data![index];
                                              final medId = medGet
                                                  .get<String>('objectId')!;
                                              final TradeName = medGet
                                                  .get<String>('TradeName')!;
                                              final ScientificName =
                                                  medGet.get<String>(
                                                      'ScientificName')!;
                                              final Publicprice = medGet
                                                  .get<num>('Publicprice')!;
                                              //Display medication that matches the search string if exist
                                              return TradeName.toLowerCase()
                                                          .startsWith(searchString
                                                              .toLowerCase()) ||
                                                      ScientificName.toLowerCase()
                                                          .startsWith(searchString
                                                              .toLowerCase())
                                                  ? GestureDetector(
                                                      //Navigate to medication details page
                                                      onTap: () => Navigator.of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  medDetailsPage(
                                                                      medId!,
                                                                      customerId))),
                                                      //Medication card information
                                                      child: Card(
                                                          elevation: 3,
                                                          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                          color: Colors.white,
                                                          child: Column(children: [
                                                            ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          8.0,
                                                                          10.0,
                                                                          8.0,
                                                                          10.0),
                                                              title: Text(
                                                                TradeName,
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Lato",
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              subtitle: Text(
                                                                '$ScientificName , $Publicprice SAR',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Lato",
                                                                    fontSize:
                                                                        19,
                                                                    color: Colors
                                                                        .black,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic),
                                                              ),
                                                              leading:
                                                                  Image.asset(
                                                                'assets/listIcon.png',
                                                              ),
                                                              trailing: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Ink(
                                                                    decoration:
                                                                        ShapeDecoration.fromBoxDecoration(
                                                                            BoxDecoration(
                                                                      color: HexColor(
                                                                          '#fad2fc'),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    )),
                                                                    //Add to cart button
                                                                    child: IconButton(
                                                                        onPressed: () async {
                                                                          if (await addToCart(
                                                                              medId,
                                                                              customerId)) {
                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                              content: Text(
                                                                                "$TradeName added to your cart",
                                                                                style: TextStyle(fontSize: 20),
                                                                              ),
                                                                              duration: Duration(milliseconds: 3000),
                                                                            ));
                                                                          };
                                                                        },
                                                                        icon: const Icon(
                                                                          Icons
                                                                              .add_shopping_cart_rounded,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              25.0,
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ])))
                                                  //If the medication doesn't matches the search string then don't display
                                                  : (--counter <= 0)?
                                               Container(
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
                                                              "Sorry we could't find any match,",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  "Lato",
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                              textAlign: TextAlign.center,
                                                            ),Text(
                                                              "try another search or continue shopping through the categories.",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                  "Lato",
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                          textAlign: TextAlign.center,
                                                            ),
                                                      ]))
                                              : Container();
                                            });
                                      }
                                  }
                                })),SizedBox(height: 80,)
                      ]),
                    ))
              ]))),
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
                        icon: Icons.home,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.receipt_long,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.settings,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartPage(customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrdersPage(customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage(customerId)));
                    }
                  }),
                ))));
  }

  //Function to get medications
  Future<List<ParseObject>> getMedication() async {
    QueryBuilder<ParseObject> queryMedication =
        QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryMedication.setLimit(200); //We have 200 medication
    queryMedication.orderByAscending('TradeName'); //Order medications
    final ParseResponse apiResponse = await queryMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
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

  //Function add medication to cart
  Future<bool> addToCart(medId, customerId) async {
    bool exist = false;
    var medInCart;
    var quantity = 0;

    //Search for medications in customer cart
    final apiResponse = await ParseObject('Cart').getAll();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        if (customerId == medInCart.get('customer').objectId) {
          if (medId == medInCart.get('medication').objectId) {
            //If medication exist in customer cart
            exist = true;
            quantity = medInCart.get<num>('Quantity');
            break;
          }
        }
      }
    }
    //If medication doesn't exist then add
    if (!exist) {
      final addToCart = ParseObject('Cart')
        ..set('customer',
            (ParseObject('Customer')..objectId = customerId).toPointer())
        ..set('medication',
            (ParseObject('Medications')..objectId = medId).toPointer())
        ..set('Quantity', 1);
      await addToCart.save();
      return true;
    }
    //If medication exist then increment quantity
    else {
      var incrementQuantity = medInCart..set('Quantity', ++quantity);
      await incrementQuantity.save();
      return true;
    }
  }
}
