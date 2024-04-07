import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/task.dart';
import 'package:task_manager/presentation/widgets/tasks_loading.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksEvent(page: 1));
    return BlocListener<AuthBloc, AuthState>(
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
                  color: MyColors.myred,
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
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TasksLoaded) {
              print('LISTTTTT ${state.tasks}');
              return LiquidPullToRefresh(
                onRefresh: () async {
                  //?get notifications
                  await Future.delayed(const Duration(seconds: 1));
                  context.read<TaskBloc>().add(const GetTasksEvent(page: 1));
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
                        context.read<TaskBloc>().add(LoadNextPageEvent());
                        return Lottie.asset('assets/lottie/SplashyLoader.json',
                            width: 50, height: 50);
                      } else {
                        return Container();
                      }
                    }
                    return MyTask(task: state.tasks[index]);
                  },
                ),
              );
            } else if (state is TasksError) {
              return GestureDetector(
                  onTap: () {
                    context.read<TaskBloc>().add(const GetTasksEvent(page: 1));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/tap_to_retry.png'),
                      Text(
                        'poor internet connection, Tap to retry!',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ));
            } else {
              return const TasksListLoading();
            }
          },
        ),
      ),
    );
  }
}
