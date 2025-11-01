import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
   // Geoapify Geocoding API
  static const String geoapifyBaseUrl = 'https://api.geoapify.com/v1';
  static String get geoapifyApiKey => dotenv.env['GEOAPIFY_API_KEY'] ?? '';

  // EndPoints 
  static const String getCities = '/geocode/autocomplete';
  
  // OpenWeatherMap API
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static String get weatherApiKey => dotenv.env['WEATHER_API_KEY'] ?? '';
  
  static const String getWeather = '/weather';
  
  // Unsplash API
  static const String unsplashBaseUrl = 'https://api.unsplash.com';
  static String get unsplashAccessKey => dotenv.env['UNSPLASH_ACCESS_KEY'] ?? '';
  static String get unsplashApiSecret => dotenv.env['UNSPLASH_SECRET_KEY'] ?? '';

  static const String searchPhotos = '/search/photos';

}
