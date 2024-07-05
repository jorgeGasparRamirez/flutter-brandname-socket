// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  late io.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.connecting; // Intentando conectarme

  SocketService() {
    _initConfig();
  }

  _initConfig() {
    _socket = io.io('http://192.168.1.176:3001',
        io.OptionBuilder().setTransports(['websocket']).build());

    _socket.onConnect((_) => serverStatus = ServerStatus.online);

    _socket.on('nuevo-mensaje', (payload) => print('Hello $payload'));

    _socket.onDisconnect((_) => serverStatus = ServerStatus.offline);
  }

  ServerStatus get serverStatus => _serverStatus;

  set serverStatus(ServerStatus value) {
    _serverStatus = value;
    notifyListeners();
  }

  io.Socket get socket => _socket;

  Function get emit => _socket.emit;
}
