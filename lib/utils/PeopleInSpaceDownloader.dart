
import 'dart:convert';

import 'package:demo_iss_tracker/model/Astronaut.dart';
import 'package:http/http.dart' as http;

class PeopleInSpaceDownloader {

  Future<List<Astronaut>> download() async {
    try {
      var url = 'http://api.open-notify.org/astros.json';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> peopleInSpace = jsonDecode(response.body);
        print(peopleInSpace);

        List<Astronaut> astronauts = List<Astronaut>
            .from(peopleInSpace['people']
            .map((model)=> Astronaut.fromJson(model)));

        return astronauts;
      }

    } on Exception catch(_) {

    }

    return List();
  }
}