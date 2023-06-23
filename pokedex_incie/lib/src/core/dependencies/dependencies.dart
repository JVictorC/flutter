



import 'package:pokedex_incie/src/core/dependencies/core_dependencies.dart';
import 'package:pokedex_incie/src/core/dependencies/cubit_dependencies.dart';
import 'package:pokedex_incie/src/core/dependencies/repositories_dependencies.dart';
import 'package:pokedex_incie/src/core/dependencies/usecases_dependencies.dart';

initAllDependencies() {
  initCoreDependencies();
  initRepositoriesDependencies();
  initUseCasesDependencies();
  initCubitDependencies();
}
