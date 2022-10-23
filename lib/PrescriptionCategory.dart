import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:untitled/AccountPage.dart';


class PrescriptionCategory extends StatefulWidget {
  @override
  Prescription createState() => Prescription();
}

class Prescription extends State<PrescriptionCategory> with TickerProviderStateMixin {
  final todoController = TextEditingController();
  int _selectedIndex = 0;
  String searchString ='';
  String packageType ='';
  late int _selectedTab ;
  @override
  Widget build(BuildContext context) {
    TabController _tabController=
    TabController(length: 7, vsync: this, initialIndex: 0 );
    _tabController.animateTo(_selectedTab);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child:AppBar(
            title: Image.asset('assets/logoheader.png', alignment: Alignment.center, width: 70, height: 70,),
            centerTitle: true,
            backgroundColor: Colors.pink[100],
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
            ),
            elevation: 0,
            leading:
            IconButton(
              padding: EdgeInsets.symmetric(vertical: 25),
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
            child: Text('Prescription medications', style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),),
          ),
          SizedBox(height: 40),
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
                print(_selectedTab);
                if(_selectedTab == 0)
                  packageType = '';
                if(_selectedTab == 1)
                  packageType = 'tablet';
                if(_selectedTab == 2)
                  packageType ='drop';
                if(_selectedTab == 3)
                  packageType = 'syrup';
                if(_selectedTab == 4)
                  packageType ='cream';
                if(_selectedTab == 5)
                  packageType = 'gel';
                if(_selectedTab == 6)
                  packageType ='capsule';
                },);},
              isScrollable: true,//if thr tabs are alot we can scroll them
              controller: _tabController,
              labelColor: Colors.grey[900],// the tab is clicked on now color
              unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Text('All'),),
              Tab(icon: Text('Tablet'),),
              Tab(icon: Text('Drop'),),
              Tab(icon: Text('Syrup'),),
              Tab(icon: Text('Cream'),),
              Tab(icon: Text('Gel'),),
              Tab(icon: Text('Capsule'),),
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
                                return ((TradeName.toLowerCase().startsWith(searchString.toLowerCase()) || ScientificName.toLowerCase().startsWith(searchString.toLowerCase()))&& PharmaceuticalForm.toLowerCase().contains(packageType))? SingleChildScrollView(
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
                                )]))):Container();
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
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(10),
                  tabs: [
                    GButton(icon: Icons.home,),
                    GButton(icon: Icons.shopping_cart,),
                    GButton(icon: Icons.shopping_bag,),
                    GButton(icon: Icons.account_circle,),
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


