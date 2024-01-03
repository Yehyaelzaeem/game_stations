class PaymentModel {
  String? mode;
  List<Formdata>? formdata;

  PaymentModel({this.mode, this.formdata});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    mode = json['mode'];
    if (json['formdata'] != null) {
      formdata = <Formdata>[];
      json['formdata'].forEach((v) {
        formdata!.add(new Formdata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mode'] = this.mode;
    if (this.formdata != null) {
      data['formdata'] = this.formdata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Formdata {
  String? key;
  String? value;
  String? description;
  String? type;

  Formdata({this.key, this.value, this.description, this.type});

  Formdata.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    description = json['description'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['description'] = this.description;
    data['type'] = this.type;
    return data;
  }
}
