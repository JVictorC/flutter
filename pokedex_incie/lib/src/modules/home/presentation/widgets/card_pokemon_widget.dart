import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_incie/src/core/core.dart';

class CardPokemonWidget extends StatelessWidget {
  const CardPokemonWidget({
    super.key,
    required this.title,
    required this.cod,
    required this.typePokemon,
    required this.onPressed,
    required this.urlImagePokemon,
  });

  final String title;
  final String cod;
  final String typePokemon;
  final Function() onPressed;
  final String urlImagePokemon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 140,
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              spreadRadius: 0,
              blurRadius: 6,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    child: Text(
                      title.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  TypePokemonColor(typePokemon: typePokemon),
                  Text(
                    "#COD $cod",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Positioned(
                  left: -20,
                  top: -10,
                  child: Image.asset(
                    "assets/images/IMG_BACKGROUND_POKEMONS_HOME_MENU.png",
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 90,
                  child: CachedNetworkImage(
                    imageUrl: urlImagePokemon,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
