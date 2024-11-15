import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iot_frontend/io/http.dart';
import 'package:iot_frontend/models/slot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'slots.g.dart';

@riverpod
Future<List<Slot>> getSlots(Ref ref) async {
  return await httpApi.getSlots();
}
