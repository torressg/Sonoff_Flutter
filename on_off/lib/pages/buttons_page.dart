import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ButtomPage extends StatefulWidget {
  const ButtomPage({super.key});

  @override
  State<ButtomPage> createState() => _ButtomPageState();
}

class _ButtomPageState extends State<ButtomPage> {
  List<dynamic>? myJsonList;

  // Call API to turn ON/OFF
  Future<void> changeSwitch() async {
    final responseChange =
        await http.get(Uri.parse('http://192.168.0.209:7777/toggle/Armario'));
    print(responseChange.toString());
  }
  // Call API to get Quantity
  Future<http.Response> countSwitch() async {
    final responseQtt = 
    await http.get(Uri.parse('http://192.168.0.209:7777/status/1000ba1e43'));
    print(responseQtt);
    return responseQtt;
  }

  @override
  initState() {
    super.initState();
    countSwitch().then((http.Response res) {
      setState(() {
        myJsonList = jsonDecode(res.body);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On | Off'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: myJsonList?.length,
              itemBuilder: (BuildContext ctx, index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: 
                        // lightIsOn ? Icon(size: 50,Icons.lightbulb) : 
                        Icon(size: 50,Icons.lightbulb_outlined),
                      ),
                      SizedBox(height: 5,),
                      Container(alignment: Alignment.center,
                      child: Text('Luz Armário'),)
                    ],
                  ),
                );
              }),
      ),    );
  }
}
