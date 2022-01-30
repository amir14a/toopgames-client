import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:toopgames_client/model/user_model.dart';

import 'consts.dart';

class AppSharedPreferences {
  static saveValue(String key, String value) async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString(key, value);
  }

  static getValue(String key, String value) async {
    final prefs = EncryptedSharedPreferences();
    return await prefs.getString(key);
  }

  static saveUser(UserModel user) async {
    final prefs = EncryptedSharedPreferences();
    await prefs.setString(Consts.userTag, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    // return UserModel(id: 1, name: "amir "+DateTime.now().second.toString());
    final prefs = EncryptedSharedPreferences();
    final userJson = await prefs.getString(Consts.userTag);
    if (userJson.isEmpty) {
      return null;
    }
    return UserModel.fromJson(jsonDecode(userJson));
  }

  static clearAll() async {
    final prefs = EncryptedSharedPreferences();
    await prefs.clear();
  }
}
