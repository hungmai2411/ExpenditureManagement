import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/spending.dart';
import 'package:expenditure_management/models/summary.dart' as s;
import 'package:expenditure_management/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SpendingRepository {
  String loginURL = 'auth/login';
  String registerURL = 'auth/register';
  String createSpendingURL = 'spends/create';
  String getAllSpendingURL = 'spends/by-date';
  String getSummaryURL = 'balances/by-month';
  String getAllSpendingByMonth = 'spends/by-month';
  String deleteSpendingURL = 'spends/delete';
  String getSpendingByDateURL = 'spends/by-month';
  String getSpendingByPeriodURL = 'spends/period';

  SpendingRepository() {
    loginURL = url + loginURL;
    registerURL = url + registerURL;
    createSpendingURL = url + createSpendingURL;
    getAllSpendingURL = url + getAllSpendingURL;
    getSummaryURL = url + getSummaryURL;
    getSpendingByDateURL = url + getSpendingByDateURL;
    getAllSpendingByMonth = url + getAllSpendingByMonth;
    deleteSpendingURL = url + deleteSpendingURL;
    getSpendingByPeriodURL = url + getSpendingByPeriodURL;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> createSpending(Spending spending) async {
    try {
      final accessToken = await getAccessToken();
      final response = await http.post(
        Uri.parse(createSpendingURL),
        body: spending.toJson(),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      log('response:$response');
    } catch (e) {
      log('error create spend: $e');
    }
  }

//https://spendingmanagementserver-production.up.railway.app/spends/delete/25
  Future<void> deleteSpending(Spending spending) async {
    try {
      final accessToken = await getAccessToken();
      final response = await http.delete(
        Uri.parse('$deleteSpendingURL/${spending.id}'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      log('response:$response');
    } catch (e) {
      log('error create spend: $e');
    }
  }

  ///1?month=6&year=2023&waletId=1

  Future<s.Summary?> getSummary(
      int idUser, int month, int year, int walletId) async {
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse(
            '$getSummaryURL/$walletId?month=$month&year=$year&waletId=$walletId'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      return s.Summary.fromMap(jsonDecode(response.body)['data']);
    } catch (e) {
      log('error get summary: $e');
    }
    return null;
  }

// https://spendingmanagementserver-production.up.railway.app/spends/by-date/6?date=2023-06-27T23:46:51.367610
// month=6&year=2023
  Future<List<Spending>> getAllSpendingsByDate(
      int userID, int day, int month, int year) async {
    List<Spending> spendings = [];
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse('$getAllSpendingURL/?day=$day&month=$month&year=$year'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      for (var map in jsonDecode(response.body)['data']['spendIndates']) {
        Spending spending = Spending.fromMap(map);
        spendings.add(spending);
      }
      log('response:$response');
    } catch (e) {
      log('get all spendings: $e');
    }
    return spendings;
  }

  Future<List<Spending>> getSpendingsByPeriod(
      int userID, String fromDate, String toDate, String type) async {
    List<Spending> spendings = [];
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse(
            '$getSpendingByPeriodURL/?fromDate=$fromDate&toDate=$toDate&type=$type'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      for (var map in jsonDecode(response.body)['data']) {
        Spending spending = Spending.fromMap(map);
        spendings.add(spending);
      }
      log('response:$response');
    } catch (e) {
      log('get all spendings: $e');
    }
    return spendings;
  }

  Future<List<Spending>> getAllSpendingsByMonth(
      int userID, int month, int year) async {
    List<Spending> spendings = [];
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse('$getAllSpendingByMonth/?month=$month&year=$year'),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      for (var map in jsonDecode(response.body)['data']) {
        Spending spending = Spending.fromMap(map);
        spendings.add(spending);
      }
      log('response:$response');
    } catch (e) {
      log('get all spendings: $e');
    }
    return spendings;
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
