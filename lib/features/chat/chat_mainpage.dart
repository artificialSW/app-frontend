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

class _ChatRootState extends State<ChatRoot> with WidgetsBindingObserver {
  int _selectedIndex = 0; // 탭 인덱스 (0: 개인질문, 1: 공통질문)
  
  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();
  
  // 개인질문 관련 데이터
  String? _selectedPersonalId; // 선택된 개인질문 ID
  ChatMainPersonalResponseDto? _personalData; // API에서 받은 개인질문 데이터
  DateTime? _personalDataLastUpdated;
  bool _isPersonalLoading = false;
  
  // 공통질문 관련 데이터
  String? _selectedCommonId; // 선택된 공통질문 ID
  List<ChatMainCommonQuestionCardDto>? _commonData; // API에서 받은 공통질문 목록
  DateTime? _commonDataLastUpdated;
  bool _isCommonLoading = false;
  
  // 이번주 공통질문 데이터
  ChatWeeklyCommonQuestionDto? _weeklyData; // API에서 받은 이번주 공통질문 데이터
  bool _isWeeklyLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 생명주기 관찰 시작
    // 페이지 로드 시 세 가지 API를 동시에 호출
    _loadAllData();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 관찰 종료
    super.dispose();
  }
  
  /// 앱이 포그라운드로 돌아올 때 자동 새로고침
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 다시 활성화되면 데이터 새로고침 (캐시 무시)
      _loadAllData(forceRefresh: true);
    }
  }

  /// 모든 데이터를 병렬로 로드
  Future<void> _loadAllData({bool forceRefresh = false}) async {
    await Future.wait([
      _loadPersonalData(forceRefresh: forceRefresh),
      _loadCommonData(forceRefresh: forceRefresh),
      _loadWeeklyData(),
    ]);
  }
  
  /// 개인질문 데이터 로드 (2분 캐싱)
  Future<void> _loadPersonalData({bool forceRefresh = false}) async {
    if (!forceRefresh && _isPersonalDataCacheValid()) return;
    
    setState(() => _isPersonalLoading = true);
    
    try {
      _personalData = await _chatService.getChatMainPersonal();
      _personalDataLastUpdated = DateTime.now();
    } catch (e) {
      print('개인질문 데이터 로드 실패: $e');
    } finally {
      setState(() => _isPersonalLoading = false);
    }
  }
  
  /// 공통질문 데이터 로드 (2분 캐싱)
  Future<void> _loadCommonData({bool forceRefresh = false}) async {
    if (!forceRefresh && _isCommonDataCacheValid()) return;
    
    setState(() => _isCommonLoading = true);
    
    try {
      _commonData = await _chatService.getChatMainCommon();
      _commonDataLastUpdated = DateTime.now();
    } catch (e) {
      print('공통질문 데이터 로드 실패: $e');
    } finally {
      setState(() => _isCommonLoading = false);
    }
  }
  
  /// 이번주 공통질문 데이터 로드
  Future<void> _loadWeeklyData() async {
    if (_weeklyData != null) return;
    
    setState(() => _isWeeklyLoading = true);
    
    try {
      _weeklyData = await _chatService.getWeeklyCommonQuestion();
    } catch (e) {
      print('이번주 공통질문 데이터 로드 실패: $e');
    } finally {
      setState(() => _isWeeklyLoading = false);
    }
  }
  
  /// 개인질문 캐시 유효성 검사 (2분 이내)
  bool _isPersonalDataCacheValid() {
    if (_personalData == null || _personalDataLastUpdated == null) return false;
    return DateTime.now().difference(_personalDataLastUpdated!).inMinutes < 2;
  }
  
  /// 공통질문 캐시 유효성 검사 (2분 이내)
  bool _isCommonDataCacheValid() {
    if (_commonData == null || _commonDataLastUpdated == null) return false;
    return DateTime.now().difference(_commonDataLastUpdated!).inMinutes < 2;
  }
  
  /// AppBar의 초록색 배지에 표시할 미답변 질문 개수
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
          if (_weeklyData != null)
          WeeklyQuestionBanner(
              question: CommonQuestion(
                id: _weeklyData!.questionId.toString(),
                title: '이번주의 공통질문',
                description: _weeklyData!.questionContent,
                likes: _weeklyData!.likes,
                comments: _weeklyData!.posts,
                isLiked: false, // 이번주 공통질문은 기본적으로 좋아요 안 누른 상태
              ),
              order: (_commonData?.length ?? 0) + 1,
          ),
          ChatTabBar(
            selectedIndex: _selectedIndex,
            onTabChanged: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Pull-to-refresh 시 해당 탭의 데이터만 새로고침
                if (_selectedIndex == 0) {
                  await _loadPersonalData(forceRefresh: true);
                } else {
                  await _loadCommonData(forceRefresh: true);
                }
              },
              child: _selectedIndex == 0 ? _buildPersonalQuestions() : _buildCommonQuestions(),
            ),
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
  Widget _buildPersonalQuestions() {
    if (_isPersonalLoading) {
      return const Center(child: CircularProgressIndicator()); // 로딩 중
    }
    
    if (_personalData == null || _personalData!.questions.isEmpty) {
      return const Center(child: Text('질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!', textAlign: TextAlign.center));
    }
    
    return ListView.builder(
      itemCount: _personalData!.questions.length,
      itemBuilder: (_, i) {
        final question = _personalData!.questions[i];
        
        // API DTO를 UI Entity로 변환
        final entity = PersonalQuestionEntity(
          id: question.questionId.toString(),
          askerUserId: question.sender.toString(),
          responderUserId: question.receiver.toString(),
          text: question.content,
          visibility: question.isPublic ? VisibilityType.public : VisibilityType.private,
          createdAt: DateTime.parse(question.createdAt),
          isLiked: question.isLiked,
        );
        
        return PersonalQuestionCard(
          question: entity,
          initialLikes: question.likes,
          commentsCount: question.comments,
          selected: _selectedPersonalId == entity.id,
          onTap: () {
            setState(() => _selectedPersonalId = entity.id);
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatPersonalThreadPage(questionId: entity.id),
            ));
          },
        );
      },
    );
  }

  /// 공통질문 목록을 렌더링하는 위젯
  Widget _buildCommonQuestions() {
    if (_isCommonLoading) {
      return const Center(child: CircularProgressIndicator()); // 로딩 중
    }
    
    if (_commonData == null || _commonData!.isEmpty) {
      return const Center(child: Text('공통질문이 없어요.\n이번주의 공통질문을 확인해보세요!', textAlign: TextAlign.center));
    }
    
    return ListView.builder(
      itemCount: _commonData!.length,
      itemBuilder: (_, i) {
        final question = _commonData![i];
        
        // API DTO를 UI CommonQuestion으로 변환
        final commonQuestion = CommonQuestion(
          id: question.questionId.toString(),
          title: '공통질문 ${_commonData!.length - i}',
          description: question.content,
          likes: question.likes,
          comments: question.comments,
          isLiked: question.isLiked,
        );
        
        return CommonQuestionCard(
          question: commonQuestion,
          selected: _selectedCommonId == commonQuestion.id,
          onTap: () {
            setState(() => _selectedCommonId = commonQuestion.id);
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatCommonThreadPage(
                questionId: commonQuestion.id, 
                order: _commonData!.length - i
              ),
            ));
          },
        );
      },
    );
  }
}


