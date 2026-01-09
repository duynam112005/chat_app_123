import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import '../../pages/home_page.dart';
import 'login_or_register.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _themeLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        //nếu login thì snapshot hasData, còn logOut thì !snapshot.hasData
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            final uid = snapshot.data!.uid;
            if (!_themeLoaded) {
              _themeLoaded = true;
              //dùng FutureBuilder  để loadTheme xong mới vào HomePage, tránh crash
              return FutureBuilder(
                future: Provider.of<ThemeProvider>(context, listen: false).loadTheme(uid),
                builder: (context, _) {
                  return HomePage();
                },
              );
            }
            return HomePage();
          } else {
            _themeLoaded = false;
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
