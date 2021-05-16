import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'home/contact_page.dart';
import 'home/home_page.dart';



void main() {
  runApp(MaterialApp(
    localizationsDelegates: [
      GlobalWidgetsLocalizations.delegate,
      GlobalMaterialLocalizations.delegate
    ],
    supportedLocales: [
      Locale("pt", "BR")
    ],
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
