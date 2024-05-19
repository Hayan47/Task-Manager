import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:task_manager/constants/my_colors.dart';

class TasksListLoading extends StatelessWidget {
  const TasksListLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12,
      highlightColor: MyColors.mywhite,
      period: const Duration(milliseconds: 500),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: Colors.white,
              width: double.infinity,
              height: MediaQuery.sizeOf(context).width * 0.2,
              child: const Padding(
                padding: EdgeInsets.all(15),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
