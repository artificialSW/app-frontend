// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common_card/chat_main_common_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_weekly_common/chat_weekly_common_question_dto.dart';

// 프로젝트 내부 (상대 경로)
import 'widget/personal_question_card.dart';
import 'widget/common_question_card.dart';
import 'widget/weekly_question_banner.dart';
import 'widget/tab_bar.dart';
import 'widget/custom_app_bar.dart';
import 'model/personal_question.dart';
import 'model/common_question.dart';
import 'chat_personal_send_logic/state/personal_question_send.dart';
import 'chat_thread/chat_common_thread.dart';
import 'chat_thread/chat_personal_thread.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});
  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot> {
  int _selectedIndex = 0; // 탭 인덱스 (0: 개인질문, 1: 공통질문)
  
  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();

  // 개인질문 관련 데이터
  String? _selectedPersonalId; // 선택된 개인질문 ID
  ChatMainPersonalResponseDto? _personalData; // API에서 받은 개인질문 데이터

  // 공통질문 관련 데이터
  String? _selectedCommonId; // 선택된 공통질문 ID
  List<ChatMainCommonQuestionCardDto>? _commonData; // API에서 받은 공통질문 목록
  ChatWeeklyCommonQuestionDto? _weeklyCommonData; // API에서 받은 이번주 공통질문 데이터

  @override
  void initState() {
    super.initState();
    // 페이지 로드 시 세 가지 API를 동시에 호출
    _loadPersonalData(); // 개인질문 목록 로드
    _loadCommonData(); // 공통질문 목록 로드
    _loadWeeklyCommonData(); // 이번주 공통질문 로드
  }

  /// 개인질문 목록을 API에서 가져오는 메서드
  /// API 호출이 실패하면 ChatService에서 자동으로 Mock 데이터를 반환
  Future<void> _loadPersonalData() async {
    try {
      final data = await _chatService.getChatMainPersonal();
      setState(() {
        _personalData = data; // 개인질문 데이터 저장
      });
    } catch (e) {
      print('개인질문 데이터 로드 실패: $e');
    }
  }

  /// 공통질문 목록을 API에서 가져오는 메서드
  /// API 호출이 실패하면 ChatService에서 자동으로 Mock 데이터를 반환
  Future<void> _loadCommonData() async {
    try {
      final data = await _chatService.getChatMainCommon();
      setState(() {
        _commonData = data; // 공통질문 목록 저장
      });
    } catch (e) {
      print('공통질문 데이터 로드 실패: $e');
    }
  }

  /// 이번주 공통질문을 API에서 가져오는 메서드
  /// API 호출이 실패하면 ChatService에서 자동으로 Mock 데이터를 반환
  Future<void> _loadWeeklyCommonData() async {
    try {
      final data = await _chatService.getWeeklyCommonQuestion();
      setState(() {
        _weeklyCommonData = data; // 이번주 공통질문 데이터 저장
      });
    } catch (e) {
      print('이번주 공통질문 데이터 로드 실패: $e');
    }
  }

  /// AppBar의 초록색 배지에 표시할 미답변 질문 개수를 반환하는 메서드
  /// API에서 받은 unsolved 값을 사용하며, 데이터가 없으면 0을 반환
  int _getIncomingQuestionsCount() {
    return _personalData?.unsolved ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatCustomAppBar(incomingQuestionsCount: _getIncomingQuestionsCount()),
      body: Column(
        children: [
          if (_weeklyCommonData != null)
            WeeklyQuestionBanner(
              question: CommonQuestion(
                id: _weeklyCommonData!.questionId.toString(),
                title: '이번주의 공통질문',
                description: _weeklyCommonData!.questionContent,
                likes: _weeklyCommonData!.likes,
                comments: _weeklyCommonData!.posts,
                isLiked: false, // 이번주 공통질문은 기본적으로 좋아요 안 누른 상태
              ),
              order: (_commonData?.length ?? 0) + 1,
            ),
          ChatTabBar(
            selectedIndex: _selectedIndex,
            onTabChanged: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
              child: _selectedIndex == 0 ? _buildPersonalQuestions() : _buildCommonQuestions()
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/personal-question'),
        backgroundColor: AppColors.plumu_gray_4,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  /// 개인질문 목록을 렌더링하는 위젯
  /// API에서 받은 DTO를 UI 컴포넌트가 사용하는 Entity 형태로 변환
  Widget _buildPersonalQuestions() {
    if (_personalData == null) {
      return const Center(child: CircularProgressIndicator()); // 로딩 중
    }
    
    if (_personalData!.questions.isEmpty) {
      return const Center(child: Text('질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!', textAlign: TextAlign.center));
    }
    
    return ListView.builder(
      itemCount: _personalData!.questions.length,
      itemBuilder: (_, i) {
        final question = _personalData!.questions[i];
        
        // API DTO를 UI Entity로 변환
        // PersonalQuestionCard는 PersonalQuestionEntity 타입을 기대합니다.
        final entity = PersonalQuestionEntity(
          id: question.questionId.toString(), // 질문 ID
          askerUserId: question.sender.toString(), // 질문자 ID
          responderUserId: question.receiver.toString(), // 답변자 ID
          text: question.content, // 질문 내용
          visibility: question.isPublic ? VisibilityType.public : VisibilityType.private, // 공개/비공개
          createdAt: DateTime.parse(question.createdAt), // 생성일시
          isLiked: question.isLiked, // 좋아요 상태
        );
        
        return PersonalQuestionCard(
          question: entity, // 변환된 Entity 전달
          initialLikes: question.likes, // API에서 받은 좋아요 수
          commentsCount: question.comments, // API에서 받은 댓글 수
          selected: _selectedPersonalId == entity.id, // 선택 상태
          onTap: () {
            setState(() => _selectedPersonalId = entity.id); // 선택 상태 업데이트
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatPersonalThreadPage(questionId: entity.id), // 상세 페이지로 이동
            ));
          },
        );
      },
    );
  }

  /// 공통질문 목록을 렌더링하는 위젯
  /// API에서 받은 DTO를 UI 컴포넌트가 사용하는 CommonQuestion 형태로 변환
  Widget _buildCommonQuestions() {
    if (_commonData == null) {
      return const Center(child: CircularProgressIndicator()); // 로딩 중
    }
    
    if (_commonData!.isEmpty) {
      return const Center(child: Text('공통질문이 없어요.\n이번주의 공통질문을 확인해보세요!', textAlign: TextAlign.center));
    }
    
    return ListView.builder(
      itemCount: _commonData!.length,
      itemBuilder: (_, i) {
        final question = _commonData![i];
        
        // API DTO를 UI CommonQuestion으로 변환
        // CommonQuestionCard는 CommonQuestion 타입을 기대합니다.
        final commonQuestion = CommonQuestion(
          id: question.questionId.toString(), // 질문 ID
          title: '공통질문 ${_commonData!.length - i}', // 질문 순서 (역순으로 표시)
          description: question.content, // 질문 내용
          likes: question.likes, // API에서 받은 좋아요 수
          comments: question.comments, // API에서 받은 댓글 수
          isLiked: question.isLiked, // 좋아요 상태
        );
        
        return CommonQuestionCard(
          question: commonQuestion, // 변환된 CommonQuestion 전달
          selected: _selectedCommonId == commonQuestion.id, // 선택 상태
          onTap: () {
            setState(() => _selectedCommonId = commonQuestion.id); // 선택 상태 업데이트
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatCommonThreadPage(
                questionId: commonQuestion.id, 
                order: _commonData!.length - i // 질문 순서 전달
              ),
            ));
          },
        );
      },
    );
  }
}


