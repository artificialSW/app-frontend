import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_home_thisweek/chat_home_thisweek_response_dto.dart';

class WeeklyQuestionBanner extends StatefulWidget {
  final ChatHomeThisweekResponseDto data;
  final int order;
  final Function(String answer)? onAnswerSubmit; // 답변 제출 콜백
  final VoidCallback? onTapThread; // 스레드 화면으로 이동하는 콜백

  const WeeklyQuestionBanner({
    super.key,
    required this.data,
    required this.order,
    this.onAnswerSubmit,
    this.onTapThread,
  });

  @override
  State<WeeklyQuestionBanner> createState() => _WeeklyQuestionBannerState();
}

class _WeeklyQuestionBannerState extends State<WeeklyQuestionBanner>
    with TickerProviderStateMixin {
  bool _expanded = false;
  String? _myLocalAnswer; // 로컬에서 입력한 내 답변 (탭 닫아도 유지)

  static const double _collapsedHeight = 56;
  static const double _expandedHeight = 339;
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
                      data: widget.data,
                      order: widget.order,
                      initialAnswer: _myLocalAnswer,
                      onAnswerChanged: (answer) {
                        setState(() => _myLocalAnswer = answer);
                      },
                      onAnswerSubmit: widget.onAnswerSubmit,
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
  final ChatHomeThisweekResponseDto data;
  final int order;
  final String? initialAnswer; // 부모에서 전달받은 초기 답변
  final Function(String? answer)? onAnswerChanged; // 답변 변경 시 부모에게 알림
  final Function(String answer)? onAnswerSubmit;

  const _ExpandedContent({
    required this.data,
    required this.order,
    this.initialAnswer,
    this.onAnswerChanged,
    this.onAnswerSubmit,
  });

  @override
  State<_ExpandedContent> createState() => _ExpandedContentState();
}

class _ExpandedContentState extends State<_ExpandedContent> {
  late String? _answerText = widget.initialAnswer; // 부모에서 전달받은 초기값
  bool _isEditing = false;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController();
  int _currentPage = 0; // 0: 내 카드/답변하기, 1~N: 가족 답변들

  // API에서 받아온 가족 답변들 (내 답변 제외, widget.data.comments 사용)
  List<Map<String, String>> get _familyAnswers {
    return widget.data.comments
        .where((comment) => comment.writer != 127) // 내 답변(127) 제외
        .map((comment) => {
          'name': comment.writerRole,    // 한국어 role (할아버지, 어머니 등)
          'content': comment.contents,   // 답변 내용
        })
        .toList();
  }

  // 내 답변 찾기 (API/Mock에서 온 내 답변)
  String? get _myApiAnswer {
    try {
      final myComment = widget.data.comments.firstWhere(
        (comment) => comment.writer == 127, // 내 답변 찾기
      );
      return myComment.contents;
    } catch (e) {
      return null; // 내 답변 없음
    }
  }

  // 공통 답변 카드 위젯
  Widget _answerCard({required String name, required String content}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.78).clamp(250.0, 340.0); // 화면의 78%, 최소 250, 최대 340
    
    return Container(
      width: cardWidth,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final answerCardWidth = (screenWidth * 0.78).clamp(250.0, 340.0); // 화면의 78%
    
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
                width: screenWidth * 0.96, // 화면의 96%
                height: 178.0,
                child: ClipRect(
                  child: Image.asset(
                    AppAssets.app_character,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
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
            widget.data.questions,
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
                    width: answerCardWidth,
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
                        if (text.isNotEmpty && widget.onAnswerSubmit != null) {
                          widget.onAnswerSubmit!(text); // 답변 제출 콜백 호출
                        }
                        setState(() {
                          _answerText = text.isEmpty ? null : text;
                          _isEditing = false;
                        });
                        // 부모에게 답변 변경 알림 (탭 닫아도 유지)
                        widget.onAnswerChanged?.call(_answerText);
                      },
                      onSubmitted: (_) {
                        final text = _controller.text.trim();
                        if (text.isNotEmpty && widget.onAnswerSubmit != null) {
                          widget.onAnswerSubmit!(text); // 답변 제출 콜백 호출
                        }
                        setState(() {
                          _answerText = text.isEmpty ? null : text;
                          _isEditing = false;
                        });
                        // 부모에게 답변 변경 알림 (탭 닫아도 유지)
                        widget.onAnswerChanged?.call(_answerText);
                      },
                    ),
                  )
                : _familyAnswers.isEmpty
                  // 답변이 없을 때: 답변하기 버튼만 표시 (PageView 없음)
                  ? GestureDetector(
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
                        width: answerCardWidth,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.white.withOpacity(0.55),
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
                  // 답변이 있을 때: PageView로 여러 답변 표시
                  : SizedBox(
                    width: answerCardWidth,
                    height: 40,
                    child: Stack(
                      children: [
                        // PageView: 답변하기/내 카드, 가족 답변들
                        PageView(
                          controller: _pageController,
                          onPageChanged: (i) => setState(() => _currentPage = i),
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // 내 답변 표시 (로컬 입력 또는 API에서 받아온 것)
                            if (_answerText != null || _myApiAnswer != null)
                              _answerCard(
                                name: '나',
                                content: _answerText ?? _myApiAnswer!, // 로컬 입력 우선, 없으면 API
                              )
                            else
                              // 내 답변 없으면 답변하기 버튼
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
                                    color: Colors.white.withOpacity(0.55),
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
                              ),
                            // 다른 가족 답변들 (내 답변 제외)
                            ..._familyAnswers.map((answer) => _answerCard(
                              name: answer['name']!,
                              content: answer['content']!,
                            )),
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
        // 인디케이터: 답변이 2개 이상일 때만 표시 (스와이프 가능할 때)
        if ((_answerText != null || _myApiAnswer != null ? 1 : 0) + _familyAnswers.length >= 2)
          Positioned(
            left: 0,
            right: 0,
            top: 197 + 40 + 12,
            child: _buildDynamicIndicator(),
          ),
      ],
    );
  }

  /// 인디케이터: 최대 4개 점, 스와이프 시 자연스럽게 이동
  Widget _buildDynamicIndicator() {
    final hasMyAnswer = _answerText != null || _myApiAnswer != null;
    final totalPages = (hasMyAnswer ? 1 : 0) + _familyAnswers.length;
    if (totalPages == 0) return const SizedBox.shrink();

    // 최대 4개 점으로 제한
    final maxDots = 4;
    final visibleDots = totalPages <= maxDots ? totalPages : maxDots;
    
    // 가시 윈도우 계산 (현재 페이지를 중심으로)
    int windowStart = _currentPage - (visibleDots ~/ 2);
    if (windowStart < 0) windowStart = 0;
    if (windowStart + visibleDots > totalPages) windowStart = totalPages - visibleDots;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(visibleDots, (i) {
        final pageIndex = windowStart + i;
        final isActive = pageIndex == _currentPage;
        final distance = (pageIndex - _currentPage).abs();
        
        // 크기와 투명도 계산 (더 부드러운 그라데이션)
        double size;
        double opacity;
        
        if (isActive) {
          size = 8.0;
            opacity = 1.0;
        } else if (distance == 1) {
            size = 6.5;
          opacity = 0.8;
        } else if (distance == 2) {
            size = 5.5;
          opacity = 0.6;
          } else {
          size = 5.0;
          opacity = 0.4;
        }
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(opacity),
            shape: BoxShape.circle,
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ] : null,
          ),
        );
      }),
    );
  }
}
