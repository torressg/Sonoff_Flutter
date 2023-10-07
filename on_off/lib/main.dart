import 'package:flutter/material.dart';
import 'package:on_off/constants/AppColors.dart';
import 'package:on_off/pages/buttons_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "lib/constants/.env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: AppColors.primaryColor,
          ),
        ),
        home: ButtomPage());
  }
}
