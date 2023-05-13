import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:untitled/widgets/header_widget.dart';
import 'package:untitled/PresAttach.dart';
import 'package:geocoding/geocoding.dart';
import 'LoginPage.dart';



class ChooseLocation extends StatefulWidget {
  //Get customer id as a parameter
  final String customerId;
  final totalPrice;
  final bool presRequired;
  const ChooseLocation(this.customerId, this.totalPrice, this.presRequired);
  @override
  Locations createState() => Locations();
}

class Locations extends State<ChooseLocation> {
  bool LocationPageNotEmpty = false;
  int NoOfLocation = 0;
  String loc ="";
  num lat = 0;
  num long = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Stack(children: [
          //Header
          Container(
            height: 150,
            child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
          ),
          ///App logo
          Container(
            child: SafeArea(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                        child: IconButton(padding: EdgeInsets.fromLTRB(0, 10, 200, 0),
                          iconSize: 40,
                          color: Colors.white,
                          onPressed: () {
                            Navigator.of(context).pop();
                          }, icon: Icon(Icons.keyboard_arrow_left),),
                      ),

                    ]),
                    SizedBox(
                      height: 75,
                    ),
                    Center(
                        child:
                        Text("Please choose your location",
                            style: TextStyle(fontFamily: 'Lato',fontSize: 20, fontWeight: FontWeight.bold,color: Colors.purple))),
                    SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            height: 620,
                            width: size.width,
                            child: Column(children: [
                              Expanded(
                                  child: FutureBuilder<List<ParseObject>>(
                                      future:
                                      getSavedLocations(),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return Center(
                                              child: Container(
                                                  width: 200,
                                                  height: 10,
                                                  child:
                                                  LinearProgressIndicator()),
                                            );
                                          default:
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text("Error3..."),
                                              );
                                            }
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child: Text("No Data..."),
                                              );
                                            } else {
                                              return LocationPageNotEmpty
                                                  ? ListView.builder(
                                                  scrollDirection:
                                                  Axis.vertical,
                                                  itemCount:
                                                  snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    //Get Parse Object Values
                                                    //Get customer locations from Locations table
                                                    NoOfLocation = snapshot.data!.length; //Save number of Locations
                                                    final LocationTable = snapshot.data![index];
                                                    final LocID = LocationTable.get('objectId')!;
                                                    final location = LocationTable.get<ParseGeoPoint>('SavedLocations')!.toJson();
                                                    final location2 = LocationTable.get<ParseGeoPoint>('SavedLocations');
                                                    return   FutureBuilder<Placemark>(
                                                        future: getUserLocation(location),
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
                                                                    physics: ClampingScrollPhysics(),
                                                                    itemCount: 1,
                                                                    itemBuilder: (context, index) {
                                                                      final address = snapshot.data!;
                                                                      final country = address.country;
                                                                      final locality = address.locality;
                                                                      final subLocality = address.subLocality;
                                                                      final street = address.street;
                                                                      return

                                                                        Stack(
                                                                          children: <Widget>[
                                                                            GestureDetector(
                                                                                onTap: ()
                                                                                {
                                                                                  StoreLocation(location2);
                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                                                                      PresAttach(widget.customerId, widget.totalPrice, widget.presRequired, lat , long)));
                                                                                } ,
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                                                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                                                                  child: Row(
                                                                                    children: <Widget>[
                                                                                      Expanded(
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: <Widget>[
                                                                                              Container(
                                                                                                padding: EdgeInsets.only(right: 8, top: 4),
                                                                                                child: Text(
                                                                                                  "Street: $street\nSublocality: $subLocality",
                                                                                                  maxLines: 2,
                                                                                                  softWrap: true,
                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700),
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                padding: EdgeInsets.only(right: 8, top: 4),
                                                                                                child: Text(
                                                                                                  "Locality: $locality\nCountry: $country",
                                                                                                  maxLines: 2,
                                                                                                  softWrap: true,
                                                                                                  style: TextStyle(fontFamily: "Lato", fontSize: 20, fontWeight: FontWeight.w700),
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(height: 6),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        flex: 100,
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                          ],
                                                                        );
                                                                    });
                                                              }
                                                          }}
                                                    );
                                                  } )




                                              ///If 'LocationNotEmpty' is false; Location is empty show this message
                                                  : Container(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                      //mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          'You do not have saved locations',
                                                          style: TextStyle(
                                                              fontFamily:
                                                              "Lato",
                                                              fontSize: 20,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700),
                                                        ),
                                                      ]));
                                            } }
                                      })

                              )]),
                          ),)),
                  ]),
            ),)
          ,])
        ,),


    );

  }


  ///Get customer's locations  from Locations table
  Future<List<ParseObject>> getSavedLocations() async {
    final QueryBuilder<ParseObject> SavedLocations =
    QueryBuilder<ParseObject>(ParseObject('Locations'));
    SavedLocations.whereEqualTo('customer',
        (ParseObject('Customer')..objectId = widget.customerId).toPointer());

    final apiResponse = await SavedLocations.query();

    if (apiResponse.success && apiResponse.results != null) {
      //If query have objects then set true
      LocationPageNotEmpty=true;

      return apiResponse.results as List<ParseObject>;
    } else {
      //If query have no object then set false
      LocationPageNotEmpty=false;
      return [];
    }
  }


  Future<Placemark> getUserLocation(currentPostion) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPostion['latitude'], currentPostion['longitude']);

    Placemark place = placemarks[0];

    return place;
  }


  void StoreLocation(loc){

    lat = loc.latitude;
    long = loc.longitude;

  }
}