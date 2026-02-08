// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;

import '../../features/currency/data/datasources/currency_local_data_source.dart'
    as _i443;
import '../../features/currency/data/datasources/currency_remote_data_source.dart'
    as _i907;
import '../../features/currency/data/repositories/currency_repository_impl.dart'
    as _i751;
import '../../features/currency/domain/repositories/currency_repository.dart'
    as _i87;
import '../../features/currency/domain/usecases/convert_currency.dart'
    as _i1073;
import '../../features/currency/domain/usecases/get_currencies.dart' as _i670;
import '../../features/currency/domain/usecases/get_historical_rates.dart'
    as _i17;
import '../../features/currency/presentation/bloc/currency_bloc.dart' as _i313;
import '../network/network_info.dart' as _i932;
import '../network/network_info_impl.dart' as _i865;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i973.InternetConnectionChecker>(
        () => registerModule.internetConnectionChecker);
    gh.lazySingleton<_i443.CurrencyLocalDataSource>(
        () => _i443.CurrencyLocalDataSourceImpl());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.historicalDio,
      instanceName: 'historicalDio',
    );
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i865.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    gh.lazySingleton<_i907.CurrencyRemoteDataSource>(
        () => _i907.CurrencyRemoteDataSourceImpl(
              dio: gh<_i361.Dio>(),
              historicalDio: gh<_i361.Dio>(instanceName: 'historicalDio'),
            ));
    gh.lazySingleton<_i87.CurrencyRepository>(
        () => _i751.CurrencyRepositoryImpl(
              remoteDataSource: gh<_i907.CurrencyRemoteDataSource>(),
              localDataSource: gh<_i443.CurrencyLocalDataSource>(),
              networkInfo: gh<_i932.NetworkInfo>(),
            ));
    gh.lazySingleton<_i1073.ConvertCurrency>(
        () => _i1073.ConvertCurrency(gh<_i87.CurrencyRepository>()));
    gh.lazySingleton<_i670.GetCurrencies>(
        () => _i670.GetCurrencies(gh<_i87.CurrencyRepository>()));
    gh.lazySingleton<_i17.GetHistoricalRates>(
        () => _i17.GetHistoricalRates(gh<_i87.CurrencyRepository>()));
    gh.factory<_i313.CurrencyBloc>(() => _i313.CurrencyBloc(
          gh<_i670.GetCurrencies>(),
          gh<_i1073.ConvertCurrency>(),
          gh<_i17.GetHistoricalRates>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
