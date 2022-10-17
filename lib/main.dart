import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:untitled/PrescriptionCategory.dart';
import 'package:untitled/animation/FadeAnimation.dart';
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
          elevation: 15,
          backgroundColor: Colors.pink[100],
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  width: 3,
                  style: BorderStyle.none
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(2000),bottomRight:Radius.circular(1000))
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(200),
              child: Column(
                mainAxisAlignment:MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                      ),

                      Text("Welcome",style: TextStyle(color: Colors.black54,fontSize: 35,fontWeight: FontWeight.w800,),),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor:  Colors.white,
                      )
                    ],
                  ),
                  SizedBox(height: 110,)
                ],
              )
          ),
        ),
        body: SingleChildScrollView(
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  FadeAnimation(1, Container(
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png')
                        )
                    ),
                  )),
                  FadeAnimation(1.1, Text("Who are you?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),)),
              SizedBox(height: 30,),
              FadeAnimation(1.2, Container(
                    padding: EdgeInsets.only(top: 0, left: 0),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFF06292),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(4,4),
                          ),
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: Offset(-4,-4),
                          )
                        ],
                        borderRadius: BorderRadius.circular(50),
                        border: Border(

                        )
                    ),
                    child: MaterialButton(
                      minWidth: 370,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      },
                      color: Colors.pink[100],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Customer", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18
                      ),),
                    ),
                  )),
                  SizedBox(height: 20,),
                  FadeAnimation(1.3, Container(
                    padding: EdgeInsets.only(top: 0, left: 0),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFF06292),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(4,4),
                        ),
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(-4,-4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(50),
                      border: Border(

                      )
                    ),
                    child: MaterialButton(
                      minWidth: 370,
                      height: 60,
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PrescriptionCategory()));
                      },
                      color: Colors.pink[100],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Text("Pharmacy", style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18
                      ),),
                    ),
                  ))
                ],
              )
          ),
        ),
      ),
    );
  }
}
