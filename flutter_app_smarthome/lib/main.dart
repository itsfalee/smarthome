import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app_smarthome/firebase_options.dart';
import 'package:flutter_app_smarthome/services/auth_gate.dart';
import 'package:flutter_app_smarthome/services/auth_service.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Smart Home App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
