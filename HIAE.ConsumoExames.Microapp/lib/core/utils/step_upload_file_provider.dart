import 'package:flutter/material.dart';

class StepUploadFileProvider extends ChangeNotifier {
  int? _sent;
  int? _total;

  get sent => _sent;
  get total => _total;

  StepUploadFileProvider({
    int? sent,
    int? total,
  })  : _sent = sent,
        _total = total;

  void updateProgress({sent, total}) {
    _sent = sent;
    _total = total;
    notifyListeners();
  }
}
