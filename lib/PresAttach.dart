import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Location.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'Settings.dart';
import 'common/theme_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';



class PresAttach extends StatefulWidget{
//Get customer id as a parameter
  final String customerId;
  final totalPrice;
  final bool presRequired;
  final lat;
  final lng;
  const PresAttach(this.customerId, this.totalPrice, this.presRequired, this.lat, this.lng);
  @override
  State<StatefulWidget> createState() {
    return _PresAttachPage();
  }
}

class _PresAttachPage extends State<PresAttach> {
  int _selectedIndex = 1;
  String searchString = "";
  PickedFile? pickedFile;
  bool isLoading = false;
  List medicationsList = [];
  bool locationExist = false;

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
                                children: [
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
                                    //child: Text('Orders', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 27, color: Colors.white70, fontWeight: FontWeight.bold),),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(40.0, 40.0, 40.0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  widget.presRequired ?
                              Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text('Attach prescription:  ', style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  SizedBox(height: 10,),
                                  Text('* The accepted image format are (png,jpg,jpeg)', style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 14,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w700),),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    child: pickedFile != null
                                        ? Container(
                                        width: 250,
                                        height: 250,
                                        decoration:
                                        BoxDecoration(border: Border.all(color: HexColor(
                                            '#ad5bf5'))),
                                        child: kIsWeb
                                            ? Image.network(pickedFile!.path)
                                            : Image.file(
                                            File(pickedFile!.path), fit: BoxFit.cover))
                                        : Container(
                                      width: 150,
                                      height: 150,
                                      decoration:
                                      BoxDecoration(border: Border.all(color: Colors
                                          .black87)),
                                      child: Center(
                                        child: Text('Click here to pick image from Gallery'),
                                      ),
                                    ),
                                    onTap: () async {
                                      PickedFile? image =
                                      await ImagePicker().getImage(
                                          source: ImageSource.gallery);

                                      if (image != null && image.path.contains("PNG") | image
                                          .path.contains("png") | image.path.contains(
                                          "jpg") | image.path.contains("JPG") | image.path
                                          .contains("jpeg") | image.path.contains("JPEG")) {
                                        setState(() {
                                          pickedFile = image;
                                        });
                                      }
                                      else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  "The accepted image format are (png,jpg,jpeg) ",
                                                  style: TextStyle(
                                                    fontFamily: 'Lato', fontSize: 20,)),
                                              actions: <Widget>[
                                                new TextButton(
                                                  child: const Text("Ok", style: TextStyle(
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
                                    },
                                  )]) : Container(),
                                  SizedBox(height: 10,),
                                  Text('Order summary:  ', style: TextStyle(
                                    fontFamily: 'Lato',
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  )),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text('Total price:  ', style: TextStyle(
                                        fontFamily: 'Lato',
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Container(
                                          margin: EdgeInsets.only(right: 15.0, left: 15.0, top: 10.0, bottom: 10.0),
                                          child:
                                          Text(
                                            "${(widget.totalPrice).toStringAsFixed(2) +' SAR'}",
                                            style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20.0,
                                                color: Color.fromRGBO(34, 34, 34, 1),
                                                background: Paint()
                                                  ..strokeWidth = 30.0
                                                  ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeJoin = StrokeJoin.round
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            SingleChildScrollView(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25,),
                                      height: size.height/2,
                                      width: size.width,
                                      child: Column(children: [
                                        Expanded(
                                          //Get cart medications for customer
                                            child: FutureBuilder<List<ParseObject>>(
                                                future:
                                                getCustomerCart(), //Will change cartNotEmpty value
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
                                                          child: Text("Error..."),
                                                        );
                                                      }
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: Text("No Data..."),
                                                        );
                                                      } else {
                                                        //If cartNotEmpty true then display medications
                                                        return ListView.builder(
                                                            scrollDirection: Axis.vertical,
                                                            itemCount: snapshot.data!.length,
                                                            itemBuilder: (context, index) {
                                                              //Get Parse Object Values
                                                              //Get customer medications from cart table
                                                              final customerCart = snapshot.data![index];
                                                              final medId = customerCart.get('medication')!;
                                                              final quantity = customerCart.get<num>('Quantity')!;
                                                              //Store customer medications in list
                                                              for (int i = 0; i < snapshot.data!.length; i++) {
                                                                var medications = {
                                                                  'medId': medId['objectId'],
                                                                  'quantity': quantity.toString(),
                                                                };
                                                                var contain = medicationsList.where((element) => element['medId'] == medId['objectId']);
                                                                if (contain.isEmpty) {
                                                                  medicationsList.add(medications);
                                                                }
                                                              }
                                                              //Get customer medications information from Medications table
                                                              return FutureBuilder<
                                                                  List<ParseObject>>(
                                                                  future: getCustomerCartMed(medId), //Send medications id that exist in customer cart
                                                                  builder: (context, snapshot) {
                                                                    switch (snapshot.connectionState) {
                                                                      case ConnectionState.none:
                                                                      case ConnectionState.waiting:
                                                                        return Center(
                                                                          child:
                                                                          Container(
                                                                            width: 50,
                                                                            height: 50,
                                                                          ),
                                                                        );
                                                                      default:
                                                                        if (snapshot.hasError) {
                                                                          return Center(
                                                                            child: Text(
                                                                                "Error..."),
                                                                          );
                                                                        }
                                                                        if (!snapshot.hasData) {
                                                                          return Center(
                                                                            child: Text(
                                                                                "No Data..."),
                                                                          );
                                                                        } else {
                                                                          return ListView.builder(
                                                                              scrollDirection: Axis.vertical,
                                                                              shrinkWrap: true,
                                                                              physics: ClampingScrollPhysics(),
                                                                              itemCount: snapshot.data!.length,
                                                                              itemBuilder: (context, index) {
                                                                                //Get Parse Object Values
                                                                                //Get medication information from Medications table
                                                                                final medGet = snapshot.data![index];
                                                                                final TradeName = medGet.get<String>('TradeName')!;
                                                                                final Publicprice = medGet.get<num>('Publicprice')! * quantity;

                                                                                return Column(
                                                                                    children: [
                                                                                      Stack(
                                                                                          children: <Widget>[
                                                                                            Container(
                                                                                              margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                              child: Row(
                                                                                                children: <Widget>[
                                                                                                  Text('$quantity X',
                                                                                                    style: TextStyle(
                                                                                                        fontFamily: "Lato",
                                                                                                        fontSize: 20,
                                                                                                        fontWeight: FontWeight.w700),),
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
                                                                                                              '$TradeName  $Publicprice SAR',
                                                                                                              maxLines: 2,
                                                                                                              softWrap: true,
                                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ],
                                                                                                      ),
                                                                                                    ),
                                                                                                    flex: 100,
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )]);
                                                                              });
                                                                        }
                                                                    }
                                                                  });
                                                            });
                                                      }
                                                  }
                                                }))
                                      ]),
                                    ))),
                          ]))),
            ])),

        persistentFooterButtons: [
          CircleAvatar(
              backgroundColor: Colors.purple.shade300,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            Location(widget.customerId, widget.totalPrice,
                                widget.presRequired)),);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                    size: 24.0,
                  ))),
          Text('Back',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(width: 79,),
          Text('Send Order',
              style: TextStyle(
                fontFamily: 'Lato',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              )),
          CircleAvatar(
              backgroundColor: Colors.purple.shade300,
              child: IconButton(
                  onPressed:
                  isLoading || pickedFile == null
                      ? widget.presRequired ? () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("Please attach a prescription!!",
                              style: TextStyle(
                                fontFamily: 'Lato', fontSize: 20,)),
                          actions: <Widget>[
                            new TextButton(
                              child: const Text("Ok", style: TextStyle(
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
                  } : () async {
                    setState(() {
                      isLoading = true;
                    });
                    final point = ParseGeoPoint(
                        latitude: widget.lat, longitude: widget.lng);
                    final orderInfo = ParseObject('Orders')
                      ..set('Customer_id', (ParseObject('Customer')
                        ..objectId = widget.customerId).toPointer())
                      ..set('TotalPrice', widget.totalPrice)
                      ..set('Location', point)
                      ..setAddUnique('MedicationsList', medicationsList);

                    await orderInfo.save();

                    if(!locationExist)
                    {
                      final saveLocation = ParseObject('Locations')
                        ..set('customer', (ParseObject('Customer')
                          ..objectId = widget.customerId).toPointer())..set(
                            'SavedLocations', point);
                      await saveLocation.save();
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Your order has been submited. You can view the order in orders page.",
                              style: TextStyle(
                                fontFamily: 'Lato', fontSize: 20,)),
                          actions: <Widget>[
                            new TextButton(
                              child: const Text("Ok", style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CategoryPage()),);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    emptyTheCart();

                    setState(() {
                      isLoading = false;
                      pickedFile = null;
                    });
                  }
                      : () async {
                    setState(() {
                      isLoading = true;
                    });
                    ParseFileBase? parseFile;

                    if (kIsWeb) {
                      //Flutter Web
                      parseFile = ParseWebFile(
                          await pickedFile!.readAsBytes(),
                          name: 'image.jpg'); //Name for file is required
                    } else {
                      //Flutter Mobile/Desktop
                      parseFile = ParseFile(File(pickedFile!.path));
                    }
                    await parseFile.save();

                    final point = ParseGeoPoint(
                        latitude: widget.lat, longitude: widget.lng);
                    final orderInfo = ParseObject('Orders')
                      ..set('Customer_id', (ParseObject('Customer')
                        ..objectId = widget.customerId).toPointer())
                      ..set('Prescription', parseFile)
                      ..set('TotalPrice', widget.totalPrice)
                      ..set('Location', point)
                      ..setAddUnique('MedicationsList', medicationsList);
                    await orderInfo.save();

                    if(!locationExist)
                    {
                      final saveLocation = ParseObject('Locations')
                        ..set('customer', (ParseObject('Customer')
                          ..objectId = widget.customerId).toPointer())..set(
                            'SavedLocations', point);
                      await saveLocation.save();
                    }

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Your order has been submited. You can view the order in orders page.",
                              style: TextStyle(
                                fontFamily: 'Lato', fontSize: 20,)),
                          actions: <Widget>[
                            new TextButton(
                              child: const Text("Ok", style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => CategoryPage()),);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    emptyTheCart();

                    setState(() {
                      isLoading = false;
                      pickedFile = null;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 24.0,
                  ))),
        ],

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
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.receipt_long,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                    GButton(
                        icon: Icons.settings,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) =>
                      setState(() {
                        _selectedIndex = index;
                        if (_selectedIndex == 0) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                        } else if (_selectedIndex == 1) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(widget.customerId)));
                        } else if (_selectedIndex == 2) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(widget.customerId)));
                        } else if (_selectedIndex == 3) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(widget.customerId)));
                        }
                      }),
                ))));
  }

  void emptyTheCart() async {
    var medInCart;
    //Query customer cart
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        medInCart.delete();
      }
    }
  }
  //Get customer medications from cart table + check existence of location
  Future<List<ParseObject>> getCustomerCart() async {
    //Query customer cart
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse1 = await customerCart.query();

    var object;
    final QueryBuilder<ParseObject> savedLocations =
    QueryBuilder<ParseObject>(ParseObject('Locations'));
    savedLocations.whereEqualTo('customer', (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse2 = await savedLocations.query();

    if (apiResponse1.success && apiResponse1.results != null) {
      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results!) {
          object = o as ParseObject;
          if (object.get<ParseGeoPoint>('SavedLocations')!.toJson()['latitude'] == widget.lat){
            if (object.get<ParseGeoPoint>('SavedLocations')!.toJson()['longitude'] == widget.lng){
              locationExist = true;
            }
          }
        }
      }
      return apiResponse1.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Get customer's medication information from Medications table
  Future<List<ParseObject>> getCustomerCartMed(medIdCart) async {
    final QueryBuilder<ParseObject> customerCartMed =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    customerCartMed.whereEqualTo('objectId', medIdCart.objectId);
    final apiResponse = await customerCartMed.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}


