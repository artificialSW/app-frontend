import 'package:artificialsw_frontend/features/Profile/profile_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> profileRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ProfileRoot());
    default:
      return MaterialPageRoute(builder: (_) => const ProfileRoot());
  }
}
