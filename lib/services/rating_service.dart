import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:supportme/models/rating.dart';

class RaatingService {
  static String url = "http://localhost:3000/api/ratings";

  static Future<Map<String, dynamic>> post(Rating rating) async {
    final response = await http.post(url, body: rating.toJson());
    return response.statusCode == 200 ? jsonDecode(response.body) : null;
  }
}
