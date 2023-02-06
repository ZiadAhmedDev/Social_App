class NewPostModel {
  String? name;
  String? uId;
  String? image;
  String? postImage;
  String? date;
  String? text;

  NewPostModel(
      {this.name, this.uId, this.postImage, this.date, this.image, this.text});

  NewPostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    date = json['date'];
    text = json['text'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'date': date,
      'text': text,
    };
  }
}
