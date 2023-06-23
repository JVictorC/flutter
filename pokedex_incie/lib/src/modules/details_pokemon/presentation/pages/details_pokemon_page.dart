import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_incie/src/core/shared/widgets/bottom_navigation.dart';
import 'package:pokedex_incie/src/main.dart';
import 'package:pokedex_incie/src/modules/details_pokemon/presentation/widgets/linear_grafic.dart';

class DetailsPokemonPage extends StatefulWidget {
  const DetailsPokemonPage({super.key});

  @override
  State<DetailsPokemonPage> createState() => _DetailsPokemonPageState();
}

class _DetailsPokemonPageState extends State<DetailsPokemonPage> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final PokemonEntity pokemonDetail = arguments["pokemon"];

    return StructureBase(
      appBar: BaseAppBar(
        hasMenu: false,
        onTapBack: () => Navigator.of(context).pushNamedAndRemoveUntil(
          PokedexRoutes.homePage,
          (_) => false,
        ),
      ),
      bottomNavigationBar: const BottomNavigatorBar(),
      child: Column(
        children: [
          CachedNetworkImage(
            key: const Key("DetailsPageImage"),
            imageUrl: pokemonDetail.imagePokemon,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  key: const Key("DetailsPageDetails"),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pokemonDetail.name.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        Text(
                          "COD: #${pokemonDetail.id}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    TypePokemonColor(typePokemon: pokemonDetail.type),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
            key: const Key("DetailsPageStatus"),
                
                  children: [
                    LinearGraphic(
                      points: double.parse(pokemonDetail.healthPoints),
                      label: "Vida",
                      color: const Color(0XFFF7802A),
                    ),
                    LinearGraphic(
                      points: double.parse(pokemonDetail.defensePoints),
                      label: "Defesa",
                      color: const Color(0XFFC4F789),
                    ),
                    LinearGraphic(
                      points: double.parse(pokemonDetail.strengthPoints),
                      label: "Ataque",
                      color: const Color(0XFFEA686D),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
