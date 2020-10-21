import 'package:flutter/material.dart';
import 'package:tasktracker/taskpage.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.red),
    debugShowCheckedModeBanner: false,
    home:MyApp(),

  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TaskPage(),
    );
  }
}