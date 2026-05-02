import 'package:geolocator/geolocator.dart';
import "dart:io";



Future<Position> determinePosition () async{
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if(!serviceEnabled){
    return Future.error("Location services are disabled");
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied){
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied){
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever){
    return Future.error("Location permissions are permanently denied, we cannot request permissions");
  }

  return await Geolocator.getCurrentPosition(
    locationSettings: Platform.isAndroid
        ? AndroidSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    )
        : AppleSettings(
      accuracy: LocationAccuracy.medium,
      timeLimit: const Duration(seconds: 10),
    ),
  );
}

