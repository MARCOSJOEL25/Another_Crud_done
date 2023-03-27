import 'dart:io';

import 'package:another_crud/pages/Login.dart';
import 'package:another_crud/pages/home.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Required for background service
  WidgetsFlutterBinding.ensureInitialized();
  // await initializeService(); // Do this later when all permissions are initialized
  HttpOverrides.global = DevHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Login(),
    );
  }
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
