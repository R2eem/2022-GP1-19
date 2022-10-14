import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/AccountPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<ParseUser?>(
                    future: getUser(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        return Container(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()
                        );
                        default:
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 60,
                                ),
                                Text(
                                  'Hello, ${snapshot.data!.username}',
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(0.8),
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600),
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
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Categories",
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(0.8),
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                      }
                    }),
              ]),
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
                    print(_selectedIndex);
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
