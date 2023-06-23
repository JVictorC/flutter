import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String msg,
}) async =>
    await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Aviso'),
        content: Text(msg),
        actions: <Widget>[
          // define os botões na base do dialogo
          ZeraButton(
            text: 'Fechar',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
