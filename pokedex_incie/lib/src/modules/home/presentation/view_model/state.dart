import 'package:equatable/equatable.dart';
import 'package:pokedex_incie/src/main.dart';

abstract class HomePageState extends Equatable {}

class InitialState extends HomePageState {
  @override
  List<Object> get props => [];
}

// Loading

class LoadingSearchPokemon extends HomePageState {
  @override
  List<Object> get props => [];
}

class LoadingTypesState extends HomePageState {
  @override
  List<Object> get props => [];
}

class LoadingMostSearch extends HomePageState {
  @override
  List<Object> get props => [];
}

// Loaded

class LoadedPokemonsTypesState extends HomePageState {
  LoadedPokemonsTypesState();

  @override
  List<Object> get props => [];
}

class LoadedPokemonState extends HomePageState {
  LoadedPokemonState(this.pokemon);

  final PokemonEntity pokemon;

  @override
  List<Object> get props => [pokemon];
}

class LoadedMostSearch extends HomePageState {
  LoadedMostSearch();


  @override
  List<Object> get props => [];
}


// Erros

class ErrorTypeList extends HomePageState {
  final String message;

  ErrorTypeList(this.message);

  @override
  List<Object> get props => [];
}

class ErrorSearchPokemonState extends HomePageState {
  final String message;

  ErrorSearchPokemonState(this.message);

  @override
  List<Object> get props => [];
}

class ErrorMostSearch extends HomePageState {
  final String message;

  ErrorMostSearch(this.message);

  @override
  List<Object> get props => [];
}
