// ignore_for_file: file_names

class Device {
  final String switchStatus;
  final int outlet;

  Device({required this.switchStatus, required this.outlet});

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      switchStatus: json['switch'],
      outlet: json['outlet'],
    );
  }
}
