
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tripmate/features/city_search/data/models/weather_model.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';

part 'city_model.g.dart';

@JsonSerializable()
@Collection()
class CityModel {
  Id isarId = Isar.autoIncrement;

  @JsonKey(name:'place_id')
  final int cityId;

  final String name;
  final String country;
  final String countryCode;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @Ignore()
  final WeatherModel? weatherData;

  @Index()
  final DateTime searchedAt;

  CityModel({
    required this.cityId,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.searchedAt,
    this.imageUrl,
    this.weatherData,
  });


  factory CityModel.fromJson(Map<String, dynamic> json) => _$CityModelFromJson(json);
  Map<String,dynamic> toJson() => _$CityModelToJson(this);

  City toEntity() {
    return City(
      id: cityId, 
      name: name, 
      country: country, 
      countryCode: countryCode, 
      latitude: latitude, 
      longitude: longitude,
      imageUrl: imageUrl,
      weather: weatherData?.toEntity(),
    );
  }

  factory CityModel.fromEntity(City city) {
    return CityModel(
      cityId: city.id, 
      name: city.name, 
      country: city.country, 
      countryCode: city.countryCode, 
      latitude: city.latitude, 
      longitude: city.longitude, 
      searchedAt: DateTime.now(),
      imageUrl:  city.imageUrl,
      weatherData: city.weather != null?
                    WeatherModel.fromEntity(city.weather!)
                    : null
    );
  }

  CityModel copyWith({
    String? imageUrl,
    WeatherModel? weatherData
  }){
    return CityModel(
      cityId: cityId, 
      name: name, 
      country: country, 
      countryCode: countryCode, 
      latitude: latitude, 
      longitude: longitude,
      searchedAt: DateTime.now(),
      imageUrl: imageUrl??this.imageUrl,
      weatherData: weatherData ?? this.weatherData,
    );
  }

}

