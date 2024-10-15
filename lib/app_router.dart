import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task_manager/data/repositories/auth_repository.dart';
import 'package:task_manager/data/repositories/task_details_repository.dart';
import 'package:task_manager/data/repositories/task_repository.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';
import 'package:task_manager/presentation/screens/home_screen.dart';
import 'package:task_manager/presentation/screens/login_screen.dart';
import 'package:task_manager/data/apis/auth_services.dart';
import 'package:task_manager/data/apis/task_services.dart';
import 'package:task_manager/data/database_helper.dart';

class AppRouter {
  late AuthBloc authBloc;
  late TaskBloc taskBloc;
  late InternetCubit internetCubit;
  late TaskDetailsBloc taskDetailsBloc;
  late AuthServices authService;
  late TaskServices taskServices;
  late FlutterSecureStorage flutterSecureStorage;
  late DatabaseHelper databaseHelper;
  late AuthRepository authRepository;
  late TaskRepository taskRepository;
  late TaskDetailsRepository taskDetailsRepository;

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

    // Initialize Repos
    authRepository = AuthRepository(
        authServices: authService, flutterSecureStorage: flutterSecureStorage);
    taskRepository = TaskRepository(
        taskServices: taskServices, databaseHelper: databaseHelper);
    taskDetailsRepository = TaskDetailsRepository(taskServices: taskServices);

    // Initialize Blocs
    authBloc = AuthBloc(
      internetCubit: internetCubit,
      authRepository: authRepository,
    );

    taskBloc = TaskBloc(
      internetCubit: internetCubit,
      taskRepository: taskRepository,
    );

    taskDetailsBloc = TaskDetailsBloc(
      taskDetailsRepository: taskDetailsRepository,
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
