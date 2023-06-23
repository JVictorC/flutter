import 'package:pokedex_incie/src/main.dart';

class PokedexRoutes {
  static const onboardingPage = "OnboardingPage";
  static const homePage = "HomePage";
  static const detailsPokemon = "DetailsPokemon";

}

final pokedexRoutes = {
  PokedexRoutes.onboardingPage: (context) => const OnboardingPage(),
  PokedexRoutes.homePage: (context) => const HomePage(),
  PokedexRoutes.detailsPokemon: (context) => const DetailsPokemonPage(),
};
