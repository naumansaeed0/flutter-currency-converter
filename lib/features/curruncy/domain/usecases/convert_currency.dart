import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';

@lazySingleton
class ConvertCurrency implements UseCase<ExchangeRateEntity, ConvertCurrencyParams> {
  final CurrencyRepository repository;

  ConvertCurrency(this.repository);

  @override
  Future<Either<Failure, ExchangeRateEntity>> call(ConvertCurrencyParams params) async {
    return await repository.getExchangeRate(
      from: params.from,
      to: params.to,
    );
  }
}


class ConvertCurrencyParams extends Equatable {
  final String from;
  final String to;

  const ConvertCurrencyParams({required this.from, required this.to});

  @override
  List<Object> get props => [from, to];
}