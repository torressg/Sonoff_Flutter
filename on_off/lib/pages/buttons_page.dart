import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtomPage extends StatefulWidget {
  const ButtomPage({super.key});

  @override
  State<ButtomPage> createState() => _ButtomPageState();
}

class _ButtomPageState extends State<ButtomPage> {
  Future<void> changeSwitch() async {
    final response = await http.get(Uri.parse(
      'http://192.168.0.209:7777/toggle/Armario'
    ));
    print(response.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On | Off'),),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: ElevatedButton(
            onPressed: () async { await changeSwitch();}, child: Icon(Icons.lightbulb_outlined)),
      ),
    );
  }
}
