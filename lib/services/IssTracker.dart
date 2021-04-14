

import 'dart:async';
import 'dart:convert';

import 'package:demo_iss_tracker/model/IssLocation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class IssTracker {

  // ignore: close_sinks
  final _controller = StreamController<LatLng>();

  int debugCounter = 0;

  IssTracker() {
    Timer.periodic(Duration(seconds: 2), (t) async {

      //TODO fill iss location here

//      try {
//        DateTime lastDownloaded = await AppConfig().getLastDownloadSbsContact();
//        DateTime now = DateTime.now();
//        Duration difference = now.difference(lastDownloaded);
//
//        if (difference.inMicroseconds < 1) {
//          File file = await _getFile;
//          if (await file.exists()) {
//      String htmlFile = await file.readAsString();
//      return _convertHtmlFileToList(htmlFile);
//      }
//      }
//
//      var url = 'http://www.epwa-spotters.pl/SbsContacts';
//      var response = await http.get(url);
//
//      if (response.statusCode == 200) {
//
//      // Saving file here
//      File file = await _getFile;
//      await file.writeAsString(response.body, flush: true);
//      await AppConfig().setLastDownloadSbsContact(DateTime.now());
//      return _convertHtmlFileToList(response.body);
//      }
//      } on Exception catch (_)  {
//      return getSbsContactsExample();
//      }

    try {
      var url = 'http://api.open-notify.org/iss-now.json';
      var response =  await http.get(url);

      if (response.statusCode == 200) {
        //print(response.body);
        Map<String, dynamic> issNow = jsonDecode(response.body);
        //Map<String, dynamic> issLocation = issNow['iss_position'];

        LatLng location = LatLng(double.parse(issNow['iss_position']['latitude']),
                                 double.parse(issNow['iss_position']['longitude']));


        _controller.sink.add(location);
      }


    } on Exception catch(_) {

    }

      //debugCounter++;
      //_controller.sink.add(LatLng(debugCounter.toDouble(), debugCounter.toDouble()));
    });
  }

  Stream<LatLng> get stream => _controller.stream;
}

//void _stream() async {
//  Duration interval = Duration(seconds: 1);
//  Stream<int> stream = Stream.periodic(interval, (data) => data);
// // Stream = stream. take (10); // Specify the number of events sent
//  await for(int i in stream ){
//    print(i);
//  }
//}