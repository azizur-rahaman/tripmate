import 'package:dio/dio.dart';
import 'package:tripmate/core/error/exceptions.dart';
import 'package:tripmate/features/city_search/data/models/city_model.dart';
import 'package:tripmate/features/city_search/data/models/weather_model.dart';
import 'package:tripmate/core/constants/api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'city_remote_data_source.g.dart';

abstract class CityRemoteDataSource {
  Future<List<CityModel>> searchCities(String query);
  Future<String?> getCityImage(String cityName);
  Future<WeatherModel> getWeather(double lat, double long);
}


@RestApi(baseUrl: ApiConstants.geoapifyBaseUrl)
abstract class GeoapifyApi {
  factory GeoapifyApi(Dio dio, {String baseUrl}) = _GeoapifyApi;

  @GET(ApiConstants.getCities)
  Future<dynamic> searchCities(
    @Query('text') String text,
    @Query('type') String type,
    @Query('limit') int limit,
    @Query('apiKey') String apiKey
  );
}

@RestApi(baseUrl: ApiConstants.weatherBaseUrl)
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET(ApiConstants.getWeather)
  Future<dynamic> getWeather(
    @Query('lat') double lat,
    @Query('lon') double lon,
    @Query('appid') String apiKey,
    @Query('units') String units
  );
}


@RestApi(baseUrl: ApiConstants.unsplashBaseUrl)
abstract class UnsplashApi {
  factory UnsplashApi(Dio dio, {String baseUrl}) = _UnsplashApi;

  @GET(ApiConstants.searchPhotos)
  Future<dynamic> searchPhotos(
    @Query('query') String query,
    @Query('client_id') String client_id,
    @Query('per_page') int perPage,

  );
}

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final GeoapifyApi geoapifyApi;
  final WeatherApi weatherApi;
  final UnsplashApi unsplashApi;

  CityRemoteDataSourceImpl({
    required this.geoapifyApi,
    required this.weatherApi,
    required this.unsplashApi
  });


  @override
  Future<List<CityModel>> searchCities(String query) async {
    try{
      final response = await geoapifyApi.searchCities(
        query, 'city', 10, ApiConstants.geoapifyApiKey);

      final features = response['features'] as List;
      final cities = features.map((feature) {
        final properties = feature['properties'] as Map<String, dynamic>;
        final geometry = feature['geometry'] as Map<String, dynamic>;
        final coordinates = geometry['coordinates'] as List;
        
        // Extract city data from Geoapify GeoJSON format
        return CityModel(
          cityId: properties['place_id']?.hashCode ?? 0,
          name: properties['city'] ?? properties['name'] ?? '',
          country: properties['country'] ?? '',
          countryCode: properties['country_code']?.toString().toUpperCase() ?? '',
          latitude: coordinates[1] as double,
          longitude: coordinates[0] as double,
          searchedAt: DateTime.now(),
        );
      }).toList();
      return cities;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }


  @override
  Future<String?> getCityImage(String cityName) async {
    try{
      final response = await unsplashApi.searchPhotos('$cityName city', ApiConstants.unsplashAccessKey, 1);

      final result = response['results'] as List;
      if(result.isNotEmpty){
        return result[0]['urls']['regular'];
      }
      return null;
    } catch (e) {
      return null; // Image is optional
    }
  }


  @override
  Future<WeatherModel> getWeather(double lat, double lon) async {
    try{
      final response = await weatherApi.getWeather(lat, lon, ApiConstants.weatherApiKey, 'metric');

      return WeatherModel(
        temperature: (response['main']['temp'] as num).toDouble(), 
        description: response['weather'][0]['description'],
        icon: response['weather'][0]['icon'],
        humidity: response['main']['humidity'], 
        feelsLike: (response['main']['feels_like'] as num).toDouble()
      );
    } on DioException catch(e) {
      throw ServerException(e.message ?? 'Weather fetch failed!');
    }
  }
}