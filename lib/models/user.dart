class User {
  final String id;
  String? token;
  String? name;
  String? email;
  String? phone;
  String? profilePic;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  
  User({
    required this.id,
    this.token,
    this.name,
    this.email,
    this.phone,
    this.profilePic,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["_id"],
    token: json["token"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    profilePic: json["profilePic"],
    fcmToken: json["fcmToken"],
    createdAt: DateTime.tryParse(json["createdAt"]??''),
    updatedAt: DateTime.tryParse(json["updatedAt"]??''),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "token": token,
    "name": name,
    "email": email,
    "phone": phone,
    "profilePic": profilePic,
    "fcmToken": fcmToken,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  User copyWith({
    String? id,
    String? token,
    String? name,
    String? email,
    String? phone,
    String? profilePic,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      token: token ?? this.token,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePic: profilePic ?? this.profilePic,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}