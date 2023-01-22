import 'dart:developer';

import 'package:adopt_us/models/chat.dart';
import 'package:adopt_us/models/conversation_room.dart';
import 'package:adopt_us/services/chat_socket_service.dart';
import 'package:adopt_us/storage/user_prefs.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{

  final _debug = DebugUtils("ChatController");

  final _loadingRooms = false.obs;
  bool get loadingRooms => _loadingRooms.value;
  final  _rooms = Rxn<List<ConversationRoom>>();
  List<ConversationRoom> get rooms => _rooms.value??[];

  final _loadingChats = false.obs;
  bool get loadingChats => _loadingChats.value;
  final  _chats = Rxn<Map<int,List<Chat>>>();
  Map<int,List<Chat>> get _allRoomChats => _chats.value??{};

  List<Chat> chatsByRoomId(int roomId){
    if(_allRoomChats[roomId]!=null){
      return _allRoomChats[roomId]!;
    }
    return [];
  }

  ConversationRoom? roomById(int roomId){
    return rooms.firstWhereOrNull((e) => e.id==roomId);
  }

  final _chatSocket = ChatSocketService();
  final _token = UserPrefs.token;
  
  @override
  void onInit() {
    super.onInit();
    connect();
  }

  @override
  void dispose() {
    _chatSocket.dispose();
    super.dispose();
  }

  Future connect()async{
    if(_token==null){
      return;
    }
    _loadingRooms(true);
    final res = await _chatSocket.createConnection(
      onGetRooms: onGetRooms,
      onGetMessages: onGetMessages,
      onGetLiveUsers: onGetLiveUsers,
      onNewMessage: onNewMessage
    );
    log("ChatController -> connect : $res");
    _loadingRooms(false);
  }

  bool createRooom({
    required String userId1,
    required String userId2
  }){
    return _chatSocket.createRooom(userId1: userId1, userId2: userId2);
  }

  bool joinRoom({
    required String roomId,
  }){
    return _chatSocket.joinRoom(roomId: roomId);
  }

  bool sendMessage({
    required String roomId,
    required String senderId,
    required String message
  }){
    return _chatSocket.sendMessage(
      roomId: roomId, 
      senderId: senderId, 
      message: message
    );
  }

  void onNewMessage(data){
    if(data is List && data.isNotEmpty){
      final chat = Chat.fromJson(data[0]);
      _chats.update((val) {
        if(val==null){
          val = {chat.roomId : [chat] };
        }else{
          val[chat.roomId] = [chat,...(val[chat.roomId]??[])];
        }
        _chats(val);
      });
    }else{
      _debug.error("onNewMessage", error: "Invalid Data Type, $data");
    }
  }
  //Loads specific room chats
  void onGetMessages(data){
    int roomId=-1;
    if(data is List){
      List<Chat> chats = [];
      for(var jsonChat in data){
        try {
          final chat = Chat.fromJson(jsonChat);
          if(roomId==-1){
            roomId=chat.roomId;
          }
          
          chats.add(chat);
        } on Exception catch (e,s) {
          _debug.error("onGetMessages", error: "Invalid jsonChat",stackTrace: s);
        }
      }
      _chats.update((val) {
        if(val==null){
          val = {roomId : chats };
        }else{
          val[roomId] =chats;
        }
        _chats(val);
      });

    }else{
      _debug.error("onGetMessages", error: "Invalid Data Type, $data");
    }
  }

  //Loads specific room chats
  void onGetLiveUsers(data){
    int? roomId = data['conversationId'];
    if(roomId==null){
      return;
    }
    List<int> liveUsers = List<int>.from(data['liveUsers'].map((val)=>val));
    _rooms.update((rooms) {
      if(rooms!=null){
        int i = rooms.indexWhere((r) => r.id==roomId);
        if(i==-1){
          return;
        }
        if(liveUsers.contains(rooms[i].user1?.userId)){
          rooms[i].user1!.isLive=true;
        }else{
          rooms[i].user1!.isLive=false;
        }
        if(liveUsers.contains(rooms[i].user2?.userId)){
          rooms[i].user2!.isLive=true;
        }else{
          rooms[i].user2!.isLive=false;
        }
      }
      _rooms(rooms);
    });
  }

  void onGetRooms(data){
    if(data is List){
      List<ConversationRoom> rooms = [];
      for(var jsonRoom in data){
        try {
          var room = ConversationRoom.fromJson(jsonRoom);
          rooms.add(room);
          joinRoom(roomId: room.id.toString());

        } on Exception catch (e,s) {
          _debug.error("onGetRooms", error: "Invalid jsonRoom",stackTrace: s);
        }
      }
      _rooms(rooms);

    }else{
      _debug.error("onGetRooms", error: "Invalid Data Type : $data");
    }
  }


}