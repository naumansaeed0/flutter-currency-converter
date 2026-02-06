part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();

  @override
  List<Object> get props => [];
}

class GetInitialDataEvent extends CurrencyEvent {}

class SourceCurrencyChanged extends CurrencyEvent {
  final String currencyCode;
  const SourceCurrencyChanged(this.currencyCode);
  @override
  List<Object> get props => [currencyCode];
}

class TargetCurrencyChanged extends CurrencyEvent {
  final String currencyCode;
  const TargetCurrencyChanged(this.currencyCode);
  @override
  List<Object> get props => [currencyCode];
}

class SwapCurrenciesEvent extends CurrencyEvent {}

class ConvertCurrencyEvent extends CurrencyEvent {
  final double amount;
  const ConvertCurrencyEvent({required this.amount});
  @override
  List<Object> get props => [amount];
}