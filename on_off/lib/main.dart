import 'package:flutter/material.dart';
import 'package:on_off/pages/buttons_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.grey[900]),
      home: ButtomPage()
    );
  }
}
