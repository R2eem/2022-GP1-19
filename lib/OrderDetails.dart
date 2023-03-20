import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'CategoryPage.dart';
import 'Cart.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:geocoding/geocoding.dart';
import 'Orders.dart';
import 'PharmaciesList.dart';
import 'Settings.dart';
import 'common/theme_helper.dart';
import 'package:badges/badges.dart' as badges;


class OrderDetailsPage extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  final String orderId;
  final bool currentOrder;
  const OrderDetailsPage(this.customerId, this.orderId, this.currentOrder);
  @override
  OrderDetails createState() => OrderDetails();
}

class OrderDetails extends State<OrderDetailsPage> {
  int _selectedIndex = 2;
  bool presRequired = false;
  var counter = 0;
  bool acceptedOrDeclined = false;
  ///Check if the order is declined before time passed
  bool pharmacyDeclined = false;
  int numOfItems = 0;

  ///To change the badge value
  @override
  void initState() {
    super.initState();
    checkEmptiness();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
        displacement: 150,
        backgroundColor: Colors.white,
        color: Colors.grey,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget));
        },
        child: Stack(
        children: <Widget>[ListView(physics: ClampingScrollPhysics(),
        ), Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                Row(children: [
                  Container(
                    child: IconButton(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      iconSize: 40,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.keyboard_arrow_left),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(65, 33, 0, 0),
                    child: Text(
                      'Order details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 27,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 55,
                ),
                SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: FutureBuilder<List<ParseObject>>(
                        future: getOrderDetails(),
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
                                return ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final customerCurrentOrders = snapshot.data![index];
                                      final OrderId = customerCurrentOrders.get('objectId');
                                      final CreatedDate = customerCurrentOrders.get('createdAt')!;
                                      final updatedAt = customerCurrentOrders.get('updatedAt')!;
                                      final OrderStatus1 = customerCurrentOrders.get('OrderStatus')!;
                                      final TotalPrice = customerCurrentOrders.get('TotalPrice')!;
                                      final medicationsList = customerCurrentOrders.get('MedicationsList')!;
                                      final location = customerCurrentOrders.get<ParseGeoPoint>('Location')!.toJson();
                                      var prescription = null;
                                      if (customerCurrentOrders.get('Prescription') != null) {
                                        presRequired = true;
                                        prescription = customerCurrentOrders.get<ParseFile>('Prescription')!;
                                      }
                                      Color color1 = Colors.black;
                                      if(OrderStatus1=='Under preparation' || OrderStatus1 == 'Ready for pick up'|| OrderStatus1=='Under processing'){
                                        color1 = Colors.orange;
                                      }
                                      if(OrderStatus1=='Collected'){
                                        color1 = Colors.green;
                                      }
                                      if(OrderStatus1=='Declined' || OrderStatus1 == 'Cancelled'){
                                        color1 = Colors.red;
                                      }
                                      return Card(
                                          elevation: 3,
                                          color: Colors.white,
                                          child: ClipPath(
                                              child: Container(
                                                  child: Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              20.0,
                                                              10.0,
                                                              20.0,
                                                              10.0),
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Order placed at  ' +
                                                                  (CreatedDate)
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          (CreatedDate)
                                                                              .toString()
                                                                              .indexOf(' ')),
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Lato",
                                                                  fontSize: 19,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                            ///Track order timeline
                                                            Card(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(
                                                                                5),
                                                                    width: size
                                                                        .width,
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    child: Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'OrderStatus: ',
                                                                            style: TextStyle(
                                                                                fontFamily: "Lato",
                                                                                fontSize: 18,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                          Text(
                                                                            '$OrderStatus1',
                                                                            style: TextStyle(
                                                                                fontFamily: "Lato",
                                                                                fontSize: 18,
                                                                                color: color1,
                                                                                fontWeight: FontWeight.w700),
                                                                          ),
                                                                        ])),
                                                              ],
                                                            )),
                                                            ///If order declined then display message for customer
                                                            (OrderStatus1=='Declined')?
                                                            Text("**We couldn't find available pharmacy, please try another time.",
                                                              style: TextStyle(
                                                                fontFamily: "Lato",
                                                                fontSize: 16,
                                                                color: Colors.red,),
                                                            ):Container(),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            FutureBuilder<
                                                                List<
                                                                    ParseObject>>(
                                                                future:
                                                                getPharmList(),
                                                                builder:
                                                                    (context,
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
                                                                            child: LinearProgressIndicator()),
                                                                      );
                                                                    default:
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Center(
                                                                          child: Text("Error..."),
                                                                        );
                                                                      }
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child: Text("No Data..."),
                                                                        );
                                                                      } else {
                                                                        return ListView.builder(
                                                                            physics: ClampingScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            scrollDirection: Axis.vertical,
                                                                            itemCount: snapshot.data!.length,
                                                                            itemBuilder: (context, index1) {
                                                                              final pharmDetails = snapshot.data![index1];
                                                                              final pharmacyId = pharmDetails.get('PharmacyId').objectId;
                                                                              var OrderStatus2 = pharmDetails.get('OrderStatus')!;
                                                                              var note = 'No note';
                                                                              var time = '';
                                                                              if(pharmDetails.get('Note')!=null) {
                                                                                note = pharmDetails.get('Note')!;
                                                                                if(note==''){
                                                                                  note = 'No note';
                                                                                }
                                                                              }
                                                                              if(pharmDetails.get('Time')!=null) {
                                                                                time = pharmDetails.get('Time')!;
                                                                                time = time.substring(0,2);
                                                                                int t = int.parse(time);
                                                                                String t1 = (updatedAt.add(Duration(hours: t))).toString();
                                                                                time = t1.substring(0,19);
                                                                              }

                                                                              ///Check if there is reply to the order
                                                                              if(OrderStatus2 =='Accepted' || OrderStatus2 =='Declined'){
                                                                                acceptedOrDeclined = true;
                                                                              }
                                                                              var index1Length = snapshot.data!.length;
                                                                              return FutureBuilder<List<ParseObject>>(
                                                                                  future: getPharmDetails(pharmacyId),
                                                                                  builder: (context, snapshot) {
                                                                                    switch (snapshot.connectionState) {
                                                                                      case ConnectionState.none:
                                                                                      case ConnectionState.waiting:
                                                                                        return Center(
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
                                                                                              physics: ClampingScrollPhysics(),
                                                                                              shrinkWrap: true,
                                                                                              scrollDirection: Axis.vertical,
                                                                                              itemCount: snapshot.data!.length,
                                                                                              itemBuilder: (context, index2) {
                                                                                                final pharmDetails = snapshot.data![index2];
                                                                                                final pharmacyName = pharmDetails.get<String>('PharmacyName')!;
                                                                                                final pharmPhonenumber = pharmDetails.get('PhoneNumber')!;
                                                                                                final pharmLocation = pharmDetails.get<ParseGeoPoint>('Location')!;
                                                                                                Color color2 = Colors.black;
                                                                                                if(OrderStatus2=='Under preparation' || OrderStatus2 == 'Ready for pick up'){
                                                                                                  color2 = Colors.orange;
                                                                                                }
                                                                                                if(OrderStatus2=='Collected'){
                                                                                                  color2 = Colors.green;
                                                                                                }

                                                                                                return (OrderStatus2 == 'Collected' || OrderStatus2 == 'Under preparation' || OrderStatus2 == 'Ready for pick up' ||(OrderStatus1=='Declined'&&OrderStatus2=='Declined'))
                                                                                                    ? Card(
                                                                                                    child: Column(
                                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Container(
                                                                                                            padding: EdgeInsets.all(5),
                                                                                                            width: size.width,
                                                                                                            color: Colors.grey.shade200,
                                                                                                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                              Text(
                                                                                                                '$pharmacyName ',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w700),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                '$pharmPhonenumber',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                '$OrderStatus2',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 15, color: color2, fontWeight: FontWeight.w600),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                'Note: $note',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                'Order expected to be ready at:',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                              ),
                                                                                                              Text(
                                                                                                                '$time',
                                                                                                                style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.blue, fontWeight: FontWeight.w600),
                                                                                                              ),
                                                                                                              FutureBuilder<Placemark>(
                                                                                                                  future: getPharmacyLocation(pharmLocation),
                                                                                                                  builder: (context, snapshot) {
                                                                                                                    switch (snapshot.connectionState) {
                                                                                                                      case ConnectionState.none:
                                                                                                                      case ConnectionState.waiting:
                                                                                                                        return Center(
                                                                                                                        );
                                                                                                                      default:
                                                                                                                        if (snapshot.hasError) {
                                                                                                                          print(snapshot.error);
                                                                                                                        }
                                                                                                                        if (!snapshot.hasData) {
                                                                                                                          return Center(
                                                                                                                            child: Text("No Data..."),
                                                                                                                          );
                                                                                                                        } else {
                                                                                                                          return ListView.builder(
                                                                                                                              physics: ClampingScrollPhysics(),
                                                                                                                              shrinkWrap: true,
                                                                                                                              scrollDirection: Axis.vertical,
                                                                                                                              itemCount: 1,
                                                                                                                              itemBuilder: (context, index) {
                                                                                                                                final address = snapshot.data!;
                                                                                                                                final country = address.country;
                                                                                                                                final locality = address.locality;
                                                                                                                                final subLocality = address.subLocality;
                                                                                                                                final street = address.street;
                                                                                                                                return Text(
                                                                                                                                  "$street, $subLocality, $locality, $country",
                                                                                                                                  maxLines: 2,
                                                                                                                                  softWrap: true,
                                                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 15, fontWeight: FontWeight.w700),
                                                                                                                                );
                                                                                                                              });
                                                                                                                        }
                                                                                                                    }
                                                                                                                  }),
                                                                                                            ])),
                                                                                                      ],
                                                                                                    ))
                                                                                                    : ///If order under processing and a pharmacy accepted or declined then show the pharmacy list button other wise tell customer to wait
                                                                                                (OrderStatus1 == 'Under processing' && acceptedOrDeclined  && index1==index1Length-1)
                                                                                                    ? Center(
                                                                                                  child:
                                                                                                  Container(
                                                                                                    decoration:
                                                                                                    ThemeHelper()
                                                                                                        .buttonBoxDecoration(context),
                                                                                                    child:
                                                                                                    ElevatedButton(
                                                                                                      style: ThemeHelper()
                                                                                                          .buttonStyle(),
                                                                                                      onPressed:
                                                                                                          () {
                                                                                                        Navigator.push(
                                                                                                            context,
                                                                                                            MaterialPageRoute(builder: (context) => PharmacyListPage(OrderId, widget.customerId)));
                                                                                                      },
                                                                                                      child:
                                                                                                      Text(
                                                                                                        'View Pharmacies List'
                                                                                                            .toUpperCase(),
                                                                                                        style: TextStyle(
                                                                                                            fontFamily: 'Lato',
                                                                                                            fontSize: 18,
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            color: Colors.white),
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                )
                                                                                                ///If order under processing and no pharmacy accepted then tell customer to wait
                                                                                                    : (OrderStatus1 == 'Under processing'  && !acceptedOrDeclined  && index1==index1Length-1)?
                                                                                                Container(
                                                                                                    child: Column(
                                                                                                        children:[Text(
                                                                                                          'Waiting for pharmacies reply... ',
                                                                                                          style: TextStyle(
                                                                                                              fontFamily: 'Lato',
                                                                                                              fontSize: 16,
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                              color: Colors.red),
                                                                                                        ),
                                                                                                          Text(
                                                                                                            '*Refresh page to check new replies.',
                                                                                                            style: TextStyle(
                                                                                                                fontFamily: 'Lato',
                                                                                                                fontSize: 12,
                                                                                                                fontWeight: FontWeight.bold,
                                                                                                                color: Colors.black54),
                                                                                                          ),
                                                                                                ])):Container();
                                                                                              });
                                                                                        }
                                                                                    }
                                                                                  });
                                                                            });
                                                                      }
                                                                  }
                                                                }),
                                                            SizedBox(
                                                              height: 10,
                                                            ),

                                                            ///customer name and phone number and location
                                                            FutureBuilder<
                                                                    Placemark>(
                                                                future:
                                                                    getUserLocation(
                                                                        location),
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
                                                                            width:
                                                                                200,
                                                                            height:
                                                                                5,
                                                                            child:
                                                                                LinearProgressIndicator()),
                                                                      );
                                                                    default:
                                                                      if (snapshot
                                                                          .hasError) {
                                                                        return Center(
                                                                          child:
                                                                              Text("Error..."),
                                                                        );
                                                                      }
                                                                      if (!snapshot
                                                                          .hasData) {
                                                                        return Center(
                                                                          child:
                                                                              Text("No Data..."),
                                                                        );
                                                                      } else {
                                                                        return ListView.builder(
                                                                            physics: ClampingScrollPhysics(),
                                                                            shrinkWrap: true,
                                                                            scrollDirection: Axis.vertical,
                                                                            itemCount: 1,
                                                                            itemBuilder: (context, index) {
                                                                              final address = snapshot.data!;
                                                                              final country = address.country;
                                                                              final locality = address.locality;
                                                                              final subLocality = address.subLocality;
                                                                              final street = address.street;
                                                                              return FutureBuilder<ParseObject>(
                                                                                  future: getCustomerDetails(),
                                                                                  builder: (context, snapshot) {
                                                                                    switch (snapshot.connectionState) {
                                                                                      case ConnectionState.none:
                                                                                      case ConnectionState.waiting:
                                                                                        return Center(
                                                                                          child: Container(width: 200, height: 5, child: LinearProgressIndicator()),
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
                                                                                              physics: ClampingScrollPhysics(),
                                                                                              shrinkWrap: true,
                                                                                              scrollDirection: Axis.vertical,
                                                                                              itemCount: 1,
                                                                                              itemBuilder: (context, index) {
                                                                                                final customerDetials = snapshot.data!;
                                                                                                final firstname = customerDetials.get<String>('Firstname');
                                                                                                final lastname = customerDetials.get<String>('Lastname');
                                                                                                final phonenumber = customerDetials.get('Phonenumber');
                                                                                                return Card(
                                                                                                    child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                        padding: EdgeInsets.all(5),
                                                                                                        width: size.width,
                                                                                                        color: Colors.grey.shade200,
                                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                          RichText(
                                                                                                            text: TextSpan(
                                                                                                              children: [
                                                                                                                WidgetSpan(
                                                                                                                  child: Icon(Icons.person, size: 20,),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: " $firstname $lastname, $phonenumber",
                                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                          RichText(
                                                                                                            text: TextSpan(
                                                                                                              children: [
                                                                                                                WidgetSpan(
                                                                                                                  child: Icon(Icons.location_on,  size: 20,),
                                                                                                                ),
                                                                                                                TextSpan(
                                                                                                                  text: " $street, $subLocality, $locality, $country",
                                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ]))
                                                                                                  ],
                                                                                                ));
                                                                                              });
                                                                                        }
                                                                                    }
                                                                                  });
                                                                            });
                                                                      }
                                                                  }
                                                                }),
                                                            SizedBox(
                                                              height: 20,
                                                            ),

                                                            ///Show total price and items of initial order
                                                            (OrderStatus1 == 'Under processing' || OrderStatus1 == 'Declined' || OrderStatus1 == 'Cancelled')
                                                                ?

                                                                ///Order total price
                                                                Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                        Card(
                                                                            child:
                                                                                Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                                padding: EdgeInsets.all(5),
                                                                                width: size.width,
                                                                                color: Colors.grey.shade200,
                                                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                  Text(
                                                                                    'Total price: $TotalPrice SAR',
                                                                                    style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                  ),
                                                                                ]))
                                                                          ],
                                                                        )),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),

                                                                        ///Order items
                                                                        Text(
                                                                          'Items:',
                                                                          style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 19,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              10,
                                                                        ),
                                                                        for (int i =
                                                                                0;
                                                                            i < medicationsList[0].length;
                                                                            i++) ...[
                                                                          FutureBuilder<List<ParseObject>>(
                                                                              future: getMedDetails(medicationsList[0][i]['medId'].toString()),
                                                                              builder: (context, snapshot) {
                                                                                switch (snapshot.connectionState) {
                                                                                  case ConnectionState.none:
                                                                                  case ConnectionState.waiting:
                                                                                    return Center(
                                                                                      child: Container(width: 200, height: 5, child: LinearProgressIndicator()),
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
                                                                                          physics: ClampingScrollPhysics(),
                                                                                          shrinkWrap: true,
                                                                                          scrollDirection: Axis.vertical,
                                                                                          itemCount: snapshot.data!.length,
                                                                                          itemBuilder: (context, index) {
                                                                                            final medDetails = snapshot.data![index];
                                                                                            final medications = medDetails.get('TradeName')!;
                                                                                            final quantity = medicationsList[0][i]['quantity'];
                                                                                            final ProductForm = medDetails.get<String>('PharmaceuticalForm')!;
                                                                                            final Strength = medDetails.get<num>('Strength')!;
                                                                                            final StrengthUnit = medDetails.get<String>('StrengthUnit')!;
                                                                                            final Publicprice = medDetails.get('Publicprice')!;

                                                                                            return Card(
                                                                                                child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Container(
                                                                                                    padding: EdgeInsets.all(5),
                                                                                                    width: size.width,
                                                                                                    color: Colors.grey.shade200,
                                                                                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                      Text(
                                                                                                        '$quantity X  $medications ',
                                                                                                        style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                      ),
                                                                                                      Text(
                                                                                                        '$ProductForm $Strength $StrengthUnit, $Publicprice SAR',
                                                                                                        style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                      )
                                                                                                    ]))
                                                                                              ],
                                                                                            ));
                                                                                          });
                                                                                    }
                                                                                }
                                                                              }),
                                                                        ],
                                                                      ])
                                                                :

                                                                ///If its not under processing then show total price and items that is accepted by the selected pharmacy
                                                                FutureBuilder<
                                                                        List<
                                                                            ParseObject>>(
                                                                    future:
                                                                        getMedList(),
                                                                    builder:
                                                                        (context,
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
                                                                                child: LinearProgressIndicator()),
                                                                          );
                                                                        default:
                                                                          if (snapshot
                                                                              .hasError) {
                                                                            return Center(
                                                                              child: Text("Error..."),
                                                                            );
                                                                          }
                                                                          if (!snapshot
                                                                              .hasData) {
                                                                            return Center(
                                                                              child: Text("No Data..."),
                                                                            );
                                                                          } else {
                                                                            return ListView.builder(
                                                                                physics: ClampingScrollPhysics(),
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: snapshot.data!.length,
                                                                                itemBuilder: (context, index) {
                                                                                  final medDetails = snapshot.data![index];
                                                                                  final medicationsList = medDetails.get('MedicationsList')!;
                                                                                  return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                    FutureBuilder<String>(
                                                                                        future: getTotalPrice(),
                                                                                        builder: (context, snapshot) {
                                                                                          switch (snapshot.connectionState) {
                                                                                            case ConnectionState.none:
                                                                                            case ConnectionState.waiting:
                                                                                              return Center(
                                                                                                child: Container(width: 200, height: 5, child: LinearProgressIndicator()),
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
                                                                                                    physics: ClampingScrollPhysics(),
                                                                                                    shrinkWrap: true,
                                                                                                    scrollDirection: Axis.vertical,
                                                                                                    itemCount: 1,
                                                                                                    itemBuilder: (context, index) {
                                                                                                      final totalPrice = snapshot.data!;
                                                                                                      return Card(
                                                                                                          child: Column(
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Container(
                                                                                                              padding: EdgeInsets.all(5),
                                                                                                              width: size.width,
                                                                                                              color: Colors.grey.shade200,
                                                                                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                                Text(
                                                                                                                  'Total price: ${totalPrice} SAR',
                                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                ),
                                                                                                              ]))
                                                                                                        ],
                                                                                                      ));
                                                                                                    });
                                                                                              }
                                                                                          }
                                                                                        }),
                                                                                    SizedBox(
                                                                                      height: 20,
                                                                                    ),

                                                                                    ///Order items
                                                                                    Text(
                                                                                      'Items:',
                                                                                      style: TextStyle(fontFamily: "Lato", fontSize: 19, color: Colors.black, fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: 10,
                                                                                    ),
                                                                                    Column(
                                                                                      children: [
                                                                                        for (int i = 0; i < medicationsList[0].length; i++) ...[
                                                                                          FutureBuilder<List<ParseObject>>(
                                                                                              future: getMedDetails(medicationsList[0][i]['medId2'].toString()),
                                                                                              builder: (context, snapshot) {
                                                                                                switch (snapshot.connectionState) {
                                                                                                  case ConnectionState.none:
                                                                                                  case ConnectionState.waiting:
                                                                                                    return Center(
                                                                                                      child: Container(width: 200, height: 5, child: LinearProgressIndicator()),
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
                                                                                                              children: [
                                                                                                                (medicationsList[0][i]['isChecked'] == true)
                                                                                                                    ? Container(
                                                                                                                        padding: EdgeInsets.all(5),
                                                                                                                        width: size.width,
                                                                                                                        color: Colors.grey.shade200,
                                                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                                          Row(children: [
                                                                                                                            Icon(
                                                                                                                              Icons.check,
                                                                                                                              color: HexColor('#2b872d'),
                                                                                                                              size: 30,
                                                                                                                            ),
                                                                                                                            Text(
                                                                                                                              '${medicationsList[0][i]['quantity']} x $medications ',
                                                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                              maxLines: 2,
                                                                                                                            ),
                                                                                                                          ]),
                                                                                                                          Text(
                                                                                                                            '$ProductForm $Strength $StrengthUnit, $Publicprice SAR',
                                                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                                            maxLines: 2,
                                                                                                                          )
                                                                                                                        ]))
                                                                                                                    : Container(),
                                                                                                                (medicationsList[0][i]['isChecked'] == false)
                                                                                                                    ? Container(
                                                                                                                        padding: EdgeInsets.all(5),
                                                                                                                        width: size.width,
                                                                                                                        color: Colors.grey.shade200,
                                                                                                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                                                          Row(children: [
                                                                                                                            Icon(
                                                                                                                              Icons.close,
                                                                                                                              color: HexColor('#bd2717'),
                                                                                                                              size: 30,
                                                                                                                            ),
                                                                                                                            Text(
                                                                                                                              '${medicationsList[0][i]['quantity']} x $medications ',
                                                                                                                              style: TextStyle(fontFamily: "Lato", fontSize: 17, color: Colors.black, fontWeight: FontWeight.w600),
                                                                                                                              maxLines: 2,
                                                                                                                            ),
                                                                                                                          ]),
                                                                                                                          Text(
                                                                                                                            '$ProductForm $Strength $StrengthUnit, $Publicprice SAR',
                                                                                                                            style: TextStyle(fontFamily: "Lato", fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                                                                                                            maxLines: 2,
                                                                                                                          )
                                                                                                                        ]))
                                                                                                                    : Container(),
                                                                                                              ],
                                                                                                            ));
                                                                                                          });
                                                                                                    }
                                                                                                }
                                                                                              })
                                                                                        ]
                                                                                      ],
                                                                                    ),
                                                                                  ]);
                                                                                });
                                                                          }
                                                                      }
                                                                    }),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ///Order prescription if exist
                                                            presRequired
                                                                ? Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                        Text(
                                                                          'Prescription: ',
                                                                          style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 19,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        Text(
                                                                          ' click to view the image',
                                                                          style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 14,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        FullScreenWidget(
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                100,
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Image.network(
                                                                              prescription!.url!,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              20,
                                                                        ),
                                                                      ])
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .stretch,
                                                                    children: [
                                                                        Text(
                                                                          'Prescription: ',
                                                                          style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 19,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                        Text(
                                                                          'No prescription attached',
                                                                          style: TextStyle(
                                                                              fontFamily: "Lato",
                                                                              fontSize: 18,
                                                                              color: Colors.black54,
                                                                              fontWeight: FontWeight.w700),
                                                                        ),
                                                                      ]),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            widget.currentOrder
                                                                ? Column(
                                                                    children: [
                                                                        Center(
                                                                          child:
                                                                              ElevatedButton(
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.red,
                                                                            ),
                                                                            child:
                                                                                Text("CANCEL ORDER", style: TextStyle(fontFamily: 'Lato', fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                            onPressed:
                                                                                () {
                                                                              Widget cancelButton = TextButton(
                                                                                child: Text("Yes", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                onPressed: () async {
                                                                                  if (await cancelOrder(OrderId)) {
                                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersPage(widget.customerId)));
                                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                      content: Text(
                                                                                        "Order number $OrderId has been deleted",
                                                                                        style: TextStyle(fontSize: 20),
                                                                                      ),
                                                                                      duration: Duration(milliseconds: 3000),
                                                                                    ));
                                                                                  }
                                                                                  ;
                                                                                },
                                                                              );
                                                                              Widget continueButton = TextButton(
                                                                                child: Text("No", style: TextStyle(fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                                                                onPressed: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                              );
                                                                              // set up the AlertDialog
                                                                              AlertDialog alert = AlertDialog(
                                                                                title: RichText(
                                                                                  text: TextSpan(
                                                                                    text: '''Are you sure you want to cancel this order?
                                                                                               ''',
                                                                                    style: TextStyle(color: Colors.black, fontFamily: 'Lato', fontSize: 20, fontWeight: FontWeight.bold),
                                                                                    children: <TextSpan>[
                                                                                      TextSpan(text: 'Please note that you cannot undo this process!!!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                                                    ],
                                                                                  ),
                                                                                ),
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
                                                                            },
                                                                          ),
                                                                        ),
                                                                      ])
                                                                : Container()
                                                          ])))));
                                    });
                              }
                          }
                        })),
              ]))),
        ])),

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
                        icon: Icons.home,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.shopping_cart,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30,
                       ),
                    GButton(
                        icon: Icons.receipt_long,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                    GButton(
                        icon: Icons.settings,
                        iconActiveColor: Colors.purple.shade200,
                        iconSize: 30),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) => setState(() {
                    _selectedIndex = index;
                    if (_selectedIndex == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage()));
                    } else if (_selectedIndex == 1) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CartPage(widget.customerId)));
                    } else if (_selectedIndex == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OrdersPage(widget.customerId)));
                    } else if (_selectedIndex == 3) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SettingsPage(widget.customerId)));
                    }
                  }),
                ))))]));
  }

  //Get customer current orders from orders table
  Future<List<ParseObject>> getOrderDetails() async {
    //Query order details
    final QueryBuilder<ParseObject> order =
        QueryBuilder<ParseObject>(ParseObject('Orders'));
    order.whereEqualTo('objectId', widget.orderId);

    final apiResponse = await order.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Function to get medication details
  Future<List<ParseObject>> getMedDetails(medicationsList) async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Medications'));
    parseQuery.whereEqualTo('objectId', medicationsList);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  //Function to get pharmacy details
  Future<List<ParseObject>> getPharmList() async {
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());

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
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Pharmacist'));
    parseQuery.whereEqualTo('objectId', pharmacyId);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    }
    return [];
  }

  //Get medications of the selected pharmacy
  Future<List<ParseObject>> getMedList() async {
    final QueryBuilder<ParseObject> parseQuery1 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery1.whereEqualTo('OrderStatus', 'Under preparation');

    final QueryBuilder<ParseObject> parseQuery2 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery2.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery2.whereEqualTo('OrderStatus', 'Ready for pick up');

    final QueryBuilder<ParseObject> parseQuery3 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery3.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery3.whereEqualTo('OrderStatus', 'Collected');

    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [parseQuery1, parseQuery2, parseQuery3],
    );

    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  //Function to get customer details
  Future<ParseObject> getCustomerDetails() async {
    var object;
    final QueryBuilder<ParseObject> parseQuery =
        QueryBuilder<ParseObject>(ParseObject('Customer'));
    parseQuery.whereEqualTo('objectId', widget.customerId);

    final apiResponse = await parseQuery.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        object = o as ParseObject;
      }
    }
    return object;
  }

  //Get total price
  Future<String> getTotalPrice() async {
    num totalPrice = 0;

    final QueryBuilder<ParseObject> parseQuery1 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery1.whereEqualTo('OrderStatus', 'Under preparation');

    final QueryBuilder<ParseObject> parseQuery2 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery2.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery2.whereEqualTo('OrderStatus', 'Ready for pick up');

    final QueryBuilder<ParseObject> parseQuery3 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery3.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery3.whereEqualTo('OrderStatus', 'Collected');

    final QueryBuilder<ParseObject> parseQuery4 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery4.whereEqualTo('OrderId',
        (ParseObject('Orders')..objectId = widget.orderId).toPointer());
    parseQuery4.whereEqualTo('OrderStatus', 'Accepted');

    QueryBuilder<ParseObject> mainQuery = QueryBuilder.or(
      ParseObject("PharmaciesList"),
      [parseQuery1, parseQuery2, parseQuery3, parseQuery4],
    );

    final ParseResponse apiResponse = await mainQuery.query();
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        var object = o as ParseObject;
        List med = object.get('MedicationsList');

        for (int i = 0; i < med[0].length; i++) {
          if (med[0][i]['isChecked'] == true) {
            final QueryBuilder<ParseObject> parseQuery =
                QueryBuilder<ParseObject>(ParseObject('Medications'));
            parseQuery.whereEqualTo('objectId', med[0][i]['medId2']);

            final apiResponse2 = await parseQuery.query();
            if (apiResponse.success && apiResponse.results != null) {
              for (var o in apiResponse2.results!) {
                var object = o as ParseObject;
                num price = object.get('Publicprice');
                num quantity = num.parse(med[0][i]['quantity']);
                totalPrice = totalPrice + (price * quantity);
              }
            }
          }
        }
      }
    } else {
      return '';
    }
    return totalPrice.toStringAsFixed(2);
  }

  Future<Placemark> getUserLocation(currentPostion) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPostion['latitude'], currentPostion['longitude']);
    Placemark place = placemarks[0];
    return place;
  }

  Future<Placemark> getPharmacyLocation(Postion) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(Postion.latitude, Postion.longitude);
    Placemark place = placemarks[0];
    return place;
  }

  Future<bool> cancelOrder(orderId) async {
    final QueryBuilder<ParseObject> parseQuery1 =
        QueryBuilder<ParseObject>(ParseObject('PharmaciesList'));
    parseQuery1.whereEqualTo(
        'OrderId', (ParseObject('Orders')..objectId = orderId).toPointer());

    final apiResponse1 = await parseQuery1.query();

    //change order status for pharmacy
    if (apiResponse1.success && apiResponse1.results != null) {
      for (var o in apiResponse1.results!) {
        var object = o as ParseObject;
        var update = object..set('OrderStatus', 'Cancelled');
        final ParseResponse parseResponse = await update.save();
      }
    }
    final QueryBuilder<ParseObject> parseQuery2 =
        QueryBuilder<ParseObject>(ParseObject('Orders'));
    parseQuery2.whereEqualTo('objectId', orderId);

    final apiResponse2 = await parseQuery2.query();

    //change order status for pharmacy
    if (apiResponse2.success && apiResponse2.results != null) {
      for (var o in apiResponse2.results!) {
        var object = o as ParseObject;
        var update = object..set('OrderStatus', 'Cancelled');
        final ParseResponse parseResponse = await update.save();
      }
      return true;
    }
    return false;
  }
  ///Get if number of items in cart
  Future<void> checkEmptiness() async {
    //Query customer cart
    final QueryBuilder<ParseObject> customerCart =
    QueryBuilder<ParseObject>(ParseObject('Cart'));
    customerCart.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());
    final apiResponse = await customerCart.query();

    if (apiResponse.success && apiResponse.results != null) {
      numOfItems = apiResponse.count;
      setState(() {});
    } else {
      numOfItems = 0;
    }
  }
}