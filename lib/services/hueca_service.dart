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

  static Future<List<Hueca>> getHuecas({String query}) async {
    try {
      final response = await _dio.get("/huecas");
      List<Hueca> res = List<Hueca>();
      for (var dat in response.data) {
        if (query == null)
          res.add(Hueca.fromJson(dat));
        else {
          Hueca hueca = Hueca.fromJson(dat);
          if (query.trim()
                    .toLowerCase()
                    .allMatches(hueca.name.toLowerCase())
                    .length >
                  0 ||
              query.trim()
                    .toLowerCase()
                    .allMatches(hueca.descrip.toLowerCase())
                    .length >
                  0) {
            res.add(hueca);
          }
        }
      }
      return res;
    } catch (_) {
      return null;
    }
  }

  static Future<List<Menu>> getMenuHuecas(int id) async {
    List<Menu> res = List<Menu>();
    try {
      final response = await _dio.get("/menu/hueca/${id.toString()}");
      if (response.data != "") {
        for (var dat in response.data) {
          res.add(Menu.fromJson(dat));
        }
        return res;
      }
      res.add(Menu.zero());
      return res;
    } on DioError catch (ex) {
      print(ex.response.data);
      res.add(Menu.zero());
      return res;
    }
  }
}
