import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_vo/src/core/core.dart';

initCoreDependencies() {
  I.registesDependency<FirebaseFirestore>(
    FirebaseFirestore.instance,
  );
}
