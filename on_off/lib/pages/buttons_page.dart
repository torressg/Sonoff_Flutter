import 'package:flutter/material.dart';

class ButtomPage extends StatefulWidget {
  const ButtomPage({super.key});

  @override
  State<ButtomPage> createState() => _ButtomPageState();
}

class _ButtomPageState extends State<ButtomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On | Off'),),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: ElevatedButton(
            onPressed: () {}, child: Icon(Icons.lightbulb_outlined)),
      ),
    );
  }
}
