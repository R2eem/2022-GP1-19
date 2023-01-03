import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Cart.dart';
import 'CategoryPage.dart';
import 'Orders.dart';
import 'Settings.dart';
import 'common/theme_helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'Location.dart';


class PresLocation extends StatefulWidget{
//Get customer id as a parameter
  final String customerId;
  final totalPrice;
  final bool presRequired;
  final lat;
  final long;
  const PresLocation(this.customerId, this.totalPrice, this.presRequired, this.lat, this.long);
  @override
  State<StatefulWidget> createState() {
    return _PresLocationPage();
  }
}

class _PresLocationPage extends State<PresLocation> {
  int _selectedIndex = 1;
  String searchString = "";
  PickedFile? pickedFile;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
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
                            SizedBox(height: 55,),
                          ]))),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 130),
                    widget.presRequired ?
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
                              : Image.file(File(pickedFile!.path), fit: BoxFit.cover))
                          : Container(
                        width: 250,
                        height: 250,
                        decoration:
                        BoxDecoration(border: Border.all(color: Colors.black87)),
                        child: Center(
                          child: Text('Click here to pick image from Gallery'),
                        ),
                      ),
                      onTap: () async {
                        PickedFile? image =
                        await ImagePicker().getImage(
                            source: ImageSource.gallery );

                        if (image != null && image.path.contains("PNG") | image.path.contains("png") | image.path.contains("jpg") | image.path.contains("JPG") | image.path.contains("jpeg") | image.path.contains("JPEG")) {
                          setState(() {
                            pickedFile = image;
                          });
                        }
                        else{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("the accepted image format are (png,jpg,jpeg) ", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
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


                      },
                    ): Container(),

                    SizedBox(height: 16),

                    SizedBox(height: 30,),
                    Row(
                      children: [
                        Text('Total price:  ', style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                        Text(widget.totalPrice.toString(), style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.red
                        )),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ])),

        persistentFooterButtons: [
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
                              ? widget.presRequired ? () {showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text("Please attach a prescription!!", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
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
                          );} : () async {
                            setState(() {
                              isLoading = true;
                            });

                            final AttachPrescription = ParseObject('Orders')
                              ..set('TotalPrice', widget.totalPrice)
                              ..set('Location', ParseGeoPoint(latitude: widget.lat, longitude: widget.long));
                            await AttachPrescription.save();

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

                            final AttachPrescription = ParseObject('Orders')
                              ..set('Prescription', parseFile)
                              ..set('TotalPrice', widget.totalPrice)
                              ..set('Location', ParseGeoPoint(latitude: widget.lat, longitude: widget.long));
                            await AttachPrescription.save();



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
                        icon: Icons.shopping_bag,
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
}


