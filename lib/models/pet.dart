// To parse this JSON data, do
//
//     final pet = petFromJson(jsonString);

import 'dart:convert';

Pet petFromJson(String str) => Pet.fromJson(json.decode(str));

String petToJson(Pet data) => json.encode(data.toJson());

class Pet {
    Pet({
      required this.petId,
      required this.userId,
      this.addressId,
      this.petName,
      this.breed,
      this.age,
      this.photos,
      this.category,
      this.petStatus,
      this.createdAt,
      this.fullName,
      this.email,
      this.password,
      this.mobile,
      this.profilePic,
      this.adoptPetsId,
      this.uploadPetsId,
      this.favouritePetsId,
      this.fcmId,
      this.addressLine,
      this.city,
      this.state,
      this.pincode,
      this.coordinates,
    });

    int petId;
    int userId;
    int? addressId;
    String? petName;
    String? breed;
    int? age;
    String? photos;
    String? category;
    String? petStatus;
    String? createdAt;
    String? fullName;
    String? email;
    String? password;
    String? mobile;
    String? profilePic;
    dynamic adoptPetsId;
    String? uploadPetsId;
    dynamic favouritePetsId;
    String? fcmId;
    String? addressLine;
    String? city;
    String? state;
    String? pincode;
    String? coordinates;

    factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        petId: json["petId"],
        userId: json["userId"],
        addressId: json["addressId"],
        petName: json["petName"],
        breed: json["breed"],
        age: json["age"],
        photos: json["photos"],
        category: json["category"],
        petStatus: json["petStatus"],
        createdAt: json["createdAt"],
        fullName: json["fullName"],
        email: json["email"],
        password: json["password"],
        mobile: json["mobile"],
        profilePic: json["profilePic"],
        adoptPetsId: json["adoptPetsId"],
        uploadPetsId: json["uploadPetsId"],
        favouritePetsId: json["favouritePetsId"],
        fcmId: json["fcmId"],
        addressLine: json["addressLine"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
        coordinates: json["coordinates"],
    );

    Map<String, dynamic> toJson() => {
        "petId": petId,
        "userId": userId,
        "addressId": addressId,
        "petName": petName,
        "breed": breed,
        "age": age,
        "photos": photos,
        "category": category,
        "petStatus": petStatus,
        "createdAt": createdAt,
        "fullName": fullName,
        "email": email,
        "password": password,
        "mobile": mobile,
        "profilePic": profilePic,
        "adoptPetsId": adoptPetsId,
        "uploadPetsId": uploadPetsId,
        "favouritePetsId": favouritePetsId,
        "fcmId": fcmId,
        "addressLine": addressLine,
        "city": city,
        "state": state,
        "pincode": pincode,
        "coordinates": coordinates,
    };
}
