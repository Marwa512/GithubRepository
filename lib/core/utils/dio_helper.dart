
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../features/home/data/model/repository_model.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
          baseUrl: "https://api.github.com/users/square/repos",
          followRedirects: false,
         ),
    );
  }

   Future<List<Repository>> getData(
      {required String url, dynamic query, int? page, int? perPage}) async {
    if (kDebugMode) {
      print("API ${dio.options.baseUrl + url}, Query : $query");
    }
    try {
      final Response<dynamic> response = await dio.get(
        url,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );
      if (kDebugMode) {
        print("response$response");
      }
      final List<dynamic> responseMap = response.data;
      List<Repository> repositories =
          responseMap.map((dynamic item) => Repository.fromJson(item)).toList();

      return repositories;
    } catch (error) {
      throw Exception('Failed to load repositories');
    }
  }
}
