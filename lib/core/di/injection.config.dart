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

import '../../features/curruncy/data/datasources/currency_local_data_source.dart'
    as _i994;
import '../../features/curruncy/data/datasources/currency_remote_data_source.dart'
    as _i936;
import '../../features/curruncy/data/repositories/currency_repository_impl.dart'
    as _i864;
import '../../features/curruncy/domain/usecases/convert_currency.dart' as _i676;
import '../../features/curruncy/domain/usecases/get_currencies.dart' as _i83;
import '../../features/curruncy/domain/usecases/get_historical_rates.dart'
    as _i452;
import '../../features/curruncy/presentation/bloc/currency_bloc.dart' as _i234;
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
    gh.lazySingleton<_i676.ConvertCurrency>(
        () => _i676.ConvertCurrency(gh<InvalidType>()));
    gh.lazySingleton<_i83.GetCurrencies>(
        () => _i83.GetCurrencies(gh<InvalidType>()));
    gh.lazySingleton<_i452.GetHistoricalRates>(
        () => _i452.GetHistoricalRates(gh<InvalidType>()));
    gh.lazySingleton<_i936.CurrencyRemoteDataSource>(
        () => _i936.CurrencyRemoteDataSourceImpl(gh<_i361.Dio>()));
    gh.lazySingleton<_i994.CurrencyLocalDataSource>(
        () => _i994.CurrencyLocalDataSourceImpl());
    gh.factory<_i234.CurrencyBloc>(() => _i234.CurrencyBloc(
          gh<InvalidType>(),
          gh<InvalidType>(),
          gh<InvalidType>(),
        ));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i865.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()));
    gh.lazySingleton<_i864.CurrencyRepositoryImpl>(
        () => _i864.CurrencyRepositoryImpl(
              remoteDataSource: gh<InvalidType>(),
              localDataSource: gh<InvalidType>(),
              networkInfo: gh<_i932.NetworkInfo>(),
            ));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
