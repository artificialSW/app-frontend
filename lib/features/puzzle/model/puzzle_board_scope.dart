// lib/features/puzzle/widgets/puzzle_board_scope.dart
import 'package:flutter/widgets.dart';

class PuzzleBoardScope extends InheritedWidget {
  final double boardWidth;
  final double boardHeight;
  final double trayTop;
  final double trayHeight;

  const PuzzleBoardScope({
    super.key,
    required this.boardWidth,
    required this.boardHeight,
    required this.trayTop,
    required this.trayHeight,
    required Widget child,
  }) : super(child: child);

  static PuzzleBoardScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<PuzzleBoardScope>();
    assert(scope != null, 'PuzzleBoardScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(PuzzleBoardScope old) =>
      boardWidth  != old.boardWidth  ||
          boardHeight != old.boardHeight ||
          trayTop     != old.trayTop     ||
          trayHeight  != old.trayHeight;
}
