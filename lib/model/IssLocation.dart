
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IssLocation extends ChangeNotifier {
  LatLng _current = LatLng(0,0);

  LatLng get current => _current;

  setCurrent(LatLng latLng) {
    _current = latLng;
    notifyListeners();
  }
}