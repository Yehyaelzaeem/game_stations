import 'package:flutter/cupertino.dart';

class GameCardCategoryModel with ChangeNotifier {
  int? id;
  String? name;
  String? image;
  List<GameCardCategoryModel>? subCategoryList;

  GameCardCategoryModel({this.id, this.name, this.image, this.subCategoryList});

  GameCardCategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    name = json['name'];
    image = json['image'] ??= "";
    if (json.containsKey("children_data")) {
      subCategoryList = (json['children_data'] as List<dynamic>)
          .map((e) => GameCardCategoryModel.fromJson(e))
          .toList();
    } else {
      subCategoryList = [];
    }
  }
}
