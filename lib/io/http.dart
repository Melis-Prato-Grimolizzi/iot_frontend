import 'package:dio/dio.dart';
import 'package:iot_frontend/models/slot.dart';

const String baseUrl = 'http://localhost:3000';

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

  Future<String?> login(String username, String password) async {
    try {
      final response = await dio.post('/users/login', data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  Future<String?> signup(String username, String password) async {
    try{
      final response = await dio.post('/users/signup', data: {
        'username': username,
        'password': password,
      });
      return response.data;
    } catch(e) {
      //print(e);
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
}
