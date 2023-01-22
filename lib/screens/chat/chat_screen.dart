import 'dart:developer';

import 'package:adopt_us/config/app_theme.dart';
import 'package:adopt_us/config/constants.dart';
import 'package:adopt_us/controllers/chat_controller.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/models/chat.dart';
import 'package:adopt_us/models/conversation_room.dart';
import 'package:adopt_us/models/user.dart';
import 'package:adopt_us/utils/misc.dart';
import 'package:adopt_us/widgets/cached_image_container.dart';
import 'package:adopt_us/widgets/chat_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  final ConversationRoom room;
  const ChatScreen({super.key, required this.room});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = Get.put(ChatController());
  final _userController = Get.put(UserController());
  
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  User? secondUser;

  @override
  void initState() {
    secondUser = widget.room.secondUser(_userController.user?.userId??-1);
    super.initState();
  }


  @override
  void dispose() {
    // _focusNode.removeListener(_onFocusChanged);
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    bool keyboardVisible = MediaQuery.of(context).viewInsets.bottom!=0.0;

    return GestureDetector(
      onTap: ()=>unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Themes.colorSecondary.withOpacity(0.8),
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          elevation: 2,
          title: Obx((){
            final room = _chatController.roomById(widget.room.id)??widget.room;
            secondUser = room.secondUser(_userController.user?.userId??-1);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: ()async{
                if(secondUser!=null){
                  await showChatUserProfile(secondUser!);
                }  
              },
              leading: CachedImageContainer(
                imgUrl: secondUser?.profilePic?? Constants.defaultPic,
                height: 40,
                width: 40,
                borderRadius: BorderRadius.circular(100),
                borderColor: secondUser?.isLive ==true
                  ? Colors.green
                  : Colors.transparent,
                borderWidth: secondUser?.isLive ==true ? 2 : 0,
              ),
              title: Text(
                "${secondUser?.fullName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                secondUser?.isLive==true ? "Online" : "Offline",
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            );
          })
        ),
        backgroundColor: Themes.backgroundColor,
        body: Obx((){
          if(_chatController.loadingChats){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chats = _chatController.chatsByRoomId(widget.room.id);
          return ListView.builder(
            controller: _scrollController,
            itemCount: chats.length+1,
            physics: const BouncingScrollPhysics(),
            reverse: true,
            shrinkWrap: true,
            itemBuilder: (context,index){
              int i=index;
              if(index==0){
                return const SizedBox(
                  height: 70,
                );
              }
              if(index<chats.length && chats[index-1].date ==chats[index].date){
                return chatBubble(chats[index-1]);
              }
              return chatBubbleWithDate(
                chats[index-1],
                chats[index-1].date , 
              );

              // i--;
              // if(i+1<chats.length && chats[i].date ==chats[i+1].date){
              //   return chatBubble(chats[i]);
              // }
              // return chatBubbleWithDate(
              //   chats[i],
              //   chats[i].date , 
              // );
              
            }
          );
          
        }),
       
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        floatingActionButton: Container(
          margin: EdgeInsets.only(
            left: 12,right: 12,
            bottom: keyboardVisible ? 0 : 12
          ),
          decoration:  BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Themes.colorSecondary.withOpacity(0.8), 
                blurRadius: 2.0, 
                spreadRadius: 0.5
              )
            ]),
          child: msgTextField()
        ),
      
      ),
    );
  }
  

  Widget chatBubble(Chat chat){
    bool sentByMe = chat.senderId == _userController.user?.userId;
    return UnconstrainedBox(
      // constrainedAxis: Axis.horizontal,
      alignment: sentByMe 
        ?  Alignment.bottomRight
        :  Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.only(
          left: 12,right: 12,top: 12
        ),
        margin: const EdgeInsets.all(4),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height*0.5,
          maxWidth: MediaQuery.of(context).size.width*0.8,
          minWidth: MediaQuery.of(context).size.width*0.3,
        ),
        decoration: BoxDecoration(
          color: sentByMe
          ? Themes.colorSecondary
          : Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
            topLeft: sentByMe ? const Radius.circular(12) : Radius.zero,
            topRight: sentByMe ? Radius.zero : const Radius.circular(12),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 2,offset: Offset(3,3),color: Colors.grey.withOpacity(0.5))
          ]
        ),
        
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (chat.message??''),
                style: TextStyle(
                  color: sentByMe
                    ? Colors.white 
                    : null
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  (chat.time),
                  style: TextStyle(
                    color: sentByMe
                      ? Colors.white.withOpacity(0.7)
                      : Themes.colorBlack.withOpacity(0.7),
                    fontSize: 11
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget chatBubbleWithDate(Chat chat, String date){
    bool sentByMe = chat.senderId == _userController.user?.userId;
    return Column(
      children: [
        Chip(
          label: Text(
            date
          ),
        ),        
        Align(
          alignment: sentByMe
           ?  Alignment.topRight
           : Alignment.topLeft,
          child: chatBubble(chat)
        ),
      ],
    );
  }

  TextField msgTextField(){
    return TextField(
      controller: _textController,
      keyboardType: TextInputType.multiline,
      maxLines: 6,
      minLines: 1,
      style: const TextStyle(
        color:Themes.colorBlack,
      ),
      decoration: InputDecoration(
        fillColor: Colors.grey[300],
        filled: true,
        hintText: " Message...",
        suffixIcon: IconButton(
          onPressed: (){
            _chatController.sendMessage(
              roomId: widget.room.id.toString(), 
              senderId: _userController.user!.userId.toString(), 
              message: _textController.text
            );
            _textController.clear();
          },
          icon: Icon(
            Icons.send,
            color: !FocusScope.of(context).hasFocus
              ?Colors.black54
              : Themes.colorSecondary
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20
        ),
        
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent, 
          ),
          borderRadius: BorderRadius.circular(20)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:Themes.colorSecondary.withOpacity(0.8), 
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20)
        ),
      ),
      
    );
  }
}
