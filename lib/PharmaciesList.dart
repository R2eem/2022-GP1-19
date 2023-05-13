import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_notify/native_notify.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'Orders.dart';


class PharmacyListPage extends StatefulWidget {
  //Get customer id as a parameter
  final String orderId;
  final String customerId;
  const PharmacyListPage(this.orderId,  this.customerId,);
  @override
  PharmacyList createState() => PharmacyList();
}

class PharmacyList extends State<PharmacyListPage> {
  int _selectedIndex = 2;
  bool presRequired = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Stack(children: [
              //Header
              Container(
                height: 150,
                child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
              ),
              //Controls app logo and page title
              Container(
                  child: SafeArea(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                                  Container(
                                    child: IconButton(
                                      padding: EdgeInsets
                                          .fromLTRB(0, 10, 0, 0),
                                      iconSize: 40,
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.keyboard_arrow_left),),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(65, 33, 0, 0),
                                    child: Text('Pharamcies list',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 27,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold),),
                                  ),
                                ]),
                            SizedBox(height: 55,),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: FutureBuilder<List<ParseObject>>(
                                  future: getPharmList(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.none:
                                      case ConnectionState.waiting:
                                        return Center(
                                          child: Container(
                                              width: 200,
                                              height: 5,
                                              child:
                                              LinearProgressIndicator()),
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
                                          return ListView.builder(
                                              physics: ClampingScrollPhysics(),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                final pharmDetails = snapshot
                                                    .data![index];
                                                final pharmacyId = pharmDetails
                                                    .get('PharmacyId')
                                                    .objectId;
                                                final Distance = pharmDetails
                                                    .get('Distance')!;
                                                var OrderStatus2 = pharmDetails
                                                    .get('OrderStatus')!;
                                                var note = null;
                                                var time = null;
                                                var medicationListStatus = null;
                                                if (OrderStatus2 == 'Accepted') {
                                                  note = pharmDetails.get('Note')!;
                                                  time = pharmDetails.get('Time')!;
                                                  medicationListStatus = pharmDetails.get('MedicationsList')!;
                                                  if(note ==''){
                                                    note = 'No note';
                                                  }
                                                }
                                                if (OrderStatus2 == 'Declined') {
                                                  note = pharmDetails.get('Note')!;
                                                  if(note ==''){
                                                    note = 'No note';
                                                  }
                                                }
                                                return FutureBuilder<
                                                    List<ParseObject>>(
                                                    future: getPharmDetails(
                                                        pharmacyId),
                                                    builder: (context,
                                                        snapshot) {
                                                      switch (snapshot
                                                          .connectionState) {
                                                        case ConnectionState
                                                            .none:
                                                        case ConnectionState
                                                            .waiting:
                                                          return Center(
                                                            child: Container(
                                                                width: 200,
                                                                height: 5,
                                                                child:
                                                                LinearProgressIndicator()),
                                                          );
                                                        default:
                                                          if (snapshot
                                                              .hasError) {
                                                            return Center(
                                                              child: Text(
                                                                  "Error..."),
                                                            );
                                                          }
                                                          if (!snapshot
                                                              .hasData) {
                                                            return Center(
                                                              child: Text(
                                                                  "No Data..."),
                                                            );
                                                          } else {
                                                            return ListView
                                                                .builder(
                                                                physics: ClampingScrollPhysics(),
                                                                shrinkWrap: true,
                                                                scrollDirection: Axis
                                                                    .vertical,
                                                                itemCount: snapshot
                                                                    .data!
                                                                    .length,
                                                                itemBuilder: (
                                                                    context,
                                                                    index) {
                                                                  final pharmDetails = snapshot
                                                                      .data![index];
                                                                  final pharmacyName = pharmDetails
                                                                      .get<
                                                                      String>(
                                                                      'PharmacyName')!;
                                                                  final pharmPhonenumber = pharmDetails
                                                                      .get(
                                                                      'PhoneNumber')!;
                                                                  final pharmLocation = pharmDetails
                                                                      .get<
                                                                      ParseGeoPoint>(
                                                                      'Location')!;
                                                                  if (OrderStatus2 ==
                                                                      'New') {
                                                                    OrderStatus2 =
                                                                    'Under processing';
                                                                  }
                                                                  return (OrderStatus2 == 'Accepted' || OrderStatus2 == 'Declined')
                                                                      ? Card(
                                                                      child: Column(
                                                                        crossAxisAlignment: CrossAxisAlignment
                                                                            .start,
                                                                        children: [
                                                                          Container(
                                                                              padding: EdgeInsets
                                                                                  .all(
                                                                                  5),
                                                                              width: size
                                                                                  .width,
                                                                              color: Colors
                                                                                  .grey
                                                                                  .shade200,
                                                                              child:
                                                                              Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Text(
                                                                                      '$pharmacyName ',
                                                                                      style: TextStyle(
                                                                                          fontFamily: "Lato",
                                                                                          fontSize: 17,
                                                                                          color: Colors
                                                                                              .black,
                                                                                          fontWeight: FontWeight
                                                                                              .w600),),
                                                                                    Text(
                                                                                      '$pharmPhonenumber',
                                                                                      style: TextStyle(
                                                                                          fontFamily: "Lato",
                                                                                          fontSize: 15,
                                                                                          color: Colors
                                                                                              .black,
                                                                                          fontWeight: FontWeight
                                                                                              .w500),),
                                                                                    FutureBuilder<
                                                                                        Placemark>(
                                                                                        future: getPharmacyLocation(
                                                                                            pharmLocation),
                                                                                        builder: (
                                                                                            context,
                                                                                            snapshot) {
                                                                                          switch (snapshot
                                                                                              .connectionState) {
                                                                                            case ConnectionState
                                                                                                .none:
                                                                                            case ConnectionState
                                                                                                .waiting:
                                                                                              return Center(
                                                                                                child: Container(
                                                                                                    width: 200,
                                                                                                    height: 5,
                                                                                                    child:
                                                                                                    LinearProgressIndicator()),
                                                                                              );
                                                                                            default:
                                                                                              if (true) {
                                                                                                print(
                                                                                                    snapshot
                                                                                                        .error);
                                                                                              }
                                                                                              if (!snapshot
                                                                                                  .hasData) {
                                                                                                return Center(
                                                                                                  child: Text(
                                                                                                      "No Data..."),
                                                                                                );
                                                                                              }
                                                                                              else {
                                                                                                return ListView
                                                                                                    .builder(
                                                                                                    physics: ClampingScrollPhysics(),
                                                                                                    shrinkWrap: true,
                                                                                                    scrollDirection: Axis
                                                                                                        .vertical,
                                                                                                    itemCount: 1,
                                                                                                    itemBuilder: (
                                                                                                        context,
                                                                                                        index) {
                                                                                                      final address = snapshot
                                                                                                          .data!;
                                                                                                      final country = address
                                                                                                          .country;
                                                                                                      final locality = address
                                                                                                          .locality;
                                                                                                      final subLocality = address
                                                                                                          .subLocality;
                                                                                                      final street = address
                                                                                                          .street;
                                                                                                      return Text(
                                                                                                        "$street, $subLocality, $locality, $country",
                                                                                                        maxLines: 2,
                                                                                                        softWrap: true,
                                                                                                        style: TextStyle(
                                                                                                            fontFamily: "Lato",
                                                                                                            fontSize: 15,
                                                                                                            fontWeight: FontWeight
                                                                                                                .w700),
                                                                                                      );
                                                                                                    });
                                                                                              }
                                                                                          }
                                                                                        }),
                                                                                    (OrderStatus2 == 'Accepted')
                                                                                        ?
                                                                                    Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            '$OrderStatus2',
                                                                                            style: TextStyle(
                                                                                                fontFamily: "Lato",
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .green,
                                                                                                fontWeight: FontWeight
                                                                                                    .w700),),
                                                                                          Text(
                                                                                            'Pharmacist note: $note',
                                                                                            style: TextStyle(
                                                                                                fontFamily: "Lato",
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .black,
                                                                                                fontWeight: FontWeight
                                                                                                    .w500),),
                                                                                          Text(
                                                                                            'Order expected to be ready at $time.',
                                                                                            style: TextStyle(
                                                                                                fontFamily: "Lato",
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .black,
                                                                                                fontWeight: FontWeight
                                                                                                    .w500),),
                                                                                          ///View medications
                                                                                          for (int i = 0; i < medicationListStatus[0].length; i++) ...[
                                                                                            FutureBuilder<List<ParseObject>>(
                                                                                                future: getMedDetails(medicationListStatus[0][i]['medId2'].toString()),
                                                                                                builder: (context, snapshot) {
                                                                                                  switch (snapshot.connectionState) {
                                                                                                    case ConnectionState.none:
                                                                                                    case ConnectionState.waiting:
                                                                                                      return Center(
                                                                                                        child: Container(
                                                                                                            width: 200,
                                                                                                            height: 5,
                                                                                                            child:
                                                                                                            LinearProgressIndicator()),
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
                                                                                                            physics: ClampingScrollPhysics(),
                                                                                                            shrinkWrap: true,
                                                                                                            scrollDirection: Axis.vertical,
                                                                                                            itemCount: snapshot.data!.length,
                                                                                                            itemBuilder: (context, index) {
                                                                                                              final medDetails = snapshot.data![index];
                                                                                                              final medications = medDetails.get('TradeName')!;
                                                                                                              final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                                                                                              final Strength = medDetails.get<num>('Strength')!;
                                                                                                              final StrengthUnit = medDetails.get<String>('StrengthUnit')!;
                                                                                                              final Publicprice = medDetails.get('Publicprice')!;

                                                                                                              return Card(
                                                                                                                  child: Column(
                                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                    children:[
                                                                                                                      (medicationListStatus[0][i]['isChecked'] == true)?
                                                                                                                      Container(
                                                                                                                          padding: EdgeInsets.all(5),
                                                                                                                          width: size.width,
                                                                                                                          color: Colors.grey.shade200,
                                                                                                                          child:
                                                                                                                          Column(
                                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                              children:[
                                                                                                                                Row(
                                                                                                                                    children:[
                                                                                                                                      Icon(Icons.check,color: HexColor('#2b872d'),size: 30,),
                                                                                                                                      Text('${medicationListStatus[0][i]['quantity']} X $medications ' ,style: TextStyle(
                                                                                                                                          fontFamily: "Lato",
                                                                                                                                          fontSize: 17,
                                                                                                                                          color: Colors.black,
                                                                                                                                          fontWeight: FontWeight.w600),
                                                                                                                                        maxLines: 2,),
                                                                                                                                    ]),
                                                                                                                                Text('$ProductForm $Strength $StrengthUnit, $Publicprice SAR' ,style: TextStyle(
                                                                                                                                    fontFamily: "Lato",
                                                                                                                                    fontSize: 15,
                                                                                                                                    color: Colors.black,
                                                                                                                                    fontWeight: FontWeight.w500),
                                                                                                                                  maxLines: 2,)
                                                                                                                              ]
                                                                                                                          )
                                                                                                                      ):Container(),
                                                                                                                      (medicationListStatus[0][i]['isChecked'] == false)?
                                                                                                                      Container(
                                                                                                                          padding: EdgeInsets.all(5),
                                                                                                                          width: size.width,
                                                                                                                          color: Colors.grey.shade200,
                                                                                                                          child:
                                                                                                                          Column(
                                                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                                              children:[
                                                                                                                                Row(
                                                                                                                                    children:[
                                                                                                                                      Icon(Icons.close,color: HexColor('#bd2717'),size: 30,),
                                                                                                                                      Text('${medicationListStatus[0][i]['quantity']} x $medications ' ,style: TextStyle(
                                                                                                                                          fontFamily: "Lato",
                                                                                                                                          fontSize: 17,
                                                                                                                                          color: Colors.black,
                                                                                                                                          fontWeight: FontWeight.w600),
                                                                                                                                        maxLines: 2,),
                                                                                                                                    ]),
                                                                                                                                Text('$ProductForm $Strength $StrengthUnit, $Publicprice SAR' ,style: TextStyle(
                                                                                                                                    fontFamily: "Lato",
                                                                                                                                    fontSize: 15,
                                                                                                                                    color: Colors.black,
                                                                                                                                    fontWeight: FontWeight.w500),
                                                                                                                                  maxLines: 2,)
                                                                                                                              ]
                                                                                                                          )
                                                                                                                      ):Container()
                                                                                                                    ],
                                                                                                                  )
                                                                                                              );
                                                                                                            });
                                                                                                      }
                                                                                                  }}
                                                                                            ),],

                                                                                          Center(
                                                                                            child: ElevatedButton(
                                                                                              style: ElevatedButton
                                                                                                  .styleFrom(
                                                                                                backgroundColor: HexColor(
                                                                                                    '#c7a1d1'),
                                                                                              ),
                                                                                              child: Text(
                                                                                                  "CONFIRM ORDER",
                                                                                                  style:
                                                                                                  TextStyle(
                                                                                                      fontFamily: 'Lato',
                                                                                                      fontSize: 15,
                                                                                                      fontWeight: FontWeight
                                                                                                          .bold,
                                                                                                      color: Colors
                                                                                                          .white)),
                                                                                              onPressed: () {
                                                                                                Widget cancelButton = TextButton(
                                                                                                  child: Text(
                                                                                                      "Yes",
                                                                                                      style: TextStyle(
                                                                                                          fontFamily: 'Lato',
                                                                                                          fontSize: 20,
                                                                                                          fontWeight: FontWeight
                                                                                                              .w600,
                                                                                                          color: Colors
                                                                                                              .black)),
                                                                                                  onPressed: () async {
                                                                                                    if (await confirmOrder(
                                                                                                        widget.orderId,
                                                                                                        pharmacyId)) {
                                                                                                      Navigator
                                                                                                          .push(
                                                                                                          context,
                                                                                                          MaterialPageRoute(
                                                                                                              builder: (
                                                                                                                  context) =>
                                                                                                                  OrdersPage(
                                                                                                                      widget.customerId)));
                                                                                                      ScaffoldMessenger
                                                                                                          .of(
                                                                                                          context)
                                                                                                          .showSnackBar(
                                                                                                          SnackBar(
                                                                                                            content: Text(
                                                                                                              "Order ${widget.orderId}, has been confirmed",
                                                                                                              style: TextStyle(
                                                                                                                  fontSize: 20),),
                                                                                                            duration: Duration(
                                                                                                                milliseconds: 3000),
                                                                                                          ));
                                                                                                    };
                                                                                                  },
                                                                                                );
                                                                                                Widget continueButton = TextButton(
                                                                                                  child: Text(
                                                                                                      "No",
                                                                                                      style: TextStyle(
                                                                                                          fontFamily: 'Lato',
                                                                                                          fontSize: 20,
                                                                                                          fontWeight: FontWeight
                                                                                                              .w600,
                                                                                                          color: Colors
                                                                                                              .black)),
                                                                                                  onPressed: () {
                                                                                                    Navigator
                                                                                                        .of(
                                                                                                        context)
                                                                                                        .pop();
                                                                                                  },
                                                                                                );
                                                                                                // set up the AlertDialog
                                                                                                AlertDialog alert = AlertDialog(
                                                                                                  title: RichText(
                                                                                                    text: TextSpan(
                                                                                                      text: '''Are you sure you want to confirm order for $pharmacyName pharmacy?
                                                                                                                                ''',
                                                                                                      style: TextStyle(
                                                                                                          color: Colors
                                                                                                              .black,
                                                                                                          fontFamily: 'Lato',
                                                                                                          fontSize: 20,
                                                                                                          fontWeight: FontWeight
                                                                                                              .bold),
                                                                                                      children: <
                                                                                                          TextSpan>[
                                                                                                        TextSpan(
                                                                                                            text: 'Please note that you cannot undo this process!!!',
                                                                                                            style: TextStyle(
                                                                                                                color: Colors
                                                                                                                    .red,
                                                                                                                fontWeight: FontWeight
                                                                                                                    .bold)),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                  content: Text(
                                                                                                      ""),
                                                                                                  actions: [
                                                                                                    cancelButton,
                                                                                                    continueButton,
                                                                                                  ],
                                                                                                );
                                                                                                // show the dialog
                                                                                                showDialog(
                                                                                                  context: context,
                                                                                                  builder: (
                                                                                                      BuildContext context) {
                                                                                                    return alert;
                                                                                                  },
                                                                                                );
                                                                                              },
                                                                                            ),
                                                                                          ),
                                                                                        ])
                                                                                        : Container(),
                                                                                    (OrderStatus2 ==
                                                                                        'Declined')
                                                                                        ?
                                                                                    Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            '$OrderStatus2',
                                                                                            style: TextStyle(
                                                                                                fontFamily: "Lato",
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .red,
                                                                                                fontWeight: FontWeight
                                                                                                    .w700),),
                                                                                          Text(
                                                                                            'Pharmacist note: $note',
                                                                                            style: TextStyle(
                                                                                                fontFamily: "Lato",
                                                                                                fontSize: 15,
                                                                                                color: Colors
                                                                                                    .black,
                                                                                                fontWeight: FontWeight
                                                                                                    .w500),),
                                                                                        ]
                                                                                    )
                                                                                        : Container()
                                                                                  ]
                                                                              )
                                                                          ),
                                                                        ],
                                                                      )
                                                                  )
                                                                      : Container();
                                                                });
                                                          }
                                                      }
                                                    }
                                                );
                                              });
                                        }
                                    }
                                  }),
                            )
                          ])))
            ])));
  }

  //Function to get pharmacy details
  Future<List<ParseObject>> getPharmList() async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')
      ..objectId = widget.orderId).toPointer());
    parseQuery.orderByAscending('Distance');

    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        return apiResponse.results as List<ParseObject>;
      }
    }
    return [];
  }

  //Function to get pharmacy details
  Future<List<ParseObject>> getPharmDetails(pharmacyId) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(
        ParseObject('Pharmacist'));
    parseQuery.whereEqualTo('objectId', pharmacyId);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  Future<Placemark> getPharmacyLocation(Postion) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        Postion.latitude, Postion.longitude);
    Placemark place = placemarks[0];
    return place;
  }

  Future<bool> confirmOrder(orderId, pharmacyId) async {
    NativeNotify.sendIndieNotification(2338, 'dX0tKYd2XD2DOtsUirIumj', pharmacyId, 'Tiryaq', 'Order $orderId is confirmed', '', '');
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')
      ..objectId = orderId).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacies
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var pharmacy = o as ParseObject;
        if (pharmacy.get('PharmacyId').objectId == pharmacyId) {
          var update = pharmacy..set('OrderStatus', 'Under preparation');
          final ParseResponse parseResponse = await update.save();
        }
        else if(pharmacy.get('OrderStatus') != 'Declined'){
          var update = pharmacy..set('OrderStatus', 'Cancelled');
          final ParseResponse parseResponse = await update.save();
        }
      }
      final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(
          ParseObject('Orders'));
      parseQuery2.whereEqualTo('objectId', orderId);

      final apiResponse2 = await parseQuery2.query();

      //change order status in orders table
      if (apiResponse2.success && apiResponse2.results != null) {
        for (var o in apiResponse2.results!) {
          var object = o as ParseObject;
          var update = object..set('OrderStatus', 'Under preparation');
          final ParseResponse parseResponse = await update.save();
        }
      }
      return true;
    }
    return false;
  }
  //Function to get medication details
  Future<List<ParseObject>> getMedDetails(medicationsList) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Medications'));
    parseQuery.whereEqualTo('objectId', medicationsList);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }

    return [];
  }
}