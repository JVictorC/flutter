import 'package:contatos_vo/src/main.dart';

initUseCasesDependencies() {
  I.registesDependency<IGetAllContactsUseCases>(
    GetAllContactsUseCases(
      repository: I.get<IGetAllContactsRepository>(),
    ),
  );
}
