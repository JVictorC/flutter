import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contatos_vo/src/main.dart';

class GetAllContactsRepository implements IGetAllContactsRepository {
  final FirebaseFirestore _fireStone;

  GetAllContactsRepository({
    required FirebaseFirestore fireStone,
  }) : _fireStone = fireStone;

  @override
  Future<Result<HomePageListError, List<ContactEntity>>> call() async {
    try {
      final contactsCollection = _fireStone.collection("contatos_parentes");

      final queryContacts = await contactsCollection.get();
      final allContacts = queryContacts.docs
          .map(
            (e) => ContactModel.fromMap(
              e.data(),
            ),
          )
          .toList();

      return Result.success(allContacts);
    } catch (e) {
      return Result.failure(
        HomePageListError(""),
      );
    }
  }
}
