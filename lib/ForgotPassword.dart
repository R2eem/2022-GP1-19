import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/LoginPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';


class ForgotPassword extends StatefulWidget {
  @override
  Forgot createState() => Forgot();
}

class Forgot extends State<ForgotPassword> {
  final controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 250;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
              children: [
                //Header
                Container(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, false,Icons.password_rounded),
                ),
                ///App logo, back button and title
                SafeArea(
                  child: Column(
                      children: [
                        IconButton(padding: EdgeInsets.fromLTRB(0, 10, 370, 0),
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push( context, MaterialPageRoute( builder: (context) => LoginPage()), );
                          }, icon: Icon(Icons.keyboard_arrow_left),),
                        SizedBox(height: 200,),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Forgot password', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 40, color: HexColor('#282b2b')),),
                              SizedBox(width: 10,),
                              Image.asset('assets/logoheader.png', fit: BoxFit.contain, width: 50, height: 40,),
                            ]),
                        SizedBox(height: 5,),
                        Text('Enter your email address associated to your account',textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Lato',fontSize: 16, color: Colors.grey[700],),),
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
                                  child: Column(
                                    children: <Widget>[
                                      //Email field
                                      Container(
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                          decoration: ThemeHelper()
                                              .textInputDecoration("Email", "Enter your email"),
                                        ),
                                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                      ),
                                      SizedBox(height: 30.0),
                                      //Send button
                                      Container(
                                        decoration: ThemeHelper().buttonBoxDecoration(context),
                                        child: ElevatedButton(
                                          style: ThemeHelper().buttonStyle(),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                            child: Text(
                                              "Send".toUpperCase(),
                                              style: TextStyle(
                                                fontFamily: 'Lato',
                                                fontSize: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            //Check validation
                                            if (_formKey.currentState!.validate()) {
                                              //Validation successful call function
                                              doUserResetPassword();
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      //Navigation to login page
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Remember your password? ",
                                                style: TextStyle(fontFamily: 'Lato', fontSize: 17, color: Colors.grey[700])),
                                            TextSpan(
                                              text: 'Login',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => LoginPage()),
                                                  );
                                                },
                                              style: TextStyle(fontFamily: 'Lato', fontSize: 17,color: Theme.of(context).accentColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        )]),
                )]),
        ));
  }

  //Function to send reset password link
  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, controllerEmail.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thank you!", style: TextStyle(fontFamily: 'Lato', fontSize: 25,)),
            content: Text(
                'You will recieve a password reset link if you have Tiryaq account.', style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
            actions: <Widget>[
              new TextButton(
                child: const Text("Ok", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          );
        },
      );
    } else {
      return;
    }
  }
}
