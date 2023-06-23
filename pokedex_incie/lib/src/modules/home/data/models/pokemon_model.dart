// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:pokedex_incie/src/main.dart';

class PokemonModel extends PokemonEntity {
  const PokemonModel({
    required String imagePokemon,
    required String name,
    required String id,
    required String type,
    required String healthPoints,
    required String strengthPoints,
    required String defensePoints,
  }) : super(
          imagePokemon,
          name,
          id,
          type,
          healthPoints,
          strengthPoints,
          defensePoints,
        );

  factory PokemonModel.fromEntity(PokemonEntity e) => PokemonModel(
        imagePokemon: e.imagePokemon,
        name: e.name,
        id: e.id,
        type: e.type,
        healthPoints: e.healthPoints,
        strengthPoints: e.strengthPoints,
        defensePoints: e.defensePoints,
      );

  Map<String, dynamic> toMap() => {
        "imagePokemon": imagePokemon,
        "name": name,
        "id": id,
        "type": type,
        "healthPoints": healthPoints,
        "strengthPoints": strengthPoints,
        "defensePoints": defensePoints,
      };

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
      imagePokemon:
          map['sprites']['other']['official-artwork']['front_default'] ?? "",
      name: map['name'] ?? '',
      id: map['id'].toString(),
      type: map['types'][0]['type']['name'] ?? "",
      healthPoints: map["stats"][0]["base_stat"].toString(),
      strengthPoints: map["stats"][1]["base_stat"].toString(),
      defensePoints: map["stats"][2]["base_stat"].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PokemonModel.fromHistory(String source) {
    final map = json.decode(source);
    return PokemonModel(
      imagePokemon: map["imagePokemon"],
      name: map["name"],
      id: map["id"],
      type: map["type"],
      healthPoints: map["healthPoints"],
      strengthPoints: map["strengthPoints"],
      defensePoints: map["defensePoints"],
    );
  }
}
