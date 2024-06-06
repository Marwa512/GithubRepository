import 'package:creative_minds/core/utils/dio_helper.dart';
import 'package:creative_minds/features/home/data/dataresources/local_data.dart';
import 'package:creative_minds/features/home/data/repository/home_repo_impl.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<DioHelper>(DioHelper());
  getIt.registerSingleton<SharedPrefrencesProvider>(SharedPrefrencesProvider());
  getIt.registerSingleton<HomeRepositoryImp>(HomeRepositoryImp(
    remoteDataSource: getIt.get<DioHelper>(),
    localDataSource:  getIt.get<SharedPrefrencesProvider>(),
  ));
}