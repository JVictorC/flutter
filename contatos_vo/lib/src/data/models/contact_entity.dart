import 'package:contatos_vo/src/domain/entities/contact_entity.dart';
import 'package:contatos_vo/src/main.dart';

class ContactModel extends ContactEntity {
  const ContactModel({
    required String apelido,
    required String endereco,
    required String imagem,
    required String nome,
    required String telefone,
    required String whatsapp,
    required Parentesco parentesco,
  }) : super(
          apelido,
          endereco,
          imagem,
          nome,
          telefone,
          whatsapp,
          parentesco,
        );

  factory ContactModel.fromEntity(ContactEntity e) {
    return ContactModel(
      apelido: e.apelido,
      endereco: e.endereco,
      imagem: e.imagem,
      nome: e.nome,
      telefone: e.telefone,
      whatsapp: e.whatsapp,
      parentesco: e.parentesco,
    );
  }

  ContactModel copyWith({
    String? apelido,
    String? endereco,
    String? imagem,
    String? nome,
    String? telefone,
    String? whatsapp,
    Parentesco? parentesco,
  }) {
    return ContactModel(
      apelido: apelido ?? this.apelido,
      endereco: endereco ?? this.endereco,
      imagem: imagem ?? this.imagem,
      nome: nome ?? this.nome,
      telefone: telefone ?? this.telefone,
      whatsapp: whatsapp ?? this.whatsapp,
      parentesco: parentesco ?? this.parentesco,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'apelido': apelido,
      'endereco': endereco,
      'imagem': imagem,
      'nome': nome,
      'telefone': telefone,
      'whatsapp': whatsapp,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      apelido: map['Apelido'] ?? "",
      endereco: map['Endereço'] ?? "",
      imagem: map['Imagem'] ?? "",
      nome: map['Nome'] ?? "",
      telefone: map['Telefone'] ?? "",
      whatsapp: map['WhatSapp'] ?? "",
      parentesco:
          map['Parentesco'] == "Filho" ? Parentesco.Filho : Parentesco.Neto,
    );
  }
}
