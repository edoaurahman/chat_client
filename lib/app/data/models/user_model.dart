class User {
  int? id;
  String? name;
  String? username;
  String? email;
  String? verificationCode;
  dynamic verifiedAt;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.verificationCode,
      this.verifiedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    verifiedAt = json['verifiedAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['username'] = username;
    data['email'] = email;
    data['verificationCode'] = verificationCode;
    data['verifiedAt'] = verifiedAt;
    return data;
  }
}
