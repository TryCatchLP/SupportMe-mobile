import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  static Session instance = Session._();
  String _token;
  String get token => _token;
  bool get isAuthenticate => token != null;

  final storage = FlutterSecureStorage();
  Map<String, String> get authorization =>
      isAuthenticate ? {"Authorization": "Bearer $_token"} : {};
  final Dio _dio = Dio(BaseOptions(
      baseUrl: "http://localhost:8000/api", contentType: "application/json"));

  Session._();

  Future<Session> initialize() async {
    _token = await storage.read(key: "token");
    return this;
  }

  Future<String> login(String email, String password) async {
    final data = {"email": email, "password": password};
    try {
      final response = await _dio.post('/login', data: data);
      if (response.statusCode == 200) {
        _token = response.data["success"]["token"];
        await storage.write(key: "token", value: _token);
        return "success";
      }
    } on DioError catch (_) {
      return _.response.data["error"];
    }
    return "No autorizado";
  }

  Future<void> logout() async {
    if (isAuthenticate) {
      storage.delete(key: "token");
      _token = null;
    }
  }
}
