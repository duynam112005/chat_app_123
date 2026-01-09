import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/themes/dark_mode.dart';
import 'package:flutter_application_1/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier{
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> loadTheme(String uid) async{
    final doc = await _firestore.collection('Users').doc(uid).get();

    final theme = doc.data()? ['theme'];

    _themeData = theme=='light' ? lightMode : darkMode;

    notifyListeners();
  }

  Future<void> toggleTheme(String uid) async{
    _themeData = _themeData== lightMode? darkMode : lightMode;
    
    await _firestore.collection('Users').doc(uid).update({'theme': _themeData == lightMode ? 'light' : 'dark'});

    notifyListeners();
  }

  // set themeData (ThemeData themeData){
  //   _themeData = themeData;
  //   notifyListeners();// để báo cho tất cá các widget đang listen rằng state thay đổi, hãy rebuild đi
  // }
  //
  // void toggleTheme(){
  //   if(_themeData==lightMode){
  //     themeData = darkMode; //tương đương với themeData(darkMode)
  //   }
  //   else{
  //     themeData = lightMode;
  //   }
  // }
}