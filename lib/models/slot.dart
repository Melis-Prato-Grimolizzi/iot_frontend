import 'package:json_annotation/json_annotation.dart';

part 'slot.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Slot {
   Slot({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.parkingId,
    required this.state,
    required this.zone,
  });

  final int id;
  final String latitude;
  final String longitude;
  final int parkingId;
  final bool state;
  final int zone;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
  Map<String, dynamic> toJson() => _$SlotToJson(this);
}
