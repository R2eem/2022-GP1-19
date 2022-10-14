import 'package:flutter/material.dart';
import 'package:untitled/animation/FadeAnimation.dart';
import 'package:untitled/LoginPage.dart';
import 'package:untitled/CategoryPage.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';

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

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height - 50,
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FadeAnimation(
                                  1,
                                  Text(
                                    "Sign up",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              FadeAnimation(
                                  1.2,
                                  Text(
                                    "Create an account, It's free",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.grey[700]),
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              //username
                              FadeAnimation(
                                1.3,Text(
                                'Username',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              )),
                              SizedBox(
                                height: 5,
                              ),
                              FadeAnimation(
                                1.3,TextFormField(
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
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              )),
                              SizedBox(
                                height: 30,
                              ),

                              //email
                              FadeAnimation(
                                1.4,Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87),
                              )),
                              SizedBox(
                                height: 5,
                              ),
                              FadeAnimation(
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
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              )),
                              SizedBox(
                                height: 30,
                              ),

                              //password
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeAnimation(
                                    1.5,Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                  )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FadeAnimation(
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
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                  )),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  //confirm password
                                  FadeAnimation(
                                    1.6,Text(
                                    'Confirm password',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87),
                                  )),
                                  FadeAnimation(
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
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                      border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey)),
                                    ),
                                  )
                                )],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              FadeAnimation(
                                  1.7,
                                  Container(
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
                                        borderRadius: BorderRadius.circular(50),),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 60,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          doUserRegistration();
                                        }
                                      },
                                      color: Colors.pink[100],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                    ),
                                  )),
                              FadeAnimation(
                                  1.7,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Already have an account?"),
                                      TextButton(
                                        child: Text(
                                          'Log in',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage()));
                                        },
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ]),
                  ),
                ))));
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

    final user = ParseUser.createUser(username, password, email)
      ..set('Email', email);

    var response = await user.signUp();

    if (response.success) {
      showSuccess();
    } else {
      showError(response.error!.message);
    }
  }
}