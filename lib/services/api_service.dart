import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<Map<String, dynamic>?> fetchData(String uri) async {
    var url = Uri.parse(uri);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
