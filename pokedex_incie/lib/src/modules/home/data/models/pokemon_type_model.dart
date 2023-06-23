import 'package:pokedex_incie/src/main.dart';

class PokemonTypeModel extends PokemonTypeEntity {
  const PokemonTypeModel({
    required String name,
    required String url,
  }) : super(
          name,
          url,
        );

  factory PokemonTypeModel.fromEntity(PokemonTypeEntity e) => PokemonTypeModel(
        name: e.name,
        url: e.url,
      );

  factory PokemonTypeModel.fromMap(Map<String, dynamic> map) {
    return PokemonTypeModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }
}
