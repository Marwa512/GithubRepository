import 'package:creative_minds/features/home/data/model/repository_model.dart';
import 'package:creative_minds/features/home/data/repository/home_repo_impl.dart';
import 'package:creative_minds/features/home/presentation/bloc/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<RepositoryState> {
  final HomeRepositoryImp repositoryImp;
  HomeCubit(this.repositoryImp) : super(RepositoryInitialState());

  List<dynamic> newRepositories = [];

  Future<void> getRepositoriesList(int page, int perPage) async {
    emit(GetRepositoryLoadingState());

    try {
      List<Repository> repositories =
          await repositoryImp.getRepositories(page, perPage);
      emit(GetRepositorySuccessState(repositories));
    } catch (e) {
      emit(GetRepositoryFailureState(e.toString()));
    }
  }

  Future<void> refreshRepositories() async {
    await repositoryImp.clearCache();
    await getRepositoriesList(1, 10);
  }

  Future<void> loadCachedRepositories() async {
    try {
      List<Repository> cachedRepos =
          await repositoryImp.getCachedRepositories();
      emit(GetRepositorySuccessState(cachedRepos));
    } catch (e) {
      emit(RepositoryInitialState());
    }
  }
}
