import 'package:flutter/material.dart';
import 'package:flutter_liste_voeux/widgets/home_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeController(title: 'Liste de souhaits'),
    );
  }
}
