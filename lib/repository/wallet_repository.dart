import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class WalletRepository {
  String loginURL = 'auth/login';
  String registerURL = 'auth/register';
  String creatFirstWalletURL = 'walets/create-first';

  WalletRepository() {
    loginURL = url + loginURL;
    registerURL = url + registerURL;
    creatFirstWalletURL = url + creatFirstWalletURL;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> createFirstWallet(
      int userId, String currenyUnit, int money) async {
    try {
      final accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse(creatFirstWalletURL),
        body: jsonEncode({
          'currencyUnit': currenyUnit,
          'money': money,
        }),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      log('response:$response');
    } catch (e) {
      log('create first wallet: $e');
    }
  }

  Future<String?> login(String email, String password) async {
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
      String result = jsonDecode(response.body)['message'];
      return result;
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
