import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_incie/src/core/shared/widgets/bottom_navigation.dart';
import 'package:pokedex_incie/src/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageCubit _cubit;
  late final TextEditingController _controller;

  @override
  void initState() {
    _staterPage();
    super.initState();
  }

  Future<void> _staterPage() async {
    _cubit = I.get<HomePageCubit>();

    _controller = TextEditingController();

    await _cubit.getAllTypesPokemon();
    await _cubit.readPokemonsHistory();
  }

  @override
  Widget build(BuildContext context) {
    return StructureBase(
      bottomNavigationBar: const BottomNavigatorBar(),
      child: BlocListener<HomePageCubit, HomePageState>(
        listener: (context, state) {
          if (state is LoadedPokemonState) {
            Navigator.pushReplacementNamed(
              context,
              PokedexRoutes.detailsPokemon,
              arguments: {
                'pokemon': state.pokemon,
              },
            );
            return;
          }

          if (state is ErrorSearchPokemonState) {
            final snackBar = SnackBar(
              content: Text(state.message),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Column(
          children: [
            _headerHomePage(
              context,
              _cubit,
              _controller,
            ),
            Expanded(
              child: BlocBuilder<HomePageCubit, HomePageState>(
                builder: (context, state) {
                  if (state is LoadingSearchPokemon) {
                    return const LoadingWidget();
                  }

                  return Column(
                    children: [
                      _typePokemonsHomePage(context, _cubit),
                      _mostSearch(context, _cubit),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _headerHomePage(
  BuildContext context,
  HomePageCubit cubit,
  TextEditingController controller,
) =>
    SizedBox(
      height: 300,
      child: Stack(
        children: [
          BaseAppBar(),
          Positioned(
            top: 70,
            left: 20,
            right: 20,
            child: Container(
              height: 200,
              width: 335,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(
                      .1,
                    ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pokedéx",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Todas as espécies de pokemons estão esperando por você!",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 20),
                          TextFormFieldSearchPokemon(
                            controller: controller,
                            onTap: () =>
                                cubit.getPokemonByName(controller.text),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Image.asset("assets/images/IMG_PIKACHU.png")
                ],
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 40,
            child: Image.asset(
              "assets/images/IMG_ELIPSE.png",
            ),
          ),
        ],
      ),
    );

Widget _typePokemonsHomePage(
  BuildContext context,
  HomePageCubit cubit,
) =>
    Stack(
      children: [
        Positioned(
          left: 10,
          top: 50,
          child: Image.asset(
            "assets/images/IMG_ELIPSE.png",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tipo",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              BlocBuilder<HomePageCubit, HomePageState>(
                builder: (context, state) {
                  if (state is LoadingTypesState) {
                    return const LoadingWidget();
                  }

                  if (state is ErrorTypeList) {
                    return const Center(
                      child: Text("Erro"),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: cubit.pokemonsTypes
                          .map(
                            (e) => TypePokemonColor(
                              typePokemon: e.name,
                            ),
                          )
                          .toList(),
                    ),
                  );
                },
              )
            ],
          ),
        )
      ],
    );

Widget _mostSearch(BuildContext context, HomePageCubit _cubit) => Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Mais procurados",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            BlocBuilder<HomePageCubit, HomePageState>(
              builder: (context, state) {
                if (state is LoadingMostSearch) {
                  return const LoadingWidget();
                }

                if (_cubit.pokemonsInHistory.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/IMG_PICHACHU_NOT_SEARCH.png",
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Infelizmente, você não fez\nnenhuma Busca",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  );
                }

                return Wrap(
                  spacing: 7,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: _cubit.pokemonsInHistory
                      .map(
                        (e) => CardPokemonWidget(
                          cod: e.id,
                          title: e.name,
                          typePokemon: e.type,
                          urlImagePokemon: e.imagePokemon,
                          onPressed: () => Navigator.pushReplacementNamed(
                            context,
                            PokedexRoutes.detailsPokemon,
                            arguments: {
                              "pokemon": e,
                            },
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )
          ],
        ),
      ),
    );
