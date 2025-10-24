import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_answer/chat_personal_answer_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';
import 'steps/step_list.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

enum _Step { list, write, success }

class PersonalAnswerFlowPage extends StatefulWidget {
  const PersonalAnswerFlowPage({super.key});

  @override
  State<PersonalAnswerFlowPage> createState() => _PersonalAnswerFlowPageState();
}

class _PersonalAnswerFlowPageState extends State<PersonalAnswerFlowPage> with WidgetsBindingObserver {
  _Step step = _Step.list;
  ChatPersonalAnswerQuestionDto? _selectedQuestion;
  String answer = '';

  late final TextEditingController _answerController;
  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();
  
  // API에서 받아온 데이터를 저장하는 변수들
  List<ChatPersonalAnswerQuestionDto>? _questions; // 나에게 온 질문 목록
  DateTime? _questionsLastUpdated; // 질문 데이터 마지막 업데이트 시간
  Map<int, String> _familyMemberMap = {}; // 가족 구성원 ID -> 이름(role) 매핑
  bool _isLoading = true; // 로딩 상태 관리

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(text: answer);
    WidgetsBinding.instance.addObserver(this);
    _loadData();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      _answerController.dispose();
    } catch (e) {
      // 이미 dispose된 경우 무시
    }
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화될 때 데이터 새로고침
      _loadData(forceRefresh: true);
    }
  }

  /// API에서 데이터를 가져오는 메서드 (2분 캐싱 적용)
  /// 가족 구성원 정보와 나에게 온 질문 목록을 병렬로 로드
  /// API 호출이 실패하면 ChatService에서 자동으로 Mock 데이터를 반환
  Future<void> _loadData({bool forceRefresh = false}) async {
    // 강제 새로고침이 아니고 캐시가 유효하면 스킵
    if (!forceRefresh && _isQuestionsCacheValid()) return;
    
    setState(() => _isLoading = true);
    
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
        _questionsLastUpdated = DateTime.now(); // 업데이트 시간 저장
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
  
  /// 질문 데이터 캐시가 유효한지 확인 (2분 이내)
  bool _isQuestionsCacheValid() {
    if (_questions == null || _questionsLastUpdated == null) return false;
    return DateTime.now().difference(_questionsLastUpdated!).inMinutes < 2;
  }

  /// 가족 구성원 ID를 한국어 이름으로 변환하는 헬퍼 메서드
  /// API에서 받은 가족 구성원 정보를 사용하여 ID를 실제 이름(role)으로 변환
  /// 만약 매핑이 없으면 "X번째" 형태로 반환
  String _getSenderName(int senderId) {
    final role = _familyMemberMap[senderId];
    if (role == null) return '$senderId번째';
    return _getRoleInKorean(role);
  }

  /// 영어 role을 한국어로 변환하는 헬퍼 함수
  String _getRoleInKorean(String role) {
    switch (role.toLowerCase()) {
      case 'father':
        return '아빠';
      case 'mother':
        return '엄마';
      case 'grandfather':
        return '할아버지';
      case 'grandmother':
        return '할머니';
      case 'sibling':
        return '형제';
      case 'brother':
        return '형제';
      case 'sister':
        return '자매';
      case 'son':
        return '아들';
      case 'daughter':
        return '딸';
      default:
        return role; // 매핑이 없으면 원본 그대로 반환
    }
  }

  /// 성공 페이지에서 2초 후 자동으로 채팅 메인 페이지로 돌아가는 메서드
  void _scheduleReturnToChat() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return; // 위젯이 아직 마운트되어 있는지 확인
      
      try {
        // Navigator 스택이 비어있지 않은지 확인
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // 이전 페이지(채팅 메인)로 돌아가기
        } else {
          // 스택이 비어있으면 홈으로 이동
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      } catch (e) {
        // Navigator 오류 발생 시 로그만 출력하고 무시
        print('Navigator 오류: $e');
      }
    });
  }

  /// 답변을 전송하는 메서드
  /// API 호출 후 성공 페이지로 이동
  Future<void> _submitAnswer() async {
    if (_selectedQuestion == null || answer.trim().isEmpty) return;
    
    try {
      // 답변 전송 API 호출
      print('🚀 [답변 전송] API 호출 시작...');
      print('🚀 [답변 전송] 질문 ID: ${_selectedQuestion!.questionRefId}');
      print('🚀 [답변 전송] 답변 내용: ${answer.trim()}');
      
      final request = ChatReplyRequestDto(
        questionRefId: _selectedQuestion!.questionRefId,
        content: answer.trim(),
      );
      
      final response = await _chatService.postChatReply(request);
      
      print('✅ [답변 전송] API 호출 성공!');
      print('✅ [답변 전송] 응답: ${response.message}');
      
    } catch (e) {
      print('❌ [답변 전송] API 호출 실패: $e');
      
      // API 실패 시 Mock 데이터로 폴백 (시연용)
      print('🔄 [답변 전송] Mock 데이터로 폴백 처리');
      MockDataManager.answerMyQuestion(
        questionRefId: _selectedQuestion!.questionRefId,
        answer: answer.trim(),
      );
    }
    
    // 데이터 새로고침 (답변 완료된 질문 제거)
    await _loadData(forceRefresh: true);
    
    // Success 화면을 rootNavigator로 표시 (Shell 하단바 완전히 가림)
    final senderRole = _selectedQuestion?.senderRole ?? '';
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          body: StepAnswerSuccess(to: senderRole),
        ),
      ),
    );
    
    // 2초 후 자동으로 Success 화면 닫고 채팅 메인으로 돌아가기
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      
      try {
        // Success 화면 닫기 (rootNavigator)
        Navigator.of(context, rootNavigator: true).pop();
        // 답변 플로우 페이지도 닫기 (채팅 메인으로 돌아감)
        Navigator.of(context).pop();
      } catch (e) {
        print('Navigator 오류: $e');
      }
    });
  }

  /// 아직 답변하지 않은 질문의 개수를 계산하는 메서드
  /// AppBar의 초록색 배지에 표시되는 숫자를 위해 사용
  int _getUnsolvedCount() {
    if (_questions == null) return 0;
    return _questions!.length; // 나에게 온 질문 개수
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
          'id': dto.questionRefId.toString(), // 질문 ID
          'from': dto.senderRole, // 보낸 사람 이름 (한국어 role)
          'text': dto.content, // 질문 내용
          'isPublic': (dto.visibility == 1).toString(), // 공개/비공개 여부
        }).toList();
        
        body = RefreshIndicator(
          onRefresh: () async {
            // Pull-to-refresh 시 강제 새로고침
            await _loadData(forceRefresh: true);
          },
          child: StepAnswerList(
            questions: questionMaps,
            onSelect: (q) {
              // 사용자가 선택한 질문의 원본 DTO를 찾아서 저장
              final selectedDto = _questions!.firstWhere(
                (dto) => dto.questionRefId.toString() == q['id'],
              );
              setState(() {
                _selectedQuestion = selectedDto; // 선택된 질문 저장
                answer = ''; // 답변 텍스트 초기화
                _answerController.text = ''; // 텍스트 필드 초기화
                step = _Step.write; // 답변 작성 단계로 이동
              });
            },
          ),
        );
      }
    } else if (step == _Step.write) {
      body = StepAnswerWrite(
        question: _selectedQuestion?.content ?? '',
        controller: _answerController,
        onChanged: (v) => setState(() => answer = v),
      );
    } else {
      // _Step.success인 경우는 이미 위에서 early return하므로 여기서는 처리하지 않음
      body = const SizedBox.shrink();
    }

    final canNext = switch (step) {
      _Step.list => false,
      _Step.write => answer.trim().isNotEmpty,
      _Step.success => false,
    };

    return Scaffold(
      backgroundColor: Colors.white,
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
        // actions 제거 - DM방에서는 우측상단 초록색 원 표시 안함
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
      bottomNavigationBar: step == _Step.list || step == _Step.success // 목록 & Success 단계에서는 하단바 숨김
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: '답변하기',
                  onPressed: canNext ? _submitAnswer : null,
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
