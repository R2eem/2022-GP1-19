import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/LoginPage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';
import 'package:device_preview/device_preview.dart';
import 'package:resize/resize.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = '0RlD4YgWV75gUlCXVcHr33pzfYN3ilb1qrFWyUy5';
  final keyClientKey = 'Vjbmxk9zpKPkJaU4D6HcGFQZkQWH5em93DvAIlJi';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  //Color _primaryColor = HexColor('#DC54FE');
  //Color _accentColor = HexColor('#8A02AE');
  //Color _primaryColor = HexColor('#ffc7fb');
  //primaryColor: HexColor('#e04ad2'),
  //Color _accentColor = HexColor('#ad5bf5');
  @override
  Widget build(BuildContext context) {
    return Resize(
        allowtextScaling: true,
        builder: () {
          // print(ResizeUtil().deviceType);
          // print(ResizeUtil().orientation);
          // print(ResizeUtil().screenHeight);
          // print(ResizeUtil().screenWidth);
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
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, false, Icons.login_rounded),
              ),
              SafeArea(
                child: Container(
                    padding: EdgeInsets.fromLTRB(2.vw, 1.vh, 2.vw, 1.vh),
                    margin: EdgeInsets.fromLTRB(2.vw, 1.vh, 2.vw, 1.vh),
                    child: Column(
                      children: [
                        Container(
                            height: MediaQuery.of(context).size.height / 4,
                            child: Image.asset('assets/tiryaglogo.png',height: 40.vh, width: 40.vw,)
                        ),
                        SizedBox(height: 2.vh,),
                        Text("Who are you?",
                  textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Lato',fontSize: 25.sp, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.vh,),
              Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(7.vw, 1.vh, 7.vw, 1.vh),
                    child: Text('Customer'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 23.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                  onPressed: (){
                    //After successful login we will redirect to profile page. Let's create profile page now
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                ),
              ),
                  SizedBox(height: 3.vh,),
                        Container(
                          decoration: ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(7.vw, 1.vh, 7.vw, 1.vh),
                              child: Text('Pharmacy'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 23.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                            onPressed: (){
                              //After successful login we will redirect to profile page. Let's create profile page now
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
