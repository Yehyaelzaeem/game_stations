import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_translate/global.dart';
import 'package:global_configuration/global_configuration.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../models/pages.dart';

class About extends ChangeNotifier {
  // Future<List<PagesModel>> getPages() async {
  //   List<PagesModel> pageList = [];
  //   final String myUrl = "${GlobalConfiguration().getString('api_base_url')}about";
  //   var response = await http.get(
  //     myUrl,
  //     headers: {
  //       "Accept": "application/json",
  //     });
  //   print("aboutResponse: \n"+response.body);
  //   if (response.statusCode == 200) {
  //     String responseBody = response.body;
  //     var responseJSON = json.decode(responseBody);
  //     for (var data in responseJSON['data']) {
  //       var thisList = PagesModel(
  //         description: data['description'].toString().trim(),
  //       );
  //       pageList.add(thisList);
  //     }
  //   }
  //   return pageList;
  // }
  Future<List<PagesModel>> getAbout(String kind) async {
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}$kind";
    var response = await http.get(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": "1",
    });
    print("aboutResponse: \n" + response.body);
    String responseBody = response.body;
    List<PagesModel> pagesModelResult = [];
    var responseJSON = json.decode(responseBody);
    for (var data in responseJSON['data']) {
      var pagesModel = PagesModel(
          description: Constant.lang == "ar"
              ? data['details'].toString().trim()
              : data['details'].toString().trim());
      pagesModelResult.add(pagesModel);
    }
    return pagesModelResult;
  }

  Future<List<PagesModel>> getSocial() async {
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}social";
    var response = await http.get(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": "1",
    });
    print("social: \n" + response.body);
    String responseBody = response.body;
    List<PagesModel> pagesModelResult = [];
    var responseJSON = json.decode(responseBody);
    for (var data in responseJSON['data']) {
      var pagesModel = PagesModel(
        kind: data['icon'].toString(),
        value: data['link'].toString(),
      );
      pagesModelResult.add(pagesModel);
    }
    return pagesModelResult;
  }

  Future sendContact(
      {String? msg, String? email, String? name, String? mobile}) async {
    final String myUrl =
        "${GlobalConfiguration().getString('api_base_url')}contact";
    showToast("◌");
    var data = {
      'msg': "$msg",
      'subject': "subject",
      "phone": "$mobile",
      "email": "$email",
      "name": "$name"
    };
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": "1",
        },
        body: data);
    print(data.toString());
    print("sendContact: " + response.body.toString());
    if (response.statusCode == 200) {
      print("good response for sendContact");
      showToast(translate("toast.good_sent_message"));
    } else {
      // showToast(response.body.toString());
    }
  }
}
