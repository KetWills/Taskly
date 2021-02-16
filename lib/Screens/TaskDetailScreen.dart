import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:taskly/Screens/Modal/TaskDetailModal.dart';
import 'package:taskly/utils/color_constant.dart';
import 'package:taskly/utils/commonWidgets/showDialog.dart';
import 'package:taskly/utils/font_constant.dart';
import 'package:taskly/utils/network_repository.dart';
import 'package:taskly/utils/tString.dart';
import 'package:nb_utils/nb_utils.dart';

class TaskDetailScreen extends StatefulWidget {
  int taskID;
  String projectName;
  TaskDetailScreen({this.taskID, this.projectName});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  bool isFinished = false;
  bool _isProgress = false;
  TaskDetail taskDetail = TaskDetail();

  var taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getTask();
  }

  @override
  Widget build(BuildContext context) {

    Widget header = Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 180,
        ),
        Container(
          height: 160,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.keyboard_arrow_left),
                  Text(
                    TString.back,
                    style: FONT_CONST.lightBlackText_18,
                  ),
                ],
              ).paddingOnly(left: 32, bottom: 10).onTap(() {
                Navigator.pop(context, true);
              }),
              Text(
                TString.task,
                style: FONT_CONST.regularBlackText_36,
              ).paddingOnly(left: 31, bottom: 23),
            ],
          ),
        ).withShadow(shadowColor: COLOR_CONST.shadowColor, blurRadius: 0.25,).paddingOnly(bottom: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isFinished == false ? Container(
              alignment: Alignment.center,
              height: 45,
              width: 120,
              color: COLOR_CONST.lightGreenColor,
              child: Text(
                TString.finish,
                style: FONT_CONST.regularWhiteText_14,
              ),
            ).cornerRadiusWithClipRRect(5).paddingOnly(right: 13).onTap(() async {
              await closeTask();
              isFinished = true;
              setState(() {});
            }) : SizedBox(),
            Container(
              height: 45,
              width: 45,
              color: COLOR_CONST.primaryColor,
              child: Icon(
                isFinished == false ? Icons.check : Icons.sync,
                color: COLOR_CONST.whiteColor,
              ),
            ).cornerRadiusWithClipRRect(10).paddingOnly(right: 47).onTap(() async {
              if (isFinished == true) {
                isFinished = false;
                setState(() {});
                await reopenTask();
              } else {
                await updateTask();
              }
            }),
          ],
        )
      ],
    );

    Widget description = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              TString.description,
              style: FONT_CONST.regularBlackText_18,
            ),
            isFinished == true ? Container(
              alignment: Alignment.center,
              height: 30,
              width: 120,
              color: COLOR_CONST.lightGreenColor,
              child: Text(
                TString.completed,
                style: FONT_CONST.regularWhiteText_14,
              ),
            ).cornerRadiusWithClipRRect(5) : SizedBox()
          ],
        ),
        TextField(
          autofocus: false,
          style: TextStyle(fontSize: 18.0, color: COLOR_CONST.blackColor),
          keyboardType: TextInputType.multiline,
          maxLines: 5,
          controller: taskController,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            filled: true,
            fillColor: COLOR_CONST.textFieldColor,
            hintText: 'Project name',
            contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textFieldColor),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: COLOR_CONST.textFieldColor),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ).paddingOnly(top: 18),
      ],
    );

    Widget project = Row(
      children: [
        Text(
          TString.project,
          style: FONT_CONST.regularBlackText_18,
        ).paddingOnly(right: 20),
        Text(
          widget.projectName != null ? widget.projectName : "Project name",
          style: FONT_CONST.lightBlackText_18,
        )
      ],
    ).paddingOnly(top: 30, bottom: 30);

    Widget crestedAt = Row(
      children: [
        Text(
          TString.createdAt,
          style: FONT_CONST.regularBlackText_18,
        ).paddingOnly(right: 20),
        Text(
          "Jan 12, 2021",
          style: FONT_CONST.lightBlackText_18,
        )
      ],
    ).paddingOnly(bottom: 42);

    return Scaffold(
      body: _isProgress ? Center(child: CircularProgressIndicator(),) : Column(
        children: [
          header,
          Flexible(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        description,
                        project,
                        crestedAt,
                      ],
                    ).paddingOnly(left: 31, right: 31, top: 45, bottom: 90),
                  ),
                ),
                Container(
                  height: 45,
                  width: 45,
                  color: COLOR_CONST.redColor,
                  child: Icon(Icons.delete_outline, color: COLOR_CONST.whiteColor,),
                ).cornerRadiusWithClipRRect(10).paddingOnly(right: 47, bottom: 36).onTap(() {
                  ShowDialog.showDialogForDelete(
                      context,
                      'Delete task',
                      'Are you sure, you want to delete this task?',
                      'Delete',
                      true,
                    okBtnFunction: () {
                        deleteTask();
                    }
                  );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}/${widget.taskID}";

      String response = await callGetMethodWithToken(context, url, TString.token);
      /*----------API Response----------------*/

      print("response-----------> $response");

      taskDetail = TaskDetail.fromJson(json.decode(response));
      taskController.text = taskDetail.content;
      isFinished = taskDetail.completed;
      _isProgress = false;
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future closeTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}/${widget.taskID}/close";

      Map mBody = {
      };

      String response = await callPostTokenMethod(context, url, mBody, TString.token);
      /*----------API Response----------------*/

      print("response-----------> $response");
      _isProgress = false;
      setState(() {});
      ShowDialog.showDialogForSuccess(context, 'Task updated successfully!', 'OK');
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future reopenTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}/${widget.taskID}/reopen";

      Map mBody = {
      };

      String response = await callPostTokenMethod(context, url, mBody, TString.token);
      /*----------API Response----------------*/

      print("response-----------> $response");
      _isProgress = false;
      setState(() {});
      ShowDialog.showDialogForSuccess(context, 'Task updated successfully!', 'OK');
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future deleteTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}/${widget.taskID}";

      String response = await callDeleteTokenMethod(context, url, TString.token);
      /*----------API Response----------------*/

      Navigator.pop(context, true);
//      projects = jsonDecode(response);
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future updateTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}/${widget.taskID}";


      Map mBody = {
        "content": "${taskController.text}"
//        "project_id": "${taskDetail.projectId}"
      };

      String response = await callPostTokenMethod(context, url, mBody, TString.token);
      /*----------API Response----------------*/

      ShowDialog.showDialogForSuccess(context, TString.taskUpdatedSuccessfully, TString.ok, okBtnFunction: () {
        Navigator.pop(context, true);
      });
//      projects = jsonDecode(response);
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }
}
