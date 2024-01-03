import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gamestation/pages/games_cards/data/search_card_games_response.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../../../helper/showtoast.dart';
import '../../../models/Constant.dart';
import '../../../models/game_card_category_model.dart';

class GameCardCategoryProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _inSearchMode = false;
  bool _isSearching = false;
  String searchQuery = "";
  TextEditingController searchController = TextEditingController();
  List<GameCardCategoryModel> _items = [];
  List<SingleCardGameProductItem> products = [];

  Future<void> fetchData() async {
    if (_items.isNotEmpty) return;
    _isLoading = true;
    _items.clear();
    // debugPrint("ESSAMresponseJSON==fggfyehya================>:${GlobalConfiguration().getString('api_base_url_dev')}cats_games");
    final String url = "${GlobalConfiguration().getString('api_base_url_dev')}cats_games";
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
    });

    String responseBody = response.body;
    Map<String, dynamic> responseJSON = json.decode(responseBody);
    // debugPrint("ESSAMresponseJSON==================>1${responseJSON}");

    if (responseJSON['success'] as bool && response.statusCode == 200) {
      for (var object in responseJSON['data']) {
        _items.add(GameCardCategoryModel.fromJson(object));
      }
    } else {
      showToast(responseJSON['message']);
    }

    _isLoading = false;
    notifyListeners();
  }

  List<GameCardCategoryModel> get items {
    return _items;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get isSearching {
    return _isSearching;
  }

  bool get inSearchMode {
    return _inSearchMode;
  }

  void onSeachModeChange(bool value) {
    _inSearchMode = value;
    notifyListeners();
  }

  void onSearchQueryChange(value) {
    searchQuery = value;
  }

  Future<void> performSearch() async {
    _isSearching = true;
    notifyListeners();
    try {
      Dio dio = Dio();
      Map<String, dynamic> params = {};
      params['search'] = searchQuery;
      params['cart_game'] = '1';

      params.forEach((key, value) {
        print("------> key->$key: value->$value");
      });

      dio.options.baseUrl = "https://gamestationapp.com/api/";
      Response response = await dio.post(
        "products_search",
        data: params,
        options: Options(
          headers: {
            "Authorization": "Bearer ${Constant.token}",
            "Accept": "application/json",
            "Content-Type": "application/json",
            "x-api-key": "mwDA9w",
            "Content-Language": Constant.lang == "ar" ? "ar" : "en",
            "Content-Country": Constant.country,
          },
        ),
      );
      print('------> res${response.data}');
      SearchCardGamesResponse searchCardGamesResponse = SearchCardGamesResponse.fromJson(response.data);
      if (searchCardGamesResponse.data!.isEmpty) {
        showToast(translate('store.no_data'));
        products.clear();
      } else {
        products = searchCardGamesResponse.data!;
      }
    } on DioError catch (e) {
      products.clear();

      if (e.response!.data['message'] != null)
        showToast('${e.response!.data['message']}');
      else if (e.response!.statusCode == 401)
        showToast(translate('store.no_data'));
      else
        showToast("Something went wrong please try again later");
    }
    _isSearching = false;
    notifyListeners();
  }
}
