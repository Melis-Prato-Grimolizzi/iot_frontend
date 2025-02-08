import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/io/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'forecaster.g.dart';

@riverpod
Future<Map<String, dynamic>?> getForecasts(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  final jwt = prefs.getString('jwt');
  if (jwt == null) return null;
  return await httpApi.getForecasts(jwt);
}
