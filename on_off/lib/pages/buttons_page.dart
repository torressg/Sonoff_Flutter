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
  int responseQtt = 0;

  // Call API to turn ON/OFF
  Future<void> changeSwitch(light) async {
    final responseChange =
        await http.get(Uri.parse('http://192.168.0.209:7777/toggle/$light'));
    print('http://192.168.0.209:7777/toggle/$light');
  }

  // Call API to get Quantity
  Future<void> qttSwitch() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.209:7777/1000ba1e43/quantity'));
    if (response.statusCode == 200) {
      setState(() {
        responseQtt = int.parse(response.body);
      });
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }
  }

  // Call API to get characteristics about Device
  Future<void> aboutDevice() async {
    final responseName = await http
        .get(Uri.parse('http://192.168.0.209:7777/status/1000ba1e43'));
    if (responseName.statusCode == 200) {
      var decodeResponse = jsonDecode(responseName.body) as List;
      setState(() {
        // Getting name os switches
        nameLight =
            decodeResponse.map((item) => item['Nome'] as String).toList();
        // Getting switches quantity
        responseQtt = decodeResponse.length;
      });
    } else {
      print('Failed to load data. Status code: ${responseName.statusCode}');
    }
  }

  @override
  initState() {
    super.initState();
    print(myJsonList);
    aboutDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On | Off'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: responseQtt == 0
            ? Center(child: CircularProgressIndicator(),) 
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: responseQtt,
                itemBuilder: (BuildContext ctx, index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        changeSwitch(
                            (nameLight[index]).replaceAll(RegExp('á'), 'a'));
                        lightIsOn[index] = !lightIsOn[index];
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: lightIsOn[index]
                              ? Icon(size: 50, Icons.lightbulb)
                              : Icon(size: 50, Icons.lightbulb_outlined),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Luz ' + nameLight[index],
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
