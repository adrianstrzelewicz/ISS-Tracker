
import 'package:demo_iss_tracker/model/VisiblePass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:sprintf/sprintf.dart';

class VisiblePassWidget extends StatelessWidget {

  final VisiblePass visiblePass;

  VisiblePassWidget(this.visiblePass);

  TextStyle dateTimeStyle = TextStyle(fontSize: 12, color: Colors.black54);

  DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  DateFormat timeFormat = DateFormat('hh:mm:ss');

  Widget _time(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    
    return Column(
      children: [
        Text(timeFormat.format(dateTime), style: dateTimeStyle,),
        Text(dateFormat.format(dateTime), style: dateTimeStyle,)
      ],
    );
  }

  String _durationInMinutes() {
    int minutes = visiblePass.duration ~/ 60;
    int restSeconds = visiblePass.duration % 60;

    return sprintf('%02d:%02d', [minutes, restSeconds]);
  }

  @override
  Widget build(BuildContext context) {
    double issSize = 32;

    var dot = Icon(Icons.brightness_1, size: 3, color: Colors.grey,);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
      child: Card(
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('START', style: dateTimeStyle.copyWith(fontWeight: FontWeight.w900),),
                      _time(visiblePass.risetime),
                    ],
                  ),
                  dot, dot, dot, dot,
                  Image.asset('assets/icons/iss.png', width: issSize, height: issSize, color: Colors.black87,),
                  dot, dot, dot, dot,
                  Column(
                    children: [
                      Text('END', style: dateTimeStyle.copyWith(fontWeight: FontWeight.w900),),
                      _time(visiblePass.endTime),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.black38,
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  Text('Duration: ', style: dateTimeStyle,),
                  Text(_durationInMinutes(), style: dateTimeStyle.copyWith(fontWeight: FontWeight.w600),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}