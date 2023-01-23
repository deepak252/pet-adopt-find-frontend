import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/utils/location_utils.dart';
import 'package:adopt_us/widgets/custom_elevated_button.dart';
import 'package:adopt_us/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapScreen extends StatefulWidget {
  final double? lat,lng;
  const GoogleMapScreen({Key? key, this.lat,this.lng}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  // late CameraPosition initialCameraPosition;

  Set<Marker> markersList = {};
  double latitude =28.5950;
  double longitude = 77.0193;
  late GoogleMapController googleMapController;
  @override
  void initState() {

    markersList.add(Marker(
        markerId: const MarkerId('0'),
        position: LatLng(widget.lat??latitude, widget.lng??longitude)));
    
    super.initState();
  }


  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // key: homeScaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(
                widget.lat??latitude, widget.lng?? longitude
              ), zoom: 14.0),
              markers: markersList,
              mapType: MapType.normal,
              // myLocationEnabled: true,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {

                googleMapController = controller;
              },
              onTap: (LatLng latlng) {
                // log('dragEndPosition :::${latlng.latitude}');
                markersList.clear();
                markersList.add(Marker(
                    markerId: const MarkerId("0"),
                    position: LatLng(latlng.latitude, latlng.longitude),
                    // draggable: true,
                    // onDrag: (dragEndPosition) {

                    //   // setState(() {
                    //   //   latitude = dragEndPosition.latitude;
                    //   //   longitude = dragEndPosition.longitude;
                    //   // });
                    //   log('dragEndPosition :::$latitude');
                    //   }
                  )
                );
                latitude=latlng.latitude;
                longitude=latlng.longitude;
                setState((){});
                // setState(() {
                //   latitude = latlng.latitude;
                //   longitude = latlng.longitude;
                // });
              },
            ),
            Positioned(
              bottom: 120,
              right: 20,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () async {
                  Position position = await LocationUtils.getGeoLocationPosition();

                  googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14)));

                  markersList.clear();

                  markersList.add(Marker(
                      markerId: const MarkerId('0'),
                      position: LatLng(position.latitude, position.longitude)));
                  latitude=position.latitude;
                  longitude=position.longitude;
                  setState((){});
                  // setState(() {
                  //   latitude = position.latitude;
                  //   longitude = position.longitude;
                  // });

                  // print('dragEndPosition :::$latitude');
                },
                // backgroundColor: ColorPalette.primaryColor,
                child: const Icon(Icons.my_location_outlined),
              ),
            ),

            // Positioned(
            //   top: 20,
            //   right: 20,
            //   left: 20,
            //   child: FloatingActionButton(
            //     heroTag: null,
            //     backgroundColor: Colors.transparent,
            //     // onPressed: _handlePressButton,
            //     onPressed: (){
                  
            //     },
            //     child: Container(
            //       height: 55,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(15),
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(0.5),
            //             spreadRadius: 5,
            //             blurRadius: 7,
            //             offset: Offset(0, 3), // changes position of shadow
            //           ),
            //         ],
            //       ),
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 15),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               'Search',
            //               style: TextStyle(
            //                   fontSize: 16, color: Themes.colorPrimary),
            //             ),
            //             Icon(Icons.search, color: Themes.colorPrimary)
            //           ],
            //         ),
            //       ),
            //     ),
            //     // Icon(Icons.search)
            //   ),
            // ),

            Positioned(
              bottom: 35,
              right: 20,
              left: 20,
              child: CustomElevatedButton(
                onPressed: (){
                  if(latitude==null || longitude==null){
                    CustomSnackbar.error(error: "Please select location!");
                    return;
                  }
                  Navigator.pop(context,[latitude,longitude]);
                 
                },
                text: "Confirm",
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _handlePressButton() async {
  //   Prediction? p = await PlacesAutocomplete.show(
  //     context: context,
  //     apiKey: kGoogleApiKey,
  //     onError: onError,
  //     mode: _mode,
  //     language: 'en',
  //     strictbounds: false,
  //     types: [""],
  //     components: [Component(Component.country, 'in')],
  //     decoration: InputDecoration(
  //         hintText: 'Search',
  //         focusedBorder: OutlineInputBorder(
  //             borderRadius: BorderRadius.circular(20),
  //             borderSide: BorderSide(color: Colors.white))),
  //   );

  //   displayPrediction(p!, homeScaffoldKey.currentState);
  // }

  // void onError(PlacesAutocompleteResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(response.errorMessage!),
  //     ),
  //   );
  // }

  // Future<void> displayPrediction(
  //     Prediction p, ScaffoldState? currentState) async {
  //   GoogleMapsPlaces places = GoogleMapsPlaces(
  //       apiKey: kGoogleApiKey,
  //       apiHeaders: await const GoogleApiHeaders().getHeaders());

  //   PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

  //   final lat = detail.result.geometry!.location.lat;
  //   final lng = detail.result.geometry!.location.lng;

  //   markersList.clear();
  //   markersList.add(Marker(
  //       markerId: const MarkerId("0"),
  //       position: LatLng(lat, lng),
  //       draggable: true,
  //       onDrag: (dragEndPosition) {
  //         setState(() {
  //           latitude = dragEndPosition.latitude;
  //           longitude = dragEndPosition.longitude;
  //         });
  //         log("dragEndPosition : ${dragEndPosition}");
  //       },
  //       infoWindow: InfoWindow(title: detail.result.name)));

  //   setState(() {
  //     latitude = lat;
  //     longitude = lng;
  //   });

  //   googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  // }
}