import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:untitled/AccountPage.dart';


class NonPrescriptionCategory extends StatefulWidget {
  @override
  NonPrescription createState() => NonPrescription();
}

class NonPrescription extends State<NonPrescriptionCategory> {
  final todoController = TextEditingController();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text('Non-Prescription medications', style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xffEFEFEF),
                      borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Search",
                        style: TextStyle(
                            color: Colors.grey, fontSize: 19),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50,),
                Expanded(
                    child: FutureBuilder<List<ParseObject>>(
                        future: getNonPresMedication(),
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
                                      final Publicprice = medGet.get<double>('Publicprice')!;
                                      //final Size = medGet.get<int>('Size')!;
                                      //final SizeUnit = medGet.get<String>('SizeUnit')!;
                                      //final Strength = medGet.get<double>('Strength')!;
                                      //final StrengthUnit = medGet.get<String>('StrengthUnit')!;
                                      //final PackageSize = medGet.get<int>('PackageSize')!;
                                      //final PackageType = medGet.get<String>('PackageType')!;
                                      var MarketingCompany = medGet.get<String>('MarketingCompany')!;
                                      var PharmaceuticalForm = medGet.get<String>('PharmaceuticalForm')!;
                                      var UsageMethod = medGet.get<String>('UsageMethod')!;
                                      MarketingCompany = MarketingCompany.toLowerCase();
                                      PharmaceuticalForm = PharmaceuticalForm.toLowerCase();
                                      UsageMethod = UsageMethod.toLowerCase();
                                      return SingleChildScrollView(
                                          child: Card(
                                              elevation: 5,
                                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                              color: Colors.purple[100],
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
                                                  leading: CircleAvatar(child: Icon(Icons.medication, color: Colors.pink,
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
                                                    )])));
                                    });
                              }
                          }
                        }))
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: GNav(
                  tabBackgroundColor: Colors.pink.shade100,
                  gap: 8,
                  padding: const EdgeInsets.all(16),
                  tabs: [
                    GButton(icon: Icons.home, text: 'Home'),
                    GButton(icon: Icons.shopping_cart, text: 'Cart'),
                    GButton(icon: Icons.shopping_bag, text: 'Orders'),
                    GButton(icon: Icons.account_circle, text: 'Account'),
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
                              builder: (context) => AccountPage()));

                    }
                  }),
                )))
    );
  }

  //query meethod
  Future<List<ParseObject>> getNonPresMedication() async {
    QueryBuilder<ParseObject> queryNonPresMedication =
    QueryBuilder<ParseObject>(ParseObject('Medication'));
    queryNonPresMedication.whereContains('LegalStatus', 'OTC');
    final ParseResponse apiResponse = await queryNonPresMedication.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}


