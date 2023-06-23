import 'package:equatable/equatable.dart';

import '../exceptions/exceptions.dart';
import '../utils/result.dart';

abstract class UseCase<Type, Params> {
  Future<Result<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
