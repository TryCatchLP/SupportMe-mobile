import 'package:dio/dio.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/models/rating.dart';

class RaatingService {
  static Dio _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api", contentType: "application/json"));

  static Future<Map<String, dynamic>> post(Rating rating) async {
    try {
      _dio.options.headers.addAll(Session.instance.authorization);
      final response = await _dio.post("/ratings", data: rating.toJson());
      return response.data;
    } on DioError catch (ex) {
      print(ex.response.data);
      return null;
    }
  }
}
