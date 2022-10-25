import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/LoginPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'AccountPage.dart';
import 'common/theme_helper.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MyApp());
}
class MyApp extends StatelessWidget{
  //Color _primaryColor = HexColor('#DC54FE');
  //Color _accentColor = HexColor('#8A02AE');
  //Color _primaryColor = HexColor('#f5a9f1');
  //primaryColor: HexColor('#e04ad2'),
  //Color _accentColor = HexColor('#ad5bf5');
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tiryaq',
      theme: ThemeData(
        primaryColor: HexColor('#f5a9f1'),
        accentColor: HexColor('#ad5bf5'),
        scaffoldBackgroundColor: Colors.grey.shade100,
        primarySwatch: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
  double _headerHeight = 250;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
        child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, false, Icons.login_rounded), //let's create a common header widget
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                    child: Column(
                      children: [
                 Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Image.asset('assets/headerlogo.png',height: 400, width: 400,)
                        ),
                Text("Who are you?",
                  textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Mulish',fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 50,),
              Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
                    child: Text('Customer'.toUpperCase(), style: TextStyle(fontFamily: 'Mulish',fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),),
                  ),
                  onPressed: (){
                    //After successful login we will redirect to profile page. Let's create profile page now
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
                  SizedBox(height: 35,),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
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
      ]),
    )
    );
  }
}
