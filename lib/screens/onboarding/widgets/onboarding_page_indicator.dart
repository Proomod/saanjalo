import 'package:flutter/material.dart';
import 'package:saanjalo/constants.dart';
import 'dart:math';

class OnBoardingPageIndicator extends StatelessWidget {
  final int currentPage;
  final double? angle;
  final Widget? child;
  const OnBoardingPageIndicator(
      {required this.currentPage, required this.child, this.angle});

  Color _getPageIndicatorColor(int pageIndex) {
    return currentPage > pageIndex ? kWhite : kWhite.withOpacity(0.25);
  }

  double get indicatorLength => pi / 3;
  double get indicatorGap => pi / 12;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: _OnBoardingPageIndicatorPainter(
            color: _getPageIndicatorColor(0),
            startAngle: (4 * indicatorLength) -
                (indicatorLength + indicatorGap) +
                angle!,
            indicatorLength: indicatorLength),
        child: CustomPaint(
          painter: _OnBoardingPageIndicatorPainter(
            color: _getPageIndicatorColor(1),
            startAngle: 4 * indicatorLength + angle!,
            indicatorLength: indicatorLength,
          ),
          child: CustomPaint(
            painter: _OnBoardingPageIndicatorPainter(
                color: _getPageIndicatorColor(2),
                startAngle: (4 * indicatorLength) +
                    (indicatorGap + indicatorLength) +
                    angle!,
                indicatorLength: indicatorLength),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _OnBoardingPageIndicatorPainter extends CustomPainter {
  final Color? color;
  final double? startAngle;
  final double? indicatorLength;
  _OnBoardingPageIndicatorPainter(
      {this.color, this.startAngle, this.indicatorLength});

  @override
  bool shouldRepaint(_OnBoardingPageIndicatorPainter oldDelegate) {
    return color != oldDelegate.color ||
        startAngle != oldDelegate.startAngle;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = color!;

    canvas.drawArc(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: (size.shortestSide + 12) / 2,
        ),
        startAngle!,
        indicatorLength!,
        false,
        paint);
  }
}
