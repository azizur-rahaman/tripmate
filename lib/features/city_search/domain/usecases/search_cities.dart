import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/failures.dart';
import 'package:tripmate/core/usecases/usecase.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';
import 'package:tripmate/features/city_search/domain/repositories/city_repository.dart';

class SearchCities implements Usecase<List<City>, SearchCitiesParams>{
  final CityRepository repository;

  SearchCities(this.repository);

  @override
  Future<Either<Failure, List<City>>> call(SearchCitiesParams params) async {
    return await repository.searchCities(params.query);
  }
}

class SearchCitiesParams {
  final String query;
  SearchCitiesParams(this.query);
}