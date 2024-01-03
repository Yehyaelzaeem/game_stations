import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_translate/global.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../helper/showtoast.dart';
import '../models/Categories.dart';
import '../models/Constant.dart';
import '../models/ProductDetails.dart';
import '../models/sliderModel.dart';
import '../pages/root_pages.dart';
import '../pages/store/game_store.dart';

class CategoriesProvider extends ChangeNotifier {
  String? catIDSearch, cityIDSearch, typeIDSearch;
  String? country;
  LatLng? latLngProvider;
  List<Categories> pCategoryList = [];
  Future<List<Categories>> getCategories({String? notCheck, int startFromIndex = 0, int? itemsLength}) async {
    List<Categories> categoryList = [];
    final String url = "${GlobalConfiguration().getString('api_base_url')}categories";
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
    });

    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    // print(url);

    final gamesCardsCategory = Categories(id: "0", name: Constant.lang == "ar" ? "كروت الالعاب" : "Games Card", image: "assets/images/game_card_icon.png", imageType: 2
        // main_category_id: data['main_category_id'].toString(),
        );

    String te = "";

    try{
      if (itemsLength! > 0) {
        categoryList.insert(0, gamesCardsCategory);
      }
    }catch(e){
      print(e.toString());
    }

    print("categoriesCountry${Constant.country}: " + responseJSON.toString());
    if (response.statusCode == 200) {
      if (Constant.categories.value.length == 0) {
        Constant.categories.value.add(gamesCardsCategory);

        for (var data in responseJSON['data']) {
          var thisList = Categories(
            id: data['id'].toString(),
            name: Constant.lang == "ar" ? data['title'].toString() : data['title'].toString(),
            image: data['image'].toString(),
            // main_category_id: data['main_category_id'].toString(),
          );
          Constant.categories.value.add(thisList);
        }
      }
      if (notCheck == "not") {
        print('------> notCheck == "not"');
        int length = itemsLength! > 0 ? itemsLength : responseJSON['data'].length;
        print('------> length $length');
        for (var i = startFromIndex; i < length; i++) {
          print('------> for $i');
          var thisList = Categories(
            id: responseJSON['data'][i]['id'].toString(),
            name: Constant.lang == "ar" ? responseJSON['data'][i]['title'].toString() : responseJSON['data'][i]['title'].toString(),
            image: responseJSON['data'][i]['img'].toString(),
            // main_category_id: data['main_category_id'].toString(),
          );
          print('------> categoryList.add(thisList);');
          categoryList.add(thisList);
          print('------> end categoryList.add(thisList);');
        }
        print('------> end for');

        // for (var data in responseJSON['data']) {
        //   var thisList = Categories(
        //     id: data['id'].toString(),
        //     name: Constant.lang == "ar" ? data['title'].toString() : data['title'].toString(),
        //     image: data['img'].toString(),
        //     // main_category_id: data['main_category_id'].toString(),
        //   );
        //   if (firstItems == "1") {
        //     if (categoryList.length < 2) {
        //       categoryList.add(thisList);
        //     }
        //   } else if (firstItems == "2") {
        //     if (data['id'].toString() == "5" || data['id'].toString() == "6") {
        //       categoryList.add(thisList);
        //     }
        //   } else if (firstItems == "3") {
        //     if (data['id'].toString() != "1" && data['id'].toString() != "2") {
        //       categoryList.add(thisList);
        //     }
        //   }
        // }
      }
    }
    pCategoryList = categoryList;
    return categoryList;
  }

  Future<List<Categories>> getPartner() async {
    List<Categories> partnerList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}partners";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {"Accept": "application/json"},
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print("partner: " + response.body.toString());
    if (response.statusCode == 200) {
      for (var data in responseJSON) {
        var thisList = Categories(id: data['id'].toString(), name: Constant.lang == "ar" ? data['name_ar'].toString() : data['name_en'].toString(), image: data['image'].toString());
        partnerList.add(thisList);
      }
    }
    return partnerList;
  }

  Future<List<ProductDetails>?> search({String? cat, String? city, String? type, String? word, bool? insideDept}) async {
    List<ProductDetails> productsList = [];
    String status = translate("store.new").toString();
    if (type.toString() == "1") {
      status = translate("store.old").toString();
    }
    // print("cat: "+cat.toString());
    // print("city: "+city.toString());
    // print("type: "+type.toString());
    // if (cat.toString() == "null") {
    //   cat = "1";
    // }
    String url = "${GlobalConfiguration().getString('api_base_url')}products_search";
    var data = {
      'search': '$word',
      'city': '$city',
      'cat': '$cat',
      'type': '$type',
    };
    var response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": Constant.country! == null ? "1" : Constant.country!,
          "Authorization": "Bearer ${Constant.token}",
        },
        body: data);
    String responseBody = response.body;
    print(url.toString());
    print("data: " + data.toString());
    print("searchProductsCountry${Constant.country}: " + response.body.toString());
    var responseJSON = json.decode(responseBody);
    List<ProductDetails> productDetailsList = [];
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        // await getProductDetails(data['id'].toString()).then((value) {
        //   productDetailsList = value;
        // });
        var thisList = ProductDetails(productId: data['id'].toString(), productImage: data['image'].toString(), price: data['price'].toString(), productName: data['title'].toString(), fav: data['favorite'].toString() == "true" ? "true" : "false", countryName: data['country'].toString(), marketName: data['SalesFirstname'].toString(), marketPhone: data['Sales_phone'].toString());
        productsList.add(thisList);
      }
      return productsList;
    }
  }

  Future<List<ProductDetails>?> getProducts(String checkCategoryId, String word, {String? type, String? city, bool? insideDept}) async {
     print("start get product");
    List<ProductDetails> productsList = [];
    if (type != null) {
      if (type.toString().contains("1")) {
        type = "${translate("store.old").toString()}";
      } else {
        type = "${translate("store.new").toString()}";
      }
    }
    String url = "${GlobalConfiguration().getString('api_base_url')}products_cat/$checkCategoryId";
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
      "Authorization": "Bearer ${Constant.token}",
    });
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    // print(url.toString());
    // print("productsCountry${Constant.country}: " + response.body.toString());
    // print(Constant.token.toString());
    List<ProductDetails> productDetailsList = [];
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        // await getProductDetails(data['id'].toString()).then((value) {
        //   productDetailsList = value;
        // });
        var thisList = ProductDetails(
          rate_value: data['rate_value'].toString(),
          productId: data['id'].toString(),
          productImage: data['image'].toString(),
          price: data['price'].toString(),
          productName: data['title'].toString(),
          // fav: productDetailsList.first.fav.toString(),
          marketName: data['SalesFirstname'].toString(),
          countryName: data['city_name'].toString(),
          fav: data['favorite'].toString() == "true" ? "true" : "false",
          lat: data['lat'].toString(),
          lng: data['lng'].toString(),
          special: data['special'].toString(),
        );
        if (insideDept == true) {
          print("f ${data['type']}");
          print("f ${data['city_name'].toString()}");
          print("$type");
          print("$city");
          if (type == null) {
            if (city.toString().trim().toLowerCase() == data['city_name'].toString().trim().toLowerCase()) {
              productsList.add(thisList);
            }
          } else {
            if (type.toString().trim().toLowerCase() == data['type'].toString().trim().toLowerCase() && city.toString().trim().toLowerCase() == data['city_name'].toString().trim().toLowerCase()) {
              productsList.add(thisList);
            }
          }
        } else {
          productsList.add(thisList);
        }
      }

      return productsList;
    }
  }

  Future<List<ProductDetails>> getProductDetails(String productId) async {
    List<ProductDetails> productsList = [];
    String url = "${GlobalConfiguration().getString('api_base_url')}product_details/$productId";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("productDetails: " + response.body.toString());
    String v = "";
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        var thisList = ProductDetails(
          productId: data['id'].toString(),
          marketId: data['sales_id'].toString(),
          views: data['views'].toString(),
          fav: data['favorite'].toString(),
          countryName: data['city_name'].toString(),
          location: data['city_name'].toString(),
          marketPhone: data['Sales_phone'].toString(),
          marketName: data['SalesFirstname'].toString() + data['SalesLastname'].toString(),
          images: List<SliderModel>.from(data["images"].map((x) => SliderModel.fromJsonProduct(x))),
          longDescription: Constant.lang == "ar" ? data['details'].toString() : data['details'].toString(),
        );
        print("${data["images"].toString()}");
        productsList.add(thisList);
      }
      return productsList;
    }
    return productsList;
  }

  String? lat, lng;
  Future addGamesClub({String? productID, String? text, String? title, String? phone, String? country, BuildContext? context, List<File>? images, String? companyName, String? cityID, String? stateID}) async {
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    final uri = Uri.parse("${GlobalConfiguration().getString('api_base_url')}add_games_clubs");
    var request = http.MultipartRequest('POST', uri);
    // print(Constant.token);
    request.headers['Authorization'] = 'Bearer ${Constant.token}';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['x-api-key'] = 'mwDA9w';
    request.headers['Content-Language'] = "en";
    request.headers['Content-Country'] = Constant.country == null ? "1" : "${Constant.country}";
    request.fields['title'] = "$title";
    request.fields['ar_title'] = "$title";
    request.fields['text'] = "$text";
    request.fields['ar_text'] = "$text";
    request.fields["country"] = "$country";
    request.fields['city'] = "$cityID";
    request.fields['state'] = "$stateID";
    request.fields['phone'] = '${Constant.userPhone}';
    request.fields['lat'] = "$lat";
    request.fields['lng'] = "$lng";
    request.fields['company_name'] = "$companyName";
    var pic_image_your_id = await http.MultipartFile.fromPath("image", images!.first.path);
    request.files.add(pic_image_your_id);
    int index = 0;
    if (images!.length > 1) {
      for (int i = 0; i < images.length; i++) {
        var pic_image_your_id = await http.MultipartFile.fromPath("image[$index]", images[i].path);
        print("image[$index]".toString());
        print(images[i].path.toString());
        request.files.add(pic_image_your_id);
        index++;
      }
    } else {
      var pic_image_your_id = await http.MultipartFile.fromPath("image[0]", images.first.path);
      print("image[0]".toString());
      request.files.add(pic_image_your_id);
    }
    print(request.fields.toString());
    await request.send().then((result) async {
      http.Response.fromStream(result).then((response) async {
        print("res\n" + response.body.toString());
        print(response.request!.method.toString());
        if (response.statusCode.toString() == "200") {
          lat = null;
          lng = null;
          showToast(translate("store.done_uploaded_product"));
          print("done uploaded ");
          print("add games clubs: " + response.body.toString());
          print("status code: " + response.statusCode.toString());
          Navigator.pushReplacement(context!, MaterialPageRoute(builder: (BuildContext context) => GameStorePage()));
        } else {
          lat = null;
          lng = null;
          showToast(translate("toast.error_occurred"));
        }
      });
      print(result.statusCode.toString());
    });
  }

  // Future addGamesClub(
  //     {String productID,String text,String title,String phone,String country,
  //       BuildContext context,File image_one,String companyName,
  //       String cityID,String stateID}) async {
  //   // ConstantWidget.loadingData(context: context);
  //   showToast("◌");
  //   print("lat:$lat lng:$lng");
  //   if(stateID==null||stateID=="null")stateID="1";
  //   String fileNameOne = image_one.path.split('/').last;
  //   FormData formData = FormData.fromMap({
  //     'title':'$title',
  //     'ar_title':'$title',
  //     'text':'$text',
  //     'ar_text':'$text',
  //     "country":"$country",
  //     'city':'$cityID',
  //     'state':'$stateID',
  //     'phone':'$phone',
  //     'lat':'$lat',
  //     'lng':'$lng',
  //     'company_name':'$companyName',
  //     "image":await MultipartFile.fromFile(image_one.path, filename:fileNameOne),
  //   });
  //   print("$stateID");
  //   print(formData.fields.toString());
  //   print("token: "+Constant.token);
  //   Dio dio = Dio();
  //   var response = await dio.post("${GlobalConfiguration().getString('api_base_url')}add_games_clubs",
  //       data: formData,options:Options(
  //           headers: {
  //             "Authorization": "Bearer ${Constant.token}",
  //             "Accept": "application/json",
  //             "x-api-key":"mwDA9w",
  //             "Content-Language":Constant.lang=="ar"?"ar":"en",
  //             "Content-Country":Constant.country==null?"1":"${Constant.country}",
  //           },
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status <= 500;
  //           }
  //       )).then((value) async{
  //     print("add games clubs: "+value.data.toString());
  //
  //     // var decodedData= jsonDecode(value.data.toString());
  //     if(value.data.toString().trim().contains("true")||
  //         value.statusCode.toString()=="200"){
  //       showToast(translate("store.done_uploaded_product"));
  //       print("done uploaded ");
  //       print("add games clubs: "+value.data.toString());
  //       print("status code: "+value.statusCode.toString());
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder:
  //           (BuildContext context) => GameStorePage()));
  //       lat=null;
  //       lng=null;
  //     }else{
  //       lat=null;
  //       lng=null;
  //       print("error when add club");
  //     }
  //   });
  // }
  Future<List<ProductDetails>?> getGamesClub({List<ProductDetails>? savedProducts, String? checkCity, String? checkState, bool? checkAuthClubs, bool? delay}) async {
    if (savedProducts != null && savedProducts.length > 0) {
      print('------> getGamesClub savedProducts');
      return savedProducts;
    }

    if (delay == true) {
      await Future.delayed(const Duration(seconds: 2), () {});
    }
    List<ProductDetails> productsList = [];

    String url = "${GlobalConfiguration().getString('api_base_url')}games_club";
    var response = await http.get(Uri.parse(url), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": "${Constant.country == null ? "1" : Constant.country}",
    });
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("gamesClubCountry${Constant.country}: " + response.body.toString());
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        ProductDetails thisList = ProductDetails(
          productId: data['id'].toString(),
          lat: data['lat'].toString(),
          lng: data['lng'].toString(),
          productName: data['title'].toString(),
          productImage: data['img'].toString(),
          location: data['city'].toString(),
          rate_value: data['rate'].toString(),
          countryName: data['country'].toString(),
          longDescription: data['details'].toString(),
          address_details: data['address'].toString(),
          auth_id: data['user'].toString(),
          city_id: data['city_id'].toString(),
          country_id: data['country_id'].toString(),
          state_id: data['state_id'].toString(),
          images: List<SliderModel>.from(data["imgs"].map((x) => SliderModel.fromJsonProduct(x))),
          marketId: data['user'].toString().trim(),
          marketPhone: data['phone'].toString().trim(),
        );
        if (Constant.id.toString() == data['user'].toString().trim()) {
          print("ff   " + data["imgs"].toString());
        }
        if (checkAuthClubs == true) {
          if (Constant.id!.contains(data['user'].toString())) {
            productsList.add(thisList);
            print(productsList.first.images!.first.image);
          }
        } else {
          if (checkCity != null) {
            if (checkState != null && checkState != "0") {
              if (checkCity == data['city_id'].toString().trim() && checkState == data['state_id'].toString().trim()) {
                if (Constant.id != data['user'].toString()) {
                  productsList.add(thisList);
                }
              }
            } else {
              if (checkCity == data['city_id'].toString().trim()) {
                if (Constant.id != data['user'].toString()) {
                  productsList.add(thisList);
                }
              }
            }
          } else {
            if (Constant.id != data['user'].toString()) {
              productsList.add(thisList);
            }
          }
        }
      }
      return productsList;
    }
  }

  Future addProduct({String? productID, String? text, String? title, String? price, String? country, BuildContext? context, List<File>? images, String? catID, String? cityID, String? type}) async {
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    print("token: ${Constant.token}");
    final uri = Uri.parse(
        // ignore: deprecated_member_use
        "${GlobalConfiguration().getString('api_base_url')}add_product");

    var request = http.MultipartRequest('POST', uri);
    // print(Constant.token);
    request.headers['Authorization'] = 'Bearer ${Constant.token}';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['x-api-key'] = 'mwDA9w';
    request.headers['Content-Language'] = Constant.lang == "ar" ? "ar" : "en";
    request.headers['Content-Country'] = Constant.country == null ? "1" : "${Constant.country}";
    request.fields['title'] = "$title";
    request.fields['ar_title'] = "$title";
    request.fields['text'] = "$text";
    request.fields['ar_text'] = "$text";
    request.fields['price'] = "$price";
    request.fields["country"] = "$country";
    request.fields['city'] = "$cityID";
    request.fields['state'] = "1";
    request.fields['phone'] = '${Constant.userPhone}';
    request.fields['qty'] = "2";
    request.fields['type'] = "$type";
    request.fields['lat'] = "$lat";
    request.fields['lng'] = "$lng";
    request.fields['cat'] = "$catID";
    int index = 0;
    if (images!.length > 1) {
      for (int i = 0; i < images.length; i++) {
        var pic_image_your_id = await http.MultipartFile.fromPath("image[$index]", images[i].path);
        print("image[$index]".toString());
        print(images[i].path.toString());
        request.files.add(pic_image_your_id);
        index++;
      }
    } else {
      var pic_image_your_id = await http.MultipartFile.fromPath("image[0]", images.first.path);
      print("image[0]".toString());
      request.files.add(pic_image_your_id);
    }
    print(request.fields.toString());
    await request.send().then((result) async {
      http.Response.fromStream(result).then((response) async {
        print('------> addProduct response ${response.statusCode}');
        print('------> addProduct response ${response.body.toString()}');
        print("res\n" + response.body.toString());
        print(response.request!.method.toString());
        if (response.statusCode.toString() == "200") {
          showToast(translate("store.done_uploaded_product"));
          lat = null;
          lng = null;
          Navigator.pushReplacement(context!, MaterialPageRoute(builder: (BuildContext context) => RootPages(checkPage: "3")));
        } else {
          lat = null;
          lng = null;
          showToast(translate("toast.error_occurred"));
        }
      });
      print('------> addProduct ${result.statusCode.toString()}');
    });
  }

  Future<String?> updateProduct({String? productID, String? text, String? title, String? price, String? country, BuildContext? context, String? catID, String? cityID, File? image, String? type}) async {
    // ConstantWidget.loadingData(context: context);
    showToast("Sending...");
    print("catID: " + catID.toString() + "type: $type");
    String fileNameOne = image != null ? image.path.split('/').last : "";
    FormData formData;
    if (image != null) {
      formData = FormData.fromMap({'title': '$title', 'ar_title': '$title', 'text': '$text', 'ar_text': '$text', "country": "1", 'city': '1', 'state': '1', 'phone': '${Constant.userPhone}', 'cat': '$catID', 'price': "$price", "qty": "2", "image": await MultipartFile.fromFile(image.path, filename: fileNameOne), "type": "$type"});
    } else {
      formData = FormData.fromMap({'title': '$title', 'ar_title': '$title', 'text': '$text', 'ar_text': '$text', "country": "1", 'city': '1', 'state': '1', 'phone': '${Constant.userPhone}', 'cat': '$catID', 'price': "$price", "qty": "2", "type": "$type"});
    }
    print("id: " + productID.toString());
    Dio dio = Dio();
    var response = await dio
        .post("${GlobalConfiguration().getString('api_base_url')}update_product/$productID",
            data: formData,
            options: Options(
                headers: {
                  "Authorization": "Bearer ${Constant.token}",
                  "Accept": "application/json",
                  "x-api-key": "mwDA9w",
                  "Content-Language": Constant.lang == "ar" ? "ar" : "en",
                  "Content-Country": Constant.country == null ? "1" : Constant.country.toString(),
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! <= 500;
                }))
        .then((value) async {
      showToast("Successfully sed");
      print("done updated ");
      print("update product: " + value.data.toString());
      if (value.statusCode.toString() == "200") {
        return "true";
      }
      print("status code" + value.statusCode.toString());
    });
    print("update product response: " + response.toString());
  }

  Future updateImage({String? imageID, File? image, BuildContext? context, bool? gamesClub}) async {
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    print("imgID: $imageID");
    String fileNameOne = image != null ? image.path.split('/').last : "";
    FormData formData = FormData.fromMap({
      'img_id': '$imageID',
      "image": await MultipartFile.fromFile(image!.path, filename: fileNameOne),
    });
    Dio dio = Dio();
    var response = await dio
        .post("${GlobalConfiguration().getString('api_base_url')}${gamesClub == true ? "edit_img_club" : "edit_img"}",
            data: formData,
            options: Options(
                headers: {
                  "Authorization": "Bearer ${Constant.token}",
                  "Accept": "application/json",
                  "x-api-key": "mwDA9w",
                  "Content-Language": Constant.lang == "ar" ? "ar" : "en",
                  "Content-Country": Constant.country == null ? "1" : Constant.country.toString(),
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! <= 500;
                }))
        .then((value) async {
      print("done updated image");
      print("update productImage: " + value.data.toString());
      if (value.statusCode.toString() == "200") {
        return "true";
      }
      // print("status code"+value.statusCode.toString());
    });
    print("update productImage response: " + response.toString());
  }

  Future<List<ProductDetails>?> getMyAds(String adsKind) async {
    List<ProductDetails> productsList = [];
    String url = "${GlobalConfiguration().getString('api_base_url')}my_ads";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "${Constant.country}",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("my ads: " + response.body.toString());
    // print("phone: "+Constant.userPhone.toString());
    String viewss = "1";
    ProductDetails? details;
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']['$adsKind']) {
        await getProductDetails(data['id'].toString()).then((value) {
          viewss = value.first.views.toString();
          details = value.first;
        });
        var thisList = ProductDetails(
          productId: data['id'].toString(),
          phone_counter: data['phone_counter'].toString(),
          count_pro_fav: data['count_pro_fav'].toString(),
          views: viewss.toString(),
          // weight: data['weight'].toString().replaceAll("null", "").toString(),
          // discount: data['discount'].toString(),
          productName: Constant.lang == "ar" ? data['title'].toString() : data['title'].toString(),
          productImage: data['image'].toString(),
          images: details!.images,
          price: data['price'].toString(),
          categoryName: data['category'].toString(),
          categoryId: data['cat_id'].toString(),
          countryName: data['country'].toString(),
          date: data['start_ads'].toString(),
          longDescription: details!.longDescription.toString(),
          type: data['title'].toString(),
          // longDescription: Constant.lang=="ar"?data['ar_text'].toString():data['ar_text'].toString(),
        );
        productsList.add(thisList);
      }
      return productsList;
    }
  }

  Future<List<ProductDetails>?> adsSales(String salesID) async {
    List<ProductDetails> productsList = [];
    String url = "${GlobalConfiguration().getString('api_base_url')}ads_sales/$salesID";
    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("my ads: " + response.body.toString());
    print("phone: " + Constant.userPhone.toString());
    List<ProductDetails> productDetailsList = [];
    if (response.statusCode == 200) {
      for (var data in responseJSON['data']) {
        await getProductDetails(data['id'].toString()).then((value) {
          productDetailsList = value;
        });
        var thisList = ProductDetails(
          productId: data['id'].toString(),
          views: productDetailsList.first.views.toString(),
          // weight: data['weight'].toString().replaceAll("null", "").toString(),
          // discount: data['discount'].toString(),
          productName: Constant.lang == "ar" ? data['title'].toString() : data['title'].toString(),
          productImage: data['image'].toString(),
          // images: List<SliderModel>.from(
          //     data["images"].map((x) => SliderModel.fromJson(x))),
          price: data['price'].toString(),
          categoryName: data['category'].toString(),
          categoryId: data['cat_id'].toString(),
          date: data['start_ads'].toString(),
          type: data['title'].toString(),
          longDescription: productDetailsList.first.longDescription,
          fav: data['favorite'].toString(),
          marketId: productDetailsList.first.marketId,
          marketName: productDetailsList.first.marketName,
          marketPhone: productDetailsList.first.marketPhone,
          countryName: productDetailsList.first.countryName,
          images: productDetailsList.first.images,
          // longDescription: Constant.lang=="ar"?data['ar_text'].toString():data['ar_text'].toString(),
        );
        productsList.add(thisList);
      }
      return productsList;
    }
  }

  Future<String?> addPhoneCounter({String? productID, String? salesID, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}add_phone_counter";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    var data = {
      'product': '$productID',
      'sales': '$salesID',
    };
    final response = await http.post(Uri.parse(myUrl), body: data, headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": "en",
      "Content-Country": "1",
      "Authorization": "Bearer ${Constant.token}",
    });
    print("productID:$productID");
    print("add_phone_counter: " + response.body.toString());
    final decodeData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "increased";
    }
  }

  Future<String?> removeAds({String? productID, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}delete_product/$productID";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    final response = await http.delete(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": "en",
      "Content-Country": "1",
      "Authorization": "Bearer ${Constant.token}",
    });
    print("productID:$productID");
    print("removeAds: " + response.body.toString());
    final decodeData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return "deleted";
    }
  }

  Future<String?> removeGameClub({String? productID, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}delete_games/$productID";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    final response = await http.delete(
      Uri.parse(myUrl),
      headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": "en",
        "Content-Country": "1",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    // print(myUrl);
    // print(Constant.token);
    print("removeGameCLub:$productID");
    print("removeGameClub: " + response.body.toString());
    final decodeData = jsonDecode(response.body);
    if (decodeData['status'].toString().contains("true")) {
      Navigator.of(context!, rootNavigator: true).pop();
      return "deleted";
    } else {
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  Future updateGameCLub({String? productID, String? text, String? title, String? country, BuildContext? context, String? cityID, String? state, String? lat, String? lng, String? address, String? company_name, String? phone, File? image}) async {
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    String fileNameOne = image != null ? image.path.split('/').last : "";
    FormData formData;
    if (image == null) {
      formData = FormData.fromMap({'title': '$title', 'ar_title': '$title', 'text': '$text', 'ar_text': '$text', "country": Constant.country == null ? "$country" : Constant.country, 'city': '$cityID', 'state': '$state', 'phone': phone != null ? phone : '${Constant.userPhone}', 'lat': '$lat', 'lng': '$lng', 'company_name': '$company_name', "schedule": "schedule", 'ar_schedule': 'ar_schedule', 'address': '$address'});
    } else {
      formData = FormData.fromMap({
        'title': '$title',
        'ar_title': '$title',
        'text': '$text',
        'ar_text': '$text',
        "country": Constant.country == null ? "$country" : Constant.country,
        'city': '$cityID',
        'state': '$state',
        'phone': phone != null ? phone : '${Constant.userPhone}',
        'lat': '$lat',
        'lng': '$lng',
        'company_name': '$company_name',
        "image": await MultipartFile.fromFile(image.path, filename: fileNameOne),
        // "image[1]":await MultipartFile.fromFile(image_two.path, filename:fileNameTwo),
        "schedule": "schedule",
        'ar_schedule': 'ar_schedule',
        'address': '$address'
      });
    }
    print("id: " + productID.toString());
    print("updateGameClub: " + formData.fields.toString());
    Dio dio = Dio();
    var response = await dio
        .post("${GlobalConfiguration().getString('api_base_url')}edit_games_clubs/$productID",
            data: formData,
            options: Options(
                headers: {
                  "Authorization": "Bearer ${Constant.token}",
                  "Accept": "application/json",
                  "x-api-key": "mwDA9w",
                  "Content-Language": Constant.lang == "ar" ? "ar" : "en",
                  "Content-Country": "1",
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! <= 500;
                }))
        .then((value) async {
      print("done updated ");
      print("updateGameClub: " + value.data.toString());
      if (value.statusCode.toString() == "200") {
        return "true";
      }
      print("status code" + value.statusCode.toString());
    });
    print("update product response: " + response.toString());
  }

  Future<List<SliderModel>> getSubscriptions() async {
    List<SliderModel> sliderList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}backages";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {"Accept": "application/json", "x-api-key": "mwDA9w", "Content-Language": Constant.lang == "ar" ? "ar" : "en", "Content-Country": "${Constant.country == null ? "1" : Constant.country}"},
    );
    String responseBody = response.body;
    print("getSubscriptions:\n" + response.body);
    var responseJSON = json.decode(responseBody);
    if (responseJSON['success'].toString().contains("true")) {
      for (var data in responseJSON['data']) {
        var thisList = SliderModel(
          id: data['id'].toString(),
          name: data['title'].toString(),
          price: data['price'].toString(),
          time: data['days'].toString(),
          // image: data['image'].toString(),
          // link: data['link'].toString(),
        );
        sliderList.add(thisList);
      }
    }
    return sliderList;
  }

  Future<List<SliderModel>> mySubscriptions() async {
    List<SliderModel> sliderList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}my_backage";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {
        "x-api-key": "mwDA9w",
        "Accept": "application/json",
        'Content-Type': 'application/json',
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "${Constant.country == null ? "1" : Constant.country}",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    String responseBody = response.body;
    print(myUrl);
    print("mySubscriptions:\n" + response.body);
    var responseJSON = json.decode(responseBody);
    if (responseJSON['success'].toString().contains("true")) {
      for (var data in responseJSON['data']) {
        var thisList = SliderModel(
          id: data['id'].toString(),
          name: data['title'].toString(),
          price: data['price'].toString(),
          time: data['days'].toString(),
          date: data['date'].toString(),
          // image: data['image'].toString(),
          // link: data['link'].toString(),
        );
        sliderList.add(thisList);
      }
    }
    return sliderList;
  }

  Future<String?> addSubscribe({String? backageID, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}add_backage";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    print("backage: $backageID");
    var data = {
      'backage': '$backageID',
    };
    final response = await http.post(Uri.parse(myUrl), body: data, headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": "en",
      "Content-Country": "1",
      "Authorization": "Bearer ${Constant.token}",
    });

    print("addSubscribe: " + response.body.toString());
    final decodeData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      showToast(translate("toast.successfully_subscribe"));
      return "true";
    }
  }
  Future<List<SliderModel>> getSlider() async {
    List<SliderModel> sliderList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}home";
    try {
      var response = await http.get(
        Uri.parse(myUrl),
        headers: {"Accept": "application/json", "x-api-key": "mwDA9w", "Content-Language": "en", "Content-Country": "1"},
      );
      String responseBody = response.body;
      // print("sliderData:\n"+response.body);
      var responseJSON = json.decode(responseBody);
      if (response.statusCode == 200) {
        if (Constant.sliders.value.length == 0) {
          for (var data in responseJSON['data']['sliders']) {
            var thisList = SliderModel(
              image: data['image'].toString(),
              link: data['link'].toString(),
              name: data['title'].toString(),
            );
            Constant.sliders.value.add(thisList);
            sliderList.add(thisList);
          }
        }
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
    return sliderList;
  }

}

bool showAds = true;
Future getFreeAds() async {
  String url = "${GlobalConfiguration().getString('api_base_url')}free_ads";
  try {
    var response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json", "x-api-key": "mwDA9w", "Content-Language": Constant.lang == "ar" ? "ar" : "en", "Content-Country": "1"},
    );
    String responseBody = response.body;
    var responseJSON = json.decode(responseBody);
    print(url.toString());
    print("free ADS: " + response.body.toString());
    if (response.statusCode == 200) {
      if (Constant.freeAds.value.length == 0) {
        for (var data in responseJSON['data']) {
          var thisList = SliderModel(
            link: data['link'].toString(),
            image: data['image'].toString(),
          );
          Constant.freeAds.value.add(thisList);
        }
      }
    }
  } catch (e) {
    print(e.toString());
  }
}


Future<SliderModel> getPopUp() async {
  String url = "${GlobalConfiguration().getString('api_base_url')}popup";
  var response = await http.get(
    Uri.parse(url),
    headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": "1",
    },
  );
  String responseBody = response.body;
  var responseJSON = json.decode(responseBody);
  print("popUp: " + response.body.toString());
  SliderModel slider = SliderModel();
  if (response.statusCode == 200) {
    for (var data in responseJSON['data']) {
      var sliderr = SliderModel(
        image: data['image'].toString(),
        link: data['link'].toString(),
      );
      slider = sliderr;
    }
  }
  print("slider " + slider.image.toString());
  return slider;
}
