import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = context.read<SocketService>();
    final dimensions = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: dimensions.width,
          height: dimensions.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Server Status: ${socketService.serverStatus}',
                style: const TextStyle(fontSize: 16),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () => socketService
              .emit('mensaje2', {'nombre': 'Gaspar'}),
        ),
      ),
    );
  }
}
