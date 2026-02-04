import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';

@lazySingleton
class GetHistoricalRates implements UseCase<Map<String, double>, GetHistoryParams> {
  final CurrencyRepository repository;

  GetHistoricalRates(this.repository);

  @override
  Future<Either<Failure, Map<String, double>>> call(GetHistoryParams params) async {
    return await repository.getHistoricalRates(
      from: params.from,
      to: params.to,
      startDate: params.startDate,
      endDate: params.endDate,
    );
  }
}

class GetHistoryParams extends Equatable {
  final String from;
  final String to;
  final String startDate;
  final String endDate;

  const GetHistoryParams({
    required this.from,
    required this.to,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object> get props => [from, to, startDate, endDate];
}