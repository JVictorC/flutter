import 'package:bloc/bloc.dart';
import 'package:pokedex_incie/src/main.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({
    required IGetPokemonByNameUsecase getPokemonByNameUsecase,
    required IGetAllPokemonTypeUsecase getAllPokemonTypeUsecase,
    required ISaveSearchedPokemonHistoryUseCase
        saveSearchedPokemonHistoryUseCase,
    required IReadSearchedPokemonHistoryUseCase
        readSearchedPokemonHistoryUseCase,
  })  : _getPokemonByNameUsecase = getPokemonByNameUsecase,
        _getAllPokemonTypeUsecase = getAllPokemonTypeUsecase,
        _saveSearchedPokemonHistoryUseCase = saveSearchedPokemonHistoryUseCase,
        _readSearchedPokemonHistoryUseCase = readSearchedPokemonHistoryUseCase,
        super(
          InitialState(),
        );

  final IGetPokemonByNameUsecase _getPokemonByNameUsecase;
  final IGetAllPokemonTypeUsecase _getAllPokemonTypeUsecase;
  final ISaveSearchedPokemonHistoryUseCase _saveSearchedPokemonHistoryUseCase;
  final IReadSearchedPokemonHistoryUseCase _readSearchedPokemonHistoryUseCase;

  List<PokemonTypeEntity> pokemonsTypes = [];
  List<PokemonEntity> pokemonsInHistory = [];

  Future<void> _savePokemonInHistory(PokemonEntity pokemon) async {
    final result = await _saveSearchedPokemonHistoryUseCase(
      pokemon,
    );

    if (result.isError) throw result.error!;

    if (result.value == true) {
      return;
    }
  }

  Future<void> getAllTypesPokemon() async {
    try {
      emit(LoadingTypesState());

      final result = await _getAllPokemonTypeUsecase();

      if (result.isError) throw result.error!;

      pokemonsTypes = result.value!;
      emit(LoadedPokemonsTypesState());
    } on GetPokemonTypeError catch (e) {
      emit(ErrorTypeList(e.message));
    } catch (e) {
      emit(
        ErrorTypeList("Aconteceu algo inesperado"),
      );
    }
  }

  Future<void> getPokemonByName(String pokemonName) async {
    try {
      emit(LoadingSearchPokemon());

      final result = await _getPokemonByNameUsecase(
        namePokemon: pokemonName,
      );

      if (result.isError) throw result.error!;

      _savePokemonInHistory(result.value!);

      emit(LoadedPokemonState(result.value!));
    } on GetPokemonByNameError catch (e) {
      emit(ErrorSearchPokemonState(e.message));
    } catch (e) {
      emit(ErrorSearchPokemonState("Aconteceu algo inesperado"));
    }
  }

  Future<void> readPokemonsHistory() async {
    try {
      emit(LoadingMostSearch());

      final result = await _readSearchedPokemonHistoryUseCase();

      if (result.isError) throw result.error!;

      emit(LoadedMostSearch());
      pokemonsInHistory = result.value!;
    } on ReadPokemonHistoryError catch (e) {
      emit(ErrorMostSearch(e.message));
    } catch (e) {
      emit(ErrorMostSearch("Aconteceu algo inesperado"));
    }
  }
}
