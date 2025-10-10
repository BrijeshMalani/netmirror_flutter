import 'package:shared_preferences/shared_preferences.dart';

class IntroUtils {
  /// Reset intro completion status (useful for testing)
  static Future<void> resetIntroStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('intro_completed');
  }

  /// Check if intro has been completed
  static Future<bool> isIntroCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('intro_completed') ?? false;
  }

  /// Mark intro as completed
  static Future<void> markIntroCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_completed', true);
  }
}
