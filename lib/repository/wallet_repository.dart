import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/user.dart';
import 'package:expenditure_management/models/wallet.dart';
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

  Future<void> createFirstWallet(
      int userId, String currenyUnit, int money) async {
    try {
      final response = await http.post(
        Uri.parse(creatFirstWalletURL),
        body: jsonEncode({
          'userId': userId,
          'currencyUnit': currenyUnit,
          'money': money,
        }),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
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

  //code thêm
  Future<List<Wallet>> getAllWallet(int userID) async {
    List<Wallet> wallets = [];
    try {
      final response = await http.get(
        Uri.parse(
            '$getAllWallet/$userID'), //cho nay hinh nhu thieu dau ? sau userID
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
        },
      );
      for (var map in jsonDecode(response.body)['data']) {
        Wallet wallet = Wallet.fromMap(map);
        wallets.add(wallet);
      }
      log('response:$response');
    } catch (e) {
      log('get all spendings: $e');
    }
    return wallets;
  }

//
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
