import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';

import '../entities/currency_entity.dart';
import '../repositories/currency_repository.dart';

@lazySingleton
class GetCurrencies implements UseCase<List<CurrencyEntity>, NoParams> {
  final CurrencyRepository repository;

  GetCurrencies(this.repository);

  @override
  Future<Either<Failure, List<CurrencyEntity>>> call(NoParams params) async {
    return await repository.getCurrencies();
  }
}