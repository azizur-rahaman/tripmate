import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String description;
  final String icon;
  final int humidity;
  final double feelsLike;

  const Weather({
    required this.temperature,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.feelsLike,
  });

  @override
  List<Object> get props => [
        temperature,
        description,
        icon,
        humidity,
        feelsLike,
      ];
}
