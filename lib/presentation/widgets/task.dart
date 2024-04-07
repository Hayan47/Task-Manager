import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/task_bloc/task_bloc.dart';
import 'package:task_manager/presentation/screens/task_screen.dart';
import 'package:task_manager/services/models/task_model.dart';

class MyTask extends StatelessWidget {
  final Task task;
  const MyTask({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) => Container(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionBuilder: (context, animation, secondaryAnimation, child) {
            return BlocProvider(
              create: (context) => TaskBloc(),
              child: ScaleTransition(
                  scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
                  child: TaskScreen(task: task)),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).width * 0.5,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/images/task.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                ListTile(
                  title: Row(
                    children: [
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: task.avatar,
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        task.firstName,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: MyColors.myred,
                            ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        task.lastName,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: MyColors.myred,
                            ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.email,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            IconlyLight.time_circle,
                            color: MyColors.mywhite.withOpacity(0.4),
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
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
