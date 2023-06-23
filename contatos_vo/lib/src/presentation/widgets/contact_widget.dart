import 'dart:ui';

import 'package:contatos_vo/src/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWidget extends StatelessWidget {
  final ContactModel contact;
  final Axis axis;
  const ContactWidget({
    Key? key,
    required this.contact,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: FittedBox(
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        contact.imagem,
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      contact.nome,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          contact.parentesco == Parentesco.Neto
                              ? "Neto"
                              : "Filho",
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.whatsapp),
                          onPressed: () async {
                            final phoneWithSpace = "55${contact.telefone.replaceAll(' ', '')}";

                            final url = Uri.parse(
                              "whatsapp://send?phone=$phoneWithSpace",
                            );

                            await launchUrl(url);
                          },
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                          icon: const Icon(Icons.phone),
                          onPressed: () async {
                          final url = Uri.parse(
                              "tel:${contact.telefone}",
                            );

                            await launchUrl(url);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          }),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  contact.imagem,
                ),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.nome,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  contact.parentesco == Parentesco.Neto ? "Neto" : "Filho",
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.star_border_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
