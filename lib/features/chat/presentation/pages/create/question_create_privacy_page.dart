import 'package:flutter/material.dart';

class QP {
  static const onSurface = Color(0xFF171D1B);
  static const title = Color(0xFF1B1D1B);
  static const progressTrack = Color(0xFFDEDEDE);
  static const progressFill = Color(0xFF5CBD56); // 초록
  static const chipBorder = Color(0xFFAAAAAA);
  static const chipText = Color(0xFF35353F);
  static const nextDisabledBg = Color(0xFFF3F3F3);
  static const nextDisabledFg = Color(0xFF282828);
}

class QuestionCreatePrivacyPage extends StatefulWidget {
  const QuestionCreatePrivacyPage({super.key, required this.selectedMembers});
  final List<String> selectedMembers;

  @override
  State<QuestionCreatePrivacyPage> createState() => _QuestionCreatePrivacyPageState();
}

class _QuestionCreatePrivacyPageState extends State<QuestionCreatePrivacyPage> {
  String? _privacy; // 'public' | 'private'
  bool get _canNext => _privacy != null;

  void _onNext() {
    if (_privacy == null) return;
    Navigator.of(context).pushNamed(
      '/chat/create/write',
      arguments: {
        'members': widget.selectedMembers,
        'privacy': _privacy, // 'public' | 'private'
      },
    ).then((result) {
      if (!mounted) return;
      if (result != null) {
        // 3단계에서 “다음”을 누르면(question 포함) 최종 결과를 상위로 전달
        Navigator.of(context).pop(result);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '질문생성',
          style: TextStyle(
            color: Colors.black, fontSize: 17, fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700, height: 1.50, letterSpacing: -0.46,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: _ThinStepBar(value: 199 / 348), // 스샷 비율
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
        children: [
          const Text(
            '공개 여부를\n선택해주세요',
            style: TextStyle(
              color: QP.title, fontSize: 27, fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700, height: 1.33, letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 12, runSpacing: 12,
            children: [
              _OutlinePill(
                label: '공개',
                selected: _privacy == 'public',
                onTap: () => setState(() => _privacy = 'public'),
              ),
              _OutlinePill(
                label: '비공개',
                selected: _privacy == 'private',
                onTap: () => setState(() => _privacy = 'private'),
              ),
            ],
          ),
          const SizedBox(height: 180),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 8, 32, 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _canNext ? _onNext : null,
              style: ButtonStyle(
                elevation: const MaterialStatePropertyAll(0),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                backgroundColor: MaterialStateProperty.resolveWith((s) =>
                s.contains(MaterialState.disabled) ? QP.nextDisabledBg : QP.progressFill),
                foregroundColor: MaterialStateProperty.resolveWith((s) =>
                s.contains(MaterialState.disabled) ? QP.nextDisabledFg : Colors.white),
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  fontSize: 16, fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600, height: 1.25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThinStepBar extends StatelessWidget {
  const _ThinStepBar({required this.value});
  final double value;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final w = c.maxWidth;
      return Stack(children: [
        Container(height: 3, width: w,
            decoration: BoxDecoration(color: QP.progressTrack, borderRadius: BorderRadius.circular(20))),
        Container(height: 3, width: w * value,
            decoration: BoxDecoration(color: QP.progressFill, borderRadius: BorderRadius.circular(20))),
      ]);
    });
  }
}

class _OutlinePill extends StatelessWidget {
  const _OutlinePill({required this.label, required this.selected, required this.onTap});
  final String label; final bool selected; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? QP.progressFill.withOpacity(0.10) : Colors.white.withOpacity(0.80);
    final bd = selected ? QP.progressFill : QP.chipBorder;
    final fg = selected ? QP.progressFill : QP.chipText;

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: bd, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fg, fontSize: 17, fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600, height: 1.29, letterSpacing: -0.41,
            ),
          ),
        ),
      ),
    );
  }
}
