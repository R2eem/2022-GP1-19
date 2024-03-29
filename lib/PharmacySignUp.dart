import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/PharmacyLogin.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';



class PharmacySignUp extends StatefulWidget {
  final lat;
  final long;
  const PharmacySignUp( this.lat, this.long);
  @override
  Signup createState() => Signup();
}

String password = '';

class Signup extends State<PharmacySignUp> {
  final controllerUsername = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPharmacyName = TextEditingController();
  final controllerCommercialRegister = TextEditingController();
  final controllerPhoneNumber = TextEditingController();
  bool _isVisible = false;
  bool _isVisibleConfirm = false;
  bool _showValidation = false;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneSpecial = false;
  bool _hasPasswordOneUpper = false;
  bool _hasPasswordOneLower = false;
  var country;
  var locality;
  var subLocality;
  var street;

  ///Password validation caller
  onPasswordChanged(String password) {
    final specialRegex = RegExp(r'(?=.*?[#?!@$%^&*-])');
    final upperRegex = RegExp(r'(?=.*[A-Z])');
    final lowerRegex = RegExp(r'(?=.*[a-z])');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8)
        _isPasswordEightCharacters = true;

      _hasPasswordOneSpecial = false;
      if (specialRegex.hasMatch(password))
        _hasPasswordOneSpecial = true;

      _hasPasswordOneUpper = false;
      if (upperRegex.hasMatch(password))
        _hasPasswordOneUpper = true;

      _hasPasswordOneLower = false;
      if (lowerRegex.hasMatch(password))
        _hasPasswordOneLower = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(
                children: [
                  //Header
                  Container(
                    height: 150,
                    child: HeaderWidget(
                        150, false, Icons.person_add_alt_1_rounded),
                  ),
                  ///App logo and page title
                  SafeArea(
                    child: Column(
                        children: [
                          IconButton(
                            padding: EdgeInsets.fromLTRB(0, 10, 370, 0),
                            iconSize: 40,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.keyboard_arrow_left),),
                          SizedBox(height: 70,),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Pharmacy Sign up', textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Lato',
                                      fontSize: 40,
                                      color: HexColor('#282b2b')),),
                                SizedBox(width: 10,),
                                Image.asset(
                                  'assets/logoheader.png', fit: BoxFit.contain,
                                  width: 50,
                                  height: 50,),
                              ]),
                          SizedBox(height: 5,),
                          Text('Create a new account', style: TextStyle(
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
                                    child: Column(
                                        children: [
                                          ///PharmacyName
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerPharmacyName,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: false,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                                MaxLengthValidator(50,
                                                    errorText: 'must be 50 character long'),
                                              ]),
                                              decoration: ThemeHelper()
                                                  .textInputDecoration(
                                                  'Pharmacy Name',
                                                  'Enter the pharmcay name'),),
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ///CommercialRegister
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerCommercialRegister,
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: false,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                                MinLengthValidator(10,
                                                    errorText: 'must be 10 digits long'),
                                                MaxLengthValidator(10,
                                                    errorText: 'must be 10 digits long'),
                                              ]),
                                              decoration: ThemeHelper()
                                                  .textInputDecoration(
                                                  'Commercial Register',
                                                  'Enter commercial register'),),
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ///email
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerEmail,
                                              keyboardType: TextInputType
                                                  .emailAddress,
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: false,
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                                EmailValidator(
                                                    errorText: 'enter a valid email address'),
                                                MaxLengthValidator(50,
                                                    errorText: 'must be 50 character long'),
                                              ]),
                                              decoration: ThemeHelper()
                                                  .textInputDecoration(
                                                  "E-mail address",
                                                  "Enter the pharmacy email"),),
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          ///Phonenumber
                                          Container(
                                            child: TextFormField(
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerPhoneNumber,
                                              keyboardType: TextInputType
                                                  .number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                FilteringTextInputFormatter
                                                    .deny(
                                                  RegExp(r'^[0-4]+'),
                                                ),
                                                FilteringTextInputFormatter
                                                    .deny(
                                                  RegExp(r'^[6-9]+'),
                                                ),
                                              ],
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                prefixText: '+966',
                                                labelText: 'Phone Number',
                                                hintText: '5xxxxxxxx',
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding: EdgeInsets
                                                    .fromLTRB(20, 10, 20, 10),
                                                ),
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                                MinLengthValidator(9,
                                                    errorText: 'must be 9 digits long'),
                                                MaxLengthValidator(9,
                                                    errorText: 'must be 9 digits long'),
                                              ]),
                                            ),
                                            decoration: ThemeHelper()
                                                .inputBoxDecorationShaddow(),
                                          ),
                                          SizedBox(height: 20.0),
                                          ///Password
                                          Container(
                                            child: TextFormField(
                                              onTap: () =>
                                              _showValidation =
                                              !_showValidation,
                                              autovalidateMode:
                                              AutovalidateMode
                                                  .onUserInteraction,
                                              controller: controllerPassword,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization
                                                  .none,
                                              autocorrect: false,
                                              obscureText: !_isVisible,
                                              onChanged: (password) =>
                                                  onPasswordChanged(password),
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: 'this field is required'),
                                              ]),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    //Visibilty of password validation list
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
                                          ///Password validation list
                                          Visibility(
                                            visible: _showValidation,
                                            child:
                                            Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: _isPasswordEightCharacters
                                                          ? Colors.green
                                                          : Colors.transparent,
                                                      border: _isPasswordEightCharacters
                                                          ? Border.all(
                                                          color: Colors
                                                              .transparent)
                                                          :
                                                      Border.all(
                                                          color: Colors.grey
                                                              .shade400),
                                                      borderRadius: BorderRadius
                                                          .circular(50)
                                                  ),
                                                  child: Center(child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 15,),),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                    "Contains at least 8 characters")
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Visibility(
                                            visible: _showValidation,
                                            child:
                                            Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: _hasPasswordOneSpecial
                                                          ? Colors.green
                                                          : Colors.transparent,
                                                      border: _hasPasswordOneSpecial
                                                          ? Border.all(
                                                          color: Colors
                                                              .transparent)
                                                          :
                                                      Border.all(
                                                          color: Colors.grey
                                                              .shade400),
                                                      borderRadius: BorderRadius
                                                          .circular(50)
                                                  ),
                                                  child: Center(child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 15,),),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                    "Contains at least 1 Special character")
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Visibility(
                                            visible: _showValidation,
                                            child:
                                            Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: _hasPasswordOneUpper
                                                          ? Colors.green
                                                          : Colors.transparent,
                                                      border: _hasPasswordOneUpper
                                                          ? Border.all(
                                                          color: Colors
                                                              .transparent)
                                                          :
                                                      Border.all(
                                                          color: Colors.grey
                                                              .shade400),
                                                      borderRadius: BorderRadius
                                                          .circular(50)
                                                  ),
                                                  child: Center(child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 15,),),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                    "Contains at least 1 uppercase character")
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5,),
                                          Visibility(
                                            visible: _showValidation,
                                            child:
                                            Row(
                                              children: [
                                                AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  width: 20,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color: _hasPasswordOneLower
                                                          ? Colors.green
                                                          : Colors.transparent,
                                                      border: _hasPasswordOneLower
                                                          ? Border.all(
                                                          color: Colors
                                                              .transparent)
                                                          :
                                                      Border.all(
                                                          color: Colors.grey
                                                              .shade400),
                                                      borderRadius: BorderRadius
                                                          .circular(50)
                                                  ),
                                                  child: Center(child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 15,),),
                                                ),
                                                SizedBox(width: 10,),
                                                Text(
                                                    "Contains at least 1 lowercase character")
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          ///confirm password
                                          Container(
                                            child: TextFormField(
                                              obscureText: !_isVisibleConfirm,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              validator: (val) {
                                                if (val!.isEmpty)
                                                  return 'this field is required';
                                                if (val !=
                                                    controllerPassword.text)
                                                  return 'password are not matching';
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isVisibleConfirm =
                                                      !_isVisibleConfirm;
                                                    });
                                                  },
                                                  icon: _isVisibleConfirm
                                                      ? Icon(Icons.visibility,
                                                    color: Colors.black,)
                                                      :
                                                  Icon(Icons.visibility_off,
                                                    color: Colors.grey,),
                                                ),
                                                labelText: 'Confirm password',
                                                hintText: 'Enter same password',
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding: EdgeInsets
                                                    .fromLTRB(20, 10, 20, 10),
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
                                            height: 20,
                                          ),
                                          ///Signup button
                                          Container(
                                            decoration: ThemeHelper()
                                                .buttonBoxDecoration(context),
                                            child: ElevatedButton(
                                              style: ThemeHelper()
                                                  .buttonStyle(),
                                              child: Padding(
                                                padding: const EdgeInsets
                                                    .fromLTRB(40, 10, 40, 10),
                                                child: Text(
                                                  "Sign up".toUpperCase(),
                                                  style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 22,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      color: Colors.white),),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  doUserRegistration();
                                                }
                                              },
                                            ),
                                          ),
                                          //Navigation to login page
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 20, 10, 20),
                                            child: Text.rich(
                                                TextSpan(
                                                    children: [
                                                      TextSpan(
                                                          text: "Already have an account? ",
                                                          style: TextStyle(
                                                              fontFamily: 'Lato',
                                                              fontSize: 17,
                                                              color: Colors
                                                                  .grey[700])),
                                                      TextSpan(
                                                        text: 'Log in',
                                                        recognizer: TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        PharmacyLogin()));
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
                                        ]),
                                  )
                                ]),
                          ),
                        ]),
                  ),
                  FutureBuilder<Placemark>(
                      future: getUserLocation(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return Center(
                              child: Container(
                                  width: 200,
                                  height: 5,
                                  child:LinearProgressIndicator()),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    "Error..."),
                              );
                            }
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text(
                                    "No Data..."),
                              );
                            } else {
                              return  ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: 1,
                                  itemBuilder: (context, index) {
                                    final address = snapshot.data!;
                                    country = address.country;
                                    locality = address.locality;
                                    subLocality = address.subLocality;
                                    street = address.street;
                                    return Container();
                                  });
                            }
                        }
                      }),
                ])));
  }

  ///Show success message function
  void showSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              'Request to create an account was successfully sent! Please verify your email before log in!',
              style: TextStyle(
                fontFamily: 'Lato', fontSize: 20,)),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok", style: TextStyle(fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PharmacyLogin()));
              },
            ),
          ],
        );
      },
    );
  }

  ///Show error message function
  void showError(String errorMessage) {
    if (errorMessage.compareTo('Account already exists for this username.') ==
        0) {
      errorMessage = 'Account already exists for this email address.';
    }
    if (errorMessage.compareTo('phoneNumber') == 0) {
      errorMessage = 'Account already exists for this phone number.';
    }
    if (errorMessage.compareTo(
        'Password must be at least 8 characters, contains one upper, one lower and one special character.') ==
        0) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(errorMessage, style: TextStyle(
            fontFamily: 'Lato', fontSize: 20,)),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok", style: TextStyle(fontFamily: 'Lato',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///User signup function
  Future<void> doUserRegistration() async {
    final email = controllerEmail.text.trim().toLowerCase();
    final password = controllerPassword.text.trim();
    final PharmacyName = controllerPharmacyName.text.trim();
    final ComRegister = controllerCommercialRegister.text.trim();
    var phonenumber = controllerPhoneNumber.text.trim();

    final user = ParseUser.createUser(email, password, email);

    ///Check unique phone number in pharmacist table
    QueryBuilder<ParseObject> queyPhonenumber = QueryBuilder<ParseObject>(
        ParseObject('Pharmacist'));
    queyPhonenumber.whereEqualTo('PhoneNumber', '0$phonenumber');
    var apiResponse = await queyPhonenumber.query();
    if (apiResponse.success) {
      if (apiResponse.count ==
          0) { //If no same phone number exist create user account
        var response = await user.signUp();
        if (response.success) {
          final createPharmacist = ParseObject('Pharmacist')
            ..set('PharmacyName', PharmacyName)
            ..set('CommercialRegister', ComRegister)
            ..set('PhoneNumber', '0$phonenumber')
            ..set('user', user)
            ..set('JoinRequest', "UnderProcessing")
            ..set('Location',ParseGeoPoint(latitude: widget.lat, longitude: widget.long))
            ..set('Address', '$street, $subLocality, $locality, $country')
            ..set('Email', email);
          await createPharmacist.save();

          showSuccess();
        } else {
          showError(response.error!.message);
        }
      }
      else
        (showError('phoneNumber'));
    }
  }

  Future<Placemark> getUserLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.lat, widget.long);
    Placemark place = placemarks[0];
    return place;
  }
}