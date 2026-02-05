import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/convert_currency.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/get_currencies.dart';
import 'package:flutter_currency_converter/features/currency/domain/usecases/get_historical_rates.dart';

part 'currency_event.dart';
part 'currency_state.dart';

@injectable
class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final GetCurrencies getCurrencies;
  final ConvertCurrency convertCurrency;
  final GetHistoricalRates getHistoricalRates;

  CurrencyBloc(
    this.getCurrencies,
    this.convertCurrency,
    this.getHistoricalRates,
  ) : super(const CurrencyState()) {

    on<GetInitialDataEvent>((event, emit) async {
      emit(state.copyWith(status: CurrencyStatus.loading));

      final currenciesResult = await getCurrencies(NoParams());

      final historyResult = await getHistoricalRates(const GetHistoryParams(
        from: AppConstants.lockedCurrencySource,
        to: AppConstants.lockedCurrencyTarget,
      ));

      currenciesResult.fold(
        (failure) => emit(state.copyWith(
          status: CurrencyStatus.failure,
          errorMessage: failure.message,
        )),
        (currenciesList) {
          final historyMap = historyResult.getOrElse(() => {});

          emit(state.copyWith(
            status: CurrencyStatus.success,
            currencies: currenciesList,
            history: historyMap,
          ));
        },
      );
    });

    on<ConvertCurrencyEvent>((event, emit) async {

      final result = await convertCurrency(ConvertCurrencyParams(
        from: event.fromCurrency,
        to: event.toCurrency,
      ));

      result.fold(
        (failure) => emit(state.copyWith(
          status: CurrencyStatus.failure,
          errorMessage: failure.message,
        )),
        (rateEntity) => emit(state.copyWith(
          status: CurrencyStatus.success,
          conversionResult: rateEntity,
          inputAmount: event.amount,
        )),
      );
    });
  }
}