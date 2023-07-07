import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/token.dart';
import 'package:expenditure_management/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  String loginURL = 'auth/login';
  String registerURL = 'auth/register';
  String verifyTokenURL = 'auth/verify_token';

  AuthRepository() {
    loginURL = url + loginURL;
    registerURL = url + registerURL;
    verifyTokenURL = url + verifyTokenURL;
  }

  Future<Token?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginURL),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
      log('response:$response');
      return Token.fromMap(jsonDecode(response.body)['data']);
    } catch (e) {
      log('error login: $e');
    }

    return null;
  }

  Future<String?> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse(registerURL),
        body: jsonEncode(user.toMap()),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
      log('response:$response');
      String result = jsonDecode(response.body)['message'];
      return result;
    } catch (e) {
      log('error register: $e');
    }

    return null;
  }

  Future<bool?> verifyAccessToken(String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(verifyTokenURL),
        body: jsonEncode({'accessToken': accessToken}),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
      String? result = jsonDecode(response.body)['message'];
      if (result == 'success') return true;
      return false;
    } catch (e) {
      print('verifyAccessToken failed:$e');
      log('error register: $e');
      return false;
    }
  }
}
