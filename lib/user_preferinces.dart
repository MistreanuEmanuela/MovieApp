import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String userIdKey = 'user_id';


  static Future<void> saveUserId(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(userIdKey, userId);
  }

  static Future<int?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(userIdKey);
  }
}
