import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:taskly/utils/tString.dart';
import 'package:http/http.dart' as http;

Future callGetMethodWithToken(
    BuildContext mContext, String url,String token) async {

  print("url--" + TString.baseUrl + url + "---");

  print("Authorization:"+token);

  return await http.get(Uri.encodeFull(TString.baseUrl + url), headers: {
    "Authorization": token,
  "Content-Type": "application/json",
  }).then((http.Response response) {
    final int statusCode = response.statusCode;
    print("response--" + response.body);
    if (statusCode < 200 || statusCode > 404 || json == null) {
      // throw new Exception("Error while fetching data");
      return TString.error_response;
    }
    return response.body;
  });
}

Future callPostTokenMethod( BuildContext mContext,String url, Map params, String token) async {
  print("url--" + TString.baseUrl + url + "---" +
      "\nparams--" +
      params.toString());

  return await http
      .post(Uri.encodeFull(TString.baseUrl + url), body: params, headers: {
    "Authorization": token,
    "Accept": "application/json",
  }).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 404 || json == null) {
      // throw new Exception("Error while fetching data");
      print("--response--" + statusCode.toString() + "---" + response.body);
      return TString.error_response;
    }
    print("--response--" + statusCode.toString() + "---" + response.body);
    return response.body;
  });
}

Future callDeleteTokenMethod( BuildContext mContext,String url, String token) async {
  print("url--" + TString.baseUrl + url + "---");

  return await http
      .delete(Uri.encodeFull(TString.baseUrl + url), headers: {
    "Authorization": token,
    "Accept": "application/json",
  }).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 404 || json == null) {
      // throw new Exception("Error while fetching data");
      print("--response--" + statusCode.toString() + "---" + response.body);
      return TString.error_response;
    }
    print("--response--" + statusCode.toString() + "---" + response.body);
    return response.body;
  });
}