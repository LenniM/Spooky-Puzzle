import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spookypuzzle/style/colors.dart';

class LevelWidget extends StatelessWidget {

  final int currentLevel;

  const LevelWidget({Key? key, required this.currentLevel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentLevel / 3,
          color: Colors.green,
          backgroundColor: SpookyColors.kLightColor,
          minHeight: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                "Level 1",
                style: TextStyle(
                  color: roundDown(currentLevel / 3, 2) == 0.33 ? SpookyColors.kTextColor : SpookyColors.kTextColor.withOpacity(0.4),
                  fontFamily: "Regular",
                ),
              ),
            ),
            Center(
              child: Text(
                "Level 2",
                style: TextStyle(
                  color: roundDown(currentLevel / 3, 2) == 0.66 ? SpookyColors.kTextColor : SpookyColors.kTextColor.withOpacity(0.4),
                  fontFamily: "Regular",
                ),
              ),
            ),
            Center(
              child: Text(
                "Level 3",
                style: TextStyle(
                  color: roundDown(currentLevel / 3, 2) == 1 ? SpookyColors.kTextColor : SpookyColors.kTextColor.withOpacity(0.4),
                  fontFamily: "Regular",
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
}

double roundDown(double value, int precision) {
  final isNegative = value.isNegative;
  final mod = pow(10.0, precision);
  final roundDown = (((value.abs() * mod).floor()) / mod);
  return isNegative ? -roundDown : roundDown;
}