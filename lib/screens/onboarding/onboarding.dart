import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';
import 'package:saanjalo/screens/login/login.dart';
import 'package:saanjalo/screens/onboarding/pages/community/index.dart';
import 'package:saanjalo/screens/onboarding/pages/education/index.dart';
import 'package:saanjalo/screens/onboarding/pages/onboarding_page.dart';
import 'package:saanjalo/screens/onboarding/pages/work/index.dart';
import 'package:saanjalo/screens/onboarding/widgets/header.dart';
import 'package:saanjalo/screens/onboarding/widgets/next_button.dart';
import 'package:saanjalo/screens/onboarding/widgets/onboarding_page_indicator.dart';
import 'package:saanjalo/screens/onboarding/widgets/ripple.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  late AnimationController _cardsAnimationController;
  late AnimationController _pageIndicatorAnimationController;
  late AnimationController _rippleAnimationController;
  late Animation<double> _pageIndicatorAnimation;
  Animation<Offset>? _slideAnimationLightCard;
  Animation<Offset>? _slideAnimationDarkCard;
  late Animation<double> _rippleAnimation;

  double screenHeight = window.physicalSize.height / window.devicePixelRatio;

  int _currentPage = 1;
  bool get isFirstPage => _currentPage == 1;

  Widget _getPage() {
    switch (_currentPage) {
      case 1:
        return OnBoardingPage(
          number: 1,
          lightCard: CommunityLightCardContent(),
          darkCard: CommunityDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: CommunityTextColumn(),
        );
      case 2:
        return OnBoardingPage(
          number: 2,
          lightCard: EducationLightCardContent(),
          darkCard: EducationDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: EducationTextColumn(),
        );
      case 3:
        return OnBoardingPage(
          number: 3,
          lightCard: WorkLightCardContent(),
          darkCard: WorkDarkCardContent(),
          lightCardOffsetAnimation: _slideAnimationLightCard,
          darkCardOffsetAnimation: _slideAnimationDarkCard,
          textColumn: WorkTextColumn(),
        );

      default:
        throw Exception("Page with number '$_currentPage' does not exist.");
    }
  }

  void _setNextPage(int nextPageNumber) {
    setState(() {
      _currentPage = nextPageNumber;
    });
  }

  Future<void> _nextPage() async {
    switch (_currentPage) {
      case 1:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(2);
          _setSlideInCardsAnimation();
          await _cardsAnimationController.forward();
          _setSlideOutAnimation();
          _setPageIndicatorAnimation(isClockWise: false);
        }

        break;
      case 2:
        if (_pageIndicatorAnimation.status == AnimationStatus.dismissed) {
          _pageIndicatorAnimationController.forward();
          await _cardsAnimationController.forward();
          _setNextPage(3);
          _setSlideInCardsAnimation();
          await _cardsAnimationController.forward();
        }

        break;
      case 3:
        if (_pageIndicatorAnimation.status == AnimationStatus.completed) {
          await goToLogin();
        }
        break;
    }
  }

  Future<void> goToLogin() async {
    _setRippleAnimation();
    await _rippleAnimationController.forward();
    Navigator.of(context).push<Object>(
      MaterialPageRoute(builder: (BuildContext context) => Login()),
    );
  }

  void _setSlideInCardsAnimation() {
    setState(() {
      _slideAnimationLightCard =
          Tween<Offset>(begin: Offset(4.0, 0), end: Offset.zero)
              .animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeIn,
      ));

      _slideAnimationDarkCard =
          Tween<Offset>(begin: Offset(1.5, 0.0), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _cardsAnimationController,
          curve: Curves.easeIn,
        ),
      );
      _cardsAnimationController.reset();
    });
  }

  void _setSlideOutAnimation() {
    setState(() {
      _slideAnimationLightCard =
          Tween<Offset>(begin: Offset.zero, end: const Offset(-4.0, 0.0))
              .animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _slideAnimationDarkCard = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0),
      ).animate(CurvedAnimation(
        parent: _cardsAnimationController,
        curve: Curves.easeOut,
      ));
      _cardsAnimationController.reset();
    });
  }

  void _setPageIndicatorAnimation({bool isClockWise = true}) {
    final int multiplicator = isClockWise ? 2 : -2;

    setState(() {
      _pageIndicatorAnimation = Tween<double>(
        begin: 0.0,
        end: multiplicator * pi,
      ).animate(CurvedAnimation(
        parent: _pageIndicatorAnimationController,
        curve: Curves.easeIn,
      ));
      _pageIndicatorAnimationController.reset();
    });
  }

  void _setRippleAnimation() {
    setState(() {
      _rippleAnimation = Tween<double>(
        begin: 0.0,
        end: screenHeight,
      ).animate(CurvedAnimation(
        parent: _rippleAnimationController,
        curve: Curves.easeIn,
      ));
    });
  }

  @override
  void initState() {
    _cardsAnimationController = AnimationController(
      vsync: this,
      duration: kCardAnimationDuration,
    );
    _pageIndicatorAnimationController = AnimationController(
      vsync: this,
      duration: kButtonAnimationDuration,
    );
    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: kRippleAnimationDuration,
    );
    _setPageIndicatorAnimation();
    _setRippleAnimation();
    _setSlideOutAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _pageIndicatorAnimationController.dispose();
    _cardsAnimationController.dispose();
    _rippleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlue,
      body: Stack(children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kPaddingL),
            child: Column(
              children: [
                Header(
                  onSkip: goToLogin,
                ),
                Expanded(
                  child: _getPage(),
                ),
                AnimatedBuilder(
                  animation: _pageIndicatorAnimation,
                  builder: (_, child) {
                    return OnBoardingPageIndicator(
                      angle: _pageIndicatorAnimation.value,
                      child: child,
                      currentPage: _currentPage,
                    );
                  },
                  child: NextButton(
                    onpressed: _nextPage,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: _rippleAnimation,
          builder: (_, child) {
            return Ripple(radius: _rippleAnimation.value);
          },
        ),
      ]),
    );
  }
}
