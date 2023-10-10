import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_off/constants/AppColors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:on_off/pages/splash_screen_page.dart';

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
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
          ).copyWith(
            secondary: AppColors.primaryColor,
          ),
        ),
        home: const SplashScreenPage());
  }
}
