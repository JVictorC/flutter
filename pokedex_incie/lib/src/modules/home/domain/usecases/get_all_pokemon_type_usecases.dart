import 'package:pokedex_incie/src/main.dart';

abstract class IGetAllPokemonTypeUsecase {
  Future<Result<GetPokemonTypeError, List<PokemonTypeEntity>>> call();
}

class GetAllPokemonTypeUsecase implements IGetAllPokemonTypeUsecase {
  final IGetAllPokemonTypeRepository _repository;

  GetAllPokemonTypeUsecase({
    required IGetAllPokemonTypeRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<GetPokemonTypeError, List<PokemonTypeEntity>>> call() async =>
      _repository();
}
