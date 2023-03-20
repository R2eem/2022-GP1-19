import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Orders.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Cart.dart';
import 'Settings.dart';
import 'medDetails.dart';
import 'package:badges/badges.dart' as badges;


class PrescriptionCategory extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  const PrescriptionCategory(this.customerId);
  @override
  Prescription createState() => Prescription();
}

class Prescription extends State<PrescriptionCategory>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  String searchString = '';
  String packageType = '';
  int _selectedTab = 0;
  bool noMed = true;
  int numOfItems = 0;

  ///To change the badge value
  @override
  void initState() {
    super.initState();
    checkEmptiness();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Filter tabs
    TabController _tabController =
        TabController(length: 11, vsync: this, initialIndex: 0);
    _tabController.animateTo(_selectedTab);
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
                  Container(
                    margin: EdgeInsets.fromLTRB(40, 13, 0, 0),
                    child: Text(
                      'Prescription' + '\n' + 'Medications',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 25,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 25,
                ),
                ///Controls prescription category page display
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: size.height - 180,
                      width: size.width,
                      child: Column(
                        children: [
                          //Search bar
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
                                    TextStyle(color: Colors.grey, fontSize: 19),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintText:
                                      'Search by Scientific or Trade name',
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: Colors.pink[100],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          ///Filter tabs
                          TabBar(
                              onTap: (index) {
                                //
                                setState(
                                  () {
                                    _selectedTab = index;
                                    if (_selectedTab == 0) packageType = '';
                                    if (_selectedTab == 1)
                                      packageType = 'Capsule';
                                    if (_selectedTab == 2)
                                      packageType = 'Cream';
                                    if (_selectedTab == 3) packageType = 'Drop';
                                    if (_selectedTab == 4)
                                      packageType = 'Granules';
                                    if (_selectedTab == 5)
                                      packageType = 'Ointment';
                                    if (_selectedTab == 6)
                                      packageType = 'Powder';
                                    if (_selectedTab == 7)
                                      packageType = 'Solution';
                                    if (_selectedTab == 8)
                                      packageType = 'Spray';
                                    if (_selectedTab == 9)
                                      packageType = 'Syrup';
                                    if (_selectedTab == 10)
                                      packageType = 'Tablet';
                                  },
                                );
                              },
                              isScrollable: true,//if tabs are a lot we can scroll them
                              controller: _tabController,
                              labelColor: Colors
                                  .grey[900], // the color of active tab
                              unselectedLabelColor: Colors.grey,
                              tabs: [
                                Tab(
                                  icon: Text(
                                    'All',
                                    style: TextStyle(
                                        fontFamily: "Lato",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17),
                                  ),
                                ),
                                Tab(
                                  icon: Text('Capsule',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Cream',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Drop',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Granules',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Ointment',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Powder',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Solution',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Spray',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Syrup',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                                Tab(
                                  icon: Text('Tablet',
                                      style: TextStyle(
                                          fontFamily: "Lato",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17)),
                                ),
                              ]),
                          SizedBox(height: 20,),
                          FutureBuilder<List<ParseObject>>(
                                future: getPresMedication(searchString),
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
                                                'Resutls: ${snapshot.data!.length}',
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
                                                          "Sorry we could't find any match,",
                                                          style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 20,),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                        ),
                                                        Text(
                                                          "try another search or continue shopping through the categories.",
                                                          style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 20,),
                                                          textAlign:
                                                          TextAlign
                                                              .center,
                                                        ),
                                                      ])):Container(),
                                            ]);
                                      }
                                  }
                                }),
                          Expanded(
                              ///Get prescription medications
                              child: FutureBuilder<List<ParseObject>>(
                                  future: getPresMedication(searchString),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: Container(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  CircularProgressIndicator()),
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
                                                  childAspectRatio: 1/1.5,),
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
                                                final ProductForm =
                                                    medGet.get<String>(
                                                        'PharmaceuticalForm')!;
                                                ParseFileBase? image;
                                                if (medGet.get<ParseFileBase>('Image') != null) {
                                                  image = medGet.get<ParseFileBase>('Image')!;
                                                }

                                                ///Display medication that matches the search string if exist and matches the filter
                                                ///Display image of medication if exist
                                                return  GestureDetector(
                                                        //Navigate to medication details page
                                                        onTap: () => Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                                builder: (context) =>
                                                                    medDetailsPage(
                                                                        medId!,
                                                                        widget.customerId))),
                                                        //Medication card information
                                                        child: Card(
                                                            elevation: 3,
                                                            margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                                            color: Colors.white,
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: [
                                                                  (image == null)
                                                                      ?Image
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
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                      children:[
                                                                        Ink(
                                                                          decoration:
                                                                          ShapeDecoration.fromBoxDecoration(BoxDecoration(
                                                                            color:
                                                                            HexColor('#fad2fc'),
                                                                            borderRadius:
                                                                            BorderRadius.circular(15),
                                                                          )),
                                                                          //Add to cart button
                                                                          child: IconButton(
                                                                              onPressed: () async {
                                                                                if (await addToCart(medId, widget.customerId)) {
                                                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                    content: Text(
                                                                                      "$TradeName added to your cart",
                                                                                      style: TextStyle(fontSize: 20),
                                                                                    ),
                                                                                    duration: Duration(milliseconds: 3000),
                                                                                  ));
                                                                                }
                                                                                ;
                                                                              },
                                                                              icon: const Icon(
                                                                                Icons.add_shopping_cart_rounded,
                                                                                color: Colors.black,
                                                                                size: 20.0,
                                                                              )),
                                                                        ),]),

                                                                ])));
                                              });
                                        }
                                    }
                                  }))
                        ],
                      ),
                    )),
              ])))
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
                        iconSize: 30,
                     ),
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
                              builder: (context) =>
                                  CartPage(widget.customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(widget.customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(widget.customerId)));
                    }
                  }),
                ))));
  }

  ///Function to get prescription medications
  Future<List<ParseObject>> getPresMedication(searchString) async {
    QueryBuilder<ParseObject> queryPresMedication =
        QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryPresMedication.whereContains('LegalStatus', 'Prescription');
    queryPresMedication.setLimit(200);
    queryPresMedication.whereEqualTo('Deleted', false);
    queryPresMedication.orderByAscending('TradeName');
    queryPresMedication.whereStartsWith('TradeName', searchString);
    queryPresMedication.whereStartsWith('PharmaceuticalForm', packageType);
    final ParseResponse apiResponse = await queryPresMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Function add medication to cart
  Future<bool> addToCart(objectId, customerId) async {
    bool exist = false;
    var medInCart;
    var quantity = 0;

    //Search for medications in customer cart
    final apiResponse = await ParseObject('Cart').getAll();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        medInCart = o as ParseObject;
        if (customerId == medInCart.get('customer').objectId) {
          if (objectId == medInCart.get('medication').objectId) {
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
            (ParseObject('Medications')..objectId = objectId).toPointer())
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
  ///Get if number of items in cart
  Future<void> checkEmptiness() async {
    //Query customer cart
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      numOfItems = apiResponse.count;
      setState(() {});
    } else {
      numOfItems = 0;
    }
  }
}
