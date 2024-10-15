import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/internet_cubit/internet_cubit.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/task_tile.dart';
import 'package:task_manager/presentation/widgets/tasks_loading_shimmer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksEvent(skip: 0));
    return BlocListener<InternetCubit, InternetState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is InternetDisconnected) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(
              icon: const Icon(Icons.error, color: MyColors.myred, size: 18),
              message: "No Internet Connection",
            ),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            MySnackBar(
              icon: const Icon(Icons.done, color: Colors.green, size: 18),
              message: "Internet Connection Restored",
            ),
          );
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedoutState) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        child: Scaffold(
          backgroundColor: MyColors.mywhite,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Image.asset('assets/images/note_icon.png'),
            ),
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'My Tasks',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.black,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(IconlyLight.login),
                  onPressed: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                ),
              ),
            ],
          ),
          body: BlocConsumer<TaskBloc, TaskState>(
            listener: (context, state) {
              if (state is TasksError) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBar(
                    icon: const Icon(Icons.error,
                        color: MyColors.myred, size: 18),
                    message: state.message,
                  ),
                );
                context.read<TaskBloc>().add(const GetTasksEvent(skip: 0));
              }
            },
            builder: (context, state) {
              if (state is TasksLoaded) {
                return LiquidPullToRefresh(
                  onRefresh: () async {
                    //?get notifications
                    await Future.delayed(const Duration(seconds: 1));
                    // context.read<TaskBloc>().add(const GetTasksEvent(skip: 0));
                    context.read<TaskBloc>().add(RefreshEvent());
                  },
                  animSpeedFactor: 1,
                  springAnimationDurationInMilliseconds: 100,
                  showChildOpacityTransition: false,
                  height: 200,
                  color: Colors.transparent,
                  backgroundColor: MyColors.myred,
                  child: ListView.builder(
                    itemCount: state.tasks.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.tasks.length) {
                        if (state.hasMore) {
                          context
                              .read<TaskBloc>()
                              .add(GetTasksEvent(skip: index));
                          return Lottie.asset(
                              'assets/lottie/SplashyLoader.json',
                              width: 50,
                              height: 50);
                        } else {
                          return Container();
                        }
                      }
                      return MyTask(task: state.tasks[index]);
                    },
                  ),
                );
              } else {
                return const TasksListLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
