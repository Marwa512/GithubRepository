import 'package:creative_minds/core/utils/bloc_observer.dart';
import 'package:creative_minds/core/utils/service_locator.dart';
import 'package:creative_minds/features/home/data/repository/home_repo_impl.dart';
import 'package:creative_minds/features/home/presentation/bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:background_fetch/background_fetch.dart';

import 'features/home/presentation/page/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  setupServiceLocator();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundTask);
  BackgroundFetch.configure(
    BackgroundFetchConfig(
      minimumFetchInterval: 60, // in minutes   
      stopOnTerminate: false,
      startOnBoot: true,
    ),
    (String taskId) async {
      await HomeCubit(getIt.get<HomeRepositoryImp>()).refreshRepositories();
      showNotification();
      BackgroundFetch.finish(taskId);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
                HomeCubit(getIt.get<HomeRepositoryImp>())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber,
          useMaterial3: false,
        ),
        home: const HomePageScreen(),
      ),
    );
  }
}

void showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    'Repository Update',
    'Repositories have been refreshed',
    platformChannelSpecifics,
    payload: 'item x',
  );
}

void backgroundTask(String taskId) async {
  await HomeCubit(getIt.get<HomeRepositoryImp>()).refreshRepositories();
  showNotification();
  BackgroundFetch.finish(taskId);
}
