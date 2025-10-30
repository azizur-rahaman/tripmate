
import 'package:equatable/equatable.dart';
import 'package:tripmate/features/city_search/domain/entities/weather.dart';

class City extends Equatable{
  final int id;
  final String name;
  final String country;
  final String countryCode;
  final int population;
  final double latitude;
  final double longitude;
  final String? imageUrl;
  final Weather? weather;

  const City({
    required this.id,
    required this.name,
    required this.country,
    required this.countryCode,
    required this.population,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
    this.weather,
  });

  @override
  List<Object?> get props => [
    id,name, country, countryCode, population, latitude, longitude, imageUrl, weather
  ];
}