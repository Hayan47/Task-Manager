import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/screens/home_screen.dart';
import 'package:task_manager/presentation/screens/login_screen.dart';

class AppRouter {
  late AuthBloc authBloc;
  late TaskBloc taskBloc;

  AppRouter() {
    authBloc = AuthBloc();
    taskBloc = TaskBloc();
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authBloc,
            child: const LogInScreen(),
          ),
        );
      case 'home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: taskBloc,
            child: const HomeScreen(),
          ),
        );
    }
    return null;
  }

  void dispose() {
    authBloc.close();
  }
}
