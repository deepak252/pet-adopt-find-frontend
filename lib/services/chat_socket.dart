
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:adopt_us/config/api_path.dart';
import 'package:adopt_us/utils/debug_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketService{
  static final _debug = DebugUtils("ChatSocketService");

  static IO.Socket? _socket;
  static Completer<String>? _socketIdCompleter;

  //Must be static to avoid STACK OVERFLOW
 
  // Future<String?> get socketId{
  //   if(_socketIdCompleter!=null){
  //     return _socketIdCompleter!.future;
  //   }
  //   return Future.value();
  // }

  /// Create Connection
  Future<String?> createConnection({
    Function(dynamic)? onSendRequest,
    Function(dynamic)? onDeleteRequest,
  })async{
    try {
      _socketIdCompleter =  Completer<String>();
      
      if(isConnected()){
        _debug.message("createConnection","SOCKET ALREADY CONNECTED");
        _socketIdCompleter?.complete(_socket?.id);
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
          if(_socketIdCompleter?.isCompleted!=true){
            _socketIdCompleter?.complete(_socket?.id);
          }
        });
        _socket?.on('SEND_REQUEST', onSendRequest?? onDataReceived);
        _socket?.on('DEL_REQUEST', onDeleteRequest?? onDataReceived);
        _socket?.onDisconnect((_) {
          _debug.message("createConnection",'SOCKET DISCONNECTED: ${_socket?.id}');
        });
        _socket?.onConnectError((err){
          _debug.error("createConnection, ERROR I",error: err);
          if(_socketIdCompleter?.isCompleted!=true){
            _socketIdCompleter?.completeError(err);
          }
        });
      }

      return _socketIdCompleter?.future;
    } catch (e,s) {
       _debug.error("createConnection, ERROR II",error: e,stackTrace: s);
    }
  }

  void onDataReceived(dynamic data)async{
    try {
      log("RUNTIME TYPE : ${data.runtimeType}");
      final prettyString = const JsonEncoder.withIndent('  ').convert(data);
      _debug.message("onDataReceived, DATA RECEIVED:, ${data.runtimeType}\n", prettyString);
    } on Exception catch (e,s) {
       _debug.error("onDataReceived", error: e, stackTrace: s);
    }
  }

  /// Send Auto Hotspot Request
  /// returns TRUE on success, else FALSE
  bool sendRequest(Map<String, dynamic> data){
    try {
      if(!isConnected()){
        throw "SOCKET NOT CONNECTED";
      }
      _socket?.emit('SEND_REQUEST', data);
      _debug.message("sendRequest", "REQUEST SENT");
      return true;
    } catch (e,s) {
      _debug.error("sendRequest", error: e,stackTrace: s);
    }
    return false;
  }

  /// Delete Auto Hotspot Request
  /// returns TRUE on success, else FALSE
  bool deleteRequest(String hotspotId){
    try {
      if(!isConnected()){
        throw "SOCKET NOT CONNECTED";
      }
      _socket?.emit('DEL_REQUEST', {"hotspotId" : hotspotId});
      _debug.message("deleteRequest", "DELETE REQUEST SENT");
      return true;
    } catch (e,s) {
      _debug.error("deleteRequest", error: e,stackTrace: s);
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





