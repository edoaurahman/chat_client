class User {
  int? id;
  String? username;
  String? email;
  String? verificationCode;
  dynamic verifiedAt;
  String? fcmToken;

  User(
      {this.id,
      this.fcmToken,
      this.username,
      this.email,
      this.verificationCode,
      this.verifiedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fcmToken = json['fcmToken'];
    username = json['username'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    verifiedAt = json['verifiedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['fcmToken'] = fcmToken;
    data['username'] = username;
    data['email'] = email;
    data['verificationCode'] = verificationCode;
    data['verifiedAt'] = verifiedAt;
    return data;
  }
}
