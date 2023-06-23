import 'package:mocktail/mocktail.dart';
import 'package:pokedex_incie/src/core/core.dart';

class _SharedPreferenceMock extends Mock implements ISharedPreference {
  
}

final sharedPreferenceMock = _SharedPreferenceMock();