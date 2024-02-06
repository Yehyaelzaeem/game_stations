import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gamestation/repository/update_fmc_token_provider.dart';
// import 'package:gamestation_app/repository/update_fmc_token_provider.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../elements/ConstantWidget.dart';
import '../helper/ClientModel.dart';
import '../helper/Database.dart';
import '../helper/checkUser.dart';
import '../helper/showtoast.dart';
import '../main.dart';
import '../models/Categories.dart';
import '../models/Constant.dart';
import '../models/basic_response.dart';
import '../models/sliderModel.dart';
import '../pages/root_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
const String baseUrl = "https://dev.gamestationapp.com/api/";

class UserAuth extends ChangeNotifier {
  String? lat, lng;
  String? country;
  String? countryImage;
  String? countryNameAfterSign;
  Future registerUser({String? firstName, String? lastName, String? email, String? mobile, String? password, BuildContext? context}) async {
   print('start  registerUser ==========================');
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}register";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    String? device = "";
    if (kDebugMode)
      await FirebaseMessaging.instance.getToken().then((value) {
        device = value;
        print("token  >>> $device");
      });
   print('token  >>> $device ==========================');

   var data = {'first_name': '$firstName', 'last_name': '$lastName', 'phone': '$mobile', 'email': '$email', "country": Constant.country ?? "1", "city": Constant.country ?? "1", 'password': '$password', 'password_confirmation': '$password', "token": device};
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": country == null ? "1" : "$country",
        },
        body: data);
    final decodeData = jsonDecode(response.body);
    print(myUrl.toString());
    print("sign up$country: " + response.body.toString());

    if (decodeData['success'].toString().contains("true")) {
      print(decodeData['token'].toString());
      await DBProvider.db.deleteAll();
      for (var data in decodeData['data']) {
        await DBProvider.db.newClient(Client(id: 0, username: "${data['first_name'].toString()}", email: "${data['email'].toString()}", password: "$password", phone: "${data['phone'].toString()}", country: "${country == null ? "1" : country}", lang: Constant.lang == "ar" ? "ar" : "en_US", userId: "user", token: "${data['access_token'].toString()}", blocked: false));
      }
      await checkUser();
      await userProfile();

      FirebaseMessaging.instance.getToken().then((token) {
        debugPrint("ESSAMTOOOKEN" + token!);
        Provider.of<UpdateFMCTokenProvider>(context!, listen: false).updateToken(token);
      });

      Navigator.pushReplacement(context!, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } else if (decodeData['errors'].toString().contains("Is Already Registered")) {
      showToast(translate("signup.already_have_account"));
    } else {
      showToast(decodeData['message']);
      print("Register failed ");
    }
  }

  loginUser({String? phone, String? password,required BuildContext context}) async {
    print("-----> loginUser ");
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}login";
    // ConstantWidget.loadingData(context: context);
    print("-----> myUrl $myUrl ");
    showToast("◌");
    String device = "";
    if (kDebugMode)
      await FirebaseMessaging.instance.getToken().then((String? value) {
        device = value!;
        print("token  >>> $device");
      });
    print("-----> 2222  $device");
    var data = {'phone': '$phone', 'password': '$password', "token": kDebugMode ?  device:'123'};
    print("-----> 3333 ${data}");
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": Constant.country ?? "1",
        },
        body: data);
    print("-----> log test in: " + response.body.toString());
    final decodeData = jsonDecode(response.body);
    if (decodeData['success'].toString().trim() == "true") {
      await DBProvider.db.deleteAll();
      for (var data in decodeData['data']) {
        await DBProvider.db.newClient(Client(id: 0, username: "${data['first_name']}", email: "${data['email']}", password: "$password", phone: "${data['phone']}", country: "${country == null ? "1" : country}", lang: Constant.lang == "ar" ? "ar" : "en_US", userId: "user", token: "${data['access_token'].toString()}", blocked: false));
      }
      await checkUser();
      await checkUser();
      await userProfile();
      if (kDebugMode)
        FirebaseMessaging.instance.getToken().then((token) {
          debugPrint("ESSAMTOOOKEN" + token!);
          Provider.of<UpdateFMCTokenProvider>(context, listen: false).updateToken(token);
        });
      Navigator.pushReplacement(context!, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    } else if (decodeData['message'].toString().contains("Wrong") || decodeData['message'].toString().contains("your account not valid")) {
      print("-----> your account not valid ");
      showToast(translate("signup.not_sign"));
    } else {
      print("-----> Log in failed ");
      showToast(translate("toast.oops"));
    }
  }

  Future signInWithFacebook(String kindRegister, BuildContext context) async {
    /*   final AccessToken accessToken = await FacebookAuth.instance.accessToken;
    await FacebookAuth.instance.login(
       permissions: ['public_profile','email'],
       loginBehavior: LoginBehavior.DIALOG_ONLY
     ).then((value) async{
       print("afterFacebookLoginLine.....");
    try{
    FacebookAuth _facebookAuth;
    final result = await FacebookAuth.instance.login(
      loginBehavior: LoginBehavior.WEB_ONLY,
      permissions: ['public_profile', 'email', ''],
    );
    if (result.status == LoginStatus.success) {
      // final AccessToken accessToken = result.accessToken;
      await FacebookAuth.instance.getUserData().then((value) async {
        print("dataFromFacebook: " + value.toString());
        await loginUserSocial(
            password: "facebook",
            email: value['email'].toString(),
            context: context);
      });
    }

    }catch(e){
      print("facebookError: "+e.toString());
      showToast(translate("toast.oops"));
    }
    });*/
  }

  Future signInWithGoogle(String kindRegister, BuildContext context) async {
    try {

      print('start*****************545******************************');
      // GoogleSignIn _googleSignIn = GoogleSignIn();
      // try {
      //   await _googleSignIn.signIn();
      // } catch (error) {
      //   // Handle sign-in errors
      //   print("Error during sign-in: $error");
      // }
      // final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      //
      final GoogleSignInAccount? googleUser = await GoogleSignIn(clientId: '684599862690-5dpfpe7j1mge9jcend1f68rqjink37rl.apps.googleusercontent.com', scopes: <String>['email']).signIn();
        print("get google user ${googleUser!.email}");
       await loginUserSocial(password: "gmail", email: googleUser!.email.toString(), context: context);

      print('nice***********************************************');

    } catch (e) {
      print("gmailError: " + e.toString());
      showToast(e.toString());
      // showToast(translate("toast.oops"));
    }
    // return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  loginUserSocial({String? email, String? password, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}login_social";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    String device = "";
    if (!kDebugMode)
      await FirebaseMessaging.instance.getToken().then((String? value) {
        device = value!;
        print("token  >>> $device");
      });
    var dataPost = {'first_name': '${email.toString().split("@").first.toString()}', 'phone': '00', 'email': '$email', "country": "${Constant.country ?? "1"}", "token": device};
    print("dataPost  $dataPost");
    final response = await http.post(Uri.parse(myUrl),
        headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": "en",
          "Content-Country": "${Constant.country ?? "1"}",
        },
        body: dataPost);
    print("log in Social$country: " + response.body.toString());
    final data = jsonDecode(response.body);
    // Navigator.of(context).pop();
    print("res  $data");
    if (data['success'].toString() == "true") {
      for (var dataa in data['data']) {
        await DBProvider.db.deleteAll();
        await DBProvider.db.newClient(Client(id: 0, username: "${dataa['first_name']}", email: "${dataa['email']}", password: "${dataa['email']}", phone: "${dataa['phone']}", country: "${Constant.country ?? "1"}", lang: Constant.lang == "ar" ? "ar" : "en_US", userId: "user", token: "${dataa['access_token'].toString()}", blocked: false));
        await checkUser();
        await userProfile();
        Navigator.of(context!).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
      }
    } else if (data['message'].toString().contains("Wrong")) {
      showToast(translate("signup.not_sign"));
    } else if (data['message'].toString().contains("User Is Not Registered")) {
      showToast(translate("login.dont_have_anaccount"));
    } else {
      print("Log in failed ");
    }
  }

  Future<String?> userProfile() async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}profile";
    var response = await http.get(
      Uri.parse(myUrl),
      headers: {
        "Authorization": "Bearer ${Constant.token}",
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": "${Constant.country ?? "1"}",
      },
    );
    var decodedData = jsonDecode(response.body);
    print("user info: " + response.body.toString());
    print("url:$myUrl");
    if (response.statusCode == 200) {
      for (var data in decodedData['data']) {
        countryNameAfterSign = data['country'].toString();
        Constant.userName = data['first_name'].toString();
        Constant.userPhone = data['phone'].toString();
        Constant.email = data['email'].toString();
        Constant.image = data['img'].toString();
        Constant.id = data['id'].toString();
        Constant.subscribe = data['backage_status'].toString().trim() == "true" ? true : false;
        print("subscribe: " + Constant.subscribe.toString());
      }
      await DBProvider.db.updateClient(Client(
        id: 0,
        username: "${Constant.userName}",
        email: "${Constant.email}",
        phone: "${Constant.userPhone}",
        country: "${Constant.country ?? "1"}",
        lang: Constant.lang.toString() == "ar" ? "ar" : "en_US",
        token: Constant.token,
        userId: "${Constant.id}",
        password: "${Constant.id}",
      ));
      await checkUser();
    }
  }

  Future updateProfile({BuildContext? context, String? userName, String? userEmail, String? phone, image}) async {
    showToast("◌");
    String fileName = image == null ? "" : image.path.split('/').last;
    FormData formData = FormData.fromMap({
      'first_name': '$userName',
      'last_name': '$userName',
      'phone': '$phone',
      'email': '$userEmail',
      "country": Constant.country == null ? "1" : "${Constant.country}",
      "city": "1",
      "state": "1",
      "image": image == null ? "" : await MultipartFile.fromFile(image.path, filename: fileName),
    });
    Dio dio = Dio();
    var response = await dio
        .post("${GlobalConfiguration().getString('api_base_url')}edit_profile",
            data: formData,
            options: Options(
                headers: {
                  "Authorization": "Bearer ${Constant.token}",
                  "Accept": "application/json",
                  "x-api-key": "mwDA9w",
                  "Content-Language": Constant.lang == "ar" ? "ar" : "en",
                  "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
                },
                followRedirects: false,
                validateStatus: (status) {
                  return status! <= 500;
                }))
        .then((value) async {
      print("done updated ");
      showToast(translate("toast.update_user_data"));
      print("update profile: " + value.data.toString());
      await userProfile();
      Navigator.of(context!).push(MaterialPageRoute(
          builder: (context) => RootPages(
                checkPage: "4",
              )));
    });
    // showToast(value.data.toString().split("message:").last.toString().split(",").first.toString());
    print("update profile response: " + response.toString());
  }

  Future resetPassword({String? email, String? oldPassword, String? newPassword, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}change-password?old_password=$oldPassword&password=$newPassword&password_confirmation=$newPassword";
    ConstantWidget.loadingData(context: context);
    final response = await http.post(
      Uri.parse(myUrl),
      headers: {
        'Content-Language': "ar",
        "Authorization": "Bearer ${Constant.token}",
      },
    );
    final data = jsonDecode(response.body);
    print("reset password: " + response.body.toString());
    if (response.statusCode == 200) {
      Navigator.of(context!, rootNavigator: true).pop();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
    } else {
      Navigator.of(context!, rootNavigator: true).pop();
    }
  }

  Future forgetPassword({String? id, BuildContext? context}) async {
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}forget_password";
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    final response = await http.post(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
    }, body: {
      "email": "$id",
    });
    print("forgetPassword: ${response.body.toString()}");
    final data = jsonDecode(response.body);
    if (response.body.toString().contains("true")) {
      // Navigator.of(context, rootNavigator: true).pop();
      showToast(translate("toast.check_email"));
    } else {
      showToast(translate("toast.error_occurred"));
    }
  }

  Future<List<SliderModel>> getCountries(bool checkOneCountryOrNot, BuildContext context) async {
    List<SliderModel> countriesList = [];
    final String myUrl = "${GlobalConfiguration().getString('api_base_url')}countries";
    var response = await http.get(Uri.parse(myUrl), headers: {
      "Accept": "application/json",
      "x-api-key": "mwDA9w",
      "Content-Language": Constant.lang == "ar" ? "ar" : "en",
      "Content-Country": country == null ? "1" : "$country",
    });
    String responseBody = response.body;
    print("countriesData:\n" + response.body);
    // print("$countryNameAfterSign");
    if (response.statusCode == 200) {
      var responseJSON = json.decode(responseBody);
      for (var data in responseJSON['data']) {
        var thisList = SliderModel(
          id: data['id'].toString(),
          name: data['title'].toString(),
          image: data['image'].toString(),
        );
        if (countryNameAfterSign.toString().trim() == data['title'].toString().trim()) {
          Constant.country = data['id'].toString();
        } else {
          Constant.country = "${Constant.country}";
        }
        countriesList.add(thisList);
      }
    }
    if (checkOneCountryOrNot == true) {
      if (countriesList.length == 1) {
        country = countriesList.first.id.toString();
        countryImage = countriesList.first.image.toString();
        print("$country" + ": " + "$countryImage");
        // Navigator.of(context).push(MaterialPageRoute(builder:
        //     (context)=> RootPages()));
      }
    }
    return countriesList;
  }

  Future<List<Categories>?> getCities() async {
    List<Categories> productsList = [];
    if (Constant.cities.value.length == 0) {
      String url = "${GlobalConfiguration().getString('api_base_url')}cities/${Constant.country == null ? "1" : "${Constant.country}"}";
      var response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
      });
      String responseBody = response.body;
      var responseJSON = json.decode(responseBody);
      // print("citiesCountry ${Constant.country}: "+response.body.toString());
      if (response.statusCode == 200) {
        if (Constant.cities.value.length == 0) {
          for (var data in responseJSON['data']) {
            var thisList = Categories(
              id: data['id'].toString(),
              name: data['title'].toString(),
            );
            productsList.add(thisList);
            Constant.cities.value.add(thisList);
          }
        }
      }
      return productsList;
    }
  }

  Future<List<Categories>?> getStates(int cityId) async {
    List<Categories> productsList = [];
    if (Constant.states.value.length == 0) {
      for (int i = 0; i < Constant.cities.value.length; i++) {
        String url = "${GlobalConfiguration().get('api_base_url')}state/$cityId";
        var response = await http.get(Uri.parse(url), headers: {
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
        });
        String responseBody = response.body;
        var responseJSON = json.decode(responseBody);
        print("states: " + response.body.toString());
        print("citiesCountry ${Constant.country}: " + response.body.toString());
        if (response.statusCode == 200) {
          if (Constant.states.value.length == 0) {
            for (var data in responseJSON['data']) {
              var thisList = Categories(id: data['id'].toString(), name: data['title'].toString(), main_category_id: "${Constant.cities.value[i].id}");
              productsList.add(thisList);
              Constant.states.value.add(thisList);
            }
            return productsList;
          }
        } else
          return [];
      }
    } else {
      print("get states");
      String url = "${GlobalConfiguration().get('api_base_url')}state/$cityId";
      var response = await http.get(Uri.parse(url), headers: {
        "Accept": "application/json",
        "x-api-key": "mwDA9w",
        "Content-Language": Constant.lang == "ar" ? "ar" : "en",
        "Content-Country": Constant.country == null ? "1" : "${Constant.country}",
      });
      String responseBody = response.body;
      var responseJSON = json.decode(responseBody);
      print("states: " + response.body.toString());
      print("citiesCountry ${Constant.country}: " + response.body.toString());
      if (response.statusCode == 200) {
        print("get states ${responseJSON['data']}");
        for (var data in responseJSON['data']) {
          productsList.add(Categories(id: data['id'].toString(), name: data['title'].toString()));
        }
        print("object >>>>>>>>>>>>>. ${productsList.length}");
        return productsList;
      } else
        return [];
    }
  }

  Future<bool> blockUser({BuildContext? context, String? productId, String? type}) async {
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Constant.token}";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-api-key"] = "mwDA9w";
    dio.options.headers["Content-Language"] = Constant.lang == "ar" ? "ar" : "en";
    dio.options.headers["Content-Country"] = Constant.country == null ? "1" : "${Constant.country}";

    Map<String, dynamic> queryParameters = {
      "product_id": productId,
      if (type != null) "type": type,
    };
    try {
      var response = await dio.post(baseUrl + "block", queryParameters: queryParameters);
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      if (basicResponse.success == true) {
        return true;
      } else
        showToast("${basicResponse.message}");
    } catch (e) {
      if (e is DioError) {
        if (e.response != null && e.response!.data != null && e.response!.data['message'] != null) {
          showToast("${e.response!.data['message']}");
        } else
          showToast("Something went wrong please try again later");
      }
    }
    return false;
  }

  Future<void> deleteAccount({BuildContext? context}) async {
    showToast("◌");
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Constant.token}";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-api-key"] = "mwDA9w";
    dio.options.headers["Content-Language"] = Constant.lang == "ar" ? "ar" : "en";
    dio.options.headers["Content-Country"] = Constant.country == null ? "1" : "${Constant.country}";

    try {
      print("------> ${baseUrl} + delete-account");
      var response = await dio.post(baseUrl + "delete-account");
      print("------> ${response.toString()}");
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      if (basicResponse.success == true) {
        Navigator.of(context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RootPages()),
          (Route<dynamic> route) => false,
        );
      } else {
        showToast("${basicResponse.message}");
      }
    } catch (e) {
      print("------> $e");
      if (e is DioError) {
        print("------> ${e.response}");
        if (e.response != null && e.response!.data != null && e.response!.data['message'] != null) {
          showToast("${e.response!.data['message']}");
        } else
          showToast("Something went wrong please try again later");
      }
    }
  }

  Future<bool> reportProduct({
    BuildContext? context,
    String? productId,
    String? message,
  }) async {
    Dio dio = Dio();
    dio.options.headers["Authorization"] = "Bearer ${Constant.token}";
    dio.options.headers["Accept"] = "application/json";
    dio.options.headers["x-api-key"] = "mwDA9w";
    dio.options.headers["Content-Language"] = Constant.lang == "ar" ? "ar" : "en";
    dio.options.headers["Content-Country"] = Constant.country == null ? "1" : "${Constant.country}";

    Map<String, dynamic> queryParameters = {
      "product_id": productId,
      "message": message,
    };
    try {
      var response = await dio.post(baseUrl + "report", queryParameters: queryParameters);
      BasicResponse basicResponse = BasicResponse.fromJson(response.data);
      if (basicResponse.success == true) {
        return true;
      } else {
        showToast("${basicResponse.message}");
      }
    } catch (e) {
      if (e is DioError) {
        if (e.response != null && e.response!.data != null && e.response!.data['message'] != null) {
          showToast("${e.response!.data['message']}");
        } else {
          showToast("Something went wrong please try again later");
        }
      }
    }
    return false;
  }
}
