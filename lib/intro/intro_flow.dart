import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ad_manager.dart';
import 'intro_screen_1.dart';
import 'intro_screen_2.dart';
import 'intro_screen_3.dart';
import 'intro_screen_4.dart';
import '../netmirror/movie_nav.dart';

class IntroFlow extends StatefulWidget {
  const IntroFlow({super.key});

  @override
  State<IntroFlow> createState() => _IntroFlowState();
}

class _IntroFlowState extends State<IntroFlow> {
  int currentScreen = 0;

  @override
  Widget build(BuildContext context) {
    switch (currentScreen) {
      case 0:
        return IntroScreen1(
          onContinue: () {
            AdManager().showInterstitialAd();
            setState(() {
              currentScreen = 1;
            });
          },
        );
      case 1:
        return IntroScreen2(
          onContinue: () {
            AdManager().showInterstitialAd();
            setState(() {
              currentScreen = 2;
            });
          },
        );
      case 2:
        return IntroScreen3(
          onSkip: () {
            setState(() {
            AdManager().showInterstitialAd();
              currentScreen = 3;
            });
          },
          onContinue: () {
            setState(() {
            AdManager().showInterstitialAd();
              currentScreen = 3;
            });
          },
        );
      case 3:
        return IntroScreen4(
          onContinue: () {
            _completeIntro();
          },
        );
      default:
        return IntroScreen1(
          onContinue: () {
            AdManager().showInterstitialAd();
            setState(() {
              currentScreen = 1;
            });
          },
        );
    }
  }

  void _completeIntro() async {
    AdManager().showInterstitialAd();
    // Mark intro as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_completed', true);

    // Navigate to main app
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Movienav()),
      );
    }
  }
}

class IntroManager {
  static Future<bool> shouldShowIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('intro_completed') ?? false);
  }
}
