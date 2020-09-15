import 'package:dio/dio.dart';
import 'package:supportme/auth/session.dart';
import 'package:supportme/models/hueca.dart';
import 'package:supportme/models/rating.dart';

class RatingService {
  static Dio _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api",
      contentType: "application/json",
      headers: Session.instance.authorization));

  static Future<Map<String, dynamic>> post(Rating rating) async {
    try {
      final response = await _dio.post("/ratings", data: rating.toJson());
      return response.data;
    } on DioError catch (ex) {
      print(ex.response.data);
      return null;
    }
  }

  static Future<Map<String, dynamic>> update(Rating rating) async {
    try {
      final response =
          await _dio.put("/ratings/${rating.id}", data: rating.toJson());
      return response.data;
    } on DioError catch (ex) {
      print(ex.response.data);
      return null;
    }
  }

  static Future<Rating> getUserRatingHueca(Hueca hueca) async {
    try {
      final response = await _dio.get("/ratings/${hueca.id}");
      if (response.data != "") {
        Map<String, dynamic> data = response.data;
        return Rating.fromJson(data);
      }
      return Rating.zero();
    } on DioError catch (ex) {
      print(ex.response.data);
      return Rating.zero();
    }
  }

  static Future<List<Rating>> getUserRatings() async {
    try {
      final response = await _dio.get("/ratings");
      List<Rating> ratings = List<Rating>();
      for (var json in response.data) {
        ratings.add(Rating.fromJsonDetail(json));
      }
      return ratings;
    } on DioError catch (ex) {
      print(ex.response.data);
      return null;
    }
  }

  static Future<List<Rating>> getRatingsByMenu(int id) async {
    List<Rating> res = List<Rating>();
    try {
      final response = await _dio.get("/ratings/hueca/${id.toString()}");
      if (response.data != "") {
        for (var dat in response.data) {
          res.add(Rating.fromJsonUser(dat));
        }
        return res;
      }
      res.add(Rating.zero());
      return res;
    } on DioError catch (ex) {
      print(ex.response.data);
      res.add(Rating.zero());
      return res;
    }
  }
}
