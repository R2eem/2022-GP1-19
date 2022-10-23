import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'LoginPage.dart';
import 'common/theme_helper.dart';



class UpdateEmail extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _UpdateEmail();
}


class _UpdateEmail extends State<UpdateEmail> {
  bool submitValid = false;
  final _emailcontroller = TextEditingController();
  final _otpcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late EmailAuth emailAuth;
  double _headerHeight = 300;

  void initState() {
    super.initState();
    // Initialize the package
    emailAuth = new EmailAuth(
      sessionName: "Sample session",
    );
  }
  void verify() {
    print(emailAuth.validateOtp(
        recipientMail: _emailcontroller.value.text,
        userOtp: _otpcontroller.value.text));
  }
  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: _emailcontroller.value.text, otpLength: 5);
    if (result) {
      setState(() {
        submitValid = true;
      });
    }
  }
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
                        Text('Update email', style: TextStyle(fontFamily: 'Mulish',fontSize: 35, fontWeight: FontWeight.bold, color: HexColor('#282b2b')),),
                        SizedBox(height: 10,),
                        Text('Enter you new email address.', style: TextStyle(fontFamily: 'Mulish',color: Colors.black45, fontWeight: FontWeight.bold),),
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
                                          controller: _emailcontroller,
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
                                        child: TextFormField(
                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                          controller: _otpcontroller,
                                          keyboardType: TextInputType.text,
                                          textCapitalization: TextCapitalization.none,
                                          autocorrect: false,
                                          obscureText: false,
                                          validator: MultiValidator([
                                            RequiredValidator(
                                                errorText: 'this field is required'),
                                          ]),
                                          decoration: ThemeHelper()
                                              .textInputDecoration("OTP", "Enter you otp"),
                                        ),
                                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                      ),
                                      Container(
                                        decoration: ThemeHelper().buttonBoxDecoration(context),
                                        child: ElevatedButton(
                                          style: ThemeHelper().buttonStyle(),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                            child: Text(
                                              "Verify OTP".toUpperCase(),
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
                                            }
                                          },
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
}