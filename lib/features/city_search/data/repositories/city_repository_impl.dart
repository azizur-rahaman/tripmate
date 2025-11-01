import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/exceptions.dart';
import 'package:tripmate/core/error/failures.dart';
import 'package:tripmate/core/networks/network_info.dart';
import 'package:tripmate/features/city_search/data/datasources/city_local_data_source.dart';
import 'package:tripmate/features/city_search/data/datasources/city_remote_data_source.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';
import 'package:tripmate/features/city_search/domain/repositories/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource remoteDataSource;
  final CityLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CityRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo
  });


  @override
  Future<Either<Failure, List<City>>> searchCities(String query) async {
    if(await networkInfo.isConnected){
      try{
        // fetch cities from API
        final cities = await remoteDataSource.searchCities(query);

        //Enrich with images and weather
        final enrichedCities = await Future.wait(
          cities.map((city) async {
            try{
              final imageUrl = await remoteDataSource.getCityImage(city.name);
              final weather = await remoteDataSource.getWeather(city.latitude, city.longitude);

              final enriched = city.copyWith(
                imageUrl: imageUrl,
                weatherData: weather
              );

              // Cache the enriched city
              await localDataSource.cacheCity(enriched);

              return enriched;
            }catch (e) {
              // if enrichment fails, cache and return basic city
              await localDataSource.cacheCity(city);
              return city;
            }
          })
        );

        return Right(enrichedCities.map((c) => c.toEntity()).toList());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      }
    }else{
      return const Left(NetworkFailure('No internet connection!'));
    }
  }



  @override
  Future<Either<Failure, List<City>>> getSearchHistory() async {
    try{
      final cachedCities = await localDataSource.getSearchHistory();
      return Right(cachedCities.map((c) => c.toEntity()).toList());
    }on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearSearchHistory() async {
    try{
      await localDataSource.clearHistory();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}