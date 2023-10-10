// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:on_off/api/api_services.dart';

class ApiRepository {
  final API = ApiService();

  // Call API to turn ON/OFF
  Future<void> changeSwitch(light) async {
    try {
      final responseChange = await API.changeSwitch(light);
      if (responseChange.statusCode != 200) {
        print(
            'Erro ao se comunicar com o servidor. Status code: ${responseChange.statusCode}');
      }
    } catch (e) {
      print('Ocorreu um erro: $e');
    }
  }

  // Call API to get characteristics about Device
  Future<List<Map<String, dynamic>>> aboutDevice() async {
    try {
      final response =
          await API.aboutDevice().timeout(const Duration(seconds: 7));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
      } else {
        print(
            'Erro ao se comunicar com o servidor. Status code: ${response.statusCode}');
        return [];
      }
    } on TimeoutException catch (e) {
      print('Ocorreu um erro: $e');
      return [];
    } catch (e) {
      print('Ocorreu um erro: $e');
      return [];
    }
  }

  Future<void> refreshList() => aboutDevice();
}
