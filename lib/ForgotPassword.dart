import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/LoginPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_hepler.dart';


class ForgotPassword extends StatefulWidget {
  @override
  Forgot createState() => Forgot();
}

class Forgot extends State<ForgotPassword> {
  final controllerEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _headerHeight = 300;

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
              child: HeaderWidget(_headerHeight, true,Icons.password_rounded),
            ),
            SafeArea(
              child: Column(
                  children: [
              IconButton(padding: EdgeInsets.fromLTRB(0, 10, 370, 0),
              iconSize: 40,
              color: Colors.white,
              onPressed: () {
                Navigator.push( context, MaterialPageRoute( builder: (context) => LoginPage()), );
              }, icon: Icon(Icons.keyboard_arrow_left),),
            SizedBox(height: 230,),
            Text('Forgot Password?', style: TextStyle(fontFamily: 'Mulish',fontSize: 35, fontWeight: FontWeight.bold, color: HexColor('#282b2b')),),
            SizedBox(height: 10,),
            Text('Enter the email address associated with your account.', style: TextStyle(fontFamily: 'Mulish',color: Colors.black45, fontWeight: FontWeight.bold),),
            SizedBox(height: 25.0),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              alignment: Alignment.center,
              child: Column(
                  children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
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
                      Container(
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Send".toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              doUserResetPassword();
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 15.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: "Remember your password? ",
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45)),
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
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.bold),
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

  void doUserResetPassword() async {
    final ParseUser user = ParseUser(null, null, controllerEmail.text.trim());
    final ParseResponse parseResponse = await user.requestPasswordReset();
    if (parseResponse.success) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thank you!"),
            content: Text(
                'You will recieve a password reset link if you have Tiryaq account'),
            actions: <Widget>[
              new TextButton(
                child: const Text("OK"),
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
        };
  }
}

Widget makeInput({label, obscureText = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      SizedBox(
        height: 5,
      ),
      TextField(
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
      SizedBox(
        height: 30,
      ),
    ],
  );
}
