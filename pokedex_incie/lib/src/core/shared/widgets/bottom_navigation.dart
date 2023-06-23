import 'package:flutter/material.dart';
import 'package:pokedex_incie/src/core/core.dart';

class BottomNavigatorBar extends StatelessWidget {
  const BottomNavigatorBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _menuItem(
            context: context,
            text: 'Home',
            image: 'IMG_HOME_ICON.png',
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
              PokedexRoutes.homePage,
              (_) => false,
            ),
          ),
          _menuItem(
            context: context,
            text: 'Favoritos',
            image: 'IMC_FAVORITES.png',
            onTap: () {},
          ),
          _menuItem(
            context: context,
            text: 'Minha Conta',
            image: 'IMG_MY_ACCOUNT.png',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required String text,
    required String image,
    required BuildContext context,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
            child: Image.asset("assets/images/$image"),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0XFFA2A9B0),
                ),
          ),
        ],
      ),
    );
  }

  Widget _separator() => Container(
        color: Colors.white,
        width: 1,
        height: 24,
      );
}
