import 'package:artificialsw_frontend/features/home/home_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> homeRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const HomeRoot());
    default:
      return MaterialPageRoute(builder: (_) => const HomeRoot());
  }
}
