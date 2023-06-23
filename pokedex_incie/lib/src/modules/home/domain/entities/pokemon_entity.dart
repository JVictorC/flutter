import 'package:equatable/equatable.dart';

class PokemonEntity extends Equatable {
  final String imagePokemon;
  final String name;
  final String id;
  final String type;
  final String healthPoints;
  final String strengthPoints;
  final String defensePoints;

  const PokemonEntity(
    this.imagePokemon,
    this.name,
    this.id,
    this.type,
    this.healthPoints,
    this.strengthPoints,
    this.defensePoints,
  );

  @override
  List<Object?> get props => [
        imagePokemon,
        name,
        id,
        type,
        healthPoints,
        strengthPoints,
        defensePoints
      ];
}
