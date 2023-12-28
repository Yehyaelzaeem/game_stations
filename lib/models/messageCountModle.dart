class MessageCountModle {
  MessageCountModle({
    this.success,
    this.data,
    this.message,
    this.code,
  });

  bool? success;
  Data? data;
  String? message;
  int? code;

  factory MessageCountModle.fromJson(Map<String, dynamic> json) =>
      MessageCountModle(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"] == null ? null : json["message"],
        code: json["code"] == null ? null : json["code"],
      );
}

class Data {
  Data({
    this.read,
    this.unRead,
  });

  int? read;
  int? unRead;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        read: json["read"] == null ? null : json["read"],
        unRead: json["un_read"] == null ? null : json["un_read"],
      );
}
