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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text("Profile Page",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          flexibleSpace:Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, //control the colores space in the app bar the purprle color
                    end: Alignment.bottomRight,//control the colores space in the app bar the pink color
                    colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
                )
            ),
          ),
        ),


        body:SingleChildScrollView(
          child: Stack(
              children: [
                Container(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),), //control the space under the app bar to be the same as the app bar

                ///// controls the profile icon
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(25, 5, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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

                        SizedBox(height: 10,),

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

                                                                    decoration: ThemeHelper().textInputDecoration('',"First Name") ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),

                                                                ),
                                                                SizedBox(height: 15.0),

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
                                                                    decoration: ThemeHelper().textInputDecoration('',"Last Name") ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),

                                                                ),

                                                                SizedBox(height: 15.0),

                                                                Container(
                                                                  child: TextFormField(
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

                                                                SizedBox(height: 15.0),

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
                                                                    decoration: ThemeHelper().textInputDecoration('',"Phone Number") ,
                                                                  ),
                                                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),

                                                                ),

                                                                SizedBox(height: 15.0),

                                                                Container(
                                                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                  child: ElevatedButton(
                                                                    style: ThemeHelper().buttonStyle(),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                                                      child: Text('Save changes'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                    ),
                                                                    onPressed: (){
                                                                      if (_formKey.currentState!.validate()) {
                                                                        updateInfo(id,Email,controllerFirstname.text, controllerLasttname.text, controllerEmail.text, controllerPhoneNumber.text);
                                                                      }
                                                                    },
                                                                  ),
                                                                ),

                                                                SizedBox(height: 10.0),

                                                                Container(
                                                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                                                  child: ElevatedButton(
                                                                    style: ThemeHelper().buttonStyle(),
                                                                    child: Padding(
                                                                      padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
                                                                      child: Text('Log out'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                                                    ),
                                                                    onPressed: (){

                                                                      doUserLogout();
                                                                    },
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
    print(id);
    var todo = ParseUser(email,null,email)..objectId = id
      ..set('Firstname', editFirstname)
      ..set('Lastname', editLastname)
      ..set('email', editEmail)
      ..set('Username', editEmail)
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

