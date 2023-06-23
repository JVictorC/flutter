import '../di/initInjector.dart';
import '../entities/user_auth_info.dart';
import '../localization/localization.dart';

extension Translate on String {
  String translate() {
    if (I.isRegistered<UserAuthInfoEntity>()) {
      final localization = I.getDependency<UserAuthInfoEntity>();
      final translateString = MapLocalization[this]![localization.localization];
      return translateString!;
    } else {
      return this;
    }
  }
}
