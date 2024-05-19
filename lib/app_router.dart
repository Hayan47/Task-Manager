import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';
import 'package:task_manager/presentation/screens/home_screen.dart';
import 'package:task_manager/presentation/screens/login_screen.dart';

class AppRouter {
  late AuthBloc authBloc;
  late TaskBloc taskBloc;
  late InternetCubit internetCubit;
  late TaskDetailsBloc taskDetailsBloc;

  AppRouter() {
    authBloc = AuthBloc();
    internetCubit = InternetCubit();
    taskBloc = TaskBloc(internetCubit: internetCubit);
    taskDetailsBloc = TaskDetailsBloc(internetCubit: internetCubit);
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
