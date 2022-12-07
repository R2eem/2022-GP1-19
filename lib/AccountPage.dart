import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'Cart.dart';
import 'Orders.dart';
import 'Settings.dart';
import 'common/theme_helper.dart';
import 'package:untitled/CategoryPage.dart';


class AccountPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _AccountPage();
  }
}

class _AccountPage extends State<AccountPage>{
  int _selectedIndex = 3;
  final controllerEditEmail = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Stack(
              children: [
                //Header
                Container(
                  height: 150,
                  child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                ),
                //Back button
                Container(
                  child: IconButton(padding: EdgeInsets.fromLTRB(0, 30, 370, 0),
                    iconSize: 40,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }, icon: Icon(Icons.keyboard_arrow_left),),
                ),
                //Controls the profile icon
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
                          child: Icon(Icons.person, size: 80, color: Colors.grey.shade300,),//control the profile icon
                        ),
                        SizedBox(height: 40,),
                        //Current user account information
                        Form(
                          key: _formKey,
                          child: Column(
                              children: <Widget>[
                                //Get user from user table
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
                                            //Get user Email from user table
                                            var userId = snapshot.data!.objectId;
                                            var email = snapshot.data!.emailAddress;
                                            //Get user from customer table
                                            return FutureBuilder<List>(
                                                future: currentuser(userId),
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
                                                              //Get user information from Customer table
                                                              final user = snapshot.data![index];
                                                              customerId = user.get<String>('objectId')!;
                                                              final Firstname = user.get<String>('Firstname')!;
                                                              final Lastname = user.get<String>('Lastname')!;
                                                              final Phonenumber = user.get<String>('Phonenumber')!;
                                                              final controllerFirstname = TextEditingController(text: Firstname);
                                                              final controllerLasttname = TextEditingController(text: Lastname);
                                                              final controllerEmail = TextEditingController(text: email);
                                                              final controllerPhoneNumber = TextEditingController(text: Phonenumber);
                                                              //Display information
                                                              return Column( children: [
                                                                //Firstname
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
                                                                //Lastname
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
                                                                //Phonenumber
                                                                Container(
                                                                  child: TextFormField(
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.text,
                                                                    controller: controllerPhoneNumber,
                                                                    validator: MultiValidator([
                                                                      RequiredValidator(
                                                                          errorText: 'this field is required'),
                                                                      MinLengthValidator(10,
                                                                          errorText: 'must be 10 digits long'),
                                                                      MaxLengthValidator(10,
                                                                          errorText: 'must be 10 digits long')
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
                                                                //Email
                                                                Container(
                                                                  child: TextFormField(
                                                                    readOnly: true,
                                                                    autovalidateMode:
                                                                    AutovalidateMode.onUserInteraction,
                                                                    keyboardType: TextInputType.emailAddress,
                                                                    controller: controllerEmail,
                                                                    decoration: ThemeHelper().textInputDecoration('',"Email") ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                                                ),
                                                                SizedBox(height: 35.0),

                                                                //Save changes button
                                                                Container(
                                                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                  child: ElevatedButton(
                                                                    style: ThemeHelper().buttonStyle(),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                      child: Text('Save changes'.toUpperCase(), style: TextStyle(fontFamily: 'Lato',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                    ),
                                                                    //Show confirmation dialog
                                                                    onPressed: (){
                                                                      if (_formKey.currentState!.validate()) {
                                                                        // set up the buttons
                                                                        Widget continueButton = TextButton(
                                                                          child: Text("Update", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                          onPressed:  () {
                                                                            //Call updateInfo function when user confirms the update
                                                                            //Send userId from User table, customerId, Firstname, Lastname, and Phonenumber from Customer table
                                                                            updateInfo(userId,customerId,controllerFirstname.text, controllerLasttname.text, controllerPhoneNumber.text);
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        );
                                                                        Widget cancelButton = TextButton(
                                                                          child: Text("Cancel", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                                                                          onPressed:  () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        );
                                                                        AlertDialog alert = AlertDialog(
                                                                          title:  Text("Are you sure you want to update your account information?", style: TextStyle(fontFamily: 'Lato', fontSize: 20,),),
                                                                          content: Text(""),
                                                                          actions: [
                                                                            continueButton,
                                                                            cancelButton,
                                                                          ],
                                                                        );
                                                                        showDialog(
                                                                          context: context,
                                                                          builder: (BuildContext context) {
                                                                            return alert;
                                                                          },
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                              ] );
                                                            });
                                                      }}
                                                });
                                          }
                                      }
                                    })
                              ]),
                        ),
                      ]),
                ),
              ]),
        ),
        //Bottom navigation bar
        bottomNavigationBar: Container(
            color: Colors.white,
            child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.all(10),
                  tabs: [
                    GButton(
                        icon: Icons.home,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_cart,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.shopping_bag,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                    GButton(
                        icon: Icons.settings,iconActiveColor:Colors.purple.shade200,iconSize: 30
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage(customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(customerId)));
                    }
                  }),
                )))
    );
  }

  //Function to update user information
  Future<void> updateInfo(userId, CustomerId, editFirstname, editLastname, editPhonenumber) async {
    var object;
    //Query the user from Customer table using CustomerId
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Customer'));
    parseQuery.whereEqualTo('objectId', CustomerId);

    //Get as a single object
    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        object = o as ParseObject;
      }
    }
    //Update the information in Customer table
    var todo = object
      ..set('Firstname', editFirstname)
      ..set('Lastname', editLastname)
      ..set('Phonenumber', editPhonenumber)
    //userId should be pointer since its a foreign key
      ..set('user', (ParseObject('_User')..objectId = userId)
          .toPointer());
    final ParseResponse parseResponse = await todo.save();

    if (parseResponse.success) {
      //If the update succeed call showSuccess function
      showSuccess();
    } else {
      //If update fails cal showError function
      showError(parseResponse.error!.message);
    }
  }

  //Function to get current logged in user
  Future<ParseUser?> getUser() async {
    var currentUser = await ParseUser.currentUser() as ParseUser?;
    return currentUser;
  }

  //Function to get current user from Customer table
  Future<List> currentuser(userId) async {
    QueryBuilder<ParseObject> queryCustomers =
    QueryBuilder<ParseObject>(ParseObject('Customer'));
    queryCustomers.whereContains('user', userId);
    final ParseResponse apiResponse = await queryCustomers.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
  //Function called when update is successful
  //Show message for 3 seconds then navigate to setting page
  void showSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          bool manuallyClosed = false;
          Future.delayed(Duration(seconds: 3)).then((_) {
            if (!manuallyClosed) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage(customerId)));
            }
          });
          return AlertDialog(
              content: Text('Changes saved!', style: TextStyle(fontFamily: 'Lato', fontSize: 20,)));

        });
  }

  //Function called when update is not successful
  //Show Alertdialog and wait for user interaction
  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text("Update failed!", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
          content: Text("Account already exists for this phone number.", style: TextStyle(fontFamily: 'Lato', fontSize: 20)),
          actions: <Widget>[
            new TextButton(
              child: const Text("Ok",style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}