
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:demo_iss_tracker/RouteNames.dart';
import 'package:demo_iss_tracker/services/IssTracker.dart';
import 'package:demo_iss_tracker/utils/AppConfig.dart';
import 'package:demo_iss_tracker/utils/AssetsPath.dart';
import 'package:demo_iss_tracker/utils/Consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  BitmapDescriptor iconMarkerIss;
  BitmapDescriptor iconMarkerMyLocation;

  LatLng _myLocation = AppConfig.DEFAULT_LATLNG;
  bool _centerAtIss = true;
  double _zoom = AppConfig.DEFAULT_ZOOM;

  @override
  void initState() {
    super.initState();

    _getBytesFromAsset(AssetsPath.ICON_ISS, 96).then((value) => iconMarkerIss = BitmapDescriptor.fromBytes(value));
    _getBytesFromAsset(AssetsPath.ICON_MY_LOCATION, 96).then((value) => iconMarkerMyLocation = BitmapDescriptor.fromBytes(value));

    AppConfig().getGoogleMapConfig().then((googleMapConfig) {
      setState(() {
        _myLocation = googleMapConfig.location;
        _centerAtIss = googleMapConfig.isCenterAtIss;
        _zoom = googleMapConfig.zoom;
      });
    });
  }

  Widget _dialButtonLabel(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(const Radius.circular(4.0))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15),),
      ),
    );
  }

  Widget buildSpeedDial() {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: MdiIcons.viewGridOutline,
      activeIcon: Icons.close,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white,
      overlayOpacity: 0.6,
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Theme.of(context).primaryColor,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      childMarginTop: 10,
      children: [
        SpeedDialChild(
          child: Icon(MdiIcons.mapMarkerRadiusOutline),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          labelWidget: _dialButtonLabel('Find my location'),
          onTap: () => _findMyCurrentLocation(),
        ),
        SpeedDialChild(
          child: Icon(!_centerAtIss ? MdiIcons.crosshairsGps : MdiIcons.crosshairsGps),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          labelWidget: _dialButtonLabel(!_centerAtIss ? 'Turn on ISS always center' : 'Turn off ISS always center'),
          onTap: () => setState(() => _centerAtIss = !_centerAtIss),
        ),
      ],
    );
  }

  _showAboutDialog() {
    TextStyle style = TextStyle(fontSize: 16, color: Colors.black87);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsPath.ISS_LARGE, height: 100,),
              ),
              Text('ISS Tracker', style: style.copyWith(fontWeight: FontWeight.bold, fontSize: 20),),
              Text('Version: 1.0', style: style.copyWith(fontSize: 18),),
              SizedBox(height: 10,),
              Text('Author: Adrian Strzelewicz', style: style,),
              Text('Data source: http://open-notify.org/', style: style,),
              SizedBox(height: 10,),
              Text('Source code:', style: style,),
              Row(
                children: [
                  Icon(MdiIcons.github),
                  SizedBox(width: 4,),
                  Text('github.com/strzelba/iss_tracker', style: style,)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              child: Image.asset('assets/graphics/iss_header.png', fit: BoxFit.cover,),
            ),
            ListTile(
              leading: Image.asset('assets/icons/iss.png', width: 24, height: 24,),
              title: Text('Visible passes'),
              onTap: () => Navigator.of(context).pushNamed(RouteNames.VISIBLE_PASSES_PAGE),
            ),
            ListTile(
              leading: Image.asset('assets/icons/astronaut.png', width: 24, height: 24,),
              title: Text('People in space'),
              onTap: () => Navigator.of(context).pushNamed(RouteNames.PEOPLE_IN_SPACE_PAGE),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: _showAboutDialog,
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Iss Tracker'),
      ),
      floatingActionButton: buildSpeedDial(),
      body: StreamProvider<LatLng>.value(
        value: IssTracker().stream,
        child: Consumer<LatLng>(
          builder: (context, issLocation, _) {

            if (issLocation == null)
              return Center(child: Text('Loading ...'));

            Set<Circle> circles = Set.from([
              Circle(
                circleId: CircleId('iss_visibility'),
                center: _myLocation,
                fillColor: Colors.blue.withOpacity(0.3),
                strokeColor: Colors.blue.withOpacity(0.1),
                strokeWidth: 3,
                radius: Consts.KILOMETER_IN_METERS * Consts.ISS_VISIBILITY,),
            ]);

            var markers = <MarkerId, Marker>{};

            var issMarker =  Marker(
                icon: iconMarkerIss,
                markerId: MarkerId('iss'),
                position: issLocation,
            );
            markers[issMarker.markerId] = issMarker;

            var myLocationMarker = Marker(
              icon: iconMarkerMyLocation,
              markerId: MarkerId('myLocation'),
              position: _myLocation,
              anchor: const Offset(0.5, 0.5),
              draggable: true,
              onDragEnd: (location) {
                setState(() => _myLocation = location);
                AppConfig().setMyLastLocation(location);
              });
            markers[myLocationMarker.markerId] = myLocationMarker;

            TextStyle styleLegend = TextStyle(color: Colors.white, fontSize: 12);


            if (_centerAtIss)
              _updateLocationCamera(issLocation);

           return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      GoogleMap(
                        compassEnabled: true,
                        zoomControlsEnabled: false,
                        onMapCreated: _onMapCreated,
                        markers: Set<Marker>.of(markers.values),
                        initialCameraPosition: CameraPosition(
                          target: issLocation,
                          zoom: _zoom,
                        ),

                        circles: circles,
                        onCameraMove: (CameraPosition cameraPosition) {
                          _zoom = cameraPosition.zoom;
                          AppConfig().setZoom(cameraPosition.zoom);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Iss current location:', style: styleLegend.copyWith(fontWeight: FontWeight.bold),),
                                Text('Latitude: ${issLocation.latitude.toStringAsFixed(5)}', style: styleLegend,),
                                Text('Location: ${issLocation.longitude.toStringAsFixed(5)}', style: styleLegend,),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        )
      )
    );
  }

  _findMyCurrentLocation() {
    Geolocator.checkPermission().then((permission) {

      print('permision = $permission');

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        _getCurrentPosition();

      } else {
        //TODO:  request permission
        print('request permision');

        Geolocator.requestPermission().then((permission) {
          if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
            _getCurrentPosition();
          } else {
            //TODO: print permission not granted
          }
        });
      }
    });
  }

  _getCurrentPosition() {
    Geolocator.isLocationServiceEnabled().then((isEnabled) {

      if (isEnabled) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) {
          _myLocation = LatLng(position.latitude, position.longitude);
          AppConfig().setMyLastLocation(_myLocation);
          setState(() {});
          _updateLocationCamera(_myLocation);
        });
      } else {
        Geolocator.openLocationSettings();
      }
    });
  }

  _updateLocationCamera(LatLng newLocation) async {
    final GoogleMapController controller = await _controller.future;

    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 0,
        target: newLocation,
        zoom: _zoom
    )));
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }
}