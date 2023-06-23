import 'package:contatos_vo/src/main.dart';

abstract class IGetAllContactsUseCases {
  Future<Result<HomePageListError, List<ContactEntity>>> call();
}

class GetAllContactsUseCases implements IGetAllContactsUseCases {
  final IGetAllContactsRepository _repository;

  GetAllContactsUseCases({
    required IGetAllContactsRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<HomePageListError, List<ContactEntity>>> call() async => _repository();
}
