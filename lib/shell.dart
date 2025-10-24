import 'package:flutter/material.dart';

// 바텀바(디자인 전용)
import 'package:artificialsw_frontend/shared/widgets/custom_bottom_bar.dart';

// 각 탭(브랜치) 라우팅
import 'package:artificialsw_frontend/features/home/home_routes.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_routes.dart';
import 'package:artificialsw_frontend/features/chat/chat_routes.dart';
import 'package:artificialsw_frontend/features/profile/profile_routes.dart';
import 'package:artificialsw_frontend/features/home/tutorial_logic/tutorial_page.dart';

class Shell extends StatefulWidget {
  const Shell({super.key, this.initialIndex = 0});
  final int initialIndex; // 앱 진입 시 시작 탭 인덱스

  @override
  State<Shell> createState() => ShellState();
}

class ShellState extends State<Shell> {
  late int index;
  final keys = List.generate(4, (_) => GlobalKey<NavigatorState>());
  bool _helpShown = false;

  // 라우트 스택 변화 시 setState를 "다음 프레임"으로 지연 호출하기 위한 플래그
  bool _pendingRecalc = false;
  void _scheduleRecalc() {
    if (_pendingRecalc || !mounted) return;
    _pendingRecalc = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _pendingRecalc = false;
      setState(() {}); // canPop 재계산
    });
  }

  // 각 브랜치 스택 변화를 관찰해서 위 스케줄러 호출
  late final List<_StackObserver> _observers =
  List.generate(4, (_) => _StackObserver(_scheduleRecalc));

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_helpShown) return;

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args?['goToHelp'] == true) {
      _helpShown = true; // ✅ 한 번만 실행되게
      // 한 프레임 뒤에 push (Navigator가 준비된 이후)
      Future.microtask(() {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => TutorialPage()),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

  bool get _branchCanPop => keys[index].currentState?.canPop() ?? false;

  @override
  Widget build(BuildContext context) {
    // 현재 탭의 네비게이터가 pop 가능하면, Shell은 pop을 막고(내부에서 처리),
    // pop 불가(루트)면 Shell이 pop을 허용(앱 종료/상위로).
    final canPopShell = !_branchCanPop;

    return PopScope(
      canPop: canPopShell,
      onPopInvoked: (didPop) {
        // 시스템이 이미 pop 처리했으면 아무 것도 안 함 (predictive back 포함)
        if (didPop) return;

        // 여기로 왔다는 건 Shell이 pop을 막았다는 뜻 → 현재 브랜치에서 pop 시도
        final nav = keys[index].currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
        }
        // 루트면 다음 back에 Shell이 종료됨 (canPopShell=true로 재빌드되기 때문)
      },
      child: Scaffold(
        body: IndexedStack(
          index: index,
          children: [
            Navigator(
              key: keys[0],
              observers: [_observers[0]],
              onGenerateRoute: homeRoutes,
            ),
            Navigator(
              key: keys[1],
              observers: [_observers[1]],
              onGenerateRoute: puzzleRoutes,
            ),
            Navigator(
              key: keys[2],
              observers: [_observers[2]],
              onGenerateRoute: chatRoutes,
            ),
            Navigator(
              key: keys[3],
              observers: [_observers[3]],
              onGenerateRoute: profileRoutes,
            ),
          ],
        ),
        bottomNavigationBar: AppBottomBar(
          currentIndex: index,
          onTap: (i) {
            if (i == index) {
              // 같은 탭 재탭 → 해당 브랜치 루트로 복귀
              keys[i].currentState?.popUntil((r) => r.isFirst);
              // popUntil에 따른 스택 변화는 옵저버가 감지해서 _scheduleRecalc 호출
            } else {
              setState(() => index = i);
            }
          },
        ),
      ),
    );
  }
}

// 브랜치 네비게이터의 스택 변화(push/pop/replace/remove) 감지용 옵저버
class _StackObserver extends NavigatorObserver {
  _StackObserver(this._requestRebuild);
  final VoidCallback _requestRebuild;

  void _n() => _requestRebuild();

  @override
  void didPush(Route route, Route? previousRoute) => _n();
  @override
  void didPop(Route route, Route? previousRoute) => _n();
  @override
  void didRemove(Route route, Route? previousRoute) => _n();
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) => _n();
}
