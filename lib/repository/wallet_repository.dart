import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../models/walet.dart';

class WalletRepository {
  String loginURL = 'auth/login';
  String registerURL = 'auth/register';
  String creatFirstWalletURL = 'walets/create-first';
  String getWalletsOfUserURL = 'walets/all-of-user';

  WalletRepository() {
    loginURL = url + loginURL;
    registerURL = url + registerURL;
    creatFirstWalletURL = url + creatFirstWalletURL;
    getWalletsOfUserURL = url + getWalletsOfUserURL;
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

  Future<List<Wallet>> getAllWalletByUser() async {
    List<Wallet> wallets = [];
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse(getWalletsOfUserURL),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 200) {
          final List<dynamic> walletData = jsonData['data'];
          for (var map in walletData) {
            Wallet wallet = Wallet.fromMap(map);
            wallets.add(wallet);
          }
        } else {
          print('API error: ${jsonData['message']}');
        }
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('API request error: $e');
    }
    print('wallets size: ${wallets.length}');
    return wallets;
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
