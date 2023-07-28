import 'dart:convert';

import 'package:chat_client/config.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class UserProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return User.fromJson(map);
      if (map is List) return map.map((item) => User.fromJson(item)).toList();
    };
    httpClient.baseUrl = ConfigEnvironment.baseUrl;
  }

  List<User> parseUsers(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future<User?> getUser(int id) async {
    final response = await get('user/$id');
    return response.body;
  }

  Future<Response> postUser(String username, String email) async =>
      await post('user', {'username': username, 'email': email});

  Future<Response> deleteUser(int id) async => await delete('user/$id');

  Future<Response<dynamic>> signin(String email) async =>
      await post('user/login', {'email': email});

  Future<Response> verif(String email, String code, String fcmToken) async =>
      await post('user/verification-code',
          {"email": email, "verificationCode": code, "fcmToken": fcmToken});

  Future<Response> searchUsername(String username) async =>
      await get('user/username/$username');
}
