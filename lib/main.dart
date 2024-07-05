import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:websocket/pages/home.dart';
import 'package:websocket/pages/status.dart';
import 'package:websocket/services/socket_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Home(),
        initialRoute: 'home',
        routes: {
          'home': (_) => const Home(),
          'status': (_) => const StatusPage(),
        },
      ),
    );
  }
}
