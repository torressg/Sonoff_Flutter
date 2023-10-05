import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:on_off/models/Device.dart';

class DeviceRepository {
  final String baseUrl;

  DeviceRepository({required this.baseUrl});

  Future<List<Device>> fetchDevices() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> deviceJson = json.decode(response.body);
      return deviceJson.map((json) => Device.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar dispositivos');
    }
  }

  Future<void> toggleDevice(String id) async {
    // Implemente a lógica para alternar o estado do dispositivo aqui
  }
  
}
