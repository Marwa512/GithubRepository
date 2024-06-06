import '../../data/model/repository_model.dart';

abstract class RepositoryState {}

class RepositoryInitialState extends RepositoryState {}

class GetRepositoryLoadingState extends RepositoryState {}

class GetRepositorySuccessState extends RepositoryState {
  final List<Repository> repositories;

  GetRepositorySuccessState(this.repositories);
}

class GetRepositoryFailureState extends RepositoryState {
  String? error;
  GetRepositoryFailureState(this.error);
}
