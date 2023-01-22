
import 'dart:convert';

import 'package:adopt_us/models/user.dart';

class ConversationRoom {
    ConversationRoom({
      required this.id,
      this.userId1,
      this.user1,
      this.userId2,
      this.user2,
      
      this.createdAt,
    });

    int id;
    int? userId1;
    User? user1;
    int? userId2;
    User? user2;

    DateTime? createdAt;
    

    factory ConversationRoom.fromJson(Map<String, dynamic> json) => ConversationRoom(
        id: json["conversationId"],
        userId1: json["userId1"].runtimeType==int
          ? json["userId1"] : null,
        user1: json["user1"].runtimeType==String
          ? User.fromJson(jsonDecode(json["user1"]))
          : null,
        userId2: json["userId2"].runtimeType==int
          ? json["userId2"] : null,
        user2: json["user2"].runtimeType==String
          ? User.fromJson(jsonDecode(json["user2"]))
          : null,
        createdAt: DateTime.tryParse(json["createdAt"]??'')?.toLocal(),
    );

    // Map<String, dynamic> toJson() => {
    //     

    // };
}

extension RoomAdmin on ConversationRoom{
  bool createdByMe(int currUserId){
    if(user1?.userId==currUserId){
      return true;
    }
    return false;
  }
  User? secondUser(int currUserId){
    if(user1?.userId==currUserId){
      return user2;
    }
    return user1;
  }
}
