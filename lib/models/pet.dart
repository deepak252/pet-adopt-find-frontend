
import 'package:adopt_us/models/address.dart';
import 'package:adopt_us/models/user.dart';

class Pet {
    Pet({
      required this.petId,
      required this.photos,
      // required this.userId,
      this.user,
      this.address,
      this.petName,
      this.breed,
      this.age,
      this.category,
      this.petStatus,
      this.createdAt,
    });

    int petId;
    // int userId;
    User? user;
    Address? address;
    // int? addressId;
    String? petName;
    String? breed;
    String? age;
    List<String> photos;
    String? category;
    String? petStatus;
    String? createdAt;
    

    factory Pet.fromJson(Map<String, dynamic> json) => Pet(
        petId: json["petId"],
        // userId: json["userId"],
        user: User.fromJson(json),
        address: Address.fromJson(json),
        petName: json["petName"],
        breed: json["breed"],
        age: json["age"],
        photos: json["photos"]!=null && json["photos"].trim()!=''
        ? json["photos"]?.split(',')
        : [],
        category: json["category"],
        petStatus: json["petStatus"],
        createdAt: json["createdAt"],
    );

    Map<String, dynamic> toJson() => {
        "petId": petId,
        "petName": petName,
        "breed": breed,
        "age": age,
        "photos": photos,
        "category": category,
        "petStatus": petStatus,
        "createdAt": createdAt,
        ...user?.toJson()??{},
        ...address?.toJson()??{},

    };
}
