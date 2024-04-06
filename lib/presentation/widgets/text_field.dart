import 'package:flutter/material.dart';
import 'package:task_manager/constants/my_colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  MyTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.textInputType,
    required this.hint,
    required this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(height: 50),
        TextFormField(
          obscureText: obscureText,
          textInputAction: TextInputAction.next,
          keyboardType: textInputType,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: MyColors.mywhite,
                fontSize: 16,
              ),
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyColors.mywhite,
                  fontSize: 16,
                ),
            errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontSize: 10,
                ),
          ),
          cursorColor: Colors.white,
        ),
      ],
    );
  }
}
