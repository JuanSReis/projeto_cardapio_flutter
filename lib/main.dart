import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'login.dart'; 
import 'menu_page.dart'; 

void main() {
  runApp(
    DevicePreview(
      enabled: true, 
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurante App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(), 
        '/MenuPage': (context) => MenuPage(),
      },
    );
  }
}
