import 'package:speech_to_text/speech_recognition_result.dart';

abstract class ISpeech {
  Future<void> initSpeechState();
  Future<void> startListening();
  void result(SpeechRecognitionResult result);
  String getResult();
  void soundLevelListener(double level);
  void stop();
  void cancel();
  bool isActive();
}
