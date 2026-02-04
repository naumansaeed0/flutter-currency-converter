import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      print('🟢 [Bloc Event] ${bloc.runtimeType} -> $event');
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    if (kDebugMode) {
      print('🔴 [Bloc Error] ${bloc.runtimeType} -> $error');
    }
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      print('🔵 [Bloc State] ${bloc.runtimeType} -> $change');
    }
  }
}