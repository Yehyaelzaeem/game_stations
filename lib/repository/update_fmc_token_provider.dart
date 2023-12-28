import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../models/Constant.dart';

class UpdateFMCTokenProvider with ChangeNotifier {
  Future<void> updateToken(String token) async {
    final String url =
        "${GlobalConfiguration().getString('api_base_url')}update_fcm_token";
    var response = await http.post(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
      "Authorization": "Bearer ${Constant.token}",
    }, body: {
      'token': "$token"
    });

    debugPrint("ESSAMUPDATETOKEN================>${response.contentLength}");

    String responseBody = response.body;
    debugPrint(
        "ESSAMUPDATETOKEN================>${responseBody} ${response.statusCode}");
  }
}
