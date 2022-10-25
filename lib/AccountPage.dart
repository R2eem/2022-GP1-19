import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'common/theme_helper.dart';
import 'package:untitled/CategoryPage.dart';
import 'main.dart';


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
        home: AccountPage(),
      )
  );
}

class AccountPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AccountPage();
  }
}

class _AccountPage extends State<AccountPage>{
  int _selectedIndex = 3;
  bool _update = false;
  final controllerEditEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Stack(
              children: [
                Container(
                  height: 150,
                  child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                ),
                ///// controls the profile icon
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 60, 10, 0),
                  child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(5), // control the size of the profile circle
                          decoration: BoxDecoration( // control the size of the profile circle
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(width: 1, color: Colors.white),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),), // control the shadow behind the profile circle
                            ],
                          ),
                          child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),////control the profile icon
                        ),

                        SizedBox(height: 40,),

                        Form(
                          key: _formKey,
                          //child: SingleChildScrollView(
                          child: Column(
                              children: <Widget>[
                                //username
                                FutureBuilder<ParseUser?>(
                                    future: getUser(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return Center(
                                            child: Container(
                                                width: 50,
                                                height: 50,
                                                child: CircularProgressIndicator()),
                                          );
                                        default:
                                          if (snapshot.hasError) {
                                            return Center(
                                              child: Text("Error..."),
                                            );
                                          }
                                          if (!snapshot.hasData) {
                                            return Center(
                                              child: Text("No Data..."),
                                            );
                                          } else {
                                            return FutureBuilder<List>(
                                                future: currentuser(snapshot.data!.objectId),
                                                builder: (context, snapshot) {
                                                  switch (snapshot.connectionState) {
                                                    case ConnectionState.none:
                                                    case ConnectionState.waiting:
                                                      return Center(
                                                        child: Container(
                                                            margin: EdgeInsets.only(top: 100),

                                                            width: 50,
                                                            height: 50,
                                                            child: CircularProgressIndicator()),
                                                      );
                                                    default:
                                                      if (snapshot.hasError) {
                                                        return Center(
                                                          child: Text("Error..."),
                                                        );
                                                      }
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: Text("No Data..."),
                                                        );
                                                      } else {
                                                        return ListView.builder(
                                                            padding: EdgeInsets.only(top: 10.0),
                                                            scrollDirection: Axis.vertical,
                                                            shrinkWrap: true,
                                                            itemCount: snapshot.data!.length,
                                                            itemBuilder: (context, index) {
                                                              //Get Parse Object Values
                                                              final user = snapshot.data![index];
                                                              final id = user.get<String>('objectId')!;
                                                              final Firstname = user.get<String>('Firstname')!;
                                                              final Lastname = user.get<String>('Lastname')!;
                                                              final Email = user.get<String>('email')!;
                                                              final Phonenumber = user.get<String>('Phonenumber')!;
                                                              final controllerFirstname = TextEditingController(text: Firstname);
                                                              final controllerLasttname = TextEditingController(text: Lastname);
                                                              final controllerEmail = TextEditingController(text: Email);
                                                              final controllerPhoneNumber = TextEditingController(text: Phonenumber);
                                                              return Column( children: [
                                                                Container(
                                                                  child: TextFormField(
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.text,
                                                                    controller: controllerFirstname,
                                                                    validator: MultiValidator([
                                                                      RequiredValidator(
                                                                          errorText: 'this field is required'),
                                                                    ]),

                                                                    decoration: InputDecoration(
                                                                      labelText: '',
                                                                      hintText: 'Firstname',
                                                                      fillColor: Colors.white,
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                                   suffixIcon: Icon(Icons.edit) ) ,
                                                                  ),
                                                                  decoration: BoxDecoration(boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors.black.withOpacity(0.1),
                                                                      blurRadius: 20,
                                                                      offset: const Offset(0, 5),
                                                                    )
                                                                  ]),

                                                                ),
                                                                SizedBox(height: 25.0),

                                                                Container(
                                                                  child: TextFormField(
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.text,
                                                                    controller: controllerLasttname,
                                                                    validator: MultiValidator([
                                                                      RequiredValidator(
                                                                          errorText: 'this field is required'),
                                                                    ]),
                                                                    decoration: InputDecoration(
                                                                      labelText: '',
                                                                      hintText: 'Lastname',
                                                                      fillColor: Colors.white,
                                                                      filled: true,
                                                                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                              suffixIcon: Icon(Icons.edit) ) ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),

                                                                ),

                                                                SizedBox(height: 25.0),

                                                                Container(
                                                                  child: TextFormField(
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.text,
                                                                    controller: controllerPhoneNumber,
                                                                    validator: MultiValidator([
                                                                      RequiredValidator(
                                                                          errorText: 'this field is required'),
                                                                      MinLengthValidator(12,
                                                                          errorText: 'must be 12 digits long'),
                                                                      MaxLengthValidator(12,
                                                                          errorText: 'must be 12 digits long')
                                                                    ]),
                                                                    decoration: InputDecoration(
                                                              labelText: '',
                                                              hintText: 'Phonenumber',
                                                              fillColor: Colors.white,
                                                              filled: true,
                                                              contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                                                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                                                              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                              focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                                                              suffixIcon: Icon(Icons.edit) ) ,
                                                              ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),

                                                                ),
                                                                SizedBox(height: 25.0),

                                                                Container(
                                                                  child: TextFormField(
                                                                    readOnly: true,
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    controller: controllerEmail,
                                                                    validator: MultiValidator([
                                                                      RequiredValidator(
                                                                          errorText: 'this field is required'),
                                                                      EmailValidator(
                                                                          errorText: 'enter a valid email address')
                                                                    ]),
                                                                    decoration: ThemeHelper().textInputDecoration('',"Email") ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                                                ),
                                                                SizedBox(height: 35.0),

                                                                Container(
                                                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                  child: ElevatedButton(
                                                                    style: ThemeHelper().buttonStyle(),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                      child: Text('Save changes'.toUpperCase(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                    ),
                                                                    onPressed: (){
                                                                      if (_formKey.currentState!.validate()) {
                                                                          // set up the buttons
                                                                          Widget cancelButton = TextButton(
                                                                            child: Text("Cancel"),
                                                                            onPressed:  () {
                                                                              _update = false;
                                                                              Navigator.of(context).pop();

                                                                            },
                                                                          );
                                                                          Widget continueButton = TextButton(
                                                                            child: Text("Update"),
                                                                            onPressed:  () {
                                                                              _update = true;
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                          );
                                                                          // set up the AlertDialog
                                                                          AlertDialog alert = AlertDialog(
                                                                            title: Text(""),
                                                                            content: Text("Are you sure you want to update your account information?"),
                                                                            actions: [
                                                                              cancelButton,
                                                                              continueButton,
                                                                            ],
                                                                          );
                                                                          // show the dialog
                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (BuildContext context) {
                                                                              return alert;
                                                                            },
                                                                          );
                                                                          if(_update)
                                                                          updateInfo(id,Email,controllerFirstname.text, controllerLasttname.text, controllerEmail.text, controllerPhoneNumber.text);
                                                                      }
                                                                    },
                                                                  ),
                                                                ),

                                                                SizedBox(height: 20.0),

                                                                Container(
                                                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                  child: ElevatedButton.icon(
                                                                    style: ThemeHelper().buttonStyle(),

                                                                    onPressed: (){
                                                                      Widget cancelButton = TextButton(
                                                                        child: Text("No"),
                                                                        onPressed:  () {
                                                                          Navigator.of(context).pop();
                                                                        },
                                                                      );
                                                                      Widget continueButton = TextButton(
                                                                        child: Text("Yes"),
                                                                        onPressed:  () {
                                                                          doUserLogout();
                                                                        },
                                                                      );
                                                                      // set up the AlertDialog
                                                                      AlertDialog alert = AlertDialog(
                                                                        title: Text("Are you sure you want to log out from your account?"),
                                                                        content: Text(""),
                                                                        actions: [
                                                                          cancelButton,
                                                                          continueButton,
                                                                        ],
                                                                      );
                                                                      // show the dialog
                                                                      showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) {
                                                                          return alert;
                                                                        },
                                                                      );
                                                                    }, icon: Icon(Icons.logout_outlined ,color: Colors.white,), label: Text('LOGOUT' ,style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                  ),
                                                                ),

                                                              ] );

                                                            });}}});
                                          }}})] ),
                        ),
                      ]),
                ),
              ]),
        ),

        bottomNavigationBar: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: GNav(
                gap: 8,
                padding: const EdgeInsets.all(10),
                tabs: [
                  GButton(icon: Icons.home,),
                  GButton(icon: Icons.shopping_cart,),
                  GButton(icon: Icons.shopping_bag,),
                  GButton(icon: Icons.account_circle,)
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) => setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  } else if (_selectedIndex == 1) {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  } else if (_selectedIndex == 2) {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                  }
                })),
          ),
        )
    );
  }


  Future<void> updateInfo(id, email, editFirstname, editLastname, editEmail, editPhonenumber) async {
    var todo = ParseUser(null,null,null)..objectId = id
      ..set('Firstname', editFirstname)
      ..set('Lastname', editLastname)
      ..set('Phonenumber', editPhonenumber);
    final ParseResponse parseResponse = await todo.save();

    if (parseResponse.success) {
      print('Object updated: $id');
    } else {
      print('Object updated with failed: ${parseResponse.error.toString()}');
    }
  }


  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }
  Future<List> currentuser(objectid) async {
    QueryBuilder<ParseUser> queryUsers =
    QueryBuilder<ParseUser>(ParseUser.forQuery());
    queryUsers.whereContains('objectId', objectid);
    final ParseResponse apiResponse = await queryUsers.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }




  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
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


  void doUserLogout() async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout();
    if (response.success) {
      setState(() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      showError(response.error!.message);
    }
  }
}

