import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../models/cities/cityModle.dart';

import 'networkUtlis.dart';

class CitiesProvider extends ChangeNotifier {
  NetworkUtil _utils = new NetworkUtil();
  List<BottomSheetModel> cities = [];
  List<BottomSheetModel> states = [];
  CityModle? cityModle;
  Future<CityModle> getCities(String countryID) async {
    Response response = await _utils.get("cities/$countryID",{'s':''});
    if (response.statusCode == 200) {
      print("get cities sucsseful");
      notifyListeners();
      cityModle = CityModle.fromJson(response.data);
      cities = cityModle!.data!;
      notifyListeners();
      return CityModle.fromJson(response.data);
    } else {
      print("error get cities data");
      cityModle = CityModle.fromJson(response.data);
      cities = [];
      notifyListeners();
      return CityModle.fromJson(response.data);
    }
  }

  Future<CityModle> getStates(int cityId) async {
    Response response = await _utils.get("state/$cityId",{'s':''});
    if (response.statusCode == 200) {
      print("get state sucsseful");
      notifyListeners();
      cityModle = CityModle.fromJson(response.data);
      states = cityModle!.data!;
      notifyListeners();
      return CityModle.fromJson(response.data);
    } else {
      print("error get state data");
      cityModle = CityModle.fromJson(response.data);
      states = [];
      notifyListeners();
      return CityModle.fromJson(response.data);
    }
  }
}
