
import 'package:flutter/material.dart';
import 'Categories.dart';
import 'ProductDetails.dart';
import 'address.dart';
import 'sliderModel.dart';

class Constant{
  static String? id;
  static String? email;
  static String? userName;
  static String? userPhone;
  static String? userPassword;
  static String? userAddress;
  static String? token;
  static String? image;
  static String? lang;
  static String? country;
  static bool? subscribe;
  static String? orderLength = "";
  static ValueNotifier <List<AddressModel>> addresses = ValueNotifier <List<AddressModel>>([]);


  static ValueNotifier <List<Categories>> states = ValueNotifier <List<Categories>>([]);
  static ValueNotifier <List<Categories>> cities = ValueNotifier <List<Categories>>([]);
  static ValueNotifier <List<Categories>> categories = ValueNotifier <List<Categories>>([]);
  static ValueNotifier <List<SliderModel>> sliders = ValueNotifier <List<SliderModel>>([]);
  static ValueNotifier <List<SliderModel>> freeAds = ValueNotifier <List<SliderModel>>([]);

  static ValueNotifier <List<ProductDetails>> cartList = ValueNotifier <List<ProductDetails>>([]);
  static ValueNotifier <List<ProductDetails>> favList = ValueNotifier <List<ProductDetails>>([]);
  static ValueNotifier<double> orderDeliveryPrice = ValueNotifier <double>(0.0);
  static ValueNotifier<double> orderTax = ValueNotifier <double>(0.0);
  static ValueNotifier<double> orderTotalProductsPrice = ValueNotifier <double>(0.0);
  static ValueNotifier<double> orderTotalPrice = ValueNotifier <double>(0.0);


  static ValueNotifier<bool> enableFilter = ValueNotifier <bool>(false);


}
clearDate(){
  Constant.cities.value.clear();
  Constant.states.value.clear();
  Constant.categories.value.clear();
}