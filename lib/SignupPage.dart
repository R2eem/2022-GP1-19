import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/LoginPage.dart';
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
    home: SignupPage(),
  ));
}

class SignupPage extends StatefulWidget {
  @override
  Signup createState() => Signup();
}

String password = '';

class Signup extends State<SignupPage> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerFirstname = TextEditingController();
  final controllerLasttname = TextEditingController();
  final controllerPhoneNumber = TextEditingController();


  final _formKey = GlobalKey<FormState>();

  double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(
                children: [
                  Container(
                    height: 150,
                    child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                  ),
                  SafeArea(
                    child: Column(
                  children: [
                           Text('Sign up', style: TextStyle(fontFamily: 'Mulish',fontSize: 50, fontWeight: FontWeight.bold, color: HexColor('#282b2b')),),
                           Text('Log in to your account', style: TextStyle(fontFamily: 'Mulish',color: Colors.black45, fontWeight: FontWeight.bold),),
                           SizedBox(height: 25.0),
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                              children: [
                                //username
                                Container(
                                  child: FadeAnimation(1.3, TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    controller: controllerUsername,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    obscureText: false,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'this field is required'),
                                    ]),
                                    decoration: ThemeHelper().textInputDecoration('Username', 'Enter your username'),)
                                  ), decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //FisrtName
                               Container(
                              child: FadeAnimation(1.3, TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: controllerFirstname,
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                obscureText: false,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'this field is required'),
                                ]),
                                  decoration: ThemeHelper().textInputDecoration('First Name', 'Enter your first name'),)
                                ), decoration: ThemeHelper().inputBoxDecorationShaddow(),
                               ),
                              SizedBox(
                                height: 20,
                              ),
                                //LastName
                                Container(
                                  child: FadeAnimation(1.3, TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    controller: controllerLasttname,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    obscureText: false,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'this field is required'),
                                    ]),
                                    decoration: ThemeHelper().textInputDecoration('Last Name', 'Enter your last name'),)
                                  ), decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              //email
                              Container(
                                child:FadeAnimation(
                                1.4,TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: controllerEmail,
                                keyboardType: TextInputType.emailAddress,
                                textCapitalization: TextCapitalization.none,
                                autocorrect: false,
                                obscureText: false,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: 'this field is required'),
                                  EmailValidator(
                                      errorText: 'enter a valid email address')
                                ]),
                                  decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),),
                                ), decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                                Container(
                                  child: TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    controller: controllerPhoneNumber,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    obscureText: false,
                                    decoration: ThemeHelper().textInputDecoration(
                                        "Mobile Number",
                                        "Enter your mobile number"),
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'this field is required'),
                                      MinLengthValidator(10,
                                          errorText: 'must be 10 digits long'),
                                      MaxLengthValidator(10,
                                          errorText: 'must be 10 digits long')
                                    ]),
                                  ),
                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 20.0),
                                  Container(
                                 child: FadeAnimation(
                                    1.5,TextFormField(
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    controller: controllerPassword,
                                    keyboardType: TextInputType.text,
                                    textCapitalization: TextCapitalization.none,
                                    autocorrect: false,
                                    obscureText: true,
                                    onChanged: (val) => password = val,
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText: 'this field is required'),
                                      MinLengthValidator(8,
                                          errorText:
                                              'must be at least 8 digits long'),
                                      PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                          errorText:
                                              'must have at least one SPECIAL character'),
                                      PatternValidator(r'(?=.*[A-Z])',
                                          errorText:
                                              'must have at least one UPPERCASE character'),
                                      PatternValidator(r'(?=.*[a-z])',
                                          errorText:
                                              'must have at least one LOWERCASE character')
                                    ]),
                                   decoration: ThemeHelper().textInputDecoration("Password", "Enter your password"),
                                    ),
                                  ), decoration: ThemeHelper().inputBoxDecorationShaddow(),),
                                  SizedBox(
                                    height: 15,
                                  ),

                                  //confirm password
                                  Container(
                                    child: FadeAnimation(
                                    1.6,TextFormField(
                                    obscureText: true,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                  validator: (val){
                                             if(val!.isEmpty)
                                                return 'this field is required';
                                             if(val != controllerPassword.text)
                                                return 'password are not matching';
                                              return null;},
                                      decoration: ThemeHelper().textInputDecoration("Confirm Password", "Enter same password"),
                                    )
                                ),decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                              SizedBox(
                                height: 30,
                              ),
                    Container(
                      decoration: ThemeHelper().buttonBoxDecoration(context),
                      child: ElevatedButton(
                        style: ThemeHelper().buttonStyle(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            "Sign up".toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            doUserRegistration();
                          }
                        },
                      ),
                    ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10,20,10,20),
                                  //child: Text('Don\'t have an account? Create'),
                                  child: Text.rich(
                                      TextSpan(
                                          children: [
                                            TextSpan(text: "Already have an account? ", style: TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.bold, color: Colors.black45)),
                                            TextSpan(
                                              text: 'Log in',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                                },
                                              style: TextStyle(fontFamily: 'Mulish',fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                            ),
                                          ]
                                      )
                                  ),
                                )
                  ]),
                        )]),
                  ),
                        ]),
        )])));
  }

  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success!",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          content: const Text("User was successfully created!"),
          actions: <Widget>[
            new TextButton(
              child: const Text("OK"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                }
            ),
          ],
        );
      },
    );
  }

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!",
              style:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          content: Text(errorMessage),
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

  void doUserRegistration() async {
    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();
    final firstname = controllerFirstname.text.trim();
    final lastname = controllerLasttname.text.trim();
    num phonenumber =num.parse(controllerPhoneNumber.text);
    final user = ParseUser.createUser(username, password, email)
      ..set('Firstname', firstname)
      ..set('Lastname', lastname)
      ..set('Email', email)
      ..set('Phonenumber', phonenumber);


    var response = await user.signUp();

    if (response.success) {
      showSuccess();
    } else {
      showError(response.error!.message);
    }
  }
}