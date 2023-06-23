import 'package:get_it/get_it.dart';

abstract class InjectorAbs {
  registesDependency<T extends Object>(T classRegistered);
  T get<T extends Object>();
}

final _get = GetIt.I;

class Injector implements InjectorAbs {
  @override
  T get<T extends Object>() {
    return _get.get<T>();
  }

  @override
  registesDependency<T extends Object>(T classRegistered) {
    _get.registerFactory<T>(() => classRegistered);
  }
}


final I = Injector();