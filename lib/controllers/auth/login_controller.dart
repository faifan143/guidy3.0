import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:guidy/core/constants/AppConnection.dart';
import 'package:guidy/core/services/sharedPreferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/user_model.dart';


class LoginController extends GetxController {
  TextEditingController myLoginEmail = TextEditingController();
  TextEditingController myLoginPassword = TextEditingController();
  bool isPassword = true;
  bool loading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  changePassState() {
    isPassword = !isPassword;
    update();
  }

  changeLoadingState() {
    loading = !loading;
    update();
  }

  MyServices myServices = Get.find();

  Future<Map<String, dynamic>> adminLogin() async {
    changeLoadingState();
    try {
      final Uri uri = Uri.parse('http://${AppConnection.url}:${AppConnection.port}/auth/admin_login');
      final response = await http.post(
        uri,
        body: json.encode({"email": myLoginEmail.text.trim(), "password": myLoginPassword.text.trim()}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        changeLoadingState();
        myServices.sharedPref.setString("token", responseData["token"]);
        myServices.sharedPref.setString('user_model', json.encode(responseData['rows'][0]));
        myServices.sharedPref.setString('isAdmin',responseData["isAdmin"]);
        return {
          'state': responseData['state'],
          'token': responseData['token'],
        };
      } else {
        changeLoadingState();
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Login failed: ${responseData['msg']}');
        return {'state': 'false', 'msg': responseData['msg']};
      }
    } catch (error) {
      changeLoadingState();
      print('Login error: $error');
      return {'state': 'false', 'msg': 'Internal server error'};
    }
  }

  Future<Map<String, dynamic>> customerLogin() async {
    changeLoadingState();
    try {
      final Uri uri = Uri.parse('http://${AppConnection.url}:${AppConnection.port}/auth/customer_login');
      final response = await http.post(
        uri,
        body: json.encode({"email": myLoginEmail.text.trim(), "password": myLoginPassword.text.trim()}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        changeLoadingState();
        myServices.sharedPref.setString("token", responseData["token"]);
        myServices.sharedPref.setString('user_model', json.encode(responseData['rows'][0]));
        myServices.sharedPref.setString('isAdmin',responseData["isAdmin"]);
        return {
          'state': responseData['state'],
        };
      } else {
        changeLoadingState();
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Login failed: ${responseData['msg']}');
        return {'state': 'false', 'msg': responseData['msg']};
      }
    } catch (error) {
      changeLoadingState();
      print('Login error: $error');
      return {'state': 'false', 'msg': 'Internal server error'};
    }
  }


  Future<Map<String, dynamic>> login(BuildContext context) async {
    RegExp regex = RegExp(r'\badmin@[\w.]+');
    if(regex.hasMatch(myLoginEmail.text.trim())){
      return await adminLogin();
    }else{
      return await customerLogin();
    }
  }

}



