import 'package:flutter/material.dart';

class TypePokemonColor extends StatelessWidget {
  const TypePokemonColor({
    super.key,
    this.withOpacity = false,
    this.hasPadding = true,
    required this.typePokemon,
  });

  final String typePokemon;
  final bool withOpacity;
  final bool hasPadding;

  Color _getColorPokemon() {
    switch (typePokemon) {
      case "normal":
        return const Color(0XFF49D0B0);
      case "fighting":
        return const Color(0XFFF1AFB2);
      case "flying":
        return const Color(0XFF9E81A9);
      case "poison":
        return const Color(0XFFF1AFB2);
      case "ground":
        return const Color(0XFF2E7885);
      case "rock":
        return const Color(0XFFF38333);
      case "bug":
        return const Color(0XFFF3656B);
      case "ghost":
        return const Color(0XFF3656BF);
      case "steel":
        return const Color(0XFF2E7885);
      case "fire":
        return const Color(0XFFF1AFB2);
      case "water":
        return const Color(0XFF2E7885);
      case "grass":
        return const Color(0XFF49D0B0);
      case "electric":
        return const Color(0XFFF49D0B);
      case "psychic":
        return const Color(0XFF2E7885);
      case "ice":
        return const Color(0XFF2E7885);
      case "dragon":
        return const Color(0XFF9E81A9);
      case "dark":
        return const Color(0XFF383332);
      case "fairy":
        return const Color(0XFFF1AFB2);
      case "unknown":
        return const Color(0XFFF1AFB2);
      case "shadow":
        return const Color(0XFF383332);
      default:
        return const Color(0XFFF1AFB2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: hasPadding ? 7 : 0, vertical: 10),
      child: Container(
        height: 40,
        width: 80,
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
        ),
        decoration: BoxDecoration(
          color: _getColorPokemon(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FittedBox(
            child: Text(
              typePokemon.toUpperCase(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
