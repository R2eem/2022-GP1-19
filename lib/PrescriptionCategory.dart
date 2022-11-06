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

class PrescriptionCategory extends StatefulWidget {
  final String customerId;
  const PrescriptionCategory(this.customerId);
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
    Size size = MediaQuery.of(context).size;
    TabController _tabController=
    TabController(length: 11, vsync: this, initialIndex: 0 );
    _tabController.animateTo(_selectedTab);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child:Stack(children: [
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
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Image.asset('assets/logoheader.png',
                                      fit: BoxFit.contain,
                                      width: 110,
                                      height: 80,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 13, 0, 0),
                                    child: Text('Prescription' + '\n' +'Medications', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),),
                                  ),]),
                            SizedBox(height: 55,),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  height: 667,
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
                                            hintText: 'Search by Scientific or Trade name',
                                            prefixIcon: Icon(Icons.search),
                                            prefixIconColor: Colors.pink[100],
                                          ),
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
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
                                              packageType = 'Granules';
                                            if(_selectedTab == 5)
                                              packageType ='Ointment';
                                            if(_selectedTab == 6)
                                              packageType = 'Powder';
                                            if(_selectedTab == 7)
                                              packageType ='Solution';
                                            if(_selectedTab == 8)
                                              packageType = 'Spray';
                                            if(_selectedTab == 9)
                                              packageType ='Syrup';
                                            if(_selectedTab == 10)
                                              packageType = 'Tablet';
                                          },);},
                                        isScrollable: true,//if the tabs are a lot we can scroll them
                                        controller: _tabController,
                                        labelColor: Colors.grey[900],// the tab is clicked on now color
                                        unselectedLabelColor: Colors.grey,
                                        tabs: [
                                          Tab(icon: Text('All', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                                          Tab(icon: Text('Capsule' ,style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Cream', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Drop', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Granules', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Ointment', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Powder', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Solution', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Spray', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Syrup', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
                                          Tab(icon: Text('Tablet', style: TextStyle(fontFamily: "Lato",fontWeight: FontWeight.w700, fontSize: 17)),),
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
                                                        padding: EdgeInsets.only(top: 10.0,bottom: 70.0),
                                                        scrollDirection: Axis.vertical,
                                                        itemCount: snapshot.data!.length,
                                                        itemBuilder: (context, index) {
                                                          //Get Parse Object Values
                                                          final medGet = snapshot.data![index];
                                                          final medId = medGet.get<String>('objectId')!;
                                                          final TradeName = medGet.get<String>('TradeName')!;
                                                          final ScientificName = medGet.get<String>('ScientificName')!;
                                                          final Publicprice = medGet.get<num>('Publicprice')!;
                                                          final ProductForm = medGet.get<String>('PharmaceuticalForm')!;
                                                          return ((TradeName.toLowerCase().startsWith(searchString.toLowerCase()) || ScientificName.toLowerCase().startsWith(searchString.toLowerCase()))&& ProductForm.toLowerCase().contains(packageType.toLowerCase()))
                                                              ?  GestureDetector(
                                                              onTap: () =>  Navigator.of(context).push(MaterialPageRoute(builder: (context) => medDetailsPage(medId!, widget.customerId))),
                                                              child: Card(
                                                                  elevation: 3,
                                                                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
                                                                  color: Colors.white,
                                                                  child: Column(
                                                                      children:[
                                                                        ListTile(
                                                                          contentPadding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                                                                          title: Text(TradeName,style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.w700),),
                                                                          subtitle: Text('$ScientificName , $Publicprice SAR',style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 19,
                                                                              color: Colors.black,
                                                                              fontStyle: FontStyle.italic),),
                                                                          leading: Image.asset('assets/listIcon.png',),
                                                                          trailing: Row(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Ink(
                                                                                  decoration: ShapeDecoration.fromBoxDecoration(
                                                                                      BoxDecoration(
                                                                                        color: HexColor('#fad2fc'),
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      )),
                                                                                  child: IconButton(
                                                                                      onPressed: () async {
                                                                                        if(await addToCart(medId, widget.customerId)) {
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                              SnackBar(content: Text("$TradeName added to your cart",style: TextStyle(fontSize: 20),),
                                                                                                duration: Duration(milliseconds: 3000),
                                                                                              ));
                                                                                        };
                                                                                      },
                                                                                      icon: const Icon(
                                                                                        Icons.add_shopping_cart_rounded,
                                                                                        color: Colors.black,
                                                                                        size: 25.0,)),
                                                                                ),
                                                                              ]
                                                                          ),
                                                                        ),
                                                                      ] ))):Container();
                                                        });
                                                  }
                                              }
                                            }))
                                  ],
                                  ),
                                )),
                          ] )))])),
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(widget.customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(widget.customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(widget.customerId)));
                    }
                  }),
                )))
    );
  }

  Future<List<ParseObject>> getPresMedication() async {
    QueryBuilder<ParseObject> queryPresMedication =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryPresMedication.whereContains('LegalStatus', 'Prescription');
    queryPresMedication.orderByAscending('TradeName');
    final ParseResponse apiResponse = await queryPresMedication.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
  Future<bool> addToCart(objectId, customerId) async{
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
    else{
      return false;
    }
    if (!exist) {
      final addToCart = ParseObject('Cart')
        ..set('customer', (ParseObject('Customer')..objectId = customerId).toPointer())
        ..set('medication', (ParseObject('Medications')..objectId = objectId).toPointer())
        ..set('Quantity', 1);
      await addToCart.save();
      return true;
    }
    else{
      var incrementQuantity = medInCart
        ..set('Quantity', ++quantity);
      await incrementQuantity.save();
      return true;
    }
  }
}

