import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final keyApplicationId = 'dztgYRZyOeHtmWYAD93X2QJSuMSbGuelhHVpsQ3p';
  final keyClientKey = 'H4yYM9tUlHZQ59JbYcNL33rfxSrkNf1Ll0g5Dqf1';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PrescriptionCategory(),
  ));
}

class PrescriptionCategory extends StatefulWidget {
  @override
  Prescription createState() => Prescription();
}

class Prescription extends State<PrescriptionCategory> {
  final todoController = TextEditingController();


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
    padding: EdgeInsets.symmetric(horizontal: 10),
    height: MediaQuery.of(context).size.height,
    width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: FutureBuilder<List<ParseObject>>(
                  future: getPresMedication(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Container(
                              width: 100,
                              height: 100,
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
                              itemCount: snapshot.data!.length,
                              itemExtent: 100,
                              itemBuilder: (context, index) {
                                //Get Parse Object Values
                                final medGet = snapshot.data![index];
                                final TradeName = medGet.get<String>('TradeName')!;
                                final ScientificName = medGet.get<String>('ScientificName')!;
                                final Publicprice = medGet.get<double>('Publicprice')!;
                                final UsageMethod = medGet.get<String>('UsageMethod')!;
                                //final Size = medGet.get<int>('Size')!;
                                //final SizeUnit = medGet.get<String>('SizeUnit')!;
                                //final Strength = medGet.get<double>('Strength')!;
                                //final StrengthUnit = medGet.get<String>('StrengthUnit')!;
                                //final PackageSize = medGet.get<int>('PackageSize')!;
                                //final PackageType = medGet.get<String>('PackageType')!;
                                final MarketingCompany = medGet.get<String>('MarketingCompany')!;
                                final PharmaceuticalForm = medGet.get<String>('PharmaceuticalForm')!;
                                return Card(
                                child: ListTile(
                                  leading: CircleAvatar(child: Icon(Icons.medication, color: Colors.pink,
                                    size: 36.0,), backgroundColor: Colors.grey.shade100, radius: 25,),
                                  title: Text(TradeName,style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16
                                  ),),
                                  subtitle: Text('$ScientificName , $Publicprice SR',style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey
                                  ),),
                                  trailing: Icon(Icons.add_shopping_cart, color: Colors.black,
                                    size: 25,),
                                  tileColor: Colors.pink[50],
                                  onTap: (){
                                    print(TradeName);
                                  },
                                ));
                              });
                        }
                    }
                  }))
        ],
      ),
    ),
    ),
    );
  }

  Future<List<ParseObject>> getPresMedication() async {
    QueryBuilder<ParseObject> queryPresMedication =
    QueryBuilder<ParseObject>(ParseObject('Medication'));
    queryPresMedication.whereContains('LegalStatus', 'Prescription');
    final ParseResponse apiResponse = await queryPresMedication.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }
}


