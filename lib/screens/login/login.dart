import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/screens/login/cubit/login_cubit.dart';
import 'package:saanjalo/screens/login/widgets/header.dart';
import 'package:saanjalo/screens/login/widgets/loginForm.dart';
// import 'package:saanjalo/widgets/logo.dart';

class Login extends StatefulWidget {
  static route(double screenHeight) {
    return MaterialPageRoute(
      builder: (context) => Login(),
    );
  }

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _headerTextAnimation;
  Animation<double>? _loginFormAnimation;
  late Animation<double> _whiteTopAnimation;
  late Animation<double> _greyTopAnimation;
  late Animation<double> _blueTopAnimation;
  var screenHeight = window.physicalSize.height / window.devicePixelRatio;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: kLoginAnimationDuration,
    );
    var fadeSlideBetween = Tween<double>(begin: 0.0, end: 1.0);
    _headerTextAnimation = fadeSlideBetween.animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.0,
          0.6,
          curve: Curves.easeInCubic,
        )));

    _loginFormAnimation = fadeSlideBetween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.7,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
    var clipperOffestTween = Tween<double>(
      begin: screenHeight,
      end: 0.0,
    );
    _blueTopAnimation = clipperOffestTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _greyTopAnimation = clipperOffestTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.35,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _whiteTopAnimation = clipperOffestTween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.5,
          0.7,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print(RepositoryProvider.of<AuthenticationRepository>(context).currentUser);
    return BlocProvider(
      create: (context) => LoginCubit(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(context)),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: kWhite,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedBuilder(
              animation: _whiteTopAnimation,
              child: Container(
                color: kGrey,
              ),
              builder: (_, child) {
                return ClipPath(
                  clipper: WhiteTopClipper(
                    yOffset: _whiteTopAnimation.value,
                  ),
                  child: child,
                );
              },
            ),
            AnimatedBuilder(
                animation: _greyTopAnimation,
                child: Container(
                  color: kBlue,
                ),
                builder: (_, child) {
                  return ClipPath(
                      clipper: GreyTopClipper(
                        yOffset: _greyTopAnimation.value,
                      ),
                      child: child);
                }),
            AnimatedBuilder(
                animation: _blueTopAnimation,
                child: Container(
                  color: kWhite,
                ),
                builder: (_, child) {
                  return ClipPath(
                    clipper: BlueTopClipper(yOffset: _blueTopAnimation.value),
                    child: child,
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kPaddingL),
              child: Column(children: [
                Header(
                  animation: _headerTextAnimation,
                ),
                Spacer(),
                LoginForm(
                  animation: _loginFormAnimation,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class BlueTopClipper extends CustomClipper<Path> {
  final double? yOffset;
  BlueTopClipper({this.yOffset});
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, 220 + yOffset!)
      ..quadraticBezierTo(
          size.width / 2.2, 270 + yOffset!, size.width, 170 + yOffset!)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class GreyTopClipper extends CustomClipper<Path> {
  final double? yOffset;
  GreyTopClipper({this.yOffset});
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, 265 + yOffset!)
      ..quadraticBezierTo(
          size.width / 2 + 20, 290 + yOffset!, size.width, 185 + yOffset!)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class WhiteTopClipper extends CustomClipper<Path> {
  final double? yOffset;
  WhiteTopClipper({this.yOffset});
  @override
  Path getClip(Size size) {
    var path = Path()
      ..lineTo(0, 310 + yOffset!)
      ..quadraticBezierTo(
          size.width / 2, 310.0 + yOffset!, size.width, 200.0 + yOffset!)
      ..lineTo(size.width, 0.0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
