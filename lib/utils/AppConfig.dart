
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConfig extends ChangeNotifier {

  static const SHARED_PREF_MY_LAST_LOCATION_LATITUDE = 'pref_my_last_location_latitude';
  static const SHARED_PREF_MY_LAST_LOCATION_LONGITUDE = 'pref_my_last_location_longitude';
  static const SHARED_PREF_CENTER_AT_ISS = 'pref_center_at_iss';
  static const SHARED_PREF_ZOOM = 'pref_zoom';

  static const double DEFAULT_LATITUDE = 51.507379;
  static const double DEFAULT_LONGITUDE = -0.127484;
  static const double DEFAULT_ZOOM = 6.5;
  static const bool DEFAULT_CENTER_AT_ISS = true;
  static const LatLng DEFAULT_LATLNG = LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE);

  Future<double> getZoom() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(SHARED_PREF_ZOOM) ?? DEFAULT_ZOOM;
  }

  Future setZoom(double zoom) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(SHARED_PREF_ZOOM, zoom);
    notifyListeners();
  }

  Future<LatLng> getMyLastLocation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    double latitude = sharedPreferences.getDouble(SHARED_PREF_MY_LAST_LOCATION_LATITUDE) ?? DEFAULT_LATITUDE;
    double longitude = sharedPreferences.getDouble(SHARED_PREF_MY_LAST_LOCATION_LONGITUDE) ?? DEFAULT_LONGITUDE;
    return LatLng(latitude, longitude);
  }

  Future setMyLastLocation(LatLng location) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setDouble(SHARED_PREF_MY_LAST_LOCATION_LATITUDE, location.latitude);
    sharedPreferences.setDouble(SHARED_PREF_MY_LAST_LOCATION_LONGITUDE, location.longitude);
    notifyListeners();
  }

  Future<bool> isCenterAtIss() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(SHARED_PREF_CENTER_AT_ISS) ?? DEFAULT_CENTER_AT_ISS;
  }

  Future setCenterAtIss(bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(SHARED_PREF_CENTER_AT_ISS, value);
    notifyListeners();
  }

  Future<GoogleMapConfig> getGoogleMapConfig() async {
    return GoogleMapConfig(
        zoom: await getZoom(),
        location: await getMyLastLocation(),
        isCenterAtIss: await isCenterAtIss(),
    );
  }
}

class GoogleMapConfig {
  double zoom;
  LatLng location;
  bool isCenterAtIss;

  GoogleMapConfig({this.zoom, this.location, this.isCenterAtIss});
}