import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_vo/src/core/di/di.dart';
import 'package:contatos_vo/src/main.dart';

initRepositoriesDependencies() {
  I.registesDependency<IGetAllContactsRepository>(
    GetAllContactsRepository(
      fireStone:  I.get<FirebaseFirestore>(),
    ),
  );
}
