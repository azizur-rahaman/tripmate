import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/failures.dart';
import 'package:tripmate/core/usecases/usecase.dart';
import 'package:tripmate/features/city_search/domain/entities/city.dart';
import 'package:tripmate/features/city_search/domain/repositories/city_repository.dart';

class GetSearchHistory implements Usecase<List<City>, NoParams> {
  final CityRepository repository;

  GetSearchHistory(this.repository);

  @override
  Future<Either<Failure, List<City>>> call(NoParams params) async {
    return await repository.getSearchHistory();
  }
}