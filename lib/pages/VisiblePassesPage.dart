
import 'package:demo_iss_tracker/custom_widgets/VisiblePassWidget.dart';
import 'package:demo_iss_tracker/model/VisiblePass.dart';
import 'package:demo_iss_tracker/utils/VisiblePasssesDownloader.dart';
import 'package:flutter/material.dart';

class VisiblePassesPage extends StatefulWidget {

  VisiblePassesPage({Key key, this.title,}) : super(key: key);
  final String title;

  @override
  _VisiblePassesPage createState() => _VisiblePassesPage();
}

class _VisiblePassesPage extends State<VisiblePassesPage> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visible passes'),
      ),
      body: FutureBuilder(
        future: VisiblePassesDownloader().download(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {

            List<VisiblePass> passes = snapshot.data;

            return ListView.builder(
              itemCount: passes.length,
              itemBuilder: (context, index) {
                return VisiblePassWidget(passes[index]);
              },);
          }

          return Center(
            child: Text('Loading ...'),);
        },
      ),
    );
  }
}