class imageModel {
  String? Image;

  imageModel({
    this.Image,
  });

  imageModel.fromJson(Map<String, dynamic> json) {
    Image = json["Image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['Image'] = this.Image;

    return data;
  }
}
