import 'dart:convert';

import 'package:adopt_us/models/pet.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/utils/date_time_utils.dart';

abstract class RequestStatus{
  ///"Accepted"
  static const accepted = "Accepted";
  ///"Rejected"
  static const rejected = "Rejected";
  ///"Pending"
  static const pending = "Pending";
}

class Request {
  final int requestId;
  String? status;
  Pet? pet;
  User? requestedBy;
  User? requestedTo;
  DateTime createdAt;
  
  Request({
    required this.requestId,
    this.status,
    this.pet,
    this.requestedBy,
    this.requestedTo,
    required this.createdAt
  });

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    requestId: json["requestId"],
    status: json["status"],
    pet: Pet.fromJson(jsonDecode(json["pet"])),
    requestedBy: User.fromJson(jsonDecode(json["requestedBy"])),
    requestedTo: User.fromJson(jsonDecode(json["requestedTo"])),
    createdAt: DateTime.parse(json["createdAt"]??'').toLocal(),
  );

  Map<String, dynamic> toJson() => {
    "requestId": requestId,
    "status": status,
    "pet" : pet?.toJson(),
    "requestedBy" : requestedBy?.toJson(),
    "requestedTo" : requestedTo?.toJson(),
    "createdAt": createdAt.toIso8601String(),
  };

  Request copyWith({
    int? requestId,
    String? status,
    Pet? pet,
    User? requestedBy,
    User? requestedTo,
    DateTime? createdAt,
  }) {
    return Request(
      requestId: requestId ?? this.requestId,
      status: status ?? this.status,
      pet : pet??this.pet,
      requestedBy : requestedBy??this.requestedBy,
      requestedTo : requestedTo??this.requestedTo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

extension DateAndTime on Request{
  String get date{
    String d = DateTimeUtils.formatMMMDDYYYY(createdAt);
    String cd = DateTimeUtils.formatMMMDDYYYY(DateTime.now());
    if(d==cd){
      return "Today";
    }
    return d;
  }
  String get time => DateTimeUtils.formatHHMM(createdAt);
}


extension ExtRequestStatus on Request{
  bool get isAccepted => status?.toLowerCase()==RequestStatus.accepted.toLowerCase();
  bool get isPending => status?.toLowerCase()==RequestStatus.pending.toLowerCase();
  bool get isRejected => status?.toLowerCase()==RequestStatus.rejected.toLowerCase();
}