import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:untitled/Settings.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';

import 'AccountPage.dart';

class PrescriptionCategory extends StatefulWidget {
  @override
  Prescription createState() => Prescription();
}

class Prescription extends State<PrescriptionCategory> with TickerProviderStateMixin {
  final todoController = TextEditingController();
  int _selectedIndex = 0;
  String searchString ='';
  String packageType ='';
  int _selectedTab = 0 ;
  @override
  Widget build(BuildContext context) {
    TabController _tabController=
    TabController(length: 12, vsync: this, initialIndex: 0 );
    _tabController.animateTo(_selectedTab);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child:Stack(children: [
            Container(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
            SafeArea(child:
            Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(child: Image.asset(
                  'assets/logoheader.png',
                  fit: BoxFit.contain,
                  width: 100,
                  height: 70,
                ),),
                Container(
                  child: Text('Prescription medications', style: TextStyle(
                    fontFamily: "Mulish",
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                ),
                SizedBox(height: 40,),
                Material(
                    elevation: 8,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    child:
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                      style: TextStyle(
                          color: Colors.grey, fontSize: 19),
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
                    )
                ),
                SizedBox(height: 20,),
                TabBar(
                    onTap: (index){ //
                      setState(() {
                        _selectedTab = index;
                        if(_selectedTab == 0)
                          packageType = '';
                        if(_selectedTab == 1)
                          packageType = 'Capsule';
                        if(_selectedTab == 2)
                          packageType ='Cream';
                        if(_selectedTab == 3)
                          packageType = 'Drop';
                        if(_selectedTab == 4)
                          packageType ='Gel';
                        if(_selectedTab == 5)
                          packageType = 'Granules';
                        if(_selectedTab == 6)
                          packageType ='Ointment';
                        if(_selectedTab == 7)
                          packageType = 'Powder';
                        if(_selectedTab == 8)
                          packageType ='Solution';
                        if(_selectedTab == 9)
                          packageType = 'Spray';
                        if(_selectedTab == 10)
                          packageType ='Syrup';
                        if(_selectedTab == 11)
                          packageType = 'Tablet';
                      },);},
                    isScrollable: true,//if thr tabs are alot we can scroll them
                    controller: _tabController,
                    labelColor: Colors.grey[900],// the tab is clicked on now color
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Text('All', style: TextStyle(fontFamily: "Mulish", fontWeight: FontWeight.w700),),),
                      Tab(icon: Text('Capsule' ,style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Cream', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Drop', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Gel', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Granules', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Ointment', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Powder', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Solution', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Spray', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Syrup', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                      Tab(icon: Text('Tablet', style: TextStyle(fontFamily: "Mulish",fontWeight: FontWeight.w700)),),
                    ]),
                Expanded(
                    child: FutureBuilder<List<ParseObject>>(
                        future: getPresMedication(),
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
                                      final medGet = snapshot.data![index];
                                      final TradeName = medGet.get<String>('TradeName')!;
                                      final ScientificName = medGet.get<String>('ScientificName')!;
                                      final Publicprice = medGet.get<num>('Publicprice')!;
                                      final Strength = medGet.get<num>('Strength')!;
                                      final StrengthUnit = medGet.get<String>('StrengthUnit')!;
                                      final PackageType = medGet.get<String>('PackageTypes')!;
                                      var UsageMethod = medGet.get<String>('UsageMethod')!;
                                      var MarketingCompany = medGet.get<String>('MarketingCompany')!;
                                      var ProductForm = medGet.get<String>('PharmaceuticalForm')!;
                                      MarketingCompany = MarketingCompany.toLowerCase();
                                      return ((TradeName.toLowerCase().startsWith(searchString.toLowerCase()) || ScientificName.toLowerCase().startsWith(searchString.toLowerCase()))&& ProductForm.toLowerCase().contains(packageType.toLowerCase()))? SingleChildScrollView(
                                          child: Card(
                                              elevation: 5,
                                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                              color: Colors.white,

                                              child: ExpansionTile(
                                                  title: Text(TradeName,style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      fontWeight: FontWeight.w900,
                                                      fontSize: 20),),
                                                  subtitle: Text('$ScientificName , $Publicprice SR',style: TextStyle(
                                                      fontFamily: "Mulish",
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 15,
                                                      color: Colors.black),),
                                                  leading: CircleAvatar(child: Icon(Icons.medication, color: Colors.purple,
                                                    size: 36.0,), backgroundColor: Colors.grey.shade100, radius: 25,),
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
                                                      subtitle: Text('Medication details:'+ '\n' +'• Package type: $PackageType' + '\n' +'• Strength: $Strength$StrengthUnit' +  '\n' +'• Usage method: $UsageMethod' + '\n' +'• Product form: $ProductForm' + '\n' +'• Marketing company: $MarketingCompany',style: TextStyle(
                                                          fontFamily: "Mulish",
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 18,
                                                          color: Colors.black
                                                      ),),
                                                    )]))):Container();
                                    });
                              }
                          }
                        }))
                ,SizedBox(height: 80,) ],
            ),
          )),
       ] )),
        bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(10),
                  tabs: [
                    GButton(icon: Icons.home, iconActiveColor:  Colors.purple.shade200,iconSize: 35,),
                    GButton(icon: Icons.shopping_cart, iconActiveColor:  Colors.purple.shade200,  iconSize: 35,),
                    GButton(icon: Icons.shopping_bag, iconActiveColor:  Colors.purple.shade200,iconSize: 35, ),
                    GButton(icon: Icons.settings,iconActiveColor:  Colors.purple.shade200,iconSize: 35, ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if(_selectedIndex == 0){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                    }
                    else if (_selectedIndex == 1) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 2) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 3) {
                      _selectedIndex = 0;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));

                    }
                  }),
                )))
    );
  }

  Future<List<ParseObject>> getPresMedication() async {
    QueryBuilder<ParseObject> queryPresMedication =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryPresMedication.whereContains('LegalStatus', 'Prescription');
    final ParseResponse apiResponse = await queryPresMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}

