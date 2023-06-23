import 'package:pokedex_incie/src/main.dart';

abstract class IReadSearchedPokemonHistoryUseCase {
  Future<Result<ReadPokemonHistoryError, List<PokemonEntity>>> call();
}

class ReadSearchedPokemonHistoryUseCase
    implements IReadSearchedPokemonHistoryUseCase {
  final IReadSearchedPokemonHistoryRepository _repository;

  ReadSearchedPokemonHistoryUseCase({
    required IReadSearchedPokemonHistoryRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<ReadPokemonHistoryError, List<PokemonEntity>>> call() =>
      _repository();
}
