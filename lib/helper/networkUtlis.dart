
import 'package:dio/dio.dart';

import '../models/Constant.dart';

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  CancelToken cancelToken = CancelToken();
  factory NetworkUtil() => _instance;
  double preasent = 0;
  Dio dio = Dio();
  Future<Response> get(String url, Map? headers) async {
    var response;
    try {
      dio.options.baseUrl = "https://gamestationapp.com/api/";
      response = await dio.get(url,
          options: Options(
            headers: {
              "Authorization": "Bearer ${Constant.token}",
              "Accept": "application/json",
              "x-api-key": "mwDA9w",
              "Content-Language": Constant.lang == "ar" ? "ar" : "en",
              "Content-Country": Constant.country,
            },
          ));
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("response: " + e.response.toString());
      } else {}
    }
    return handleResponse(response);
  }

  Future<Response> post(String url, {Map? headers, FormData? body, encoding}) async {
    var response;
    dio.options.baseUrl = "https://gamestationapp.com/api/";
    try {
      response = await dio.post(
        url,
        data: body,
        options: Options(headers: {
          "Authorization": "Bearer ${Constant.token}",
          "Accept": "application/json",
          "x-api-key": "mwDA9w",
          "Content-Language": Constant.lang == "ar" ? "ar" : "en",
          "Content-Country": Constant.country,
        }, requestEncoder: encoding),
        onSendProgress: (int sent, int total) {
          preasent = sent / total * 100;
          print('progress: $preasent ($sent/$total)');
        },
      );

    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
        print("response: " + e.response.toString());
      } else {}
    }
    return handleResponse(response);
  }

  Future<Response> handleResponse(Response response) async {
    preasent = 0;
    if (response.data.runtimeType == String) {
      return Response(statusCode: 102, data: {
        "mainCode": 0,
        "code": 102,
        "data": null,
        "error": [
          {"key": "internet", "value": "هناك خطا يرجي اعادة المحاولة"}
        ]
      }, requestOptions: RequestOptions());
    } else {
      final int statusCode = response.statusCode!;
      print("response: " + response.toString());
      print("statusCode: " + statusCode.toString());

      return response;
    }
  }
}
