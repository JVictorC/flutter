import 'package:bloc/bloc.dart';
import 'package:contatos_vo/src/main.dart';
import 'package:contatos_vo/src/presentation/viewModels/home_page_view_model/states.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({
    required IGetAllContactsUseCases getAllContactsUseCases,
  })  : _getAllContactsUseCases = getAllContactsUseCases,
        super(
          InitialState(),
        );

  final IGetAllContactsUseCases _getAllContactsUseCases;

  Future<void> getAllContacts() async {
    try {
      emit(LoadingState());

      final result = await _getAllContactsUseCases();

      if (result.isError) throw result.error!;

      emit(LoadedState(result.value!));
    } catch (e) {
      emit(ErrorState());
    }
  }
}
