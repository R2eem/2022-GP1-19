import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:untitled/ChooseLocation.dart';
import 'Cart.dart';
import 'PresAttach.dart';


class Locationpage extends StatefulWidget{
//Get customer id as a parameter
  final String customerId;
  final totalPrice;
  final bool presRequired;
  const Locationpage(this.customerId, this.totalPrice, this.presRequired);
  @override
  State<StatefulWidget> createState() {
    return _LocationPage();
  }
}

class _LocationPage extends State<Locationpage> {
  GlobalKey _toolTipKey = GlobalKey();
  late GoogleMapController googleMapController;
  //for error message
  bool Lat = false;
  bool Long = false;
  //for passing to another page
  num lat= 0;
  num long= 0;
  String address="";

  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(24.7223, 46.6345), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final dynamic tooltip = _toolTipKey.currentState;
      tooltip.ensureTooltipVisible();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white ,
        onPressed: () async {
          Position position = await _determinePosition();

          googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

          markers.clear();

          markers.add(Marker(markerId: const MarkerId('currentLocation'),position: LatLng(position.latitude, position.longitude)));

          setState(() {});
          lat = position.latitude;
          long = position.longitude;
          Lat = true;
          Long = true;
        },
        label: Tooltip(
          key: _toolTipKey,
          message: 'Get current location',
          child: Icon(Icons.my_location ,color: Colors.black,),
          preferBelow: false,
          triggerMode: TooltipTriggerMode.manual,
        ),
      ),

      bottomNavigationBar:
    SizedBox(
      height: size.height/6.7,
      child:
      Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
         FutureBuilder<Placemark>(
             future: getAddress(lat,long),
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
                               "Select location"),
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
                             itemCount: 1,
                             itemBuilder: (context, index) {
                               final address = snapshot.data!;
                               var country = address.country;
                               var locality = address.locality;
                               var subLocality = address.subLocality;
                               var street = address.street;
                               return Stack(
                                   children: <Widget>[
                                     Container(
                                         margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                                         padding: EdgeInsets.all(10),
                                         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(16))),
                                         child:Row(
                                             children: [
                                               Icon(Icons.location_on),
                                               Expanded(
                                                 child:
                                                 Text(" $street, $subLocality, $locality, $country",style: TextStyle(
                                                   fontFamily: "Lato",
                                                   fontSize: 17,
                                                   color: Colors.black,
                                                   fontWeight: FontWeight.w600,),
                                                   maxLines: 2,
                                                   overflow: TextOverflow.ellipsis,
                                                 ),
                                             )],
                                           ),
                                         )

                                   ]
                               );
                             });
                       }
               }
             }),
        Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              SizedBox(width: 8,),
              CircleAvatar(
            backgroundColor: Colors.purple.shade300,
            child: IconButton(
              onPressed: (){
                Navigator.push( context, MaterialPageRoute( builder: (context) => CartPage(widget.customerId), ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 24,
              ),
            )),
        Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton
                  .styleFrom(
                backgroundColor: Colors.purple.shade300
              ),
              onPressed: (){
                Navigator.push( context, MaterialPageRoute( builder: (context) => ChooseLocation(widget.customerId, widget.totalPrice, widget.presRequired), ));
              },

              icon: Icon(Icons.location_on ,color: Colors.white,),
              label: Text('Saved locations', style:
            TextStyle(
                fontFamily: 'Lato',
                fontSize: 15,
                fontWeight: FontWeight
                    .bold,
                color: Colors
                    .white),),
            ),
          Spacer(),
          CircleAvatar(
              backgroundColor: Colors.purple.shade300,
              child:
              IconButton(
                  style: ElevatedButton
                      .styleFrom(
                      backgroundColor: Colors.purple.shade300
                  ),
                  onPressed:
                  Long || Lat ? (){Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      PresAttach(widget.customerId, widget.totalPrice, widget.presRequired, lat , long))
                  );}
                      :() {showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text("Please detect your location!", style: TextStyle(fontFamily: 'Lato', fontSize: 20,)),
                        actions: <Widget>[
                          new TextButton(
                            child: const Text("Ok", style: TextStyle(fontFamily: 'Lato', fontSize: 20,fontWeight: FontWeight.w600, color: Colors.black)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );},
                  icon: const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 24,
                  )            )),
              SizedBox(width: 8,)
      ])]),
    ));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();


    return position;
  }
  ///Convert coordinates to address
  Future<Placemark> getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        lat, long);
    Placemark place = placemarks[0];
    return place;
  }
}
