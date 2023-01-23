import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/conversation_room.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/screens/chat/chat_screen.dart';
import 'package:adopt_us/utils/app_navigator.dart';
import 'package:adopt_us/utils/date_time_utils.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/chat_user_profile.dart';
import 'package:adopt_us/widgets/not_signed_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({super.key});

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> {
  final _chatController = Get.put(ChatController());
  final _userController = Get.put(UserController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx((){
        if(!_userController.isSignedIn){
          return const NotSignedIn();
        }
        if(_chatController.loadingRooms){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if(_chatController.rooms.isEmpty){
          return const Center(
            child: Text(
              "No Conversations"
            ),
          );
        }
        return ListView.separated(
          itemCount: _chatController.rooms.length+1,
          separatorBuilder: (context, index) => const Divider(height: 0,),
          itemBuilder: (context,index){
            if(index==_chatController.rooms.length){
              return const SizedBox();
            }
            return _chatTile(
              _chatController.rooms[index],
            );
          }
        );
      })
    );
  }

  Widget _chatTile(ConversationRoom room){
    bool createdByMe  = room.createdByMe(_userController.user?.userId??-1);
    User? secondUser = room.secondUser(_userController.user?.userId??-1);
    return ListTile(
      onTap: ()async{
        AppNavigator.push(context, ChatScreen(
          room: room,
        ));        
      },
      leading: GestureDetector(
        onTap: ()async{
          if(secondUser!=null){
            await showChatUserProfile(secondUser);
          }
        },
        child: CachedImageContainer(
          imgUrl: secondUser?.profilePic?? Constants.defaultPic,
          height: 50,
          width: 50,
          borderRadius: BorderRadius.circular(100),
          borderColor: secondUser?.isLive ==true
            ? Colors.green
            : Colors.transparent,
          borderWidth: secondUser?.isLive ==true
            ? 2
            : 0,
        ),
      ),
      title: Text(
         "${secondUser?.fullName}",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17
        ),
      ),
      subtitle: Text(
        "Created by ${createdByMe ? 'you' : secondUser?.fullName}",
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon(Icons.),
          const SizedBox(),
          if(room.createdAt!=null)
          Text(
            DateTimeUtils.formatMMMDDYYYY(room.createdAt!),
            style: const TextStyle(
              fontSize: 12
            ),
          ),
        ],
      ),
    );
  }
}
