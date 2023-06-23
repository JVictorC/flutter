import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_incie/src/core/core.dart';
import 'package:pokedex_incie/src/modules/home/home.dart';

export './core/core.dart';
export './modules/onboarding/onboarding.dart';
export './modules/home/home.dart';
export './modules/details_pokemon/details_pokemon.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initAllDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => I.get<HomePageCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'PokeDex Inicie',
        theme: pokedexTheme,
        routes: pokedexRoutes,
        initialRoute: PokedexRoutes.onboardingPage,
      ),
    ),
  );
}
