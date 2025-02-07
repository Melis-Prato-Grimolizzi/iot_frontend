import 'package:json_annotation/json_annotation.dart';

part 'forecaster.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Forecaster {
  Forecaster({
    required this.parkingId,
    required this.state,
  });

  final int parkingId;
  final bool state;

  factory Forecaster.fromJson(Map<String, dynamic> json) =>
      _$ForecasterFromJson(json);
  Map<String, dynamic> toJson() => _$ForecasterToJson(this);
}
