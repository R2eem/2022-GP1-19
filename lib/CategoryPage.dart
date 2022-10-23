import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/AccountPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/style/colors.dart';
import 'package:untitled/style/styles.dart';
import 'NonPrescriptionCategory.dart';
import 'PrescriptionCategory.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:hexcolor/hexcolor.dart';
import 'common/theme_hepler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CategoryPage(),

  ));
}

class CategoryPage extends StatefulWidget {
  @override
  Category createState() => Category();
}

class Category extends State<CategoryPage> {
  int _selectedIndex = 0;
  double _headerHeight = 250;
  String searchString = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(

          child:Stack(children: [
          Container(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
         Container(
           child:
             SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  Container(child: Image.asset(
                    'assets/logoheader.png',
                    fit: BoxFit.contain,
                    width: 100,
                    height: 70,
                  ),)
                  ,
                 Container(child: FutureBuilder<ParseUser?>(
                future: getUser(),
                builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                 return Center(
                     child: Container(
                     margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                     alignment: Alignment.center,
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
        return FutureBuilder<List>(
        future: currentuser(snapshot.data!.objectId),
    builder: (context, snapshot) {
    switch (snapshot.connectionState) {
    case ConnectionState.none:
    case ConnectionState.waiting:
    return Center(
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
    final id = user.get<String>('objectId')!;
    final Firstname = user.get<String>('Firstname')!;
    final Lastname = user.get<String>('Lastname')!;
    return SingleChildScrollView(child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: 90,
                    child:
                              Text(
                                'Hello, ${Firstname} ${Lastname}',

                                style: TextStyle(
                                  fontFamily: "Mulish",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,),
                              ),
                    ),
            ]
        );
    }}})),
             Align(
                 alignment: Alignment.bottomCenter,
                 child: Container(
                     padding: const EdgeInsets.symmetric(
                         horizontal: 20, vertical: 10),
                     height: 600,
                     width: size.width,
                     child:  Column(children: [
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
            ]
        ));
    });}}});}}})]),
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PrescriptionCategory()));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                                width: 110 ,
                                height: 70 ,
                                color: HexColor('#F8D4FB'),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("Prescription Medication", style: TextStyle(
                                      fontFamily: "Mulish",
                                      color: Colors.purple,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),),)
                            ))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NonPrescriptionCategory()));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              width: 110 ,
                              height: 70 ,
                              color: HexColor('#F8D4FB'),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Non-Prescription Medication", style: TextStyle(
                                    fontFamily: "Mulish",
                                    color: Colors.purple,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),),)
                          ),
                        )),
                  ],),
                SizedBox(height: 25,),
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
                                      final medGet = snapshot.data![index];
                                      final TradeName = medGet.get<String>('TradeName')!;
                                      final ScientificName = medGet.get<String>('ScientificName')!;
                                      final Publicprice = medGet.get<num>('Publicprice')!;
                                      final Size = medGet.get<num>('Size')!;
                                      final SizeUnit = medGet.get<String>('SizeUnit')!;
                                      final Strength = medGet.get<num>('Strength')!;
                                      final StrengthUnit = medGet.get<String>('StrengthUnit')!;
                                      final PackageSize = medGet.get<num>('PackageSize')!;
                                      final PackageType = medGet.get<String>('PackageTypes')!;
                                      var UsageMethod = medGet.get<String>('UsageMethod')!;
                                      var MarketingCompany = medGet.get<String>('MarketingCompany')!;
                                      var PharmaceuticalForm = medGet.get<String>('PharmaceuticalForm')!;
                                      UsageMethod = UsageMethod.toLowerCase();
                                      MarketingCompany = MarketingCompany.toLowerCase();
                                      PharmaceuticalForm = PharmaceuticalForm.toLowerCase();
                                      return TradeName.toLowerCase().startsWith(searchString.toLowerCase()) || ScientificName.toLowerCase().startsWith(searchString.toLowerCase())? SingleChildScrollView(
                                          child: Card(
                                              elevation: 5,
                                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0),
                                              ),
                                              child: ExpansionTile(
                                                  title: Text(TradeName,style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 20),),
                                                  subtitle: Text('$ScientificName , $Publicprice SR',style: TextStyle(
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: 15,
                                                      color: Colors.black),),
                                                  leading: CircleAvatar(child: Icon(Icons.medication, color: Colors.purple,
                                                    size: 36.0,), backgroundColor: Colors.grey.shade100, radius: 25,),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.keyboard_arrow_down,color: Colors.black,
                                                        size: 26.0,),
                                                      IconButton(onPressed: () {}, icon: const Icon(Icons.add_shopping_cart,color: Colors.black,
                                                        size: 25.0,)),
                                                    ],
                                                  ),
                                                  children: <Widget>[
                                                    ListTile(
                                                      subtitle: Text('Medication details:'+ '\n' +'• Usage method: $UsageMethod' + '\n' +'• Pharmaceutical form: $PharmaceuticalForm' + '\n' +'• Marketing company: $MarketingCompany',style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 18,
                                                          color: Colors.black
                                                      ),),
                                                    )]))):Container();
                                    });
                              }
                          }
                        }))

              ]),

            ))]))),])),


        bottomNavigationBar: Container(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(10),
                  tabs: [
                    GButton(icon: Icons.home, ),
                    GButton(icon: Icons.shopping_cart,),
                    GButton(icon: Icons.shopping_bag, ),
                    GButton(icon: Icons.account_circle, ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 1) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 2) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountPage()));
                    }
                  }),
                ))));
  }

  Future<List<ParseObject>> getMedication() async {
    QueryBuilder<ParseObject> queryMedication =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    final ParseResponse apiResponse = await queryMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  Future<List> currentuser(objectid) async {
    QueryBuilder<ParseUser> queryUsers =
    QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryUsers.whereContains('objectId', objectid);
    final ParseResponse apiResponse = await queryUsers.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}
class MedicationCategories extends StatelessWidget {
  final Color background;
  final String title;
  final String subtitle;
  final String image;
  const MedicationCategories(
      {Key? key,
        required this.background,
        required this.title,
        required this.subtitle,
        required this.image})
      : super(key: key);
}





