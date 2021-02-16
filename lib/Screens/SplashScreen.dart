import 'package:flutter/material.dart';
import 'package:taskly/Screens/HomeScreen.dart';
import 'package:taskly/utils/color_constant.dart';
import 'package:taskly/utils/font_constant.dart';
import 'package:taskly/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:taskly/utils/tString.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void initState() {
    super.initState();
    init();
  }

  void init() async {
    Future.delayed(Duration(seconds: 3), () async {
      HomeScreen().launch(context, isNewTask: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            TImages.ic_splashBackground,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: 110,
                  height: 110,
                  color: COLOR_CONST.primaryColor,
                  child: Text(
                    'T',
                    style: FONT_CONST.boldWhiteText_80,
                  ).center(),
                ).cornerRadiusWithClipRRect(20),
                Text(
                  TString.taskly,
                  style: FONT_CONST.boldBlackText_60,
                ),
                Expanded(child: SizedBox()),
                Text(
                  'v1.0',
                  style: FONT_CONST.regularWhiteText_24,
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
