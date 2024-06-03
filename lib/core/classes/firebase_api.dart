import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final serverToken = 'AAAAFrS3OnQ:APA91bGj24jq__2I1pteSlQjRieCT4bSjXK8Rkimqn9G-rxG83WVKr88Ah4bIVsEgNSXJ1XB9sABwQV1UJdRZE31oXdDYc1d1XVm39vXEJmiqrLVmHp3K76zOuz0CVR1fE9-LJHyISB8';
Future<void> sendNotification({required BuildContext context ,required String body , required String title , required Map<String,String> data}) async {
  await http
      .post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'title': title,
          'body': body
        },
        'priority': 'high',
        'data': data,
        'to': "/topics/all",
      },
    ),
  )
      .then((value) async {
    print("\n\n\n\n\n ${value.body} \n\n\n\n\n\n");
    if (value.statusCode == 200) {
    print("=========done=========");
    } else {
      print("=========false=========");
    }
  }).catchError((onError) {
    print(onError);
  });
}