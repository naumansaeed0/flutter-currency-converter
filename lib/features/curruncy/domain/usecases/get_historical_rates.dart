import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_currency_converter/core/error/failures.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/features/currency/domain/repositories/currency_repository.dart';

@lazySingleton
class GetHistoricalRates implements UseCase<Map<String, double>, GetHistoryParams> {
  final CurrencyRepository repository;

  GetHistoricalRates(this.repository);

  @override
  Future<Either<Failure, Map<String, double>>> call(GetHistoryParams params) async {
    final now = DateTime.now();

    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    final dateFormat = DateFormat('yyyy-MM-dd');
    final startDateString = dateFormat.format(sevenDaysAgo);
    final endDateString = dateFormat.format(now);

    return await repository.getHistoricalRates(
      from: params.from,
      to: params.to,
      startDate: startDateString,
      endDate: endDateString,
    );
  }
}

class GetHistoryParams extends Equatable {
  final String from;
  final String to;

  const GetHistoryParams({
    required this.from,
    required this.to,
  });

  @override
  List<Object> get props => [from, to];
}