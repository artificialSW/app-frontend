// lib/features/chat/question_create_write_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QW {
  // 피그마 색상
  static const progressTrack = Color(0xFFDEDEDE);
  static const progressFill  = Color(0xFF5CBD56); // 상단 초록 라인 & 활성 버튼
  static const bigTitle      = Color(0xFF1B1D1B);
  static const boxBorder     = Color(0xFFAAAAAA);
  static const hint          = Color(0xFFAAAAAA);
  static const counter       = Color(0xFFAAAAAA);
  static const nextDisabledBg= Color(0xFFF3F3F3);
  static const nextDisabledFg= Color(0xFF282828);
}

class QuestionCreateWritePage extends StatefulWidget {
  const QuestionCreateWritePage({
    super.key,
    required this.members,
    required this.privacy,
  });

  final List<String> members;   // 이전 단계에서 전달
  final String privacy;         // 'public' | 'private'

  @override
  State<QuestionCreateWritePage> createState() => _QuestionCreateWritePageState();
}

class _QuestionCreateWritePageState extends State<QuestionCreateWritePage> {
  final _text = TextEditingController();
  static const _maxLen = 150;

  bool get _canNext => _text.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _text.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_canNext) return;

    final result = {
      'members': widget.members,
      'privacy': widget.privacy,     // 'public' | 'private'
      'question': _text.text.trim(), // 최종 질문
    };

    // ✅ 성공 화면으로 이동 → 성공 화면이 pop(...)하면 그 결과를 상위로 다시 전달
    Navigator.of(context).pushNamed('/chat/create/success', arguments: result)
        .then((value) {
      if (!mounted) return;
      if (value != null) {
        Navigator.of(context).pop(value); // 2단계로 전달
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            fontSize: 17,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.50,
            letterSpacing: -0.46,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(16),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 0, 32, 8),
            child: _ThinBar(value: 1.0), // 스샷처럼 초록만 보이게 full
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
        children: [
          const Text(
            '질문을 작성해주세요',
            style: TextStyle(
              color: QW.bigTitle,
              fontSize: 27,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.19,
              letterSpacing: -0.32,
            ),
          ),
          const SizedBox(height: 24),

          // 테두리 1px, r=16 텍스트 박스(높이 고정) + 안쪽 카운터
          SizedBox(
            height: 267,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: QW.boxBorder, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                // 실제 입력창
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: TextField(
                    controller: _text,
                    minLines: 8,
                    maxLines: 8,
                    maxLength: _maxLen,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: const InputDecoration(
                      isCollapsed: true,
                      border: InputBorder.none,
                      hintText: '질문을 작성해주세요',
                      hintStyle: TextStyle(
                        color: QW.hint,
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                      counterText: '', // 기본 카운터 숨김 (우측 하단에 커스텀 표시)
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
                    ),
                  ),
                ),
                // 우하단 커스텀 카운터 (0/150)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Text(
                    '${_text.text.characters.length}/$_maxLen',
                    style: const TextStyle(
                      color: QW.counter,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.67,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 180),
        ],
      ),

      // 하단 고정 “다음” 버튼
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
                s.contains(MaterialState.disabled) ? QW.nextDisabledBg : QW.progressFill),
                foregroundColor: MaterialStateProperty.resolveWith((s) =>
                s.contains(MaterialState.disabled) ? QW.nextDisabledFg : Colors.white),
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ThinBar extends StatelessWidget {
  const _ThinBar({required this.value});
  final double value; // 0~1
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, c) {
      final w = c.maxWidth;
      return Stack(children: [
        Container(height: 3, width: w,
            decoration: BoxDecoration(color: QW.progressTrack, borderRadius: BorderRadius.circular(20))),
        Container(height: 3, width: w * value,
            decoration: BoxDecoration(color: QW.progressFill, borderRadius: BorderRadius.circular(20))),
      ]);
    });
  }
}
