abstract class IBaseInjector {
  T getDependency<T extends Object>();
  void registerSingleton<T extends Object>(T dependency);
  void registerFactory<T extends Object>(
    T Function() factoryFunc,
  );
  void registerLazySingleton<T extends Object>(T dependency);
  void unregister<T extends Object>();
  bool isRegistered<T extends Object>();
}
