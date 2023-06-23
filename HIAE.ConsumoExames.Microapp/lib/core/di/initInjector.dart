import '../adapters/base_injector/base_injector_adapter.dart';
import '../adapters/base_injector/base_injector_interface.dart';
import 'di.dart';

late final IBaseInjector I;

void initInjector() {
  I = BaseInjectorAdapter();

  adapters();
  initDatasource();
  initRepository();
  initUseCase();
  initCubit();
}
