import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';
import 'package:task_manager/presentation/screens/home_screen.dart';
import 'package:task_manager/presentation/screens/login_screen.dart';
import 'package:task_manager/services/apis/auth_services.dart';
import 'package:task_manager/services/apis/task_services.dart';
import 'package:task_manager/services/database_helper.dart';

class AppRouter {
  late AuthBloc authBloc;
  late TaskBloc taskBloc;
  late InternetCubit internetCubit;
  late TaskDetailsBloc taskDetailsBloc;
  late AuthServices authService;
  late TaskServices taskServices;
  late FlutterSecureStorage flutterSecureStorage;
  late DatabaseHelper databaseHelper;

  AppRouter() {
    _initializeAppRouter();
  }

  Future<void> _initializeAppRouter() async {
    // Initialize SharedPreferences
    flutterSecureStorage = const FlutterSecureStorage();
    databaseHelper = DatabaseHelper();

    // Initialize other services and blocs
    internetCubit = InternetCubit();
    authService = AuthServices(flutterSecureStorage: flutterSecureStorage);
    taskServices = TaskServices();

    authBloc = AuthBloc(
      internetCubit: internetCubit,
      authService: authService,
      flutterSecureStorage: flutterSecureStorage,
    );

    taskBloc = TaskBloc(
      internetCubit: internetCubit,
      taskServices: taskServices,
      databaseHelper: databaseHelper,
    );

    taskDetailsBloc = TaskDetailsBloc(
      taskServices: taskServices,
      internetCubit: internetCubit,
    );
  }

  // Method to get the initial route
  Route<dynamic> generateInitialRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => FutureBuilder(
        future: _initializeAppRouter(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Return your initial route widget here
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: authBloc),
                BlocProvider.value(value: internetCubit),
              ],
              child: const LogInScreen(),
            );
          }
          // Show a loading indicator while initializing
          return const CircularProgressIndicator(color: Colors.black);
        },
      ),
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authBloc),
              BlocProvider.value(value: internetCubit),
            ],
            child: const LogInScreen(),
          ),
        );
      case 'home':
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: taskBloc),
              BlocProvider.value(value: taskDetailsBloc),
              BlocProvider.value(value: authBloc),
              BlocProvider.value(value: internetCubit),
            ],
            child: const HomeScreen(),
          ),
        );
    }
    return null;
  }

  void dispose() {
    authBloc.close();
    taskBloc.close();
    internetCubit.close();
    taskDetailsBloc.close();
  }
}
