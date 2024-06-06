
import 'package:creative_minds/core/utils/dio_helper.dart';
import 'package:creative_minds/features/home/data/model/repository_model.dart';
import 'package:creative_minds/features/home/data/repository/home_repo.dart';

import '../dataresources/local_data.dart';

class HomeRepositoryImp implements HomeRepo{
  final SharedPrefrencesProvider localDataSource;
  final DioHelper remoteDataSource;

  HomeRepositoryImp({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<Repository>> getRepositories(int page, int perPage) async {
    try {
      List<Repository> remoteRepositories =
          await remoteDataSource.getData( url: "",page: page, perPage: perPage, query: "");
      await localDataSource.cacheRepositories(remoteRepositories);
      return remoteRepositories;
    } catch (e) {
      return localDataSource.getCachedRepositories();
    }
  }

  @override
  Future<void> clearCache() {
    return localDataSource.clearCache();
  }

  @override
  Future<List<Repository>> getCachedRepositories() {
    return localDataSource.getCachedRepositories();
  }
}
