
import 'package:contatos_vo/src/main.dart';
import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {}

class InitialState extends HomePageState {
  @override
  List<Object> get props => [];
}

class LoadingState extends HomePageState {
  @override
  List<Object> get props => [];
}

class LoadedState extends HomePageState {
  LoadedState(this.contacts);

  final List<ContactEntity> contacts;

  @override
  List<Object> get props => [contacts];
}

class ErrorState extends HomePageState {
  @override
  List<Object> get props => [];
}