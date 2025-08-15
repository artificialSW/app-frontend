// lib/features/chat/chat_page.dart
import 'package:flutter/material.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});

  @override
  State<ChatRoot> createState() => _ChatRootState();
}

/// 디자인 튜닝 포인트(캡처와 동일감 유지용 상수)
class _Spec {
  // 상단 배너 색감 (옅은 파랑 배경 + 파랑 테두리/텍스트)
  static const bannerBg = Color(0xFFEFF5FF);   // 아주 옅은 파랑
  static const bannerBorder = Color(0xFF5B8CFF); // 파랑 테두리
  static const bannerText = Color(0xFF3A73FF);   // 파랑 텍스트

  // 앱바 아이콘 배지 색
  static const badgeBg = Color(0xFF3A73FF);
  static const badgeText = Colors.white;

  // 탭/텍스트 색
  static const tabSelected = Colors.black87;
  static const tabUnselected = Color(0xFF8E8E93); // iOS 그레이 느낌
  static const divider = Color(0xFFE6E6E6);

  // 간격/크기
  static const screenHPad = 14.0;
  static const bannerRadius = 12.0;
  static const bannerPadV = 12.0;
  static const bannerPadH = 12.0;
  static const appbarTitleSize = 18.0;
  static const tabIndicatorThickness = 2.0;
}

class _ChatRootState extends State<ChatRoot> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  Future<void> _goCreate() async {
    final result = await Navigator.of(context).pushNamed('/chat/create');
    if (!mounted) return;
    if (result is String && result.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('“${result.trim()}”이(가) 생성되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 바텀바가 있는 Shell이라 하단 여백 살짝 확보
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          '소통방',
          style: TextStyle(
            fontSize: _Spec.appbarTitleSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: const [
          _BadgeIconButton(count: 5), // 캡처와 동일하게 5로 샘플
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // 🎉 이번주의 공동질문 배너
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _Spec.screenHPad),
            child: _WeeklyBanner(
              text: '🎉 이번주의 공동질문',
              onTap: () {
                // TODO: 공동질문 상세 이동
              },
            ),
          ),
          const SizedBox(height: 16),
          // 탭바 (개인질문 / 공동질문)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tab,
                labelPadding: const EdgeInsets.symmetric(horizontal: 16),
                isScrollable: false,
                labelColor: _Spec.tabSelected,
                unselectedLabelColor: _Spec.tabUnselected,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                indicatorColor: Colors.black87,
                indicatorWeight: _Spec.tabIndicatorThickness,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: const [
                  Tab(text: '개인질문'),
                  Tab(text: '공동질문'),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: _Spec.divider),

          // 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const BouncingScrollPhysics(),
              children: const [
                _EmptyState(),
                _EmptyState(),
              ],
            ),
          ),
          SizedBox(height: bottomInset), // 하단 바와 간섭 방지용
        ],
      ),

      // 오른쪽 아래 동그란 회색 + 아이콘(캡처 느낌)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFF0F0F0),
        elevation: 3,
        onPressed: _goCreate,
        child: const Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}

// ===== 위젯들 =====

class _WeeklyBanner extends StatelessWidget {
  const _WeeklyBanner({required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _Spec.bannerBg,
      borderRadius: BorderRadius.circular(_Spec.bannerRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_Spec.bannerRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: _Spec.bannerPadH,
            vertical: _Spec.bannerPadV,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_Spec.bannerRadius),
            border: Border.all(color: _Spec.bannerBorder, width: 1.25),
          ),
          alignment: Alignment.centerLeft,
          child: const Text(
            '🎉 이번주의 공동질문',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _Spec.bannerText,
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  const _BadgeIconButton({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () {
              // TODO: 알림/보낸함 이동
            },
            icon: const Icon(Icons.send_rounded),
            tooltip: '알림',
          ),
          if (count > 0)
            Positioned(
              right: 4,
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: _Spec.badgeBg,
                  borderRadius: BorderRadius.circular(9),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: _Spec.badgeText,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('(빈 페이지 문구)',
              style: base.copyWith(color: Colors.black54, height: 1.35)),
          const SizedBox(height: 8),
          const Text(
            '질문이 없어요. 가족에게 궁금했던 점\n을 질문해보세요~',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, height: 1.35),
          ),
        ],
      ),
    );
  }
}
