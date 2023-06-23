import 'package:get_it/get_it.dart';

abstract class InjectorAbs {
  registesDependency<T extends Object>(T classRegistered);
  T get<T extends Object>();
  reset();
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

  @override
  reset() async {
    await _get.reset();
  }
}

final I = Injector();
