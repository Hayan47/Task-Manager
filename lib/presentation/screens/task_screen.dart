import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/logic/task_details/task_details_bloc.dart';
import 'package:task_manager/presentation/widgets/button.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/text_field.dart';
import 'package:task_manager/data/models/task_model.dart';

class TaskScreen extends StatelessWidget {
  final Task task;
  TextEditingController _todoController = TextEditingController();
  TaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    _todoController = TextEditingController(text: task.todo);
    context.read<TaskDetailsBloc>().add(GetUserInfo(id: task.userId));
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/task.jpg'),
                fit: BoxFit.fill,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
                builder: (context, state) {
                  if (state is TaskDetailsLoaded) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: state.user.image,
                                fit: BoxFit.cover,
                                width: 80,
                                height: 80,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${state.user.firstName} ${state.user.lastName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  state.user.phone,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: MyTextField(
                              controller: _todoController,
                              validator: (p0) {},
                              textInputType: TextInputType.text,
                              hint: '',
                              obscureText: false,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        //! buttons
                        Center(
                          child: Column(
                            children: [
                              BlocConsumer<TaskBloc, TaskState>(
                                listener: (context, state) {
                                  if (state is TaskUpdated) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      MySnackBar(
                                        icon: const Icon(Icons.done,
                                            color: Colors.green, size: 18),
                                        message: state.message,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (state is TaskDeleted) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      MySnackBar(
                                        icon: const Icon(Icons.done,
                                            color: Colors.green, size: 18),
                                        message: state.message,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else if (state is TasksError) {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      MySnackBar(
                                        icon: const Icon(Icons.error,
                                            color: MyColors.myred, size: 18),
                                        message: state.message,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is TasksLoading) {
                                    return Lottie.asset(
                                      'assets/lottie/SplashyLoader.json',
                                      width: 50,
                                      height: 50,
                                    );
                                  } else {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        MyButton(
                                          color: MyColors.mywhite,
                                          textColor: Colors.black,
                                          text: 'Delete',
                                          onpressed: () {
                                            context.read<TaskBloc>().add(
                                                DeleteTaskEvent(
                                                    taskID: task.id));
                                          },
                                        ),
                                        MyButton(
                                          color: Colors.black,
                                          textColor: MyColors.mywhite,
                                          text: 'Save',
                                          onpressed: () {
                                            context.read<TaskBloc>().add(
                                                UpdateTaskEvent(task: task));
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is TaskDetailsError) {
                    return GestureDetector(
                      onTap: () => context
                          .read<TaskDetailsBloc>()
                          .add(GetUserInfo(id: task.userId)),
                      child: Column(
                        children: [
                          Image.asset('assets/images/tap_to_retry.png'),
                          const SizedBox(height: 10),
                          Text(
                            'Poor internet connection! Tap to retey',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/SplashyLoader.json',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
