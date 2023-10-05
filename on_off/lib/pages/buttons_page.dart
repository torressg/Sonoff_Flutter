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
  List<bool> lightIsOn = [false, false, false];
  List<String> nameLight = [];

  // Call API to turn ON/OFF
  Future<void> changeSwitch() async {
    final responseChange =
        await http.get(Uri.parse('http://172.22.111.250:7777/toggle/Armario'));
  }
  // Call API to get Quantity
  Future<http.Response> statusSwitch() async {
    final responseQtt = 
    await http.get(Uri.parse('http://172.22.111.250:7777/status/1000ba1e43'));
    return responseQtt;
  }

  void catchName() {
    statusSwitch().then((http.Response response){
      var decodeResponse = jsonDecode(response.body) as List;
      setState(() {
        nameLight = decodeResponse.map((item) => item['Nome'] as String).toList();
      });
    });
  }

  @override
  initState() {
    super.initState();
    statusSwitch().then((http.Response res) {
      setState(() {
        catchName();
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: myJsonList?.length ?? 0,
              itemBuilder: (BuildContext ctx, index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // changeSwitch();
                      lightIsOn[index] = !lightIsOn[index];
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: 
                        lightIsOn[index] ? Icon(size: 50,Icons.lightbulb) : 
                        Icon(size: 50,Icons.lightbulb_outlined),
                      ),
                      SizedBox(height: 5,),
                      Container(alignment: Alignment.center,
                      child: Text('Luz ' + nameLight[index], style: TextStyle(fontSize: 15),),)
                    ],
                  ),
                );
              }),
      ),    );
  }
}
