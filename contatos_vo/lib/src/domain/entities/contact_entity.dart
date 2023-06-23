import 'package:contatos_vo/src/main.dart';
import 'package:equatable/equatable.dart';

class ContactEntity extends Equatable {
  final String apelido;
  final String endereco;
  final String imagem;
  final String nome;
  final String telefone;
  final String whatsapp;
  final Parentesco parentesco;

  const ContactEntity(
    this.apelido,
    this.endereco,
    this.imagem,
    this.nome,
    this.telefone,
    this.whatsapp,
    this.parentesco,
  );

  @override
  List<Object?> get props => [
        apelido,
        endereco,
        imagem,
        nome,
        telefone,
        whatsapp,
      ];
}
