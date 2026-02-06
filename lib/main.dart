import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_converter/core/di/injection.dart';
import 'package:flutter_currency_converter/core/theme/app_theme.dart';
import 'package:flutter_currency_converter/core/utils/bloc_observer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/currency/data/models/currency_model.dart';
import 'features/currency/data/models/history_model.dart';
import 'features/currency/presentation/bloc/currency_bloc.dart';
import 'features/currency/presentation/pages/dashboard_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(CurrencyModelAdapter());
  Hive.registerAdapter(HistoryModelAdapter());

  await configureDependencies();
  Bloc.observer = SimpleBlocObserver();


  runApp(const CurrencyApp());
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CurrencyBloc>()..add(GetInitialDataEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Currency Converter',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const DashboardPage(),
      ),
    );
  }
}