import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/LoginPage.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      )
  );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 15,
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 3,
                  style: BorderStyle.none
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                    child: Column(
                      children: [
                Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.asset('assets/logo.png',height: 400, width: 400,)
                        ),
                  Text("Who are you?",
                  textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Mulish',fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
             Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                    child: Text('Customer'.toUpperCase(), style: TextStyle(fontFamily: 'Mulish',fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),),
                  ),
                  onPressed: (){
                    //After successful login we will redirect to profile page. Let's create profile page now
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
                  SizedBox(height: 20,),
                      Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                              child: Text('Pharmacy'.toUpperCase(), style: TextStyle(fontFamily: 'Mulish',fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                            onPressed: (){
                              //After successful login we will redirect to profile page. Let's create profile page now
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                          ),
                        ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
