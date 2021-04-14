
import 'dart:convert';

import 'package:demo_iss_tracker/model/VisiblePass.dart';
import 'package:demo_iss_tracker/utils/AppConfig.dart';
import 'package:http/http.dart' as http;

class VisiblePassesDownloader {

  Future<List<VisiblePass>> download({int numberOfPasses = 10}) async {
    try {
      var location = await AppConfig().getMyLastLocation();
      var url = 'http://api.open-notify.org/iss-pass.json?lat=${location.latitude}&lon=${location.longitude}&n=$numberOfPasses';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> passes = jsonDecode(response.body);


        List<VisiblePass> visiblePasses = List<VisiblePass>
            .from(passes['response']
            .map((model)=> VisiblePass.fromJson(model)));

        return visiblePasses;
      }

    } on Exception catch(_) {

    }

    return List();
  }
}