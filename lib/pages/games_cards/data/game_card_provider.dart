import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../../helper/showtoast.dart';
import '../../../models/Constant.dart';
import '../../../models/game_card_model.dart';

class GameCardProvider with ChangeNotifier {
  bool _isLoading = false;
  List<GameCardModel> _items = [];
  int lastFetchedCategoryId = 0;
  Future<void> fetchData(int category_id) async {
    if (category_id == lastFetchedCategoryId) {
      return;
    }
    lastFetchedCategoryId = category_id;
    _isLoading = true;
    _items.clear();

    notifyListeners();
    final String url = "${GlobalConfiguration().getString('api_base_url')}product_games/$category_id";
    debugPrint("ESSAMresponseJSON==================>:$url");
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
    });

    String responseBody = response.body;
    Map<String, dynamic> responseJSON = json.decode(responseBody);
    debugPrint("ESSAMresponseJSON==================>${responseJSON}");

    if (responseJSON['success'] as bool && response.statusCode == 200) {
      for (var object in responseJSON['data']) {
        _items.add(GameCardModel.fromJson(object));
      }
    } else {
      showToast(responseJSON['message']);
    }

    _isLoading = false;
    notifyListeners();
  }

  List<GameCardModel> get items {
    return _items;
  }

  bool get isLoading {
    return _isLoading;
  }
}
