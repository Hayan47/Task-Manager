import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final void Function() onpressed;
  const MyButton({
    super.key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onpressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
        fixedSize: WidgetStateProperty.all(
          Size((MediaQuery.sizeOf(context).width * 0.3), 40),
        ),
        backgroundColor: WidgetStateProperty.all(color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: textColor,
              fontSize: 14,
            ),
      ),
    );
  }
}
