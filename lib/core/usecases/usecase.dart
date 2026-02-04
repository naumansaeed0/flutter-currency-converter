import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';

// Type: The data we expect to get back (e.g., List<Currency>)
// Params: What we need to send to the API (e.g., "USD" string)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}