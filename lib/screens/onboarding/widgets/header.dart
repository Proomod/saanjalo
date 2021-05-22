import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/widgets/logo.dart';

class Header extends StatelessWidget {
  final VoidCallback onSkip;

  Header({required this.onSkip}) : assert(onSkip != null);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Logo(
          size: 30.0,
          color: kWhite,
        ),
        GestureDetector(
          onTap: onSkip,
          child: Text(
            'skip',
            style:
                Theme.of(context).textTheme.subtitle1!.copyWith(color: kWhite),
          ),
        ),
      ],
    );
  }
}
