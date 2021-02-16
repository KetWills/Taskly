import 'package:flutter/material.dart';
import 'package:taskly/utils/color_constant.dart';

class FONT_CONST {
  static final bold = TextStyle(
      fontFamily: 'AleoBold',
  );

  static final regular = TextStyle(
    fontFamily: 'AleoRegular',
  );

  static final light = TextStyle(
    fontFamily: 'AleoLight',
  );

  //Bold
  static final boldWhiteText = bold.copyWith(color: COLOR_CONST.whiteColor, fontWeight: FontWeight.w600);
  static final boldWhiteText_80 = boldWhiteText.copyWith(fontSize: 80);

  static final boldBlackText = bold.copyWith(color: COLOR_CONST.blackColor, fontWeight: FontWeight.w900);
  static final boldBlackText_60 = boldBlackText.copyWith(fontSize: 60);

  //regular
  static final regularWhiteText = regular.copyWith(color: COLOR_CONST.whiteColor);
  static final regularWhiteText_24 = regularWhiteText.copyWith(fontSize: 24);
  static final regularWhiteText_14 = regularWhiteText.copyWith(fontSize: 14);

  static final regularBlackText = regular.copyWith(color: COLOR_CONST.blackColor);
  static final regularBlackText_36 = regularBlackText.copyWith(fontSize: 36);
  static final regularBlackText_18 = regularBlackText.copyWith(fontSize: 18);
  static final regularBlackText_14 = regularBlackText.copyWith(fontSize: 14);
  static final regularBlackText_24 = regularBlackText.copyWith(fontSize: 24);

  //Light
  static final lightBlackText = light.copyWith(color: COLOR_CONST.blackColor);
  static final lightBlackText_18 = lightBlackText.copyWith(fontSize: 18);
}