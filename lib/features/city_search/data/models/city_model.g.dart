// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityModel _$CityModelFromJson(Map<String, dynamic> json) => CityModel(
      cityId: (json['id'] as num).toInt(),
      name: json['name'] as String,
      country: json['country'] as String,
      countryCode: json['countryCode'] as String,
      population: (json['population'] as num).toInt(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      searchedAt: json['searchedAt'] == null
          ? null
          : DateTime.parse(json['searchedAt'] as String),
    )..isarId = (json['isarId'] as num).toInt();

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
      'isarId': instance.isarId,
      'id': instance.cityId,
      'name': instance.name,
      'country': instance.country,
      'countryCode': instance.countryCode,
      'population': instance.population,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrl': instance.imageUrl,
      'searchedAt': instance.searchedAt.toIso8601String(),
    };
