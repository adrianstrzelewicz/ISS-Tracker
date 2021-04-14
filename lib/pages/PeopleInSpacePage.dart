
import 'package:demo_iss_tracker/custom_widgets/AstronautInSpaceWidget.dart';
import 'package:demo_iss_tracker/model/Astronaut.dart';
import 'package:demo_iss_tracker/utils/PeopleInSpaceDownloader.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PeopleInSpacePage extends StatefulWidget {

  PeopleInSpacePage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _PeopleInSpacePage createState() => _PeopleInSpacePage();
}

class _PeopleInSpacePage extends State<PeopleInSpacePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People in space'),
      ),
      body: FutureBuilder(
        future: PeopleInSpaceDownloader().download(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            List<Astronaut> astronauts = snapshot.data;

            return ListView.builder(
                itemCount: astronauts.length,
                itemBuilder: (context, index) {
                  return AstronautInSpaceWidget(astronaut: astronauts[index],);
                },);
          }

          return Center(
              child: Text('Loading ...'),);
        },
      ),
    );
  }
}