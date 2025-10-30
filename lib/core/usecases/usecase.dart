import 'package:dartz/dartz.dart';
import 'package:tripmate/core/error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<Either<Failure, Type>> call(Params Params);
}

class NoParams {}