import 'dart:developer';

import 'package:adopt_us/models/geo_location.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationUtils{

  static Future checkPermissions()async{
    LocationPermission permission =  await Geolocator.requestPermission();
    
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.unableToDetermine) {
      return Future.error( "Couldn't determine location");
    }

  }

  static Future<Position> getGeoLocationPosition() async {
   
    final res=await checkPermissions();
    if(res!=null){
      return res; // throw error
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  static Future<GeoLocation> getAddressFromCoordinaties(double latitude, double longitude) async {
    List<Placemark> placemarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(latitude, longitude);

    Placemark place = placemarks[0];
    GeoLocation location = GeoLocation(
      name: place.name??'',
      sublocality: place.subLocality??'',
      city: place.locality ?? '',
      country: place.country ?? '',
      state: place.administrativeArea ?? '',
      pincode: place.postalCode??'',
      latitude: latitude.toPrecision(4), 
      longitude: longitude.toPrecision(4), 
    );
    return location;
  }

  //Get device location
  static Future<GeoLocation?> getCurrentLocation() async {
    try {
      Position position = await getGeoLocationPosition();
      // final location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
      final location = await getAddressFromCoordinaties(
        position.latitude,
        position.longitude
      );
      return location;
    } on Exception catch (e,s) {
      log("Error : LocationService-> getCurrentLocation,", error:  e,stackTrace: s);
      return Future.error(e);
    }
  }


  static double distanceInMetres(double lat1,double lng1,double lat2,double lng2){
    return double.parse(Geolocator.distanceBetween(lat1, lng1, lat2, lng2).toStringAsFixed(4));
  }
}

// import 'dart:developer';

// import 'package:adopt_us/models/location.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// class LocationUtils{
//   static Future<Position> getGeoLocationPosition() async {
//     LocationPermission permission;

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   static Future<LocationModel> getAddressFromCoordinaties(double latitude, double longitude) async {
//     List<Placemark> placemarks = await GeocodingPlatform.instance
//         .placemarkFromCoordinates(latitude, longitude);

//     Placemark place = placemarks[0];
//     LocationModel location = LocationModel(
//       name: place.name??'',
//       sublocality: place.subLocality??'',
//       city: place.locality ?? '',
//       country: place.country ?? '',
//       state: place.administrativeArea ?? '',
//       pincode: place.postalCode??'',
//       latitude: latitude.toPrecision(4), 
//       longitude: longitude.toPrecision(4), 
//     );
//     return location;
//   }

//   //Get device location
//   static Future<LocationModel?> getCurrentLocation() async {
//     try {
//       Position position = await getGeoLocationPosition();
//       // final location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
//       final location = await getAddressFromCoordinaties(
//         position.latitude,
//         position.longitude
//       );
//       return location;
//     } on Exception catch (e,s) {
//       log("Error : LocationUtils-> getCurrentLocation,", error:  e,stackTrace: s);
//       return Future.error(e);
//     }
//   }

// }


// // Future<_LocationModel> getCurrentCity() async {
// //     Position position = await _getGeoLocationPosition();
// //     final location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
// //     _LocationModel address = await getAddressFromLatLong(position);
// //     return address;
// //   }


// // .getAddressFromCoordinaties(
// //                     latlong[0], latlong[1]);


// // final loc = await LocationService.getCurrentLocation();