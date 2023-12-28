class Options{

  String? idIndex,name,value;

  Options({this.idIndex,this.name, this.value});

  Options.fromJson(Map<String, dynamic> jsonMap) {
    // idIndex = jsonMap['id'].toString();
    name = jsonMap['name'].toString();
    value = jsonMap['value'].toString();
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["value"] = value;
    return map;
  }
}
class MainOptions{

  final String? idIndex;
  late final List<Options>?  options;

  MainOptions({this.idIndex,this.options});


  MainOptions.fromJson(Map<String, dynamic> jsonMap, this.idIndex, this.options) {
    // idIndex = jsonMap['id'].toString();
    if (jsonMap['options'] != null) {
      options = <Options>[];
      jsonMap['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

}

