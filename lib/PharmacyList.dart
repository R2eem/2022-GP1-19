import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:native_notify/native_notify.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Cart.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geocoding/geocoding.dart';
import 'Orders.dart';
import 'Settings.dart';


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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
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
    child: IconButton(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
    iconSize: 40,
    color: Colors.white,
    onPressed: () {
    Navigator.of(context).pop();
    }, icon: Icon(Icons.keyboard_arrow_left),),
    ),
    Container(
    margin: EdgeInsets.fromLTRB(55, 33, 0, 0),
    child: Text('Pharmacies List',
    textAlign: TextAlign.center, style: TextStyle(
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
    child:FutureBuilder<List<ParseObject>>(
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
                return  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final pharmDetails = snapshot.data![index];
                      final pharmacyId = pharmDetails.get('PharmacyId').objectId;
                      final Distance = pharmDetails.get('Distance')!;
                      var OrderStatus2 = pharmDetails.get('OrderStatus')!;
                      return FutureBuilder<List<ParseObject>>(
                          future: getPharmDetails(pharmacyId),
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
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final pharmDetails = snapshot.data![index];
                                        final pharmacyName = pharmDetails.get<String>('PharmacyName')!;
                                        final pharmPhonenumber = pharmDetails.get('PhoneNumber')!;
                                        final pharmLocation = pharmDetails.get<ParseGeoPoint>('Location')!;
                                        if (OrderStatus2 == 'Accept/Decline') {
                                          OrderStatus2 = 'Under processing';
                                        }

                                        return (OrderStatus2 == 'Under processing')
                                        ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets
                                                    .all(
                                                    5),
                                                width: size.width,
                                                color: Colors.grey.shade200,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('$pharmacyName ', style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),),
                                                      Text('$pharmPhonenumber', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
                                                      Text('$pharmLocation', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
                                                      Text('$OrderStatus2', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
                                                    ]
                                                )
                                            )
                                          ],
                                        )
                                            :Container();
                                      });
                                }
                            }
                          });


                    });
              }
          }
        }
    ),




    )])))])));
  }


  //Function to get pharmacy details
  Future<List<ParseObject>> getPharmList() async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = widget.orderId ).toPointer());

    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        return apiResponse.results as List<ParseObject>;
      }
    }
    return [];
  }


  Future<List<ParseObject>> getPharmDetails(pharmacyId) async {
    final QueryBuilder<ParseObject> parseQuery = QueryBuilder<ParseObject>(ParseObject('Pharmacist'));
    parseQuery.whereEqualTo('objectId', pharmacyId);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  // function to send if the order is accepted or declined to the customer
  Future<List<ParseObject>> getPharmcyAcceptOrDeclineDetails(pharmacyId) async {
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('PharmacyId',
        (ParseObject('Pharmacist')..objectId =pharmacyId).toPointer());
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = widget.orderId).toPointer());

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  Future<ParseObject> getNote(pharmacyId) async {
    final QueryBuilder<ParseObject> parseQuery =
    QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('PharmacyId', (ParseObject('Pharmacist')..objectId =pharmacyId).toPointer());
    parseQuery.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = widget.orderId).toPointer());

    final apiResponse = await parseQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        return object;
      }
    }
    return null!;
  }

  Future<bool> confirmOrder(orderId, pharmacyId) async {
    NativeNotify.sendIndieNotification(2338, 'dX0tKYd2XD2DOtsUirIumj', pharmacyId, 'Tiryaq', 'Order $orderId is confirmed', '', '');
    final QueryBuilder<ParseObject> parseQuery1 = QueryBuilder<ParseObject>(
        ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId', (ParseObject('Orders')..objectId = orderId ).toPointer());
    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacies
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var pharmacy = o as ParseObject;
        if(pharmacy.get('PharmacyId').objectId == pharmacyId){
          var update = pharmacy..set('OrderStatus', 'Under preparation');
          final ParseResponse parseResponse = await update.save();
        }
        else{
          var update = pharmacy..set('OrderStatus', 'Cancelled');
          final ParseResponse parseResponse = await update.save();
        }
      }
      final QueryBuilder<ParseObject> parseQuery2 = QueryBuilder<ParseObject>(
          ParseObject('Orders'));
      parseQuery2.whereEqualTo('objectId', orderId);

      final apiResponse2 = await parseQuery2.query();

      //change order status for pharmacy
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
}

// FutureBuilder<List<ParseObject>>(
// future: getPharmcyAcceptOrDeclineDetails(pharmacyId),
// builder: (context, snapshot) {
// switch (snapshot
//     .connectionState) {
// case ConnectionState.none:
// case ConnectionState.waiting:
// return Center(
// child: Container(
// width: 200,
// height: 5,
// child:
// LinearProgressIndicator()),
// );
// default:
// if (snapshot.hasError) {
// return Center(
// child: Text(
// "Error..."),
// );
// }
// if (!snapshot.hasData) {
// return Center(
// child: Text(
// "No Data..."),
// );
// } else {
// return ListView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.vertical,
// itemCount: snapshot.data!.length,
// itemBuilder: (context, index) {
// final OrderDetails = snapshot.data![index];
// final medicationsList = OrderDetails.get('MedicationsList')!;
//
// // هنا نجيب معلومات الطلب وكل دواء والفاليو حقته
//
//
// return FutureBuilder<ParseObject>(
// future: getNote(pharmacyId),
// builder: (context, snapshot) {
// switch (snapshot.connectionState) {
// case ConnectionState.none:
// case ConnectionState.waiting:
// /* return Center(
//                                                                      child: Container(
//                                                                       width: 200,
//                                                                       height: 5,
//                                                                        child: LinearProgressIndicator()),
//                                                                          );*/
// default:
// if (snapshot.hasError) {
// return Center(
// child: Text(
// "Error..."),
// );
// }
// if (!snapshot.hasData) {
// return Center(
// child: Text(""),
// );
// } else {
// return  ListView.builder(
// shrinkWrap: true,
// scrollDirection: Axis.vertical,
// itemCount: 1,
// itemBuilder: (context, index) {
// final noteDetail = snapshot.data!;
// final note = noteDetail.get("Note");
//
//
// return (OrderStatus2 == 'Under processing' || OrderStatus2 == 'Accepted' || OrderStatus2 == 'Declined' || OrderStatus2 == 'Under preparation' || OrderStatus2 == 'Ready for pick up')
// ? ExpansionTile(
// title: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Container(
// padding: EdgeInsets
//     .all(
// 5),
// width: size.width,
// color: Colors.grey.shade200,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('$pharmacyName ', style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),),
// Text('$pharmPhonenumber', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
// Text('$pharmLocation', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
// Text('$OrderStatus2', style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),),
//
// (OrderStatus2 == 'Accepted') ?
//
// Column(
// children: [
// Center(
// child: ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: HexColor('#c7a1d1'),
// ),
// child: Text("CONFIRM ORDER", style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
// onPressed: () {
// Widget cancelButton = TextButton(
// child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
// onPressed: () async {
// if (await confirmOrder(widget.orderId, pharmacyId)) {
// Navigator.push(context,
// MaterialPageRoute(builder: (context) =>
// OrdersPage(widget.customerId)));
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(content: Text("Order ${widget.orderId} has been confirmed", style: TextStyle(fontSize: 20),),
// duration: Duration(
// milliseconds: 3000),
// ));
// };
// },
// );
// Widget continueButton = TextButton(
// child: Text("No", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
// onPressed: () {Navigator.of(context).pop();
// },
// );
// // set up the AlertDialog
// AlertDialog alert = AlertDialog(
// title: RichText(
// text: TextSpan(
// text: '''Are you sure you want to confirm order for $pharmacyName pharmacy?
//                                                                                                                                 ''',
// style: TextStyle(
// color: Colors
//     .black,
// fontFamily: 'Lato',
// fontSize: 20,
// fontWeight: FontWeight
//     .bold),
// children: <
// TextSpan>[
// TextSpan(
// text: 'Please note that you cannot undo this process!!!',
// style: TextStyle(
// color: Colors
//     .red,
// fontWeight: FontWeight
//     .bold)),
// ],
// ),
// ),
// content: Text(
// ""),
// actions: [
// cancelButton,
// continueButton,
// ],
// );
// // show the dialog
// showDialog(
// context: context,
// builder: (
// BuildContext context) {
// return alert;
// },
// );
// },
// ),
// ),
// ])
//     : Container()
// ]
// )
// )
// ],
// ),
// children: <Widget>[
//
// ])
//
//
//
//
//
//
//
//     : Container();
//
// });
// }
// }
// });
//
//
// });
// }
// }
// });
