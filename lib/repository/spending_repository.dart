import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/models/user.dart';
import 'package:http/http.dart' as http;

class SpendingRepository {
  String loginURL = 'auth/login';
  String registerURL = 'auth/register';
  String createSpendingURL = 'spends/create';

  SpendingRepository() {
    loginURL = url + loginURL;
    registerURL = url + registerURL;
    createSpendingURL = url + createSpendingURL;
  }

  Future<void> createSpending(Spending spending) async {
    try {
      final response = await http.post(
        Uri.parse(createSpendingURL),
        body: spending.toJson(),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
      log('response:$response');
    } catch (e) {
      log('error create spend: $e');
    }
  }

  Future<User?> login(String email, String password) async {
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
      return User.fromMap(jsonDecode(response.body)['data']);
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
}
