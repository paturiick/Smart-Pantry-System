import 'package:flutter/material.dart';
import 'package:smart_pantry/pages/add_item.dart';
import 'package:smart_pantry/pages/home_page.dart';
import 'package:smart_pantry/pages/splash_screen.dart';
import 'package:smart_pantry/routes/routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      AppRoutes.HOMEPAGE: (context) => HomePage(),
      AppRoutes.SPLASHSCREEN: (context) => SplashScreen(),
      AppRoutes.ADDITEM: (context) => AddItemPage(),
    };
  }
}
