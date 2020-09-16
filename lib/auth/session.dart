import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supportme/models/user.dart';

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

  Future<User> profile() async {
    if (isAuthenticate) {
      try {
        _dio.options.headers = Session.instance.authorization;
        final response = await _dio.get('/profile');
        if (response.statusCode == 200) {
          Map<String, dynamic> data = response.data["success"];
          //return response()->json(['success' => $user], $this-> successStatus)
          //Por eso accedo al success 
          return User.fromJson(data);
        }
        return User.zero();
      } on DioError catch (ex) {
        print(ex.response.data);
        return User.zero();
      }
    }
    return User.zero();
  }

  Future<bool> profileUpdate(User user) async {
    if (isAuthenticate) {
      try {
        _dio.options.headers = Session.instance.authorization;
        final response = await _dio.put('/profile', data: user.toJson());
        if (response.statusCode == 200) {
          return true;
        }
        return false;
      } on DioError catch (ex) {
        print(ex.response.data);
        return false;
      }
    }
    return false;
  }
Future<bool> profileCreated(User user, String contrasena, String contrasenaComp) async {
    Map<String, dynamic> data=user.toJson();
    data.remove("id");
    data["password"]=contrasena;
    data["c_password"]=contrasenaComp;
    try {
      _dio.options.headers = Session.instance.authorization;
      final response = await _dio.post('/profile', data: data);
      if (response.statusCode == 200) {
        _token = response.data["success"]["token"];
        await storage.write(key: "token", value: _token);
        return true;
      }
      return false;
    } on DioError catch (ex) {
      print(ex.response.data);
      return false;
    }
  }
}
