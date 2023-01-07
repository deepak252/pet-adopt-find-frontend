class User {
  final int userId;
  String? token;
  String? fullName;
  String? email;
  String? mobile;
  String? profilePic;
  String? fcmToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  
  User({
    required this.userId,
    this.token,
    this.fullName,
    this.email,
    this.mobile,
    this.profilePic,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    token: json["token"],
    fullName: json["fullName"],
    email: json["email"],
    mobile: json["mobile"],
    profilePic: json["profilePic"],
    fcmToken: json["fcmToken"],
    createdAt: DateTime.tryParse(json["createdAt"]??''),
    updatedAt: DateTime.tryParse(json["updatedAt"]??''),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "token": token,
    "fullName": fullName,
    "email": email,
    "mobile": mobile,
    "profilePic": profilePic,
    "fcmToken": fcmToken,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };

  User copyWith({
    int? userId,
    String? token,
    String? fullName,
    String? email,
    String? mobile,
    String? profilePic,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      userId: userId ?? this.userId,
      token: token ?? this.token,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      profilePic: profilePic ?? this.profilePic,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}