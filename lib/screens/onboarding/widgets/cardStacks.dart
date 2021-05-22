import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';

class CardStack extends StatelessWidget {
  final Animation<Offset>? lightCardOffsetAnimation;
  final Animation<Offset>? darkCardOffsetAnimation;
  final int pageNumber;
  final Widget lightCard;
  final Widget darkCard;

  CardStack(
      {required this.pageNumber,
      required this.lightCard,
      required this.darkCard,
      this.darkCardOffsetAnimation,
      this.lightCardOffsetAnimation})
      : assert(pageNumber != null),
        assert(lightCard != null),
        assert(darkCard != null);

  bool get isOddNumber => pageNumber % 2 == 1;

  @override
  Widget build(BuildContext context) {
    var darkCardWidth = MediaQuery.of(context).size.width - 2 * kPaddingL;
    var darkCardHeight = MediaQuery.of(context).size.height / 3;
    return Padding(
      padding: EdgeInsets.only(top: isOddNumber ? 25.0 : 50.0),
      child: Stack(
        overflow: Overflow.visible,
        alignment: AlignmentDirectional.center,
        children: [
          SlideTransition(
            position: darkCardOffsetAnimation!,
            child: Card(
              color: kDarkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Container(
                height: darkCardHeight,
                width: darkCardWidth,
                padding: EdgeInsets.only(
                  top: !isOddNumber ? 100 : 0.0,
                  bottom: isOddNumber ? 100 : 0.0,
                ),
                child: Center(
                  child: darkCard,
                ),
              ),
            ),
          ),
          Positioned(
            top: !isOddNumber ? -25 : null,
            bottom: isOddNumber ? -25 : null,
            // left: -10.0,
            child: SlideTransition(
              position: lightCardOffsetAnimation!,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: kLightBlue,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: kPaddingM),
                  height: darkCardHeight * 0.5,
                  width: darkCardWidth * 0.8,
                  child: Center(
                    child: lightCard,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
