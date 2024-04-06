import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/task.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(const GetTasksEvent(page: 1));
    return Scaffold(
      backgroundColor: MyColors.mywhite,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'My Tasks',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 32,
                color: MyColors.myred,
              ),
        ),
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
              backgroundColor: MyColors.mywhite,
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
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
