import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/screens/login/widgets/fadeSlide.dart';
import 'package:saanjalo/widgets/logo.dart';

class Header extends StatelessWidget {
  final Animation<double>? animation;

  const Header({this.animation});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            Logo(
              color: kBlue,
              size: 30.0,
            ),
            SizedBox(width: 20.0),
            FadeSlideTransition(
              additionalOffset: 0,
              animation: animation!,
              child: Text(
                'Welcome to Bubble',
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: kBlack, fontWeight: FontWeight.bold),
              ),
            )
          ]),
          const SizedBox(height: kSpaceS),
          FadeSlideTransition(
            animation: animation!,
            additionalOffset: 10.0,
            child: Text(
              'Est ad dolor aute ex commodo tempor exercitation proident.',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: kBlack.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
