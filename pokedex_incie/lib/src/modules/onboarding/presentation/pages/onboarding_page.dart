import 'package:flutter/material.dart';
import 'package:pokedex_incie/src/main.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StructureBase(
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 60,
                    child: Image.asset(
                      "assets/images/IMG_LOGO_INICIE.png",
                      key: const Key("OnboardingPageLogoImage"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 15,
                    child: Image.asset(
                      "assets/images/IMG_BACKGROUND_ONBOARDING.png",
                      key: const Key("OnboardingPageBackGroundImage"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Explore o mundo dos ',
                    style: Theme.of(context).textTheme.displayLarge,
                    children: <InlineSpan>[
                      TextSpan(
                        text: 'Pokémons',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ],
                  ),
                  key: const Key("OnboardingPageTitle"),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "Descubra todas as espécies de Pokémons",
                  key: const Key(
                    "OnboardingPageSubTitle",
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: 227,
                  child: MainButton(
                    key: const Key(
                      "OnboardingPageButtonStart",
                    ),
                    onTap: () => Navigator.of(context).pushReplacementNamed(
                      PokedexRoutes.homePage,
                    ),
                    child: Row(
                      children: [
                        const Spacer(flex: 3),
                        Text(
                          'Começar',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(flex: 2),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
