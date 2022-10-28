import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Cart.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'CategoryPage.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class medDetailsPage extends StatefulWidget {
  final String objectId;
  final String customerId;
  const medDetailsPage(this.objectId, this.customerId);
  @override
  MedDetails createState() => MedDetails();
}

class MedDetails extends State<medDetailsPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Stack(
                children: [
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
                  Row(
                  children:[
                  Container(
                  child: BackButton(
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 13, 0, 0),
                  child: Text('', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),),
              ),
            ]),SizedBox(height: 55,),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 620,
                                  width: size.width,
                                  child: Column(children: [
                      Expanded(
                          child: FutureBuilder<ParseObject>(
                              future: getMedDetails(),
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
                                      return ListView.builder(
                                          padding: EdgeInsets.only(top: 10.0),
                                          scrollDirection: Axis.vertical,
                                          itemCount: 1,
                                          itemBuilder: (context, index) {
                                            //Get Parse Object Values
                                            final medDetails = snapshot.data!;
                                            final medId = medDetails.get<String>('objectId');
                                            final TradeName = medDetails.get<String>('TradeName')!;
                                            final ScientificName = medDetails.get<String>('ScientificName')!;
                                            final Publicprice = medDetails.get<num>('Publicprice')!;
                                            final Strength = medDetails.get<num>('Strength')!;
                                            final StrengthUnit = medDetails.get<String>('StrengthUnit')!;
                                            final PackageType = medDetails.get<String>('PackageTypes')!;
                                            final UsageMethod = medDetails.get<String>('UsageMethod')!;
                                            final MarketingCompany = medDetails.get<String>('MarketingCompany')!;
                                            final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                            return SingleChildScrollView(
                                                      child: Container(
                                                              child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                 Stack(
                                                                     children: [
                                                                       Container(
                                                                         height: MediaQuery.of(context).size.height * 0.3,
                                                                       ),
                                                                       SafeArea(
                                                                           child: Column(
                                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                                               children: [
                                                                                 SizedBox(
                                                                                   height: 30.0,
                                                                                 ),
                                                                                 Container(
                                                                                     padding: EdgeInsets.symmetric(horizontal: 16.0),
                                                                                     child: Column(
                                                                                         crossAxisAlignment: CrossAxisAlignment.start,
                                                                                         children: [
                                                                                           RichText(
                                                                                             textAlign: TextAlign.left,
                                                                                             text: TextSpan(
                                                                                               children: [
                                                                                                 TextSpan(
                                                                                                   text: TradeName,
                                                                                                   style: TextStyle(
                                                                                                     height: 2.5,
                                                                                                     fontSize: 30.0,
                                                                                                     fontWeight: FontWeight.w600,
                                                                                                     color: Color.fromRGBO(34, 34, 34, 1),
                                                                                                   ),
                                                                                                 ),
                                                                                                 TextSpan(
                                                                                                   text: '  $ProductForm',
                                                                                                   style: TextStyle(
                                                                                                     fontSize: 30.0,
                                                                                                     color: Color.fromRGBO(34, 34, 34, 1),
                                                                                                   ),
                                                                                                 ),],),),
                                                                                           SizedBox(
                                                                                             height: 5.0,
                                                                                           ),
                                                                                           Text(
                                                                                             ScientificName,
                                                                                             style: TextStyle(
                                                                                               fontSize: 20.0,
                                                                                               color: Colors.grey[700],
                                                                                               fontWeight: FontWeight.w600
                                                                                             ),
                                                                                           ),
                                                                                           SizedBox(height: 10,),
                                                                                           Row(
                                                                                               children: [
                                                                                                 Container(
                                                                                                     margin: EdgeInsets.only(),
                                                                                                     width: 345.0,
                                                                                                     decoration: BoxDecoration(
                                                                                                       borderRadius:
                                                                                                       BorderRadius.circular(8.0),
                                                                                                       border: Border.all(
                                                                                                         color: Colors.grey.withOpacity(0.5),
                                                                                                       ),
                                                                                                     ))
                                                                                               ]
                                                                                           ),
                                                                                           Container(
                                                                                               height: 60.0,
                                                                                               margin: EdgeInsets.only(right: 15.0, left: 15.0,top: 25.0),
                                                                                               child:
                                                                                                     Text(
                                                                                                       "${(Publicprice).toStringAsFixed(2) +'SAR'}",
                                                                                                       style: TextStyle(
                                                                                                         fontWeight: FontWeight.w600,
                                                                                                         fontSize: 24.0,
                                                                                                         color: Color.fromRGBO(34, 34, 34, 1),
                                                                                                           background: Paint()
                                                                                                             ..strokeWidth = 30.0
                                                                                                             ..color =  HexColor('#c7a1d1').withOpacity(0.5)
                                                                                                             ..style = PaintingStyle.stroke
                                                                                                             ..strokeJoin = StrokeJoin.round
                                                                                                       ),
                                                                                                     )),
                                                                                           Text('More information: ',
                                                                                             style: TextStyle(
                                                                                               fontSize: 20.0,
                                                                                               color: Colors.black87,
                                                                                               height: 1.40,
                                                                                             ),
                                                                                           ),
                                                                                           SizedBox(height: 10,),
                                                                                           Row(
                                                                                             children:[
                                                                                           Text('Strength:',
                                                                                             style: TextStyle(
                                                                                               fontSize: 18.0,
                                                                                               color: Colors.black54,
                                                                                               height: 1.40,
                                                                                             ),
                                                                                           ),Text('  $Strength  $StrengthUnit',
                                                                                             style: TextStyle(
                                                                                               fontSize: 16.0,
                                                                                               color: Colors.black45,
                                                                                               height: 1.40,
                                                                                                 fontStyle: FontStyle.italic
                                                                                             ),
                                                                                           ),]),
                                                                                           SizedBox(
                                                                                             height: 10.0,
                                                                                           ),
                                                                                           Row(
                                                                                               children:[
                                                                                                 Text('Usage method: ',
                                                                                             style: TextStyle(
                                                                                               fontSize: 18.0,
                                                                                               color: Colors.black54,
                                                                                               height: 1.40,
                                                                                             ),
                                                                                           ),
                                                                                           Text('$UsageMethod',
                                                                                             style: TextStyle(
                                                                                               fontSize: 16.0,
                                                                                               color: Colors.black45,
                                                                                               height: 1.40,
                                                                                               fontStyle: FontStyle.italic
                                                                                             ),
                                                                                           ),]),
                                                                                           SizedBox(
                                                                                             height: 10.0,
                                                                                           ),
                                                                                           Row(
                                                                                             children:[
                                                                                               Text('Package type: ',
                                                                                             style: TextStyle(
                                                                                               fontSize: 18.0,
                                                                                               color: Colors.black54,
                                                                                               height: 1.40,
                                                                                             ),
                                                                                           ),
                                                                                           Text('$PackageType',
                                                                                             style: TextStyle(
                                                                                               fontSize: 16.0,
                                                                                               color: Colors.black45,
                                                                                               height: 1.40,
                                                                                                 fontStyle: FontStyle.italic
                                                                                             ),
                                                                                           ),]),
                                                                                           SizedBox(
                                                                                             height: 10.0,
                                                                                           ),
                                                                                           Row(
                                                                                             children:[
                                                                                           Text('Marketing company: ',
                                                                                             style: TextStyle(
                                                                                               fontSize: 18.0,
                                                                                               color: Colors.black54,
                                                                                               height: 1.40,
                                                                                             ),
                                                                                           ),
                                                                                           Flexible(
                                                                                             child:
                                                                                           Text(MarketingCompany,
                                                                                             style: TextStyle(
                                                                                               fontSize: 16.0,
                                                                                               color: Colors.black45,
                                                                                               height: 1.40,
                                                                                                 fontStyle: FontStyle.italic,
                                                                                             ),
                                                                                           ),)]),
                                                                                            SizedBox(height: 50,),
                                                                                     InkWell(
                                                                                         onTap: () {
                                                                                             addToCart(medId, widget.customerId);
                                                                                         },
                                                                                             child: Ink(
                                                                                               decoration: BoxDecoration(
                                                                                                 borderRadius: BorderRadius.circular(8.0),
                                                                                                 color: HexColor('#c7a1d1'),
                                                                                               ),
                                                                                               child:Container(
                                                                                                 margin: EdgeInsets.only(right: 15.0),
                                                                                                 height: 60.0,
                                                                                                 padding: EdgeInsets.symmetric(
                                                                                                   horizontal: 32.0,
                                                                                                 ),
                                                                                                 child: Center(
                                                                                                   child: Text(
                                                                                                     "Add to Cart",
                                                                                                     style: TextStyle(
                                                                                                       color: Colors.white,
                                                                                                       fontWeight: FontWeight.w600,
                                                                                                       fontSize: 20.0,
                                                                                                     ),
                                                                                                   ),
                                                                                                 ),
                                                                                               ),
                                                                                             ),
                                                                                           ),
                                                                                          ]))]))
                                                                     ])
                                                              ])
                                                      )
                                            );
                                          }
                                      );
                                    }
                                }
                              }))
            ])))])))])
    ),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
                    }
                  }),
                )))
    );
  }

  Future<ParseObject> getMedDetails() async {
    var object;
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Medications'));

    parseQuery.whereEqualTo('objectId', widget.objectId);
    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        object = o as ParseObject;
      }
    }
    return object;
  }

  void addToCart(objectId, customerId) async{
    bool exist = false;
    var medInCart;
    var quantity = 0;
    final apiResponse = await ParseObject('Cart').getAll();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        if(customerId == medInCart.get('customer').objectId){
          if(objectId == medInCart.get('medication').objectId){
            exist = true;
            quantity = medInCart.get<num>('Quantity');
            break;
          }
        }
      }
    }
    if (!exist) {
      final addToCart = ParseObject('Cart')
        ..set('customer', (ParseObject('Customer')
          ..objectId = customerId)
            .toPointer())..set('medication', (ParseObject('Medications')
          ..objectId = objectId)
            .toPointer())..set('Quantity', 1);
      await addToCart.save();
    }
    else{
      var incrementQuantity = medInCart
        ..set('Quantity', ++quantity);
      await incrementQuantity.save();
    }
  }
}