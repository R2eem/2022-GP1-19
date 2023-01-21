import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled/Cart.dart';
import 'package:untitled/ChooseLocation.dart';
import 'PresAttach.dart';
import 'common/theme_helper.dart';


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
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.purple.shade300 ,
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
          // getAddress(lat,long);
        },
        label: const Text("Current Location",style: TextStyle(fontFamily: 'Lato',
          fontSize: 17,),),
        icon: const Icon(Icons.location_history ,),
      ),

      persistentFooterButtons: [
        CircleAvatar(
            backgroundColor: Colors.purple.shade300,
            child: IconButton(
              onPressed: (){
                Navigator.push( context, MaterialPageRoute( builder: (context) => CartPage(widget.customerId), ));
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.white,
                size: 20,
              ),
            )),
        SizedBox(width: 50,),
        Container(
            child:
            ElevatedButton.icon(
              style: ThemeHelper().buttonStyle(),
              onPressed: (){
                Navigator.push( context, MaterialPageRoute( builder: (context) => ChooseLocation(widget.customerId, widget.totalPrice, widget.presRequired), ));
              },

              icon: Icon(Icons.location_on ,color: Colors.white,), label: Text('Saved Locations', style: TextStyle(fontFamily: 'Lato',fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),
            )),

        SizedBox(width:32,),
        CircleAvatar(
            backgroundColor: Colors.purple.shade300,
            child: IconButton(
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
                );} ,
                icon: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.white,
                  size: 20,
                ))),
      ],

    );
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
}