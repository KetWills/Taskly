import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:taskly/Screens/CreateProjectScreen.dart';
import 'package:taskly/Screens/Modal/ProjectDetailModal.dart';
import 'package:taskly/utils/color_constant.dart';
import 'package:taskly/utils/commonWidgets/showDialog.dart';
import 'package:taskly/utils/font_constant.dart';
import 'package:taskly/utils/network_repository.dart';
import 'package:taskly/utils/tString.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isProgress = false;
  List<dynamic> projects;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getProjects();
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
          child: Icon(Icons.add, color: COLOR_CONST.whiteColor,),
        ).cornerRadiusWithClipRRect(10).paddingOnly(right: 47).onTap(() async {
          bool value = await CreateProjectScreen().launch(context);
          if (value) {
            init();
          }
        })
      ],
    );

    Widget projectList = GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              width: 80,
              height: 80,
              color: COLOR_CONST.lightGreyColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.favorite,
                    size: 20,
                    color: projects[index]['favorite'] == false ? COLOR_CONST.whiteColor : COLOR_CONST.redColor,
                  ).paddingOnly(top: 12, left: 12),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${projects[index]['name'][0]}',
                        style: FONT_CONST.regularBlackText_24,
                      ).paddingOnly(right: 8, bottom: 8),
                    ],
                  )
                ],
              ),
            ).cornerRadiusWithClipRRect(10).paddingOnly(bottom: 5).onTap(() async {
              bool value = await CreateProjectScreen(isEdit: true, projectID: projects[index]['id'],).launch(context);
              if (value) {
                init();
              }
            }),
            Text(
              '${projects[index]['name']}',
              style: FONT_CONST.regularBlackText_14,
            ),
          ],
        );
      },
      itemCount: projects != null ? projects.length : 0,
    ).paddingOnly(top: 50);

    return Scaffold(
      body: Column(
        children: [
          header,
          Container(
            height: MediaQuery.of(context).size.height - 180,
              child: _isProgress ? Center(child: CircularProgressIndicator(),) : projectList
          )
        ],
      ),
    );
  }

  Future getProjects() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        FocusScope.of(context).requestFocus(FocusNode());
        _isProgress = true;
      });

      /*----------API url----------------*/
      String url = TString.getProject;

      String response = await callGetMethodWithToken(context, url, TString.token);
      /*----------API Response----------------*/

      projects = jsonDecode(response);
      _isProgress = false;
      setState(() {});
    } else {
      ShowDialog.showCustomDialog(
          context, "No Internet connection", "");
    }
  }
}
