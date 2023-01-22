import 'package:adopt_us/utils/date_time_utils.dart';

class Chat {
    Chat({
      required this.id,
      required this.roomId,
      required this.senderId,
      required this.createdAt,
      this.message,
    });

    final int id;
    final int roomId;
    final int senderId;
    String? message;
    final DateTime createdAt;

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["conversationId"],
        senderId: json["senderId"].runtimeType==int
          ? json["senderId"] : null,
        roomId: json["conversationId"].runtimeType==int
          ? json["conversationId"] : null,
        message: json["message"],
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
    );

   
}


extension DateAndTime on Chat{
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

