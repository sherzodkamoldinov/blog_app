import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vlog_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:vlog_app/cubits/blogs_cubit/blogs_cubit.dart';
import 'package:vlog_app/cubits/users_cubit/users_cubit.dart';
import 'package:vlog_app/data/services/api/api_provider.dart';
import 'package:vlog_app/data/repositories/auth_repository.dart';
import 'package:vlog_app/data/repositories/blogs_repository.dart';
import 'package:vlog_app/data/repositories/users_repository.dart';
import 'package:vlog_app/data/services/local/storage_service.dart';
import 'package:vlog_app/views/no_internet/no_internet_page.dart';
import 'package:vlog_app/views/router.dart';
import 'package:vlog_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/services/api/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await StorageRepository.getInstance();
  await ScreenUtil.ensureScreenSize();
  StorageService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final ApiProvider _apiProvider = ApiProvider(
    apiClient: ApiClient(),
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(apiProvider: _apiProvider),
        ),
        RepositoryProvider<UsersRepository>(
          create: (_) => UsersRepository(apiProvider: _apiProvider),
        ),
        RepositoryProvider<BlogsRepository>(
          create: (_) => BlogsRepository(apiProvider: _apiProvider),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => UsersCubit(
              usersRepository: context.read<UsersRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => BlogsCubit(
              blogsRepository: context.read<BlogsRepository>(),
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
          builder: (context, child) {
            return StreamBuilder(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  if (snapshot.data == ConnectivityResult.none) {
                    return const NoInternetPage();
                  }
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: 1.0, alwaysUse24HourFormat: true),
                    child: child!,
                  );
                });
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.orange,
            appBarTheme: const AppBarTheme(backgroundColor: Colors.orange)
          ),
          onGenerateRoute: MyRouter.generateRoute,
          initialRoute: splashView // mainPage,
          ),
    );
  }
}
