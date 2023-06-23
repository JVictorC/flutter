import 'package:pokedex_incie/src/core/core.dart';

initCoreDependencies() {
  I.registesDependency<IHttpClient>(
    HttpClient(),
  );

  I.registesDependency<ISharedPreference>(
    SharedPreference(),
  );
}
