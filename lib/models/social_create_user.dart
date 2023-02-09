class SocialUserModel {
  String? name;
  String? phone;
  String? email;
  String? uId;
  String? bio;
  String? image;
  String? cover;
  String? password;
  // bool? isEmailVerified;

  SocialUserModel(
      {this.name,
      this.email,
      this.phone,
      this.uId,
      // this.isEmailVerified,
      this.bio,
      this.password,
      this.cover,
      this.image});

  SocialUserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    uId = json['uId'];
    password = json['password'];
    bio = json['bio'];
    cover = json['cover'];
    image = json['image'];
    // isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'uId': uId,
      'password': password,
      // 'isEmailVerified': isEmailVerified,
      'bio': bio,
      'cover': cover,
      'image': image,
    };
  }
}
