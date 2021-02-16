import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/utils/color_constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../font_constant.dart';
import '../images.dart';

class ShowDialog {
  static ShowDialog _instance = new ShowDialog.internal();

  ShowDialog.internal();

  factory ShowDialog() => _instance;

  static void showCustomDialog(BuildContext context, String msg, String btn,{VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          //title: new Text("Alert"),
          content: Text(msg),
          actions: [
            CupertinoDialogAction(
                onPressed: () {
                  if(okBtnFunction!=null){
                    okBtnFunction();
                    Navigator.pop(context, true);
                  }else{
                    Navigator.pop(context,true);
                  }
                },
                isDefaultAction: true,
                child: Text(btn.isNotEmpty ? btn : "OK",))
          ],
        ));
  }

  static void showDialogForDelete(
      BuildContext context, String headerMsg, String msg, String btn, bool isDelete,{VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: COLOR_CONST.whiteColor.withOpacity(0.4),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                color: COLOR_CONST.whiteColor,
                height: 240,
                child: Column(
                  children: [
                    Text(
                      headerMsg,
                      style: FONT_CONST.regularBlackText_18,
                      textAlign: TextAlign.center,
                    ).paddingOnly(top: 37, left: 16, right: 16),
                    Text(
                      msg,
                      style: FONT_CONST.regularBlackText_14,
                      textAlign: TextAlign.center,
                    ).paddingOnly(top: 30, bottom: 40, left: 16, right: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          color: COLOR_CONST.lightGreyColor,
                          textColor: COLOR_CONST.whiteColor,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: 120,
                            child: Text(
                              "Cancel",
                              style: FONT_CONST.regularWhiteText_14,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ).cornerRadiusWithClipRRect(10).paddingOnly(right: 8),
                        RaisedButton(
                          color: COLOR_CONST.redColor,
                          textColor: COLOR_CONST.whiteColor,
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            width: 120,
                            child: Text(
                              btn,
                              style: FONT_CONST.regularWhiteText_14,
                            ),
                          ),
                          onPressed: () {
                            if(okBtnFunction!=null){
                              okBtnFunction();
                              Navigator.pop(context, true);
                            }else{
                              Navigator.pop(context,true);
                            }
                          },
                        ).cornerRadiusWithClipRRect(10)
                      ],
                    ).paddingOnly(bottom: 22)
                  ],
                ),
              ).center().paddingOnly(left: 16, right: 16),
            )
          ],
        ));
  }

  static void showDialogForSuccess(
      BuildContext context, String msg, String btn,{VoidCallback okBtnFunction}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: COLOR_CONST.whiteColor.withOpacity(0.4),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Container(
                color: COLOR_CONST.whiteColor,
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Image.asset(
                            TImages.ic_success,
                            height: 60,
                            width: 60,
                            fit: BoxFit.fitHeight,
                          ),
                          Icon(Icons.check, color: COLOR_CONST.whiteColor,)
                        ],
                        alignment: Alignment.center,
                      ),
                    ).paddingOnly(top: 26, bottom: 14),
                    Text(
                      'Success',
                      style: FONT_CONST.regularBlackText_18,
                      textAlign: TextAlign.center,
                    ).paddingOnly(left: 16, right: 16),
                    Text(
                      msg,
                      style: FONT_CONST.regularBlackText_14,
                      textAlign: TextAlign.center,
                    ).paddingOnly(top: 8, bottom: 20, left: 16, right: 16),
                    RaisedButton(
                      color: COLOR_CONST.primaryColor,
                      textColor: COLOR_CONST.whiteColor,
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        width: 120,
                        child: Text(
                          btn,
                          style: FONT_CONST.regularWhiteText_14,
                        ),
                      ),
                      onPressed: () {
                        if(okBtnFunction!=null){
                          okBtnFunction();
                          Navigator.pop(context, true);
                        }else{
                          Navigator.pop(context,true);
                        }
                      },
                    ).cornerRadiusWithClipRRect(10).paddingOnly(bottom: 30)
                  ],
                ),
              ).center().paddingOnly(left: 36, right: 36),
            )
          ],
        ));
  }
}