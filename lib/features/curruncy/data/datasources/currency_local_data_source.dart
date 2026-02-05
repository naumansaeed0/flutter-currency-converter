import 'package:flutter_currency_converter/core/error/exceptions.dart';
import 'package:flutter_currency_converter/features/currency/data/models/currency_model.dart';
import 'package:flutter_currency_converter/features/currency/data/models/history_model.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class CurrencyLocalDataSource {
  Future<List<CurrencyModel>> getLastCurrencies();
  Future<void> cacheCurrencies(List<CurrencyModel> currencies);

  // New: History Methods
  Future<HistoryModel> getLastHistory(String from, String to);
  Future<void> cacheHistory(HistoryModel history);
}

const String kCurrencyBox = 'currency_box';
const String kHistoryBox = 'history_box';

@LazySingleton(as: CurrencyLocalDataSource)
class CurrencyLocalDataSourceImpl implements CurrencyLocalDataSource {

  Future<Box<CurrencyModel>> _openCurrencyBox() async {
    if (Hive.isBoxOpen(kCurrencyBox)) return Hive.box<CurrencyModel>(kCurrencyBox);
    return await Hive.openBox<CurrencyModel>(kCurrencyBox);
  }

  Future<Box<HistoryModel>> _openHistoryBox() async {
    if (Hive.isBoxOpen(kHistoryBox)) return Hive.box<HistoryModel>(kHistoryBox);
    return await Hive.openBox<HistoryModel>(kHistoryBox);
  }

  @override
  Future<List<CurrencyModel>> getLastCurrencies() async {
    final box = await _openCurrencyBox();
    if (box.isNotEmpty) return box.values.toList();
    throw CacheException();
  }

  @override
  Future<void> cacheCurrencies(List<CurrencyModel> currencies) async {
    final box = await _openCurrencyBox();
    await box.clear();
    await box.addAll(currencies);
  }


  @override
  Future<HistoryModel> getLastHistory(String from, String to) async {
    final box = await _openHistoryBox();
    final key = '${from}_$to';

    final history = box.get(key);
    if (history != null) {
      return history;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheHistory(HistoryModel history) async {
    final box = await _openHistoryBox();
    final key = '${history.from}_${history.to}';
    await box.put(key, history);
  }
}