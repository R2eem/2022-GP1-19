import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/Cart.dart';
import 'NonPrescriptionCategory.dart';
import 'Orders.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Settings.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class CategoryPage extends StatefulWidget {
  @override
  Category createState() => Category();
}

class Category extends State<CategoryPage> {
  int _selectedIndex = 0;
  String searchString = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
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
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Image.asset(
                    'assets/logoheader.png',
                    fit: BoxFit.contain,
                    width: 110,
                    height: 80,
                  ),
                ),
                SizedBox(height: 55,),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 620,
                      width: size.width,
                      child: Column(children: [
                        Material(
                            elevation: 4,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: TextField(
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
                                hintText: 'Search',
                                prefixIcon: Icon(Icons.search),
                                prefixIconColor: Colors.pink[100],
                              ),
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PrescriptionCategory()));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      width: 150,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [HexColor('#e9c3fa'), HexColor('#fac3f5')])
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Prescription Medication",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              color: HexColor('#884bbd'),
                                              fontSize: 18,
                                          fontWeight: FontWeight.bold,),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NonPrescriptionCategory()));
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      width: 150,
                                      height: 70,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [HexColor('#e9c3fa'), HexColor('#fac3f5')])
                                      ),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Non-Prescription Medication",
                                          style: TextStyle(
                                              fontFamily: "Lato",
                                              color: HexColor('#884bbd'),
                                              fontSize: 18,
                                          fontWeight: FontWeight.bold,),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
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
                                        return ListView.builder(
                                            padding: EdgeInsets.only(top: 10.0),
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              //Get Parse Object Values
                                              final medGet =
                                                  snapshot.data![index];
                                              final TradeName = medGet
                                                  .get<String>('TradeName')!;
                                              final ScientificName =
                                                  medGet.get<String>('ScientificName')!;
                                              final Publicprice = medGet
                                                  .get<num>('Publicprice')!;
                                              final Strength =
                                                  medGet.get<num>('Strength')!;
                                              final StrengthUnit = medGet
                                                  .get<String>('StrengthUnit')!;
                                              final PackageType = medGet
                                                  .get<String>('PackageTypes')!;
                                              var UsageMethod = medGet
                                                  .get<String>('UsageMethod')!;
                                              var MarketingCompany =
                                                  medGet.get<String>('MarketingCompany')!;
                                              var ProductForm =
                                                  medGet.get<String>('PharmaceuticalForm')!;
                                              MarketingCompany =
                                                  MarketingCompany
                                                      .toLowerCase();
                                              return TradeName.toLowerCase()
                                                          .startsWith(searchString
                                                              .toLowerCase()) ||
                                                      ScientificName
                                                              .toLowerCase()
                                                          .startsWith(
                                                              searchString
                                                                  .toLowerCase())
                                                  ? SingleChildScrollView(
                                                  child: Card(
                                                      elevation: 3,
                                                      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                      color: Colors.white,
                                                      child: Column(
                                                        children:[

                                                       ExpansionTile(
                                                          title: Text(TradeName,style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700),),
                                                          subtitle: Text('$ScientificName , $Publicprice SR',style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 15,
                                                              color: Colors.black),),
                                                          leading: Image.asset('assets/listIcon.png',),
                                                          trailing: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Icon(Icons.keyboard_arrow_down,color: Colors.black,
                                                                size: 26.0,),
                                                              IconButton(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart_outlined,color: Colors.black,
                                                                size: 25.0,)),
                                                            ],
                                                          ),
                                                          children: <Widget>[
                                                            ListTile(
                                                                  subtitle: Text('Medication details:'+ '\n' +'• Package type:  $PackageType' + '\n' +'• Strength:  $Strength$StrengthUnit' +  '\n' +'• Usage method:  $UsageMethod' + '\n' +'• Product form:  $ProductForm' + '\n' +'• Marketing company:  $MarketingCompany',style: TextStyle(
                                                                      fontFamily: "Lato",
                                                                      fontWeight: FontWeight.w500,
                                                                      fontSize: 18,
                                                                      color: Colors.black
                                                                  ),),
                                                            ),
                                                                 ]),

                                                         ] ))):Container();
                                            });
                                      }
                                  }
                                }))
                        ]),
                    ))
              ]))),
        ])),
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
                ))));
  }

  Future<List<ParseObject>> getMedication() async {
    QueryBuilder<ParseObject> queryMedication =
        QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryMedication.setLimit(200);
    final ParseResponse apiResponse = await queryMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}
