import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/main.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'ForgotPassword.dart';
import 'common/theme_helper.dart';
import 'package:untitled/PharmacyLocation.dart';
import 'package:untitled/PharHomePage.dart';


class PharmacyLogin extends StatefulWidget {
  const PharmacyLogin({Key? key}): super(key:key);
  @override
  Login createState() => Login();
}

class Login extends State<PharmacyLogin> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 250;
  bool _isVisible = false;
  bool isLoggedIn = false;
  var PharmacistId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(
                children: [ //Header
                  Container(
                    height: _headerHeight,
                    child: HeaderWidget(_headerHeight, false, Icons
                        .login_rounded), //let's create a common header widget
                  ),
                  ///App logo and title
                  SafeArea(
                      child: Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.fromLTRB(0, 10, 370, 0),
                              iconSize: 40,
                              color: Colors.white,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => HomePage()),);
                              },
                              icon: Icon(Icons.keyboard_arrow_left),),
                            SizedBox(height: 200,),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Pharmacy Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontFamily: 'Lato',
                                        fontSize: 43,
                                        color: HexColor('#282b2b')),),
                                  SizedBox(width: 10,),
                                  Image.asset('assets/logoheader.png',
                                    fit: BoxFit.contain,
                                    width: 50,
                                    height: 50,),
                                ]),
                            SizedBox(height: 5,),
                            Text('Log in to your account', style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 18,
                              color: Colors.grey[700],),),
                            SizedBox(height: 25.0),
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              alignment: Alignment.center,
                              child: Column(
                                  children: [
                                    //Form
                                    Form(
                                      key: _formKey,
                                      //child: SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          ///email
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerEmail,
                                              enabled: !isLoggedIn,
                                              keyboardType: TextInputType
                                                  .emailAddress,
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: false,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                              ]),
                                              decoration: ThemeHelper()
                                                  .textInputDecoration('Email',
                                                  'Enter your email address'),),
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          ///password
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerPassword,
                                              enabled: !isLoggedIn,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: !_isVisible,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this is required'),
                                              ]),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isVisible = !_isVisible;
                                                    });
                                                  },
                                                  icon: _isVisible ? Icon(
                                                    Icons.visibility,
                                                    color: Colors.black,) :
                                                  Icon(Icons.visibility_off,
                                                    color: Colors.grey,),
                                                ),
                                                labelText: 'Password',
                                                hintText: 'Enter your password',
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding: EdgeInsets
                                                    .fromLTRB(20, 10, 20, 10),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(100.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(100.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.grey
                                                            .shade400)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(100.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2.0)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius
                                                        .circular(100.0),
                                                    borderSide: BorderSide(
                                                        color: Colors.red,
                                                        width: 2.0)),
                                              ),),
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 5),
                                                  )
                                                ]),),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          ///Navigation to forgot password page
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 10, 20),
                                            alignment: Alignment.topRight,
                                            child: GestureDetector(
                                              onTap: () {
                                                 Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPassword()), );
                                              },
                                              child: Text(
                                                "Forgot your password?",
                                                style: TextStyle(
                                                  fontFamily: 'Lato',
                                                  fontSize: 17,
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor,),
                                              ),
                                            ),
                                          ),

                                          ///Login button
                                          Container(
                                            decoration: ThemeHelper()
                                                .buttonBoxDecoration(context),
                                            child: ElevatedButton(
                                                style: ThemeHelper()
                                                    .buttonStyle(),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      35, 7, 35, 7),
                                                  child: Text(
                                                    'Log In'.toUpperCase(),
                                                    style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 22,
                                                        fontWeight: FontWeight
                                                            .bold,
                                                        color: Colors.white),),
                                                ),
                                                onPressed: () {
                                                  //Check validation
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    //Validation successful call function
                                                    CheckJoinRequest2();
                                                  };
                                                }
                                            ),
                                          ),
                                          //Navigation to signup page
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 20, 10, 20),
                                            child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: "Don\'t have an account? ",
                                                          style: TextStyle(
                                                              fontFamily: 'Lato',
                                                              fontSize: 17,
                                                              color: Colors
                                                                  .grey[700])),
                                                      TextSpan(
                                                        text: 'Sign up',
                                                        recognizer: TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        PharmacyLocation()));
                                                          },
                                                        style: TextStyle(
                                                            fontFamily: 'Lato',
                                                            fontSize: 17,
                                                            color: Theme
                                                                .of(context)
                                                                .accentColor),
                                                      ),
                                                    ]
                                                )
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ]),
                            )
                          ])
                  )
                ])
        ));
  }

  ///Show error message function
  void showError(String errorMessage) {
    if (errorMessage.compareTo('Invalid username/password.') == 0) {
      errorMessage = 'Invalid email or password. Please try again.';
    }
    if (errorMessage.compareTo('User email is not verified.') == 0) {
      errorMessage = 'Please verify your email before Login.';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            errorMessage, style: TextStyle(fontFamily: 'Lato', fontSize: 20,),),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok", style: TextStyle(fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),),
              onPressed: () {
                if(errorMessage.compareTo('Invalid email or password. Please try again.')!=0 && errorMessage.compareTo('Please verify your email before Login.')!=0){
                  doUserLogout();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///User log in function
  void CheckJoinRequest2() async {
    var object;
    var pharmacy;
    var id;
    var type;
    bool block = false;
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    QueryBuilder<ParseObject> queryPharmacy1 =
    QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryPharmacy1.whereEqualTo('email', email);
    final ParseResponse apiResponse1 = await queryPharmacy1.query();

    ///If user exist search for type otherwise invalid inputs
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        object = o as ParseObject;
        id = object.get('objectId');
      }
    }

    ///If account not signed up in Tiryaq
    else {
      showError('Invalid username/password.');
    }

    //If user exist in Pharmacy table then log in successfully
    if (id != null) {
      QueryBuilder<ParseObject> queryPharmacy2 =
      QueryBuilder<ParseObject>(ParseObject('Pharmacist'));
      queryPharmacy2.whereEqualTo('user', (ParseUser.forQuery()
        ..objectId = id).toPointer());
      final ParseResponse apiResponse2 = await queryPharmacy2.query();

      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results!) {
          type = 'Pharmacy';
          block = o.get('Block');
          pharmacy = o;
        }
      }
      if (type == 'Pharmacy') {
        final user = ParseUser(email, password, null);

        var response = await user.login();

        ///If credentials correct and not blocked enter account
        if (response.success && !block) {
          setState(() {
            isLoggedIn = true;
          });
          if ("accepted" == pharmacy.get('JoinRequest')) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PharHomePage()));
          }
          if ("UnderProcessing" == pharmacy.get('JoinRequest')) {
            showError("Your join request is under processing");
          }
          if ("declined" == pharmacy.get('JoinRequest')) {
            showError("Sorry, Your join request is declined");
          }

          ///If credentials correct and blocked don't enter account
        } else if (response.success && block) {
          showError('Account blocked, contact Tiryaq admin.');
        }

        ///If credentials not correct and blocked don't enter account
        else {
          showError(response.error!.message);
        }
      }
      ///Account not pharmacy
      else {
        showError('Invalid username/password.');
      }
    }
  }

  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PharmacyLogin()));
      });
    } else {
      showError(response.error!.message);
    }
  }
}



