import 'package:dio/dio.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/menu.dart';

class HuecaService {
  static Dio _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api", contentType: "application/json"));

  static Future<Map<String, dynamic>> post(Hueca hueca, List<Menu> menu) async {
    try {
      
      String fileName = hueca.photo.split('/').last;
      FormData formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile(hueca.photo, filename: fileName),
        "hueca": hueca.toJson(),
        "menues": menu.map((item) => item.toJson()).toList()
      });

      final response = await _dio.post("/huecas", data: formData);
      return response.data;
    } on DioError catch (ex) {
      print(ex.response.data);
      return null;
    }
  }

  static Future<List<Hueca>> getHuecas() async {
    try {
      final response = await _dio.get("/huecas");
      List<Hueca> res = List<Hueca>();
      for (var dat in response.data) {
        res.add(Hueca.fromJson(dat));
      }
      return res;
    } catch (_) {
      return null;
    }
  }
}
