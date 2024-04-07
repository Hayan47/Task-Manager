import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/button.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/text_field.dart';
import 'package:task_manager/services/models/task_model.dart';

class TaskScreen extends StatelessWidget {
  final Task task;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  TaskScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
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
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: task.avatar,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${task.firstName} ${task.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: MyColors.myred,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              task.email,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: MyColors.myred,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: MyColors.myred),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Edit Information',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'First Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                            ),
                            MyTextField2(
                              controller: _firstNameController,
                              hint: task.firstName,
                              inputType: TextInputType.name,
                              actionType: TextInputAction.next,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Last Name',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                            ),
                            MyTextField2(
                              controller: _lastNameController,
                              hint: task.lastName,
                              inputType: TextInputType.name,
                              actionType: TextInputAction.next,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                            ),
                            MyTextField2(
                              controller: _emailController,
                              hint: task.email,
                              inputType: TextInputType.emailAddress,
                              actionType: TextInputAction.done,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        BlocConsumer<TaskBloc, TaskState>(
                          listener: (context, state) {
                            if (state is TaskUpdated) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                MySnackBar(
                                  icon: const Icon(Icons.done,
                                      color: Colors.green, size: 18),
                                  message: state.message,
                                  margin: 5,
                                ),
                              );
                              Navigator.pop(context);
                            } else if (state is TaskDeleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                MySnackBar(
                                  icon: const Icon(Icons.done,
                                      color: Colors.green, size: 18),
                                  message: state.message,
                                  margin: 5,
                                ),
                              );
                              Navigator.pop(context);
                            } else if (state is TasksError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                MySnackBar(
                                  icon: const Icon(Icons.error,
                                      color: MyColors.myred, size: 18),
                                  message: state.message,
                                  margin: 5,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is TasksLoading) {
                              return Lottie.asset(
                                  'assets/lottie/SplashyLoader.json',
                                  width: 50,
                                  height: 50);
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  MyButton(
                                    color: MyColors.myred,
                                    textColor: MyColors.mywhite,
                                    text: 'Delete',
                                    onpressed: () {
                                      context.read<TaskBloc>().add(
                                          DeleteTaskEvent(taskID: task.id));
                                    },
                                  ),
                                  MyButton(
                                    color: Colors.black,
                                    textColor: MyColors.mywhite,
                                    text: 'Save',
                                    onpressed: () {
                                      context
                                          .read<TaskBloc>()
                                          .add(UpdateTaskEvent(task: task));
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
