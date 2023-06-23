import 'package:get_it/get_it.dart';

import 'base_injector_interface.dart';

class BaseInjectorAdapter implements IBaseInjector {
  final _getIt = GetIt.instance;

  @override
  void unregister<T extends Object>() {
    if (_getIt.isRegistered<T>()) {
      _getIt.unregister<T>();
    }
  }

  @override
  T getDependency<T extends Object>() => _getIt.get<T>();

  @override
  void registerSingleton<T extends Object>(T dependency) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(dependency);
    }
  }

  @override
  void registerFactory<T extends Object>(
    T Function() factoryFunc,
  ) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerFactory<T>(factoryFunc);
    }
  }

  @override
  void registerLazySingleton<T extends Object>(T dependency) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerLazySingleton<T>(() => dependency);
    }
  }

  @override
  bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();
}
