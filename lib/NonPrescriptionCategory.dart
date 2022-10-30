import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Cart.dart';
import 'Orders.dart';
import 'Settings.dart';
import 'medDetails.dart';

class NonPrescriptionCategory extends StatefulWidget {
  final String customerId;
  const NonPrescriptionCategory(this.customerId);

  @override
  NonPrescription createState() => NonPrescription();
}

class NonPrescription extends State<NonPrescriptionCategory>with TickerProviderStateMixin {
  final todoController = TextEditingController();
  int _selectedIndex = 0;
  String searchString ='';
  String packageType ='';
  int _selectedTab = 0 ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            Container(
              child: SafeArea(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Row(
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
                            margin: EdgeInsets.fromLTRB(20, 13, 0, 0),
                            child: Text('Non-Prescription' + '\n' +'Medications', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 25, color: Colors.white70, fontWeight: FontWeight.bold),),
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
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                            prefixIconColor: Colors.pink[100],
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    TabBar(onTap: (index){ //
                          setState(() {
                            _selectedTab = index;
                            if(_selectedTab == 0)
                              packageType = '';
                            if(_selectedTab == 1)
                              packageType = 'Caplet';
                            if(_selectedTab == 2)
                              packageType ='Cream';
                            if(_selectedTab == 3)
                              packageType = 'Drop';
                            if(_selectedTab == 4)
                              packageType ='Gel';
                            if(_selectedTab == 5)
                              packageType = 'Liquid';
                            if(_selectedTab == 6)
                              packageType ='Lozenge';
                            if(_selectedTab == 7)
                              packageType = 'Ointment';
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
                          Tab(icon: Text('All', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Caplet' ,style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Cream', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Drop', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Gel', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Liquid', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Lozenge', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Ointment', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Solution', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Spray', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Syrup', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                          Tab(icon: Text('Tablet', style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.w700, fontSize: 17),),),
                        ]),
                    SizedBox(height: 20,),
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
                                                          title: Text(TradeName,style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.w700),),
                                                          subtitle: Text('$ScientificName , $Publicprice SAR',style: TextStyle(
                                                              fontFamily: "Lato",
                                                              fontSize: 17,
                                                              color: Colors.black),),
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
                                                                      onPressed: () {
                                                                        addToCart(medId, widget.customerId);
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage()));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(widget.customerId)));
                    }
                  }),
                )))
    );
  }

  //query meethoodd
  Future<List<ParseObject>> getNonPresMedication() async {
    QueryBuilder<ParseObject> queryNonPresMedication =
    QueryBuilder<ParseObject>(ParseObject('Medications'));
    queryNonPresMedication.whereContains('LegalStatus', 'OTC');
    queryNonPresMedication.orderByAscending('TradeName');
    final ParseResponse apiResponse = await queryNonPresMedication.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
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