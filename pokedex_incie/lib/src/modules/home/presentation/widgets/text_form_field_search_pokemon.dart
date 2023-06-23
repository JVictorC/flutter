import 'package:flutter/material.dart';

class TextFormFieldSearchPokemon extends StatelessWidget {
  const TextFormFieldSearchPokemon({
    super.key,
    this.onChanged,
    this.onTap,
    this.controller,
  });

  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: TextField(
          key: const Key("HomePageTextField"),
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              bottom: 0,
              left: 10,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            suffixIcon: GestureDetector(
              key: const Key("HomePageButtonConfirmTextFormField"),
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
