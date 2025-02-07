// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecaster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecaster _$ForecasterFromJson(Map<String, dynamic> json) => Forecaster(
      parkingId: (json['parking_id'] as num).toInt(),
      state: json['state'] as bool,
    );

Map<String, dynamic> _$ForecasterToJson(Forecaster instance) =>
    <String, dynamic>{
      'parking_id': instance.parkingId,
      'state': instance.state,
    };
