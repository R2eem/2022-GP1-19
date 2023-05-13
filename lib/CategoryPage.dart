import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Cart.dart';
import 'package:untitled/medDetails.dart';
import 'LoginPage.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:native_notify/native_notify.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';


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
  bool noMed = true;


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
                                        NativeNotify.registerIndieID(
                                            customerId);
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
          ///App logo
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
                      Spacer(),
                      Container(
                          child: IconButton(
                        onPressed: () {
                          Widget cancelButton = TextButton(
                            child: Text("Yes",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            onPressed: () {
                              doUserLogout();
                            },
                          );
                          Widget continueButton = TextButton(
                            child: Text("No",
                                style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Are you sure you want to log out?",
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 20,
                                )),
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
                          Icons.logout_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      ))
                    ]),
                SizedBox(
                  height: 25,
                ),
                ///Category page display
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: size.height - 150,
                      width: size.width,
                      child: Column(children: [
                        ///Search bar
                        Material(
                            elevation: 4,
                            shadowColor: Colors.grey,
                            child: TextField(
                              //Whenever value in text field changes set state
                              onChanged: (value) {
                                setState(() {
                                  searchString = value;
                                });
                              },
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                              decoration: InputDecoration(
                                filled: false,
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
                        ImageSlideshow(
                          // Width of the [ImageSlideshow].
                          width: double.infinity,
                          // Height of the [ImageSlideshow].
                          height: 150,
                          // The page to show when first creating the [ImageSlideshow].
                          initialPage: 0,
                          // The color to paint the indicator.
                          indicatorColor: Colors.purple,
                          // The color to paint behind th indicator.
                          indicatorBackgroundColor: Colors.grey,
                          // The widgets to display in the [ImageSlideshow].
                          children: [
                            Image.asset(
                              'assets/Slide1.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/Slide2.png',
                              fit: BoxFit.cover,
                            ),
                            Image.asset(
                              'assets/Slide3.png',
                              fit: BoxFit.cover,
                            ),
                          ],
                          // Called whenever the page in the center of the viewport changes.
                          onPageChanged: (value) {
                          },
                          // Auto scroll interval.
                          autoPlayInterval: 3000,
                          // Loops back to first slide.
                          isLoop: true,
                        ),
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
                        FutureBuilder<List<ParseObject>>(
                              future: getMedication(searchString),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Center(
                                    );
                                  default:
                                    if (snapshot.hasError) {
                                      return Center(
                                        child: Text(""),
                                      );
                                    }
                                    if (!snapshot.hasData) {
                                      return Center(
                                        child: Text(""),
                                      );
                                    } else {
                                      return Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Text(
                                              'Results: ${snapshot.data!.length}',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontFamily: "Lato",
                                                  fontSize: 17,
                                                  fontWeight:
                                                  FontWeight.w700),
                                            ),
                                            ///If the no medication matches the search string then display no medication message
                                            (snapshot.data!.length==0)?
                                            Container(
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                                                    //mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 60,
                                                      ),
                                                      Text(
                                                        "Sorry, No results match your search.",
                                                        style: TextStyle(
                                                            fontFamily:
                                                            "Lato",
                                                            fontSize:
                                                            20,),
                                                        textAlign:
                                                        TextAlign
                                                            .center,
                                                      ),
                                                    ])):Container(),
                                          ]);
                                    }
                                }
                              }),
                        ///Medications list display
                        Expanded(
                            //Get medications
                            child: FutureBuilder<List<ParseObject>>(
                                future: getMedication(searchString),
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
                                        return GridView.builder(
                                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 300,
                                                childAspectRatio: 1/1.8,),
                                            padding: EdgeInsets.only(
                                                top: 10.0, bottom: 70.0),
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
                                              final LegalStatus = medGet.get("LegalStatus")!;
                                              ParseFileBase? image;
                                              if (medGet.get<ParseFileBase>('Image') != null) {
                                                image = medGet.get<ParseFileBase>('Image')!;
                                              }
                                              ///Display medication that matches the search string if exist
                                              return GestureDetector(
                                                          //Navigate to medication details page
                                                          onTap: () => Navigator.of(
                                                                  context)
                                                              .push(MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      medDetailsPage(
                                                                          medId!, customerId))),
                                                          //Medication card information
                                                          child: Card(
                                                              elevation: 3,
                                                              margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                              color: Colors.white,
                                                              child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                  children: [
                                                                    (image == null)?
                                                                    Image
                                                                    .asset(
                                                                  'assets/listIcon.png', height: 100, width: 70,
                                                                ):Image
                                                                        .network(
                                                                      image!.url!,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height: 120, width: 90,
                                                                    ),
                                                               Text(
                                                                    TradeName,
                                                                 textAlign: TextAlign.center,
                                                                 style: TextStyle(
                                                                        fontFamily:
                                                                            "Lato",
                                                                        fontSize:
                                                                            17,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                    Text(
                                                                    '$ScientificName',
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                        fontFamily:
                                                                            "Lato",
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontStyle:
                                                                            FontStyle.italic),
                                                                  ),
                                                                Text(
                                                                  '$Publicprice SAR',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                      "Lato",
                                                                      fontSize:
                                                                      14,
                                                                      color: Colors
                                                                          .black,
                                                                      fontStyle:
                                                                      FontStyle.italic),
                                                                ),
                                                                    (LegalStatus == 'Prescription')?
                                                                    Text('Requires prescription',
                                                                      style: TextStyle(
                                                                          fontFamily: 'Lato',
                                                                          fontSize: 14,
                                                                          color: Colors.red),):
                                                                    SizedBox(width: 0,),
                                                                    Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children:[
                                                                          Ink(
                                                                        decoration:
                                                                            ShapeDecoration.fromBoxDecoration(BoxDecoration(
                                                                          color:
                                                                          HexColor('#c7a1d1').withOpacity(0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                        )),
                                                                            width: size.width/3,
                                                                            height: size.height/22,
                                                                        ///Add to cart button
                                                                        child: IconButton(
                                                                            onPressed: () async {
                                                                              if (await addToCart(medId, customerId)) {
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
                                                                              Icons.add_shopping_cart_rounded,
                                                                              color: Colors.black,
                                                                              size: 20.0,
                                                                            )),
                                                                      ),]),
                                                                    SizedBox(height: 5,)


                                                              ])));
                                            });
                                      }
                                  }
                                })),
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

  ///Function to get medications
  Future<List<ParseObject>> getMedication(searchString) async {
    QueryBuilder<ParseObject> queryMedication1 =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryMedication1.whereStartsWith('TradeName', searchString);

    QueryBuilder<ParseObject> queryMedication2 =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryMedication2.whereStartsWith('ScientificName', searchString);

    QueryBuilder<ParseObject> queryMedication = QueryBuilder.or(
      ParseObject("Medications"),
      [queryMedication1, queryMedication2],
    );
    queryMedication.setLimit(1000);
    queryMedication.whereEqualTo('Deleted', false);
    queryMedication.orderByAscending('TradeName');
    final ParseResponse apiResponse = await queryMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  ///Function to get current logged in user
  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  ///Function to get current user from Customer table
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

  ///Function add medication to cart
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

  void showErrorLogout(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Log out failed!",
              style: TextStyle(
                  fontFamily: 'Lato', fontSize: 20, color: Colors.red)),
          content: Text(errorMessage),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok",
                  style: TextStyle(
                      fontFamily: 'Lato',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
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
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
    } else {
      showErrorLogout(response.error!.message);
    }
  }
}
