import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_answer/chat_personal_answer_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'steps/step_list.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

enum _Step { list, write, success }

class PersonalAnswerFlowPage extends StatefulWidget {
  const PersonalAnswerFlowPage({super.key});

  @override
  State<PersonalAnswerFlowPage> createState() => _PersonalAnswerFlowPageState();
}

class _PersonalAnswerFlowPageState extends State<PersonalAnswerFlowPage> {
  _Step step = _Step.list;
  ChatPersonalAnswerQuestionDto? _selectedQuestion;
  String answer = '';

  late final TextEditingController _answerController;
  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();
  
  // API에서 받아온 데이터를 저장하는 변수들
  List<ChatPersonalAnswerQuestionDto>? _questions; // 나에게 온 질문 목록
  Map<int, String> _familyMemberMap = {}; // 가족 구성원 ID -> 이름(role) 매핑
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(text: answer);
    _loadData();
  }

  /// API에서 데이터를 가져오는 메서드
  /// 가족 구성원 정보와 나에게 온 질문 목록을 병렬로 로드
  /// API 호출이 실패하면 ChatService에서 자동으로 Mock 데이터를 반환
  Future<void> _loadData() async {
    try {
      // 두 개의 API를 동시에 호출하여 성능을 최적화
      final results = await Future.wait([
        _chatService.getFamilyMembers(), // 가족 구성원 목록 API
        _chatService.getChatMyQuestions(), // 나에게 온 질문 목록 API
      ]);
      
      // API 응답을 적절한 타입으로 캐스팅
      final familyMembers = results[0] as List<ChatFamilyMemberDto>;
      final questions = results[1] as List<ChatPersonalAnswerQuestionDto>;
      
      setState(() {
        // 가족 구성원 ID를 이름(role)으로 매핑하는 Map 생성
        // 예: {1: "아빠", 2: "엄마", 3: "할아버지"}
        _familyMemberMap = {
          for (var member in familyMembers) member.id: member.role
        };
        _questions = questions; // 질문 목록 저장
        _isLoading = false; // 로딩 완료
      });
    } catch (e) {
      // API 호출 실패 시 에러 로그 출력
      print('데이터 로드 실패: $e');
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  }

  /// 가족 구성원 ID를 이름으로 변환하는 헬퍼 메서드
  /// API에서 받은 가족 구성원 정보를 사용하여 ID를 실제 이름(role)으로 변환
  /// 만약 매핑이 없으면 "X번째" 형태로 반환
  String _getSenderName(int senderId) {
    return _familyMemberMap[senderId] ?? '$senderId번째';
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  /// 성공 페이지에서 1.2초 후 자동으로 채팅 메인 페이지로 돌아가는 메서드
  void _scheduleReturnToChat() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return; // 위젯이 아직 마운트되어 있는지 확인
      Navigator.of(context).pop(); // 이전 페이지(채팅 메인)로 돌아가기
    });
  }

  /// 아직 답변하지 않은 질문의 개수를 계산하는 메서드
  /// AppBar의 초록색 배지에 표시되는 숫자를 위해 사용
  int _getUnsolvedCount() {
    if (_questions == null) return 0;
    return _questions!.where((q) => !q.solved).length; // solved가 false인 질문만 카운트
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (step == _Step.list) {
      if (_isLoading) {
        body = const Center(child: CircularProgressIndicator());
      } else if (_questions == null || _questions!.isEmpty) {
        body = const Center(
          child: Text(
            '나에게 온 질문이 없어요!',
            textAlign: TextAlign.center,
          ),
        );
      } else {
        // API에서 받은 DTO를 기존 UI 컴포넌트와 호환되는 Map 형태로 변환
        // StepAnswerList는 Map<String, String> 형태의 데이터를 기대합니다.
        final questionMaps = _questions!.map((dto) => {
          'id': dto.questionId.toString(), // 질문 ID
          'from': _getSenderName(dto.sender), // 보낸 사람 이름 (ID -> 이름 변환)
          'text': dto.content, // 질문 내용
          'isPublic': dto.isPublic.toString(), // 공개/비공개 여부
        }).toList();
        
        body = StepAnswerList(
          questions: questionMaps,
          onSelect: (q) {
            // 사용자가 선택한 질문의 원본 DTO를 찾아서 저장
            final selectedDto = _questions!.firstWhere(
              (dto) => dto.questionId.toString() == q['id'],
            );
            setState(() {
              _selectedQuestion = selectedDto; // 선택된 질문 저장
              answer = ''; // 답변 텍스트 초기화
              _answerController.text = ''; // 텍스트 필드 초기화
              step = _Step.write; // 답변 작성 단계로 이동
            });
          },
        );
      }
    } else if (step == _Step.write) {
      body = StepAnswerWrite(
        question: _selectedQuestion?.content ?? '',
        controller: _answerController,
        onChanged: (v) => setState(() => answer = v),
      );
    } else {
      body = StepAnswerSuccess(to: _selectedQuestion != null ? _getSenderName(_selectedQuestion!.sender) : '');
      _scheduleReturnToChat();
    }

    final canNext = switch (step) {
      _Step.list => false,
      _Step.write => answer.trim().isNotEmpty,
      _Step.success => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나에게 온 질문',
          style: AppTextStyles.pretendard_bold.copyWith(
            fontSize: 17,
            color: AppColors.plumu_gray_7,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.plumu_white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.plumu_gray_7),
        actions: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.plumu_green_main,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${_getUnsolvedCount()}',
                style: AppTextStyles.pretendard_medium.copyWith(
                  fontSize: 9,
                  color: AppColors.plumu_white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
      bottomNavigationBar: step == _Step.list || step == _Step.success
          ? null
          : SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: '답변하기',
            onPressed: canNext ? () => setState(() => step = _Step.success) : null,
            width: double.infinity,
            height: 52,
            fontSize: 16,
            textColor: AppColors.plumu_white,
            backgroundColor: AppColors.plumu_green_main,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
