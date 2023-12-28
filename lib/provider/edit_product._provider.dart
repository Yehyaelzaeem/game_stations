import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:global_configuration/global_configuration.dart';

import '../helper/showtoast.dart';
import '../models/Constant.dart';
import '../models/sliderModel.dart';

class EditProductProvider with ChangeNotifier {
  Future updateImage({
    String? product_id,
    List<SliderModel>? images,
    BuildContext? context,
  }) async {
    // ConstantWidget.loadingData(context: context);
    showToast("◌");
    print("Essam =================> imgID: ${images!.length} ${product_id}");
    final uri = Uri.parse(
        "${GlobalConfiguration().getString('api_base_url')}addImageProduct");
    var request = http.MultipartRequest('POST', uri);

    if (images!.length > 0) {
      for (int i = 0; i < images.length; i++) {
        var pic_image_your_id =
            await http.MultipartFile.fromPath("image[$i]", images[i].image!);
        print("image[$i]".toString());
        print(images[i].image.toString());
        request.files.add(pic_image_your_id);
      }
    }
    request.headers['Authorization'] = 'Bearer ${Constant.token}';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'application/json';
    request.headers['x-api-key'] = 'mwDA9w';
    request.headers['Content-Language'] = "en";
    request.headers['Content-Country'] =
        Constant.country == null ? "1" : "${Constant.country}";
    request.fields['product_id'] = "$product_id";
    print(request.fields.toString());
    await request.send().then((result) async {
      http.Response.fromStream(result).then((response) async {
        print("res\n" + response.body.toString());
        print(response.request!.method.toString());
        if (response.statusCode.toString() == "200") {
          print("done uploaded ");
          print("add new image: " + response.body.toString());
          print("status code: " + response.statusCode.toString());
        } else {}
      });
      print(result.statusCode.toString());
    });

    print("update productImage response: ");
  }
}
