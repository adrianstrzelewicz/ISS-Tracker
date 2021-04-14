
import 'package:demo_iss_tracker/model/Astronaut.dart';
import 'package:demo_iss_tracker/utils/AssetsPath.dart';
import 'package:flutter/material.dart';

class AstronautInSpaceWidget extends StatelessWidget {

  final Astronaut astronaut;

  AstronautInSpaceWidget({this.astronaut});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 72,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(AssetsPath.ICON_ASTRONAUT, width: 40, height: 40,),
            ),
            Expanded(child: Text(astronaut.name, style: TextStyle(fontSize: 18),)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetsPath.ICON_ISS, width: 20, height: 20, ),
                  SizedBox(height: 2,),
                  Text(astronaut.craft, style: TextStyle(fontSize: 12),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}