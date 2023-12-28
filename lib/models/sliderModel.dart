class SliderModel {
  String? id, image, name, description, link, price, time, date;
  bool? isNew = false;
  bool? isEdit = false;

  SliderModel(
      {this.id,
      this.image,
      this.name,
      this.description,
      this.link,
      this.price,
      this.time,
      this.date,
      this.isNew});
  SliderModel.fromJson(Map<String, dynamic> jsonMap) {
    name = jsonMap['name'].toString();
    image = jsonMap['image'].toString();
    link = jsonMap['link'].toString();
    date = jsonMap['date'].toString();
    isNew = false;
  }
  SliderModel.fromJsonProduct(Map<String, dynamic> jsonMap) {
    image = jsonMap['img'].toString();
    id = jsonMap['img_id'].toString();
    isNew = false;
  }

  SliderModel.addNewImage(String newPath) {
    image = newPath;
    isNew = true;
  }
}
