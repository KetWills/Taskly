import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:taskly/Screens/Modal/ProjectDetailModal.dart';
import 'package:taskly/Screens/TaskDetailScreen.dart';
import 'package:taskly/utils/color_constant.dart';
import 'package:taskly/utils/commonWidgets/showDialog.dart';
import 'package:taskly/utils/font_constant.dart';
import 'package:taskly/utils/network_repository.dart';
import 'package:taskly/utils/tString.dart';

class CreateProjectScreen extends StatefulWidget {
  bool isEdit;
  int projectID;
  CreateProjectScreen({this.isEdit = false, this.projectID});

  @override
  _CreateProjectScreenState createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  var favorite = false;
  List<String> arrTask = [];
  bool _isProgress = false;
  ProjectDetail projectDetail = ProjectDetail();
  List<dynamic> tasks;

  var projectNameController = TextEditingController();
  var taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (widget.isEdit == true) {
      await getProject();
      await getTasks();
      projectNameController.text = projectDetail.name;
      favorite = projectDetail.favorite;
    }
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
                TString.projects,
                style: FONT_CONST.regularBlackText_36,
              ).paddingOnly(left: 31, bottom: 23),
            ],
          ),
        ).withShadow(shadowColor: COLOR_CONST.shadowColor, blurRadius: 0.25,).paddingOnly(bottom: 20),
        Container(
          height: 45,
          width: 45,
          color: COLOR_CONST.primaryColor,
          child: Icon(Icons.check, color: COLOR_CONST.whiteColor,),
        ).cornerRadiusWithClipRRect(10).paddingOnly(right: 47).onTap(() {
          if (projectNameController.text.trim() != "") {
            createProject();
          } else {
            ShowDialog.showCustomDialog(context, TString.enterProjectName, TString.ok);
          }
        })
      ],
    );

    Widget newProject = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.isEdit == true ? TString.projectName : TString.createNewProject,
              style: FONT_CONST.regularBlackText_18,
            ),
            favorite == false ? Icon(Icons.favorite_border, size: 15,) : Icon(Icons.favorite, size: 15, color: COLOR_CONST.redColor,)
          ],
        ),
        TextField(
          autofocus: false,
          style: TextStyle(fontSize: 18.0, color: COLOR_CONST.blackColor),
          controller: projectNameController,
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

    Widget color = Row(
      children: [
        Text(
          TString.color,
          style: FONT_CONST.lightBlackText_18,
        ).paddingOnly(right: 20),
        Container(
          width: 22,
          height: 22,
          color: COLOR_CONST.lightGreyColor,
        ).cornerRadiusWithClipRRect(11)
      ],
    ).paddingOnly(top: 30, bottom: 30);

    Widget fav = Row(
      children: [
        Text(
          TString.favorite,
          style: FONT_CONST.lightBlackText_18,
        ).paddingOnly(right: 20),
        CupertinoSwitch(
            value: favorite,
            activeColor: COLOR_CONST.primaryColor,
            onChanged: (value) {
              favorite = value;
              setState(() {});
            })
      ],
    ).paddingOnly(bottom: 42);

    Widget task = TextField(
      autofocus: false,
      style: TextStyle(fontSize: 18.0, color: COLOR_CONST.blackColor),
      controller: taskController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        filled: false,
        hintText: 'Task:',
        suffixIcon: Icon(Icons.add, color: COLOR_CONST.blackColor,).onTap(() {
          arrTask.add("${taskController.text}");
          createTask();
        })
      ),
    );

    Widget taskList = ListView.builder(
        itemCount: tasks != null ? tasks.length : 0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(0),
        itemBuilder: (context, index) {
          return Container(
            color: COLOR_CONST.lightGreyColor.withOpacity(0.2),
            child: Text(
              task != null ? tasks[index]["content"] : "",
              style: FONT_CONST.regularBlackText_18,
            ).paddingOnly(left: 14, right: 14, top: 12, bottom: 12),
          ).paddingOnly(bottom: 8).onTap(() async {
            if (widget.isEdit == true) {
              bool value = await TaskDetailScreen(projectName: projectDetail.name, taskID: tasks[index]["id"],).launch(context);
              if (value) {
                init();
              }
            }
          });
        });

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
                        newProject,
                        color,
                        fav,
                        widget.isEdit == true ? task : SizedBox(),
                        widget.isEdit == true ? taskList : SizedBox(),
                      ],
                    ).paddingOnly(left: 31, right: 31, top: 45, bottom: 90),
                  ),
                ),
                widget.isEdit == true ? Container(
                  height: 45,
                  width: 45,
                  color: COLOR_CONST.redColor,
                  child: Icon(Icons.delete_outline, color: COLOR_CONST.whiteColor,),
                ).cornerRadiusWithClipRRect(10).paddingOnly(right: 47, bottom: 36).onTap(() {
                  ShowDialog.showDialogForDelete(
                      context,
                      'Delete project',
                      'Are you sure, you want to delete ${projectDetail.name} Project?',
                      'Delete',
                      true,
                    okBtnFunction: () {
                        deleteProject();
                    }
                  );
                }) : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future createProject() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url;
      if (widget.isEdit == true) {
        url = "${TString.getProject}/${widget.projectID}";
      } else {
        url = TString.getProject;
      }

      Map mBody = {
        "name": "${projectNameController.text}",
        "favorite": "$favorite"
      };

      String response = await callPostTokenMethod(context, url, mBody, TString.token);
      projectDetail = ProjectDetail.fromJson(json.decode(response));
      print("response-------> $response");
      /*----------API Response----------------*/

      ShowDialog.showDialogForSuccess(context, TString.projectCreatedSuccessfully, TString.ok);

      widget.isEdit = true;
      widget.projectID = projectDetail.id;
      init();
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future getProject() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getProject}/${widget.projectID}";

      String response = await callGetMethodWithToken(context, url, TString.token);
      /*----------API Response----------------*/

      projectDetail = ProjectDetail.fromJson(json.decode(response));
      _isProgress = false;
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future deleteProject() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getProject}/${widget.projectID}";

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

  Future createTask() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = TString.getTask;

      Map mBody = {
        "content": "${taskController.text}",
//        "due_string": "tomorrow at 12:00",
//        "due_lang" : "en",
//        "priority": "4",
//        "project_id": "${widget.projectID}"
      };

      String response = await callPostTokenMethod(context, url, mBody, TString.token);
      /*----------API Response----------------*/

      ShowDialog.showDialogForSuccess(context, TString.taskCreatedSuccessfully, TString.ok, okBtnFunction: () {
        taskController.clear();
        setState(() {});
        Navigator.pop(context, true);
      });
//      projects = jsonDecode(response);
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }

  Future getTasks() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = "${TString.getTask}";

      String response = await callGetMethodWithToken(context, url, TString.token);
      /*----------API Response----------------*/

      print("response---->$response");

      tasks = jsonDecode(response);
      _isProgress = false;
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }
}
