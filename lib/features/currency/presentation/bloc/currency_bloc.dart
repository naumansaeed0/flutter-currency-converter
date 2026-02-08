import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_currency_converter/core/usecases/usecase.dart';
import 'package:flutter_currency_converter/core/utils/constants.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/currency_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/exchange_rate_entity.dart';
import 'package:flutter_currency_converter/features/currency/domain/entities/historical_rate_entity.dart';
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
      emit(state.copyWith(
        currenciesStatus: CurrencyStatus.loading,
        historyStatus: CurrencyStatus.loading,
      ));

      final currenciesResult = await getCurrencies(NoParams());

      await currenciesResult.fold(
            (failure) async => emit(state.copyWith(
          currenciesStatus: CurrencyStatus.failure,
          errorMessage: failure.message,
        )),
            (currenciesList) async {
          emit(state.copyWith(
            currenciesStatus: CurrencyStatus.success,
            currencies: currenciesList,
          ));

          final now = DateTime.now();
          final sevenDaysAgo = now.subtract(const Duration(days: 6));

          final historyResult = await getHistoricalRates(GetHistoryParams(
            from: AppConstants.lockedCurrencySource,
            to: AppConstants.lockedCurrencyTarget,
            startDate: sevenDaysAgo,
            endDate: now,
          ));

          historyResult.fold(
                (failure) => emit(state.copyWith(historyStatus: CurrencyStatus.failure)),
                (historyList) {
              final sortedHistory = List<HistoricalRateEntity>.from(historyList)
                ..sort((a, b) => a.date.compareTo(b.date));

              emit(state.copyWith(
                historyStatus: CurrencyStatus.success,
                history: sortedHistory,
              ));
            },
          );
        },
      );
    });

    on<SourceCurrencyChanged>((event, emit) {
      emit(state.copyWith(
        fromCurrency: event.currencyCode,
        conversionStatus: CurrencyStatus.loading,
      ));
      add(ConvertCurrencyEvent(amount: state.inputAmount));
    });

    on<TargetCurrencyChanged>((event, emit) {
      emit(state.copyWith(
        toCurrency: event.currencyCode,
        conversionStatus: CurrencyStatus.loading,
      ));
      add(ConvertCurrencyEvent(amount: state.inputAmount));
    });

    on<SwapCurrenciesEvent>((event, emit) {
      emit(state.copyWith(
        fromCurrency: state.toCurrency,
        toCurrency: state.fromCurrency,
      ));
      add(ConvertCurrencyEvent(amount: state.inputAmount));
    });

    on<ConvertCurrencyEvent>((event, emit) async {
      emit(state.copyWith(
        conversionStatus: CurrencyStatus.loading,
        inputAmount: event.amount,
      ));

      final result = await convertCurrency(ConvertCurrencyParams(
        from: state.fromCurrency,
        to: state.toCurrency,
      ));

      result.fold(
            (failure) => emit(state.copyWith(
          conversionStatus: CurrencyStatus.failure,
          errorMessage: failure.message,
        )),
            (rateEntity) => emit(state.copyWith(
          conversionStatus: CurrencyStatus.success,
          conversionResult: rateEntity,
        )),
      );
    });
  }
}