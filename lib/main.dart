import 'package:demo_iss_tracker/model/IssLocation.dart';
import 'package:demo_iss_tracker/pages/HomePage.dart';
import 'package:demo_iss_tracker/pages/PeopleInSpacePage.dart';
import 'package:demo_iss_tracker/pages/VisiblePassesPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'RouteNames.dart';

Future<void> main() async {

  runApp(MultiProvider(
    providers: [
        ChangeNotifierProvider<IssLocation>(create: (_) => IssLocation(),)
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iss Tracker',
      initialRoute: RouteNames.HOME_PAGE,
      routes: {
        RouteNames.HOME_PAGE: (_) => HomePage(),
        RouteNames.VISIBLE_PASSES_PAGE: (_) => VisiblePassesPage(),
        RouteNames.PEOPLE_IN_SPACE_PAGE: (_) => PeopleInSpacePage(),
      },
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primaryColor: Color(Colors.blue[700].value),
        primaryColorDark: Color(Colors.blue[800].value),
        accentColor: Colors.orangeAccent,
        primarySwatch: Colors.blue,
      ),
    ),
  ));
}
