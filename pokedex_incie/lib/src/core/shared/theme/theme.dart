import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final pokedexTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0XFFEA686D),
    secondary: const Color(0XFF2F3E77),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.nunito(
      fontWeight: FontWeight.w700,
      color: const Color(0XFF2F3E77),
      fontSize: 35,
    ),
    bodySmall: GoogleFonts.nunito(
      fontWeight: FontWeight.w400,
      color: const Color(0XFF2F3E77),
      fontSize: 14,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontWeight: FontWeight.w400,
      color: const Color(0XFF2F3E77),
      fontSize: 16,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontWeight: FontWeight.w700,
      color: const Color(0XFFFFFFFF),
      fontSize: 18,
    ),
  ),
);
