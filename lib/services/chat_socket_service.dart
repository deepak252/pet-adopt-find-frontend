
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/controllers/user_controller.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChatSocketService{
  static final _debug = DebugUtils("ChatSocketService");

  static IO.Socket? _socket;
  // static ? socketIdCompleter;
  static final _userController = Get.put(UserController());

  /// Create Connection
  Future<String?> createConnection({
    Function(dynamic)? onNewMessage,
    Function(dynamic)? onGetMessages,
    Function(dynamic)? onGetRooms,
    Function(dynamic)? onGetLiveUsers,
  })async{
    final user = _userController.user;
    Completer<String> socketIdCompleter =  Completer<String>();
    if(user==null){
      return "Not Signed In";
    }
    try {
      
      if(isConnected()){
        _debug.message("createConnection","SOCKET ALREADY CONNECTED");
        socketIdCompleter.complete(_socket?.id);
      }else{
        _debug.message("createConnection","CONNECTING...");
        
        _socket??= IO.io(  // if socket is null
          ApiPath.baseUrl,
          IO.OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .build());
        
        _socket?.connect();
        _socket?.onConnect((_){
          _debug.message("createConnection",'SOCKET CONNECTED: ${_socket?.id}');
          
          // _socket?.emit("live",{"email" : user.email});
          _socket?.emit("live",{"userId" : user.userId});

          if(socketIdCompleter.isCompleted!=true){
            socketIdCompleter.complete(_socket?.id);
          }
        });

        _socket?.on('newRoom', (data){
          onDataReceived(
            data,
            eventName: "newRoom",
            onData: onGetMessages
          );
        });

        _socket?.on('getLiveUsers', (data){
          onDataReceived(
            data,
            eventName: "getLiveUsers",
            onData: onGetLiveUsers
          );
        });

        _socket?.on('getRooms',(data){
          //  onSendRequest?? onDataReceived
          onDataReceived(
            data,
            eventName: "getRooms",
            onData: onGetRooms
          );
        });

        _socket?.on('newMessage',(data){
          onDataReceived(
            data,
            eventName: "newMessage",
            onData: onNewMessage
          );
        });
        _socket?.on('getMessages',(data){
          //  onSendRequest?? onDataReceived
          onDataReceived(
            data,
            eventName: "getMessages",
            onData: onGetMessages
          );
        });
        
        // _socket?.on('sendMessage', onDeleteRequest?? onDataReceived);

        _socket?.onDisconnect((_) {
          _debug.message("createConnection",'SOCKET DISCONNECTED: ${_socket?.id}');
        });
        _socket?.onConnectError((err){
          _debug.error("createConnection, ERROR I",error: err);
          if(socketIdCompleter.isCompleted!=true){
            socketIdCompleter.completeError(err);
          }
        });
      }
      await Future.delayed(const Duration(milliseconds: 500));
      return socketIdCompleter.future;
    } catch (e,s) {
       _debug.error("createConnection, ERROR II",error: e,stackTrace: s);
    }
  }

  void onDataReceived(dynamic data,{
    String? eventName,
    Function(dynamic)? onData,    
  })async{
    try {
      log("RUNTIME TYPE : ${data.runtimeType}");
      final prettyString = const JsonEncoder.withIndent('  ').convert(data);

      _debug.message("${eventName??'onDataReceived '} : , ${data.runtimeType}\n", prettyString);
      if(onData!=null){
        onData(data);
      }
    } on Exception catch (e,s) {
       _debug.error(eventName??'onDataReceived ', error: e, stackTrace: s);
    }
  }

  /// returns TRUE on success, else FALSE
  bool sendMessage({
    required String roomId,
    required String senderId,
    required String message
  }){
    try {
      if(!isConnected()){
        throw "SOCKET NOT CONNECTED";
      }
      _socket?.emit('sendMessage', {
        "roomId" : roomId,
        "senderId" : senderId,
        "message" : message
      });
      _debug.message("sendMessage", "MESSAGE SENT");
      return true;
    } catch (e,s) {
      _debug.error("sendMessage", error: e,stackTrace: s);
    }
    return false;
  }

  /// returns TRUE on success, else FALSE
  bool joinRoom({
    required String roomId,
  }){
    try {
      if(!isConnected()){
        throw "SOCKET NOT CONNECTED";
      }
      _debug.message("joinRoom", "Joining room...");
      _socket?.emit('joinRoom', {
        "roomId" : roomId
      });
      return true;
    } catch (e,s) {
      _debug.error("joinRoom", error: e,stackTrace: s);
    }
    return false;
  }

  /// returns TRUE on success, else FALSE
  bool createRooom({
    required String userId1,
    required String userId2
  }){
    try {
      if(!isConnected()){
        throw "SOCKET NOT CONNECTED";
      }
      _debug.message("joinRoom", "Creating room...");
      _socket?.emit('createRoom', {
        "userId1" : userId1,
        "userId2" : userId2
      });
      return true;
    } catch (e,s) {
      _debug.error("createRoom", error: e,stackTrace: s);
    }
    return false;
  }

  bool isConnected(){
    if(_socket?.connected==true){
      return true;
    }
    return false;
  }

  /// Disconnect and Dispose connection
  void dispose() {
    _socket?.disconnect();
    //Clear all event listeners
    _socket?.dispose();
    _debug.message("dispose", "SOCKECT DISCONNECTED SUCCESSFULLY");

  }

}

