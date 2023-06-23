import 'package:contatos_vo/src/main.dart';

abstract class IGetAllContactsRepository {
  Future<Result<HomePageListError, List<ContactEntity>>> call();
}

