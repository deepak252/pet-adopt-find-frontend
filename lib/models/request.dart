import 'dart:convert';

import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/models/user.dart';

class Request {
  final int requestId;
  String? status;
  Pet? pet;
  User? requestedBy;
  User? requestedTo;
  DateTime? requestedAt;
  
  Request({
    required this.requestId,
    this.status,
    this.pet,
    this.requestedBy,
    this.requestedTo,
    this.requestedAt
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    requestId: json["requestId"],
    status: json["status"],
    pet: Pet.fromJson(jsonDecode(json["pet"])),
    requestedBy: User.fromJson(jsonDecode(json["requestedBy"])),
    requestedTo: User.fromJson(jsonDecode(json["requestedTo"])),
    requestedAt: DateTime.tryParse(json["requestedAt"]??''),
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "status": status,
    "pet" : pet?.toJson(),
    "requestedBy" : requestedBy?.toJson(),
    "requestedTo" : requestedTo?.toJson(),
    "requestedAt": requestedAt?.toIso8601String(),
  };

  Request copyWith({
    int? requestId,
    String? status,
    Pet? pet,
    User? requestedBy,
    User? requestedTo,
    DateTime? requestedAt,
  }) {
    return Request(
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
      pet : pet??this.pet,
      requestedBy : requestedBy??this.requestedBy,
      requestedTo : requestedTo??this.requestedTo,
      requestedAt: requestedAt ?? this.requestedAt,
    );
  }
}