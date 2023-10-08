// ignore_for_file: avoid_print

import 'dart:async';
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
  bool errorLoad = false;

  // Call API to turn ON/OFF
  Future<void> changeSwitch(light) async {
    try {
      final responseChange = await http
          .get(Uri.parse('http://${dotenv.env['IP']}:7777/toggle/$light'));
      if (responseChange.statusCode != 200) {
        print(
            'Erro ao se comunicar com o servidor. Status code: ${responseChange.statusCode}');
      }
    } catch (e) {
      print('Ocorreu um erro: $e');
    }
  }

  // Call API to get Quantity
  Future<void> qttSwitch() async {
    final response = await http
        .get(Uri.parse('http://${dotenv.env['IP']}:7777/1000ba1e43/quantity'));
    await Future.delayed(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      setState(() {
        responseQtt = int.parse(response.body);
      });
    } else {
      print(
          'Erro ao se comunicar com o servidor. Status code: ${response.statusCode}');
    }
  }

  // Call API to get characteristics about Device
  Future<void> aboutDevice() async {
    try {
      final responseName = await http
          .get(Uri.parse('http://${dotenv.env['IP']}:7777/status/1000ba1e43'))
          .timeout(const Duration(seconds: 7));
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
        print(
            'Erro ao se comunicar com o servidor. Status code: ${responseName.statusCode}');
      }
    } on TimeoutException catch (e) {
      errorLoad = true;
      responseQtt = 0;
      print('Ocorreu um erro: $e');
      setState(() {});
    } catch (e) {
      print('Ocorreu um erro: $e');
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
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: errorLoad
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Ocorreu um erro para se conectar.",
                        style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            errorLoad = false;
                          });
                          aboutDevice();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                AppColors.primaryColor)),
                        child: Container(
                            height: 30,
                            width: 120,
                            alignment: Alignment.center,
                            child: const Text(
                              "Tentar novamente",
                              style: TextStyle(fontSize: 14),
                            )),
                      )
                    ],
                  )
                : responseQtt == 0
                    ? const Center(
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.primaryColor)),
                            onPressed: () async {
                              try {
                                await changeSwitch((nameLight[index])
                                  .replaceAll(RegExp('á'), 'a')).timeout(const Duration(seconds: 7));
                                setState(() {
                                  if (statusSwitches[index] == 'on') {
                                    statusSwitches[index] = 'off';
                                  } else if (statusSwitches[index] == 'off') {
                                    statusSwitches[index] = 'on';
                                  }
                                });
                              } on TimeoutException catch (e) {
                                print('Ocorreu um erro: $e');
                                final snackBar = SnackBar(
                                  content: Text('Ocorreu um erro, tente novamente ou recarregue a página.'),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                
                              }
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: statusSwitches[index] == 'on'
                                      ? const Icon(size: 50, Icons.lightbulb)
                                      : const Icon(
                                          size: 50, Icons.lightbulb_outlined),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Luz ${nameLight[index]}',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: statusSwitches[index] == 'on'
                                      ? const Text(
                                          'Ativada',
                                          style: TextStyle(fontSize: 10),
                                        )
                                      : const Text(
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
