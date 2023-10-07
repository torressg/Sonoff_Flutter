import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:on_off/constants/AppColors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  List<String> statusSwitches = [];

  // Call API to turn ON/OFF
  Future<void> changeSwitch(light) async {
    final responseChange = await http
        .get(Uri.parse('http://${dotenv.env['IP']}:7777/toggle/$light'));
  }

  // Call API to get Quantity
  Future<void> qttSwitch() async {
    final response = await http
        .get(Uri.parse('http://${dotenv.env['IP']}:7777/1000ba1e43/quantity'));
    await Future.delayed(Duration(seconds: 2));
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
        .get(Uri.parse('http://${dotenv.env['IP']}:7777/status/1000ba1e43'));
    if (responseName.statusCode == 200) {
      var decodeResponse = jsonDecode(responseName.body) as List;
      setState(() {
        // Getting name os switches
        nameLight =
            decodeResponse.map((item) => item['Nome'] as String).toList();
        // Getting switches quantity
        responseQtt = decodeResponse.length;
        // Getting status switches
        statusSwitches =
            decodeResponse.map((item) => item['switch'] as String).toList();
      });
    } else {
      print('Failed to load data. Status code: ${responseName.statusCode}');
    }
  }

  Future<void> refreshList() => qttSwitch();

  @override
  initState() {
    super.initState();
    aboutDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('On | Off'),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryColor,
        backgroundColor: AppColors.backgroundColor,
        onRefresh: aboutDevice,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: responseQtt == 0
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: responseQtt,
                    itemBuilder: (BuildContext ctx, index) {
                      return ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primaryColor)),
                        onPressed: () async {
                          await changeSwitch(
                              (nameLight[index]).replaceAll(RegExp('á'), 'a'));
                          setState(() {
                            if (statusSwitches[index] == 'on') {
                              statusSwitches[index] = 'off';
                            } else if (statusSwitches[index] == 'off') {
                              statusSwitches[index] = 'on';
                            }
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: statusSwitches[index] == 'on'
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
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: statusSwitches[index] == 'on'
                                  ? Text(
                                      'Ativada',
                                      style: TextStyle(fontSize: 10),
                                    )
                                  : Text(
                                      'Desativada',
                                      style: TextStyle(fontSize: 10),
                                    ),
                            ),
                          ],
                        ),
                      );
                    }),
          ),
        ),
      ),
    );
  }
}
