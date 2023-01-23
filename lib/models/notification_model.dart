
import 'package:adopt_us/utils/date_time_utils.dart';

class NotificationModel {
    NotificationModel({
        required this.notificationId,
        required this.userId,
        required this.type,
        required this.title,
        required this.description,
        required this.isRead,
        required this.createdAt
    });

    int notificationId;
    int? userId;
    String? type;
    String? title;
    String? description;
    bool isRead;
    final DateTime createdAt;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        notificationId: json["notificationId"],
        userId: json["userId"],
        type: json["type"],
        title: json["title"],
        description: json["description"],
        isRead: json["isRead"]=="true" || json["isRead"]==true,
        createdAt: DateTime.parse(json["createdAt"]).toLocal(),
    );

    Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "userId": userId,
        "type": type,
        "title": title,
        "description": description,
        "isRead": isRead,
        "createdAt" : createdAt.toIso8601String()
    };
}



extension DateAndTime on NotificationModel{
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

