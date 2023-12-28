class Categories {
  String? id, name, image, main_category_id;
  int? imageType = 1;

  Categories(
      {this.id, this.name, this.image, this.main_category_id, this.imageType});

  // Categories.fromJson(Map<String, dynamic> jsonMap) {
  //   id = jsonMap['id'].cast<String>();
  //   name = jsonMap['name'].cast<String>();
  // }
}
