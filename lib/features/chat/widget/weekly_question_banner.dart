import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import '../model/common_question.dart';

class WeeklyQuestionBanner extends StatefulWidget {
  final CommonQuestion question;
  final int order;
  final VoidCallback? onTapThread; // 스레드 화면으로 이동하는 콜백

  const WeeklyQuestionBanner({
    super.key,
    required this.question,
    required this.order,
    this.onTapThread,
  });

  @override
  State<WeeklyQuestionBanner> createState() => _WeeklyQuestionBannerState();
}

class _WeeklyQuestionBannerState extends State<WeeklyQuestionBanner>
    with TickerProviderStateMixin {
  bool _expanded = false;

  static const double _collapsedHeight = 56;
  static const double _expandedHeight = 348;
  static const double _expandedWidth = 373;

  void _toggle() => setState(() => _expanded = !_expanded);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          borderRadius: BorderRadius.circular(_expanded ? 54 : 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            width: double.infinity, // 폭은 항상 부모(패딩 포함) 너비 유지
            height: _expanded ? _expandedHeight : _collapsedHeight,
            decoration: BoxDecoration(
              // 같은 타입(BoxDecoration)로 유지해 보간 시 assertion 방지
              color: _expanded ? null : AppColors.plumu_green_30per,
              gradient: _expanded
                  ? const LinearGradient(
                      begin: Alignment(0.92, 0.09),
                      end: Alignment(0.10, 0.95),
                      // 더 연한 느낌: 30%와 25% 투명도
                      colors: [Color(0x4D5CBD56), Color(0x405CBD56)],
                    )
                  : null,
              borderRadius: BorderRadius.circular(_expanded ? 54 : 16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              // 내부에서도 동일한 radius를 유지해 시각적 일치
              child: _expanded
                  ? _ExpandedContent(
                      content: widget.question.description,
                      order: widget.order,
                    )
                  : _CollapsedContent(onTapThread: widget.onTapThread),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedContent extends StatelessWidget {
  final VoidCallback? onTapThread;

  const _CollapsedContent({this.onTapThread});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '이번주의 공통질문',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.pretendard_medium.copyWith(
                fontSize: 16,
                color: AppColors.plumu_green_main,
              ),
            ),
          ),
          // 작은 화살표 버튼
          if (onTapThread != null)
            GestureDetector(
              onTap: () {
                // 스레드 화면으로 이동
                onTapThread!();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.plumu_green_main,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExpandedContent extends StatefulWidget {
  final String content;
  final int order;

  const _ExpandedContent({required this.content, required this.order});

  @override
  State<_ExpandedContent> createState() => _ExpandedContentState();
}

class _ExpandedContentState extends State<_ExpandedContent> {
  String? _answerText;
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController();
  int _currentPage = 0; // 0: 내 카드/답변하기, 1: 엄마, 2: 아빠

  List<Map<String, String>> get _dummyFamilyAnswers => const [
        {'name': '엄마', 'content': '뜨개질, 커피'},
        {'name': '아빠', 'content': '낚시, 골프'},
        {'name': '할아버지', 'content': '장기, 산책'},
      ];

  // 공통 답변 카드 위젯
  Widget _answerCard({required String name, required String content}) {
    return Container(
      width: 290,
      height: 40,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.75),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x193A0D10),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 35, right: 48),
      child: Row(
        children: [
          Image.asset(AppAssets.person_circle, width: 24, height: 24),
          const SizedBox(width: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B1D1B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3B3D3B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _promptAnswer() async {
    final controller = TextEditingController(text: _answerText ?? '');
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('답변하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: '예: 야구 직관',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Text('완료'),
              ),
            ],
          ),
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() => _answerText = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 하단 병아리 캐릭터 이미지 — 비율 유지, 상단 178px만 보이도록 크롭 (항상 가장 아래에 렌더)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 357.7,
                height: 178.0,
                child: ClipRect(
                  child: Image.asset(
                    AppAssets.app_character,
                    fit: BoxFit.cover, // 비율 유지하며 채우기
                    alignment: Alignment.topCenter, // 위쪽 기준으로 크롭
                    width: 357.7,
                    height: 376.46,
                  ),
                ),
              ),
            ),
          ),
        ),
        // "이번주의 공통질문" — 좌측 45px
        const Positioned(
          left: 45,
          top: 28,
          child: SizedBox(
            width: 246.41,
            height: 20.23,
            child: Text(
              '이번주의 공통질문',
              style: TextStyle(
                color: Color(0xFF5CBD56),
                fontSize: 20,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
        ),
        // "N번째 질문" 뱃지 — 그 아래
        Positioned(
          left: 45,
          top: 60,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            constraints: const BoxConstraints(minHeight: 24),
            decoration: ShapeDecoration(
              color: const Color(0xFF5CBD56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(13.64)),
              ),
            ),
            child: Text(
              '${widget.order}번째 질문',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ),
        ),
        // 메인 질문 텍스트 — 그 아래
        Positioned(
          left: 45,
          top: 110,
          right: 24,
          child: Text(
            widget.content,
            style: const TextStyle(
              color: Color(0xFF1B1D1B),
              fontSize: 24.42,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.33,
            ),
          ),
        ),
        // 답변하기 버튼 또는 입력 결과 표시 (가운데)
        Positioned(
          left: 0,
          right: 0,
          top: 197,
          child: Center(
            child: _isEditing
                ? Container(
                    width: 290,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x193A0D10),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF3B3D3B),
                      ),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        final text = _controller.text.trim();
                        setState(() {
                          _answerText = text.isEmpty ? null : text;
                          _isEditing = false;
                        });
                      },
                      onSubmitted: (_) {
                        final text = _controller.text.trim();
                        setState(() {
                          _answerText = text.isEmpty ? null : text;
                          _isEditing = false;
                        });
                      },
                    ),
                  )
                : SizedBox(
                    width: 290,
                    height: 40,
                    child: Stack(
                      children: [
                        // PageView: 답변하기/내 카드, 엄마, 아빠
                        PageView(
                          controller: _pageController,
                          onPageChanged: (i) => setState(() => _currentPage = i),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // 내 카드 또는 답변하기 버튼
                            if (_answerText == null)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEditing = true;
                                    _controller.text = '';
                                  });
                                  Future.delayed(const Duration(milliseconds: 10), () {
                                    if (mounted) _focusNode.requestFocus();
                                  });
                                },
                                child: Container(
                                  decoration: ShapeDecoration(
                                    color: Colors.white.withOpacity(0.55), // 버튼 박스도 살짝 더 진하게
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x193A0D10),
                                        blurRadius: 20,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '답변하기',
                                    style: TextStyle(
                                      color: Color(0xFF3B3D3B),
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                      height: 1.25,
                                    ),
                                  ),
                                ),
                              )
                            else
                              _answerCard(name: '나', content: _answerText!),
                            // 엄마/아빠 더미
                            _answerCard(
                              name: _dummyFamilyAnswers[0]['name']!,
                              content: _dummyFamilyAnswers[0]['content']!,
                            ),
                            _answerCard(
                              name: _dummyFamilyAnswers[1]['name']!,
                              content: _dummyFamilyAnswers[1]['content']!,
                            ),
                            // 추가: 할아버지
                            _answerCard(
                              name: _dummyFamilyAnswers[2]['name']!,
                              content: _dummyFamilyAnswers[2]['content']!,
                            ),
                          ],
                        ),
                        // 왼쪽 페이드
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 오른쪽 페이드
                        Positioned(
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: IgnorePointer(
                            child: Container(
                              width: 12,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        // 인디케이터(항상 3개), 답변 박스 하단 중앙에 노출
        Positioned(
          left: 0,
          right: 0,
          top: 197 + 40 + 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              final int groupIndex = _currentPage.clamp(0, 2); // 0: 첫 페이지, 1: 중간, 2: 마지막 그룹(3+ 페이지도 2로 고정)
              final isActive = i == groupIndex;
              final double size = isActive ? 8 : 6;
              return Container(
                width: size,
                height: size,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive ? Colors.black : const Color(0xFFBDBDBD), // 검정/회색
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
