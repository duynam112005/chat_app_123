import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/services/auth/auth_gate.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // tạo và cung cấp instance ThemeProvider để dùng cho toàn app
  //dùng ChangeNotifierProvider vì ThemeProvider extend từ ChangeNotify và để sử dụng được NotifyListener
  runApp(ChangeNotifierProvider(create: (context) => ThemeProvider(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: Provider.of<ThemeProvider>(context, listen: true).themeData,// khi notifyListener được gọi, thì widget này được rebuild, themData được đọc lại
    );
  }
}
