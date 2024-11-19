import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/widgets/button.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/text_field.dart';

class AddTaskScreen extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();
  AddTaskScreen({super.key});

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
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Add Your Todo!',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 28,
                      color: Colors.black,
                    ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                    hint: 'what do you want to do!',
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
                        if (state is TaskAdded) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            MySnackBar(
                              icon: const Icon(Icons.done,
                                  color: Colors.green, size: 18),
                              message: state.message,
                            ),
                          );
                          Navigator.pop(context);
                        } else if (state is TasksError) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MyButton(
                              color: Colors.black,
                              textColor: MyColors.mywhite,
                              text: 'Add',
                              onpressed: () {
                                context.read<TaskBloc>().add(
                                      AddTaskEvent(
                                        task: Task(
                                          id: 1,
                                          userId: 1,
                                          todo: _todoController.text,
                                          completed: false,
                                        ),
                                      ),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
