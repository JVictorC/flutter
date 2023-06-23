abstract class HomeException implements Exception {
  final String message;

  HomeException(this.message);
}

class GetPokemonByNameError implements HomeException {
  @override
  final String message;

  GetPokemonByNameError(this.message);
}

class GetPokemonTypeError implements HomeException {
  @override
  final String message;

  GetPokemonTypeError(this.message);
}

class SavePokemonError implements HomeException {
  @override
  final String message;

  SavePokemonError(this.message);
}

class ReadPokemonHistoryError implements HomeException {
  @override
  final String message;

  ReadPokemonHistoryError(this.message);
}