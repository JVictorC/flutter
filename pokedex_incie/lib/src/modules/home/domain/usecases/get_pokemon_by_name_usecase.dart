import 'package:pokedex_incie/src/main.dart';

abstract class IGetPokemonByNameUsecase {
  Future<Result<GetPokemonByNameError, PokemonEntity>> call({
    required String namePokemon,
  });
}

class GetPokemonByNameUsecase implements IGetPokemonByNameUsecase {
  final IGetPokemonByNameRepository _repository;

  GetPokemonByNameUsecase({
    required IGetPokemonByNameRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<GetPokemonByNameError, PokemonEntity>> call({
    required String namePokemon,
  }) async =>
      _repository(namePokemon);
}
