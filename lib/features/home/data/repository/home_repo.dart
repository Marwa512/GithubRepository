import 'package:creative_minds/features/home/data/model/repository_model.dart';

abstract class HomeRepo { 
   Future<List<Repository>> getRepositories(int page, int perPage);
  Future<void> clearCache();
  Future<List<Repository>> getCachedRepositories();
}