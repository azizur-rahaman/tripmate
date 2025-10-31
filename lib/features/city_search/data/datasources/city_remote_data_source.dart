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


@RestApi(baseUrl: ApiConstants.geoDbBaseUrl)
abstract class GeoDbApi {
  factory GeoDbApi(Dio dio, {String baseUrl}) = _GeoDbApi;


  @GET(ApiConstants.getCities)
  Future<HttpResponse<Map<String, dynamic>>> searchCities(
    @Query('namePrefix') String namePrefix,
    @Query('limit') int limit,
    @Header('X-RapidAPI-Key') String apiKey,
    @Header('X-RapidAPI-Host') String host
  );
}

@RestApi(baseUrl: ApiConstants.weatherBaseUrl)
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET(ApiConstants.getWeather)
  Future<HttpResponse<Map<String,dynamic>>> getWeather(
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
  Future<HttpResponse<Map<String, dynamic>>> searchPhotos(
    @Query('query') String query,
    @Query('client_id') String client_id,
    @Query('per_page') int perPage,

  );
}

class CityRemoteDataSourceImpl implements CityRemoteDataSource {
  final GeoDbApi geoDbApi;
  final WeatherApi weatherApi;
  final UnsplashApi unsplashApi;

  CityRemoteDataSourceImpl({
    required this.geoDbApi,
    required this.weatherApi,
    required this.unsplashApi
  });


  @override
  Future<List<CityModel>> searchCities(String query) async {
    try{
      final response = await geoDbApi.searchCities(
        query, 10, ApiConstants.geoDbApiKey, ApiConstants.geoDbHost);

      if(response.response.statusCode == 200){
        final data = response.data['data'] as List;
        final cities = data.map((json) => CityModel.fromJson(json)).toList();
        return cities;
      }else{
        throw ServerException('Failed to Fetch cities');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }


  @override
  Future<String?> getCityImage(String cityName) async {
    try{
      final response = await unsplashApi.searchPhotos('$cityName city', ApiConstants.unsplashAccessKey, 1);

      if(response.response.statusCode == 200){
        final result = response.data['results'] as List;
        if(result.isNotEmpty){
          return result[0]['urls']['regular'];
        }
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

      if(response.response.statusCode == 200){
        final data = response.data;
        return WeatherModel(
          temperature: (data['main']['temp'] as num).toDouble(), 
          description: data['weather'][0]['description'],
          icon: data['weather'][0]['icon'],
          humidity: data['main']['humidity'], 
          feelsLike: (data['main']['feels_like'] as num).toDouble()
        );
      }else {
        throw ServerException('Failed to fetch weather');
      }
    } on DioException catch(e) {
      throw ServerException(e.message ?? 'Weather fetch failed!');
    }
  }
}