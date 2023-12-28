import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/Constant.dart';
import '../models/messageCountModle.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

class MassageCountProvider extends ChangeNotifier {
  MessageCountModle? messageCountModle;
  int unRead = 0;
  int read = 0;
  messageCount() async {
    final String myUrl =
        "${GlobalConfiguration().get('api_base_url')}msg_count";
    http.Response response = await http.get(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${Constant.token}",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": "1",
    });
    print("aboutResponse: \n" + response.body);
    messageCountModle = MessageCountModle.fromJson(json.decode(response.body));
    unRead = messageCountModle!.data!.unRead!;
    notifyListeners();
  }
}
