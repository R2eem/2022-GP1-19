
import 'package:untitled/LoginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'LoginPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AccountPage(),
  ));
}

class AccountPage extends StatefulWidget {
  @override
  Account createState() => Account();
}



class Account extends State<AccountPage> {
  int _selectedIndex = 3;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child:AppBar(
            title:
            Text("My Account",
              style: TextStyle(
                  fontSize: 30,
                  letterSpacing: 2),
            ),
            leading: Icon(Icons.account_circle_rounded),
            leadingWidth: 100,
            backgroundColor: Colors.pink[100],
          ),
        ),

      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,

        body: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center, // the location of the circle under under the profile pic
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,// location of text fields

                    children: [

                      Container(
                        height: 400, // height of text fields location
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 10), // length of text fields
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // space between text fields
                          crossAxisAlignment: CrossAxisAlignment.end,


                            children: <Widget>[
                                 FutureBuilder<ParseUser?>(
                                 future: getUser(),
                                 builder: (context, snapshot) {
                                 switch (snapshot.connectionState) {
                                 case ConnectionState.none:
                                 case ConnectionState.waiting:
                                   // return Container(
                                   //     width: 100,
                                   //     height: 100,
                                   //     child: CircularProgressIndicator()
                                   // );
                                   default:
                                     return


                            Column(
                              children:[
                                  Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Container(
                                           child:
                                             Text("UserName:",
                                              style: TextStyle(
                                              fontSize: 20 ,
                                              color:Colors.pink[100],
                                              letterSpacing: 2, // text color
                                              fontWeight: FontWeight.bold,
                                                            ),
                                                ),
                                                      ),
                                       ),

                                   SizedBox(height: 25,),

                                   textfield(
                                   hintText:'${snapshot.data!.username}',
                                     enabled:false,

                                   ),

                                   SizedBox(height: 25,),

                                   Align(
                                     alignment: AlignmentDirectional.centerStart,
                                     child: Container(
                                            child:
                                              Text("Email:",
                                              style: TextStyle(
                                              fontSize: 20 ,color:Colors.pink[100],
                                              letterSpacing: 2, // text color
                                              fontWeight: FontWeight.bold,
                                                              ),
                                                  ),
                                                      ),
                                         ),

                                   SizedBox(height: 25,),

                                     textfield(
                                      hintText:'${snapshot.data!.emailAddress}',
                                         enabled:false,


                                              ),

                                   SizedBox(height: 25),
                                    LogoutButton((){}),


                                   // SizedBox(height: 10,),
                                   //
                                   //  ChangeButton((){}),

                                   ]
                                 );
                               }
                             }
                           ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),



        bottomNavigationBar: Container(
        child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
    child: GNav(
    tabBackgroundColor: Colors.pink.shade100,
    gap: 8,
    padding: const EdgeInsets.all(16),
    tabs:  [
    GButton(icon: Icons.home, text: 'Home'),
    GButton(icon: Icons.shopping_cart, text: 'Cart'),
    GButton(icon: Icons.shopping_bag, text: 'Orders'),
    GButton(icon: Icons.account_circle, text: 'Account')
    ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) => setState(() {
          _selectedIndex = index;
          if(_selectedIndex == 0){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
          else if(_selectedIndex == 1){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
          else if(_selectedIndex == 2){
            //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
          }
        }) ),
    ),
   )
  );
  }
}





Widget textfield({required String hintText,required enabled}) {
  return Material(
    elevation: 10, //the shadow under text fields
    shadowColor:  Colors.grey, // showdow color
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),//text fields shape
    child: TextField(
      enabled:false,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          letterSpacing: 2,
          color: Colors.blueGrey[200], // text color
          fontWeight: FontWeight.bold,
        ),
        fillColor: Colors.white30, //the text fields color
        filled: true,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none
        ), // text fields outline space
      ),
    ),

  );
}

// Widget ChangeButton( Function onPressed) {
//
//   return MaterialButton(
//     minWidth: 200,
//     height: 40,
//     splashColor: Colors.green[500],
//     onPressed: () => onPressed(),
//     color: Colors.green[200],
//     elevation: 0,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(50)
//     ),
//     child: Text("Save Changes",
//       style: TextStyle(
//           fontWeight: FontWeight.w600,
//           fontSize: 20
//       ),
//     ),
//
//   );
// }

//////////////////////////Button
Widget LogoutButton(Function onPressed) {
  return MaterialButton(
    minWidth: 200,
    height: 40,
    splashColor: Colors.red[500],
    onPressed: () {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    },
    color: Colors.red[200],
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50)
    ),
    child: Text("Logout",
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20
      ),
    ),
  );
}

Future<ParseUser?> getUser() async {
  var currentUser = await ParseUser.currentUser() as ParseUser?;
  return currentUser;
}

