import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/controllers/bottom_nav_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/notification_model.dart';
import 'package:adopt_us/screens/request/all_requests_screen.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/widgets/no_result_widget.dart';
import 'package:adopt_us/widgets/not_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({ Key? key }) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _userController = Get.put(UserController());
  final _bottomNavController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: Obx((){
        if(!_userController.isSignedIn){
          return const NotSignedIn();
        }
        if(_userController.loadingNotifications){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_userController.notifications.isEmpty){
          return NoResultWidget(
            title: "No Notifications Found!",
            onRefresh: ()async{
              _userController.fetchNotifications(enableLoading: true);
            },
          );
        }
        return ListView.separated(
          itemCount: _userController.notifications.length,
          separatorBuilder: (BuildContext context, int index){
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index){
            return notificationTile(
              _userController.notifications[index]
            );
          },
        );
      }),
     
    );
  }

  Widget notificationTile(NotificationModel notification){
    return ListTile(
      tileColor: notification.isRead==true
        ? null
        : Colors.blue.withOpacity(0.1),
      onTap: (){
        _userController.markNotificationRead(notification.notificationId);
        if(notification.type=="Missing"){
          Navigator.pop(context);
          _bottomNavController.changeRoute(index: 1);
        }else if(notification.type=="Request"){
          Navigator.pop(context);
          AppNavigator.push(context, const AllRequestsScreen());
        }
      },
      leading: CircleAvatar(
        backgroundColor: Themes.colorPrimary.withOpacity(0.8),
        child: const Icon(Icons.notifications),
      ),
      title: Text(
        "${notification.title}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4,),
          Text(
            "${notification.description}",
            style: TextStyle(
              fontSize: 14
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2,),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${notification.date}, ${notification.time}",
              style: const TextStyle(
                fontSize: 12
              ),
            ),
          ),
        ],
      ),
      

    );
  }
}