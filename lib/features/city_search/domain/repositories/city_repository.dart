import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/failures.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';

abstract class CityRepository {
  Future<Either<Failure, List<City>>> searchCities(String query);
  Future<Either<Failure,List<City>>> getSearchHistory();
  Future<Either<Failure, void>> clearSearchHistory();
}