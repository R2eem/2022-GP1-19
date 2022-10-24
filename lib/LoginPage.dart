import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/SignupPage.dart';
import 'package:untitled/ForgotPassword.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/main.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}): super(key:key);
  @override
  Login createState() => Login();
}

class Login extends State<LoginPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 250;
  bool _isVisible = false;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
            height: _headerHeight,
            child: HeaderWidget(_headerHeight, false, Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Column(
                  children: [
              IconButton(padding: EdgeInsets.fromLTRB(0, 10, 370, 0),
              iconSize: 40,
              color: Colors.white,
              onPressed: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => HomePage()), );
              }, icon: Icon(Icons.keyboard_arrow_left),),
            SizedBox(height: 200,),
            Text('Log in', style: TextStyle(fontFamily: 'Mulish',fontSize: 50, fontWeight: FontWeight.bold, color: HexColor('#282b2b')),),
            Text('Log in to your account', style: TextStyle(fontFamily: 'Mulish',color: Colors.black45, fontWeight: FontWeight.bold),),
            SizedBox(height: 25.0),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              child: Column(
                  children: [
          Form(
            key: _formKey,
            //child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                //email
                  Container(
                  child:TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controllerEmail,
                          enabled: !isLoggedIn,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          autocorrect: false,
                          obscureText: false,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'this field is required'),
                          ]),
                          decoration: ThemeHelper().textInputDecoration('Email', 'Enter your email address'),),
                       decoration: ThemeHelper().inputBoxDecorationShaddow(),),
                        SizedBox(
                          height: 30,
                        ),
                        //password
                    Container(
                      child:TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: controllerPassword,
                          enabled: !isLoggedIn,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
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
                            icon: _isVisible ? Icon(Icons.visibility, color: Colors.black,) :
                            Icon(Icons.visibility_off, color: Colors.grey,),
                          ),
                          labelText: 'Password',
                          hintText: 'Enter you password',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                        ),),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 5),
                        )
                      ]),),
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
                  )])
            )])
        ));
  }


  void showError(String errorMessage) {
    if(errorMessage.compareTo('Invalid username/password.')==0){
      errorMessage = 'Invalid email or password. Please try again.';
    }
    if(errorMessage.compareTo('User email is not verified.')==0){
      errorMessage = 'Please verify your email before Login.';
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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

  void doUserLogin() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(email, password, null);

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