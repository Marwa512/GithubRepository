import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/repository_model.dart';

class SharedPrefrencesProvider {
  Future<void> cacheRepositories(List<Repository> repositories) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> repoStrings =
        repositories.map((repo) => jsonEncode(repo.toJson())).toList();
    await prefs.setStringList('cached_repos', repoStrings);
  }

  Future<List<Repository>> getCachedRepositories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? repoStrings = prefs.getStringList('cached_repos');
    if (repoStrings != null) {
      List<Repository> cachedRepos = repoStrings
          .map((repo) => Repository.fromJson(jsonDecode(repo)))
          .toList();
      return cachedRepos;
    } else {
      throw Exception('No cached repositories found');
    }
  }

  Future<void> clearCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_repos');
  }
}
