import 'package:json_annotation/json_annotation.dart';
import 'package:tripmate/features/city_search/domain/entities/weather.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double feelsLike;

  WeatherModel({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.feelsLike
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => _$WeatherModelFromJson(json);
  Map<String,dynamic> toJson() => _$WeatherModelToJson(this);

  Weather toEntity() {
    return Weather(temperature: temperature, description: description, icon: icon, humidity: humidity, feelsLike: feelsLike);
  }

  factory WeatherModel.fromEntity(Weather weather) {
    return WeatherModel(temperature: weather.temperature, description: weather.description, icon: weather.icon, humidity: weather.humidity, feelsLike: weather.feelsLike);
  }
}