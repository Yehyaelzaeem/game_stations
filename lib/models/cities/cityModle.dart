class CityModle {
  CityModle({ this.success, this.data, this.message,  this.code});

  final bool? success;
  final List<BottomSheetModel>? data;
  final String? message;
  final int? code;




  factory CityModle.fromJson(Map<String, dynamic> json) => CityModle(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : List<BottomSheetModel>.from(json["data"].map((x) => BottomSheetModel.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
      );
}

class BottomSheetModel {
  BottomSheetModel({this.id, this.title});

  final int? id;
  final  String? title;

  factory BottomSheetModel.fromJson(Map<String, dynamic> json) => BottomSheetModel(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
      );
}
