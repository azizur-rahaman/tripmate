import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/failures.dart';
import 'package:tripmate/core/usecases/usecase.dart';
import 'package:tripmate/features/city_search/domain/repositories/city_repository.dart';

class ClearSearchHistory implements Usecase<void, NoParams>{
  final CityRepository repository;

  ClearSearchHistory(this.repository);


  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.clearSearchHistory();
  }
}