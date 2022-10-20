import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/SignupPage.dart';
import 'package:untitled/ForgotPassword.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';

import 'common/theme_hepler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}): super(key:key);
  @override
  Login createState() => Login();
}

String password = '';

class Login extends State<LoginPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 250;

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, false, Icons.login_rounded), //let's create a common header widget
            ),
              SafeArea(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),// This will be the login form
                       child: Column(
                       children: [
                         Text('Login', style: TextStyle(fontFamily: 'Mulish',fontSize: 50, fontWeight: FontWeight.bold, color: HexColor('#282b2b')),),
                         Text('Log in to your account', style: TextStyle(fontFamily: 'Mulish',color: Colors.black45, fontWeight: FontWeight.bold),),
                         SizedBox(height: 25.0),
          Form(
            key: _formKey,
            //child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                //username
                  Container(
                  child:FadeAnimation(
                          1.3,TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controllerUsername,
                          enabled: !isLoggedIn,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          obscureText: false,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'this field is required'),
                          ]),
                          decoration: ThemeHelper().textInputDecoration('Username', 'Enter your user name'),)
                         ),
                       decoration: ThemeHelper().inputBoxDecorationShaddow(),),
                        SizedBox(
                          height: 30,
                        ),
                        //password
                    Container(
                      child: FadeAnimation(
                          1.4,TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controllerPassword,
                          enabled: !isLoggedIn,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          obscureText: true,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'password is required'),
                          ]),
                        decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),),
                        ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10,0,10,20),
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPassword()), );
                      },
                      child: Text( "Forgot your password?", style: TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.bold,color: Theme.of(context).accentColor, ),
                      ),
                    ),
                  ),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text('Log In'.toUpperCase(), style: TextStyle(fontFamily: 'Mulish',fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            doUserLogin();
                          };
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(10,20,10,20),
                      //child: Text('Don\'t have an account? Create'),
                      child: Text.rich(
                          TextSpan(
                              children: [
                                TextSpan(text: "Don\'t have an account? ", style: TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.bold, color: Colors.black45)),
                                TextSpan(
                                  text: 'Sign up',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                                    },
                                  style: TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                ),
                              ]
                          )
                        ),
                    )
                ],
              ),
          ),
                       ]),
                  ))
            ])
        ));
  }


  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Invalid!"),
          content: Text('wrong username or password'),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void doUserLogin() async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (response.success) {
      setState(() {
        isLoggedIn = true;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
    } else {
      showError(response.error!.message);
    }
  }
}