import 'package:dio/dio.dart';
import 'package:iot_frontend/models/slot.dart';
import 'package:iot_frontend/models/user.dart';

const String baseUrl = 'https://iot.grimos.dev';

final httpApi = HttpApi(
  Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': Headers.formUrlEncodedContentType},
    ),
  ),
);

class HttpApi {
  const HttpApi(this.dio);
  final Dio dio;

  Future<Response?> login(String username, String password) async {
    try {
      final response = await dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
    }
    return null;
  }

  Future<Response?> signup(
      String username, String password, String carPlate) async {
    try {
      final response = await dio.post('/users/signup', data: {
        'username': username,
        'password': password,
        'car_plate': carPlate,
      });
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
    }
    return null;
  }

  Future<List<Slot>> getSlots() async {
    List<Slot> slots = [];

    final response = await dio.get('/slots');

    for (var slot in response.data) {
      slots.add(Slot.fromJson(slot));
    }

    return slots;
  }

  Future<Response?> startSession(String idSlot, String jwt) async {
    try {
      final response = await dio.post('/slots/start_parking_session/$idSlot',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      return response;
    } catch (e) {
      if (e is DioException) {
        return e.response;
      }
    }
    return null;
  }

  Future<User?> getUser(String jwt) async {
    try {
      final response = await dio.get('/users/verify',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      final id = response.data['id'];
      final user = await dio.get('/users/user/$id');
      return User.fromJson(user.data);
    } catch (e) {
      if (e is DioException) {
        return null;
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> getForecasts(String jwt) async {
    try {
      final response = await dio.get('/slots/get_forecasts',
          options: Options(headers: {'Authorization': 'Bearer $jwt'}));
      return response.data;
    } catch (e) {
      if (e is DioException) {
        return null;
      }
    }
    return null;
  }
}
