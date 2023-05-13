import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/LoginPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'PharmacyLogin.dart';
import 'common/theme_helper.dart';
import 'package:native_notify/native_notify.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '0RlD4YgWV75gUlCXVcHr33pzfYN3ilb1qrFWyUy5';
  final keyClientKey = 'Vjbmxk9zpKPkJaU4D6HcGFQZkQWH5em93DvAIlJi';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  ///Push notification
  WidgetsFlutterBinding.ensureInitialized();
  NativeNotify.initialize(2338, 'dX0tKYd2XD2DOtsUirIumj', null, null);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
              children: [
                //Header
                Container(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, false, Icons.login_rounded),
                ),
                ///Page logo and title
                SafeArea(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height / 4,
                              child: Image.asset('assets/tiryaglogo.png',height: 400, width: 400,)
                          ),
                          SizedBox(height: 20,),
                          Text("Who are you?",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'Lato',fontSize: 25, fontWeight: FontWeight.bold),),
                          SizedBox(height: 50,),
                          ///Customer button
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(73, 18, 73, 18),
                                child: Text('Customer'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              },
                            ),
                          ),
                          SizedBox(height: 35,),
                          ///Pharmacy button
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(73, 18, 73, 18),
                                child: Text('Pharmacy'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 23, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PharmacyLogin()));
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