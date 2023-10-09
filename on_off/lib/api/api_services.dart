import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  // Call API to turn ON/OFF
  Future<http.Response> changeSwitch(light) async {
    return await http.get(Uri.parse('http://${dotenv.env['IP']}:7777/toggle/$light'));
  }

  // Call API to get characteristics about Device
    Future<http.Response> aboutDevice() async {
      return await http
          .get(Uri.parse('http://${dotenv.env['IP']}:7777/status/1000ba1e43'));
    }

  Future<http.Response> refreshList() => aboutDevice();
}
