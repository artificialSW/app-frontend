import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/tree_page.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/tree_loading_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> homeRoutes(RouteSettings s) {
  switch (s.name) {
    // 홈 메인 화면
    case '/':
      return MaterialPageRoute(builder: (_) => const HomeRoot());
    
    // 각 나무 페이지들 (홈에서 나무 클릭 시 이동하는 페이지들)
    case '/flower-tree-1':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'flower-1'));
    case '/flower-tree-2':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'flower-2'));
    case '/fruit-tree-1':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'fruit-1'));
    case '/fruit-tree-2':
      return MaterialPageRoute(builder: (_) => TreePage(treeType: 'fruit-2'));
    
    // 로딩 페이지 라우트들 (나무 페이지로 이동하기 전에 보여지는 로딩 화면들)
    case '/loading-flower-tree-1':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'flower-1'));
    case '/loading-flower-tree-2':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'flower-2'));
    case '/loading-fruit-tree-1':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'fruit-1'));
    case '/loading-fruit-tree-2':
      return MaterialPageRoute(builder: (_) => TreeLoadingPage(treeType: 'fruit-2'));
    
    // 알 수 없는 라우트의 경우 홈으로 이동
    default:
      return MaterialPageRoute(builder: (_) => const HomeRoot());
  }
}
