import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'speech_interface.dart';

class SpeechAdapter implements ISpeech {
  late final SpeechToText _speech;
  late String _currentLocaleId;
  bool _hasSpeech = false;
  String? _lastWords;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  TextEditingController controller;

  SpeechAdapter({
    required this.controller,
  }) {
    _speech = SpeechToText();
  }

  @override
  Future<void> initSpeechState() async {
    try {
      var hasSpeech = await _speech.initialize(
        debugLogging: false,
      );

      if (hasSpeech) {
        var systemLocale = await _speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      _hasSpeech = hasSpeech;
    } catch (e) {
      _hasSpeech = false;
    }
  }

  @override
  Future<void> startListening() async {
    const pauseFor = 3;
    const listenFor = 10;
    _lastWords = '';

    await _speech.listen(
      onResult: result,
      listenFor: const Duration(seconds: listenFor),
      pauseFor: const Duration(seconds: pauseFor),
      partialResults: true,
      localeId: 'pt_BR', // _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      cancelOnError: true,
      listenMode: ListenMode.confirmation,
    );
  }

  @override
  void cancel() {
    _speech.cancel();
  }

  @override
  void stop() {
    _speech.stop();
  }

  @override
  void result(SpeechRecognitionResult result) {
    _lastWords = result.recognizedWords;

    controller.clear();

    if (_lastWords != null && _lastWords!.isNotEmpty) {
      controller.text = _lastWords!;
    }
  }

  @override
  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
  }

  @override
  String getResult() => _lastWords ?? '';

  @override
  bool isActive() => _hasSpeech || _speech.isListening;
}
