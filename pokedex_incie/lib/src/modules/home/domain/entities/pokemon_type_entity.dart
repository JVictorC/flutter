import 'package:equatable/equatable.dart';

class PokemonTypeEntity extends Equatable {
  final String name;
  final String url;

  const PokemonTypeEntity(this.name, this.url);
  
  @override
  List<Object?> get props => [name, url];
}