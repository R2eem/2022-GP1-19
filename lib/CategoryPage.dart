import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/AccountPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/style/colors.dart';
import 'package:untitled/style/styles.dart';
import 'NonPrescriptionCategory.dart';
import 'PrescriptionCategory.dart';

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
    theme: ThemeData(
      fontFamily: 'Gordita',
    ),
  ));
}

class CategoryPage extends StatefulWidget {
  @override
  Category createState() => Category();
}

class Category extends State<CategoryPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
        FutureBuilder<ParseUser?>(
        future: getUser(),
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
        return  SingleChildScrollView(child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    padding: const EdgeInsets.only(left: 15),
                    height: 150,
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: AppColors.babypink,
                    ),
                    child: SafeArea(
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/logoheader.png',
                                    fit: BoxFit.contain,
                                    width: 100,
                                    height: 85,
                                  ),
                                  //Image.asset('assets/logo.png'),
                                  const SizedBox(
                                    width: 12,
                                  ),

                                ],
                              ),

                              const SizedBox(
                                height: 1,
                              ),
                              Text(
                                'Hello, ${snapshot.data!.username}',
                                style: TextStyle(
                                    color: Colors.black87.withOpacity(0.8),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )),
                    )),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 10),
                  height: 500,
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(34)),
                  child:  Column(children: [
                      Text(
                        'Categories',
                        style: AppStyle.b33w,
                      ),
                    const SizedBox(
                      height: 7,
                    ),
                      Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 30.0,),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: const [
                                MedicationCategories(
                                    background: AppColors.babypink,
                                    title: 'Non-Prescription medication',
                                    subtitle: '',
                                    image: 'assets/medicationnono.png'),
                                MedicationCategoriesno(
                                    background: AppColors.pink,
                                    title: 'Prescription medication',
                                    subtitle: '',
                                    image: 'assets/medecationwith.png'),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
            ]
        ));
    }}})]),

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

  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
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

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NonPrescriptionCategory()));
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: 300,
          height: 200,
          decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(34),
              border: Border.all(color: Colors.white, width: 8),
              boxShadow: [
                BoxShadow(
                    blurRadius: 50,
                    color: const Color(0xFF0B0C2A).withOpacity(.09),
                    offset: const Offset(10, 10))
              ]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 20),
            Text(title, style: AppStyle.m12w),
            Text(subtitle, style: AppStyle.r10wt),
            const SizedBox(height: 1),
            Expanded(child: Image.asset(image)),
          ]),

        ),
      );

  }
}


class MedicationCategoriesno extends StatelessWidget {
  final Color background;
  final String title;
  final String subtitle;
  final String image;
  const MedicationCategoriesno(
      {Key? key,
        required this.background,
        required this.title,
        required this.subtitle,
        required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PrescriptionCategory()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        width: 300,
        height: 200,
        decoration: BoxDecoration(
            color: const Color(0xFFE1BEE7),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: Colors.white, width: 8),
            boxShadow: [
              BoxShadow(
                  blurRadius: 50,
                  color: const Color(0xFF0B0C2A).withOpacity(.09),
                  offset: const Offset(10, 10))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          Text(title, style: AppStyle.m12w),
          Text(subtitle, style: AppStyle.r10wt),
          const SizedBox(height: 1),
          Expanded(child: Image.asset(image)),
        ]),
      ), );
  }
}