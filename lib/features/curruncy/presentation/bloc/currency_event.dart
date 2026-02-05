part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class GetInitialDataEvent extends CurrencyEvent {}

class ConvertCurrencyEvent extends CurrencyEvent {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  const ConvertCurrencyEvent({
    required this.fromCurrency,
    required this.toCurrency,
    required this.amount,
  });

  @override
  List<Object> get props => [fromCurrency, toCurrency, amount];
}