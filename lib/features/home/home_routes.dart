import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/home/tree_page.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_loading_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> homeRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const HomeRoot());
    case '/flower-tree-1':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'flower-1'));
    case '/flower-tree-2':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'flower-2'));
    case '/fruit-tree-1':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'fruit-1'));
    case '/fruit-tree-2':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'fruit-2'));
    // 로딩 페이지 라우트들
    case '/loading-flower-tree-1':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'flower-1'));
    case '/loading-flower-tree-2':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'flower-2'));
    case '/loading-fruit-tree-1':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'fruit-1'));
    case '/loading-fruit-tree-2':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'fruit-2'));
    default:
      return MaterialPageRoute(builder: (_) => const HomeRoot());
  }
}
