import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';
import 'package:task_manager/presentation/screens/task_screen.dart';
import 'package:task_manager/data/models/task_model.dart';

class MyTask extends StatelessWidget {
  final Task task;
  const MyTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final taskBloc = context.read<TaskBloc>();
    final taskDetailsBloc = context.read<TaskDetailsBloc>();
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: taskBloc),
                BlocProvider.value(value: taskDetailsBloc),
              ],
              child: TaskScreen(task: task),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.2,
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/images/task.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                isLandscape
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          task.completed
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  child: Image.asset('assets/images/done.png',
                                      width: 25, height: 25),
                                )
                              : Lottie.asset('assets/lottie/sandclock.json',
                                  width: 50, height: 50),
                          Center(
                            child: Text(
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              task.todo,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: ListTile(
                          leading: task.completed
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  child: Image.asset('assets/images/done.png',
                                      width: 25, height: 25),
                                )
                              : Lottie.asset('assets/lottie/sandclock.json'),
                          title: Text(
                            task.todo,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
