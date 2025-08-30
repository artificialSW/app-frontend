// lib/features/chat/question_create_page.dart
import 'package:flutter/material.dart';

class QuestionCreatePage extends StatefulWidget {
  const QuestionCreatePage({super.key});

  @override
  State<QuestionCreatePage> createState() => _QuestionCreatePageState();
}

/* 디자인 스펙(전역 상수) — 다른 위젯에서도 접근 가능 */
class QC {
  static const primary = Color(0xFF22C55E); // 진행바/활성 버튼 초록
  static const track = Color(0xFFE5E7EB);   // 진행 트랙
  static const titleColor = Color(0xFF171D1B);

  static const chipBorder = Color(0xFFDBDBDB);
  static const chipText = Color(0xFF2B2B2B);

  static const nextDisabledBg = Color(0xFFF5F5F5);
  static const nextDisabledFg = Color(0xFF9E9E9E);
}

class _QuestionCreatePageState extends State<QuestionCreatePage> {
  final _candidates = const ['아빠', '엄마', '할아버지', '할머니', '동생'];
  final Set<String> _selected = {};

  bool get _canNext => _selected.isNotEmpty;

  void _toggle(String label) {
    setState(() {
      _selected.contains(label) ? _selected.remove(label) : _selected.add(label);
    });
  }

  /// ✅ 1단계 → 2단계로 이동하고, 2단계 결과를 상위로 전달
  Future<void> _onNext() async {
    if (!_canNext) return;

    final result = await Navigator.of(context).pushNamed(
      '/chat/create/privacy',
      arguments: {'members': _selected.toList()},
    );

    if (!mounted) return;

    // 2단계에서 pop(...)으로 결과(Map)를 주면, 이 화면도 pop 하며 그대로 올려보냄
    if (result != null) {
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '질문생성',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',     // 없으면 시스템 폰트로 대체됨
            letterSpacing: 0.25,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: const _StepProgress(value: 0.33), // 1/3 단계
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        children: [
          const SizedBox(height: 8),
          const _BigTitle(text: '가족 구성원을\n선택해주세요'),
          const SizedBox(height: 28),

          // 라운드 아웃라인 캡슐 버튼 5개 (자동 줄바꿈)
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _candidates.map((label) {
              final selected = _selected.contains(label);
              return _OutlinePill(
                label: label,
                selected: selected,
                onTap: () => _toggle(label),
              );
            }).toList(),
          ),

          const SizedBox(height: 160),
        ],
      ),

      // 하단 고정 “다음” 버튼
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: EdgeInsets.only(bottom: bottom == 0 ? 8 : 0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _canNext ? _onNext : null,
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                backgroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) return QC.nextDisabledBg;
                  return QC.primary;
                }),
                foregroundColor: MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.disabled)) return QC.nextDisabledFg;
                  return Colors.white;
                }),
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 상단 얇은 진행바(회색 트랙 + 좌측에서 채워지는 초록)
class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.value});
  final double value; // 0.0 ~ 1.0

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return Stack(
            children: [
              Container(width: w, height: 2, color: QC.track), // 트랙
              Align( // 채워진 부분
                alignment: Alignment.centerLeft,
                child: Container(width: w * value, height: 2, color: QC.primary),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 큰 제목 — 두 줄, 굵은 검정
class _BigTitle extends StatelessWidget {
  const _BigTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: const TextStyle(
        color: QC.titleColor,
        fontSize: 24,
        height: 1.25,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
      ),
    );
  }
}

/// 라운드 아웃라인 캡슐 버튼 (선택 토글)
class _OutlinePill extends StatelessWidget {
  const _OutlinePill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? QC.primary.withOpacity(0.06) : Colors.white;
    final bd = selected ? QC.primary : QC.chipBorder;
    final fg = selected ? QC.primary : QC.chipText;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: bd, width: 1.1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }
}
