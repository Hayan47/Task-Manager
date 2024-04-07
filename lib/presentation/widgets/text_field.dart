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
                color: Colors.black,
                fontSize: 16,
              ),
          cursorColor: Colors.black,
          cursorErrorColor: Colors.black,
          controller: controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
            errorStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: MyColors.myred,
                  fontSize: 10,
                ),
          ),
        ),
      ],
    );
  }
}

class MyTextField2 extends StatelessWidget {
  final String hint;
  final TextInputType inputType;
  final TextInputAction actionType;
  final TextEditingController controller;

  const MyTextField2({
    Key? key,
    required this.hint,
    required this.inputType,
    required this.actionType,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: 44,
          width: MediaQuery.sizeOf(context).width * 0.45,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: MyColors.mywhite,
              width: 0.4,
            ),
          ),
          child: SingleChildScrollView(
            child: TextField(
              maxLines: null,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                  ),
              controller: controller,
              decoration: InputDecoration(
                //!hint style
                hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                //!hint
                hintText: hint,
                floatingLabelStyle: const TextStyle(color: MyColors.myBlue2),
                labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: MyColors.mywhite,
                    ),
                floatingLabelAlignment: FloatingLabelAlignment.start,
              ),
              cursorHeight: 18,
              keyboardType: inputType,
              textInputAction: actionType,
            ),
          ),
        ),
      ),
    );
  }
}
