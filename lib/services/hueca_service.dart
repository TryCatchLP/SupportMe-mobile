import 'package:dio/dio.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/menu.dart';

class HuecaService {
  static Dio _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api", contentType: "application/json"));

  static Future<Map<String, dynamic>> post(Hueca hueca, List<Menu> menu) async {
    try {
      final response = await _dio.post("/huecas", data: {"hueca": hueca.toJson(), "menues":  menu.map( (item) => item.toJson()).toList()});
      return response.data;
    } catch (_) {
      return null;
    }
  }
}
