// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slot _$SlotFromJson(Map<String, dynamic> json) => Slot(
      id: (json['id'] as num).toInt(),
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      parkingId: (json['parking_id'] as num).toInt(),
      state: json['state'] as bool,
      zone: (json['zone'] as num).toInt(),
    );

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'parking_id': instance.parkingId,
      'state': instance.state,
      'zone': instance.zone,
    };
