import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:projeto_cardapio/firebase_options.dart';
import 'login.dart';
import 'menu_page.dart';
import 'item_detail_page.dart';
import 'order.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      debugShowCheckedModeBanner: false,
      title: 'Restaurante App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => LoginPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/MenuPage') {
          final args = settings.arguments as String; 
          return MaterialPageRoute(
            builder: (context) => MenuPage(uid: args),
          );
        } else if (settings.name == '/ItemDetail') {
          final args = settings.arguments as Map<String, String>;
          final itemId = args['itemId']!;
          final userId = args['userId']!;
          return MaterialPageRoute(
            builder: (context) =>
                ItemDetailPage(itemId: itemId, userId: userId),
          );
        } else if (settings.name == '/OrderPage') {
          final args = settings.arguments as String; 
          return MaterialPageRoute(
            builder: (context) =>
                OrderPage(userId: args), 
          );
        }
        return null;
      },
    );
  }
}
