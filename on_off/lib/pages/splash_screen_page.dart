import 'package:flutter/material.dart';
import 'package:on_off/constants/AppColors.dart';
import 'package:on_off/pages/buttons_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  bool _isFilled = false;
  bool _isGlow = false;

  @override
  void initState() {
    super.initState();
    _toggleIcon();
  }

  _toggleIcon() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isFilled = !_isFilled;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isGlow = !_isGlow;
    });
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ButtomPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: AppColors.backgroundColor),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: 
            _isFilled
                ? _isGlow
                    ? 
                    const Icon(Icons.lightbulb,
                        key: ValueKey<int>(1),
                        size: 200,
                        color: AppColors.primaryColor,
                        shadows: [
                            Shadow(
                              blurRadius: 80,
                              color: AppColors.primaryColor,
                              offset: Offset(
                                0.0,
                                0.0,
                              ),
                            )
                          ])
                    : const Icon(
                        Icons.lightbulb,
                        key: ValueKey<int>(1),
                        size: 200,
                        color: AppColors.primaryColor,
                      )
                : const Icon(Icons.lightbulb_outline,
                    key: ValueKey<int>(0),
                    size: 200,
                    color: AppColors.primaryColor),
          ),
        ),
      ),
    );
  }
}
