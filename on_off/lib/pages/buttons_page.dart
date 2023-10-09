// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:on_off/constants/AppColors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:on_off/repositories/api_repository.dart';

class ButtomPage extends StatefulWidget {
  const ButtomPage({super.key});

  @override
  State<ButtomPage> createState() => _ButtomPageState();
}

class _ButtomPageState extends State<ButtomPage> {
  final apiRepository = ApiRepository();
  List<dynamic>? myJsonList;
  List<bool> lightIsOn = [false, false, false];
  List<String> nameLight = [];
  int responseQtt = 0;
  List<String> statusSwitches = [];
  bool errorLoad = false;

  // Call API to turn ON/OFF
  Future<void> changeSwitch(light) async {
    await apiRepository.changeSwitch(light);
  }

  // Call API to get characteristics about Device
  Future<void> aboutDevice() async {
    final response = await apiRepository.aboutDevice();
    if (response.isNotEmpty) {
      setState(() {
        // Getting name os switches
        nameLight = response.map((item) => item['Nome'] as String).toList();
        // Getting switches quantity
        responseQtt = response.length;
        // Getting status switches
        statusSwitches =
            response.map((item) => item['switch'] as String).toList();
      });
    } else {
      setState(() {
        errorLoad = true;
        responseQtt = 0;
      });
    }
  }

  Future<void> refreshList() => aboutDevice();

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
        onRefresh: refreshList,
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
                                        .replaceAll(RegExp('á'), 'a'))
                                    .timeout(const Duration(seconds: 7));
                                setState(() {
                                  if (statusSwitches[index] == 'on') {
                                    statusSwitches[index] = 'off';
                                  } else if (statusSwitches[index] == 'off') {
                                    statusSwitches[index] = 'on';
                                  }
                                });
                              } on TimeoutException catch (e) {
                                print('Ocorreu um erro: $e');
                                const snackBar = SnackBar(
                                  content: Text(
                                      'Ocorreu um erro, tente novamente ou recarregue a página.'),
                                  duration: Duration(seconds: 2),
                                );
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
