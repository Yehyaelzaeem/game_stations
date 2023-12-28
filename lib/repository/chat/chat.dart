import 'package:flutter/widgets.dart';
import '../../models/Constant.dart';
import '../../models/chat_model.dart';

import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatProvider extends ChangeNotifier {
  Future<String> sendMessage({String? messageTo, String? message}) async {
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}send_msg";
    var data = {
      "title": "$message",
      "text": "$message",
      "to": "$messageTo",
    };
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": "1",
          "Authorization": "Bearer ${Constant.token}",
        },
        body: data);
    print(Constant.token);
    print(myUrl.toString());
    print("sendMessage: " + data.toString());
    print("sendMessage: " + response.body.toString());
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    if (responseJSON['success'].toString().trim().contains("true")) {
      return "yes";
    } else {
      return "no";
    }
  }

  Future<List<ChatModel>> getChatMessages(String room_id) async {
    List<ChatModel> chatList = [];
    print("roomID: $room_id");
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}msgs_details/$room_id/room";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    print(myUrl.toString());
    print("chatData: " + response.body);
    String responseBody = response.body;
    if (response.statusCode == 200) {
      var responseJSON = json.decode(responseBody);
      for (var data in responseJSON['data']) {
        var thisList = ChatModel(
          message: data['address'].toString(),
          id: data['id'].toString(),
          to: data['to_id'].toString(),
          time: "\n" + data['msg_date'].toString().trim() ==
                  DateTime.now().toString().split(" ").first.toString().trim()
              ? " "
              : data['msg_date'].toString() + " " + data['msg_time'].toString(),
        );
        print("m" + data['msg_date'].toString().trim());
        print(
            "s" + DateTime.now().toString().split(" ").first.toString().trim());
        chatList.add(thisList);
      }
    }
    var reversedList = chatList.reversed.toList();
    return reversedList;
  }

  Future<List<ChatModel>> getChatMessagesByID(
      String saller_id, String user_id) async {
    print("sallerID: $saller_id");
    List<ChatModel> chatList = [];
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}msgs_details/$saller_id/seller";
    // var data = {
    //   'user_id':'$user_id',
    //   'saller_id':'$saller_id'
    // };
    // print("${Constant.token}");
    print(myUrl.toString());
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country":
            Constant.country == null ? "1" : "${Constant.country}",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    print(myUrl.toString());
    print("chatDataByID: " + response.body);
    String responseBody = response.body;
    if (response.statusCode == 200) {
      var responseJSON = json.decode(responseBody);
      for (var data in responseJSON['data']) {
        var thisList = ChatModel(
          message: data['address'].toString(),
          id: data['id'].toString(),
          from: data['from'].toString(),
          title: data['address'].toString(),
          time: "\n" + data['msg_date'].toString().trim() ==
                  DateTime.now().toString().split(" ").first.toString().trim()
              ? " "
              : data['msg_date'].toString() + " " + data['msg_time'].toString(),
        );

        chatList.add(thisList);
      }
    }
    var reversedList = chatList.reversed.toList();
    return reversedList;
  }

  Future<List<ChatModel>> getRooms() async {
    List<ChatModel> chatList = [];
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}all_msgs";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    print("roomData: " + response.body);
    print(myUrl.toString());
    print(Constant.token.toString());
    if (response.statusCode == 200) {
      var responseJSON = json.decode(responseBody);
      for (var data in responseJSON['data']) {
        var thisList = ChatModel(
          title: data['id'].toString(),
          id: data['id'].toString(),
          from: data['from'].toString(),
          to: Constant.id == data['from_id'].toString()
              ? data['to'].toString()
              : data['from'].toString(),
          // user_id: data['user_id'].toString(),
          saller_id: Constant.id == data['to_id'].toString()
              ? data['from_id'].toString()
              : data['to_id'].toString(),
          // saller_name:data['saller']!=null?(Constant.lang=="ar"?data['saller']['name_ar'].toString():
          // data['saller']['name_en'].toString()):"",
          // saller_image:data['saller']!=null?
          // (data['saller']['image'].toString()):"",
          time: data['last_msg'].toString().split(" ").first.toString(),
        );
        chatList.add(thisList);
      }
    }
    var reversedList = chatList.reversed.toList();
    return reversedList;
  }
}
