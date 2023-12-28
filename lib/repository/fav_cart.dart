import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../models/ProductDetails.dart';
import '../models/sliderModel.dart';

class FavAndCart extends ChangeNotifier{

  Future<List<ProductDetails>?> getProductDetails(String productId) async {
    List<ProductDetails> productsList = [];
    String url = "${GlobalConfiguration().getString('api_base_url')}product_details/$productId";
    var response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json",
        "x-api-key":"mwDA9w",
        "Content-Language": Constant.lang=="ar"?"ar":"en",
        "Content-Country":"1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("productDetails: "+response.body.toString());
    String v="";
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        var thisList = ProductDetails(
          productId: data['id'].toString(),
          marketId: data['sales_id'].toString(),
          views: data['views'].toString(),
          fav: data['favorite'].toString(),
          countryName: data['city_name'].toString(),
          marketPhone: data['Sales_phone'].toString(),
          marketName: data['SalesFirstname'].toString()+data['SalesLastname'].toString(),
          images: List<SliderModel>.from(
              data["images"].map((x) => SliderModel.fromJsonProduct(x))),
          longDescription: Constant.lang=="ar"?data['details'].toString():data['details'].toString(),
        );
        productsList..add(thisList);
      }
      return productsList;
    }
  }

  Future<String> addToFavourite({String? productID,BuildContext? context,String? favOrDis}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}add_to_favorite";
    // ConstantWidget.loadingData(context: context);
 
    var data = {
      'product':'$productID',
    };
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key":"mwDA9w",
          "Content-Language":"en",
          "Content-Country":"1",
          "Authorization": "Bearer ${Constant.token}",
        },
        body: data);
    print(data.toString());
    print(Constant.token.toString());
    print(Constant.userPhone.toString());
    print(myUrl);
    String ret="";
    print("addFavourite: "+response.body.toString());
    final decodeData = jsonDecode(response.body);
    if(response.body.toString().trim().contains('added success')) {
      showToast(translate("toast.favourite"));
      ret= "true";
    }else if(response.body.toString().trim().contains('remove from favorite')){
        showToast(translate("toast.dis_favourite"));
        ret= "false";
    }else{

    }
    return ret;
  }


  Future<List<ProductDetails>> getFavProducts() async {
    List<ProductDetails> productsList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}products_favorite";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {"Accept": "application/json",
        "x-api-key":"mwDA9w", "Content-Language":"en",
        "Content-Country":"1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print("fav: "+responseJSON.toString());
    List<ProductDetails> productDetailsList = [];
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        // await getProductDetails(data['id'].toString()).then((value) {
        //   productDetailsList = value;
        // });
        var thisList = ProductDetails(
            productId: data['id'].toString(),
            productName: Constant.lang=="ar"?data['title'].toString():data['title'].toString(),
            productImage:data['image'].toString(),
            price: data['price'].toString(),
            categoryName:data['category'].toString(),
            countryName: data['country'].toString(),
            marketName: data['SalesFirstname'].toString(),
            marketPhone: data['Sales_phone'].toString()
        );
          productsList.add(thisList);
      }
    }
    return productsList;
  }



  Future productRate({String? productID,String? rate_value,String? kind})async{
    String idKind = "product";
    if(kind=="rate_game_Club")idKind="game_club";
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}$kind";
    var data ={
      '$idKind':'$productID',
      'rate':'$rate_value'
    };
    final response = await http.post(Uri.parse(myUrl),
      headers: {
        "Accept": "application/json",
        "x-api-key":"mwDA9w",
        "Content-Language":Constant.lang=="ar"?"ar":"en",
        "Content-Country":"1",
        "Authorization": "Bearer ${Constant.token}",},body: data);
    print(data.toString());
    print("rate: "+response.body.toString());
    var decodedData= jsonDecode(response.body);
    showToast(translate("${decodedData['message']}"));
    if(response.statusCode ==200) {
      // final data = jsonDecode(response.body);

      // showToast(translate("toast.successfully_rate"));
      print("good response for rate product");
    }else{
      // print(response.body.toString());
    }
  }

}
Future<String> checkFavProducts(String checkIDFav) async {
  String fav="";
  String url = "${GlobalConfiguration().getString('api_base_url')}my-wishlist";
  var response = await http.post(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${Constant.token}"},
  );
  String responseBody = response.body;
  var responseJSON = json.decode(responseBody);
  // print(responseJSON.toString());
  if (response.statusCode == 200) {
    for (var data in responseJSON['products']) {
      if(checkIDFav.toString().trim()==data['product_id'].toString().trim()){
        fav="fav";
      }
    }
  }
  return fav;
}
Future<List<ProductDetails>> getCartProducts() async {
  List<ProductDetails> productsList = [];
  try{
   final String myUrl = "${GlobalConfiguration().getString('api_base_url')}shopping-cart";
   var response = await http.get(
     Uri.parse(myUrl),
     headers: {
       "Accept": "application/json",
       "Authorization": "Bearer ${Constant.token}"},
   );
   var responseBody = response.body;
   var responseJSON = json.decode(responseBody);
   if (response.statusCode == 200) {
     for (var data in responseJSON['items']) {
       var thisList = ProductDetails(
         productId: data['product_id'].toString(),
         productName: Constant.lang=="ar"?data['name_ar'].toString():data['name_en'].toString(),
         productImage: data['image'].toString(),
         price: data['price'].toString(),
         priceSale: data['price'].toString(),
         amount:data['quantity'].toString(),
       );
       productsList.add(thisList);
       Constant.cartList.value.add(thisList);
     }
     Constant.orderTotalProductsPrice.value =double.parse("0").toDouble();
     Constant.orderDeliveryPrice.value =double.parse("0").toDouble();
     Constant.orderTotalPrice.value =double.parse(responseJSON['total'].toString()).toDouble();
     if(productsList.length==0){
       Constant.orderTotalPrice.value = 0.0;
     }
   }
 }catch(e){print(e);}
  return productsList;
}