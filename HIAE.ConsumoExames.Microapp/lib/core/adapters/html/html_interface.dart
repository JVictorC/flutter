import 'package:flutter/material.dart';

abstract class IHTMLAdapter {
  Widget html({
    required String html,
    String? url,
  });
}
