import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/screens/onboarding/widgets/cardStacks.dart';

class OnBoardingPage extends StatelessWidget {
  final Animation<Offset>? lightCardOffsetAnimation;
  final Animation<Offset>? darkCardOffsetAnimation;
  final Widget? lightCard;
  final Widget? darkCard;
  final Widget? textColumn;
  final int? number;
  OnBoardingPage(
      {this.lightCard,
      this.darkCard,
      this.textColumn,
      this.number,
      this.lightCardOffsetAnimation,
      this.darkCardOffsetAnimation});
  // : assert(lightCard != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardStack(
          pageNumber: number!,
          lightCard: lightCard!,
          darkCard: darkCard!,
          lightCardOffsetAnimation: lightCardOffsetAnimation,
          darkCardOffsetAnimation: darkCardOffsetAnimation,
        ),
        SizedBox(
          height: (number! % 2 == 1) ? 50 : 25,
        ),
        AnimatedSwitcher(
          duration: kCardAnimationDuration,
          child: textColumn,
        )
      ],
    );
  }
}
