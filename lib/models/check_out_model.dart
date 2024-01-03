class CheckOutModel {
  bool? success;
  String? paymentUrl;
  String? message;
  int? code;

  CheckOutModel({this.success, this.paymentUrl, this.message, this.code});

  CheckOutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    paymentUrl = json['payment_url'];
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['payment_url'] = this.paymentUrl;
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}
