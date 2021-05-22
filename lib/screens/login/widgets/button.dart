import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color? textColor;
  final Widget textBox;
  final Widget? image;
  final VoidCallback onPressed;

  const CustomButton({
    required this.color,
    this.textColor,
    required this.textBox,
    required this.onPressed,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: image != null
          ? OutlineButton(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: kPaddingL),
                    child: image,
                  ),
                  textBox,
                ],
              ),
              onPressed: onPressed,
            )
          : FlatButton(
              color: color,
              padding: const EdgeInsets.all(kPaddingM),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: textBox,
              onPressed: onPressed,
            ),
    );
  }
}
