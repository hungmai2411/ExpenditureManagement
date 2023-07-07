import 'dart:convert';
import 'dart:developer';

import 'package:expenditure_management/constants/environment.dart';
import 'package:expenditure_management/models/type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TypeRepository {
  String getAllTypeURL = 'types/all';

  TypeRepository() {
    getAllTypeURL = url + getAllTypeURL;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<List<SpendingType>> getAllTypes() async {
    List<SpendingType> types = [];
    try {
      final accessToken = await getAccessToken();
      final response = await http.get(
        Uri.parse(getAllTypeURL),
        headers: {
          'Accept': '*/*',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      for (var map in jsonDecode(response.body)['data']) {
        SpendingType type = SpendingType.fromMap(map);
        types.add(type);
      }
      log('response:$response');
    } catch (e) {
      log('get all types: $e');
    }
    return types;
  }
}
