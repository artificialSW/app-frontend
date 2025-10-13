// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_home_thisweek/chat_home_thisweek_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common_card/chat_main_common_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_response_dto.dart';

// 프로젝트 내부 (상대 경로)
import 'widget/personal_question_card.dart';
import 'widget/common_question_card.dart';
import 'widget/weekly_question_banner.dart';
import 'widget/tab_bar.dart';
import 'widget/custom_app_bar.dart';
import 'model/personal_question.dart';
import 'model/common_question.dart';
import 'chat_thread/chat_common_thread.dart';
import 'chat_personal_send_logic/state/personal_question_send.dart';
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
  List<ChatMainPersonalQuestionCardDto>? _personalData; // API에서 받은 개인질문 목록
  DateTime? _personalDataLastUpdated;
  bool _isPersonalLoading = false;
  
  // 공통질문 관련 데이터
  String? _selectedCommonId; // 선택된 공통질문 ID
  List<ChatMainCommonQuestionCardDto>? _commonData; // API에서 받은 공통질문 목록
  DateTime? _commonDataLastUpdated;
  bool _isCommonLoading = false;
  
  // 이번주 공통질문 데이터 (상단 배너)
  ChatHomeThisweekResponseDto? _weeklyData; // API에서 받은 이번주 공통질문 데이터
  bool _isWeeklyLoading = false;
  
  // 가족 구성원 정보 (역할명 변환용)
  Map<int, String> _familyMemberMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 생명주기 관찰 시작
    // 주간 업데이트 확인 후 데이터 로드
    _checkAndUpdateWeeklyQuestion().then((_) {
      _loadAllData();
    });
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
      _loadWeeklyData(forceRefresh: forceRefresh),
      _loadFamilyMembers(), // 가족 구성원 정보 로드
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
  
  /// 주간 공통질문 업데이트 확인 및 실행
  /// 월요일 00시 기준으로 새로운 주가 시작되었는지 확인하고
  /// 필요시 업데이트 API 호출
  Future<void> _checkAndUpdateWeeklyQuestion() async {
    final now = DateTime.now();
    final currentWeekStart = _getWeekStart(now);
    
    // 현재 시간이 월요일 00시 이후인지 확인
    if (_shouldUpdateWeeklyQuestion(currentWeekStart)) {
      try {
        print('[ChatMainPage] 새로운 주 시작 감지, 주간 질문 업데이트 중...');
        await _chatService.updateWeeklyQuestion();
        print('[ChatMainPage] 주간 질문 업데이트 완료');
      } catch (e) {
        print('[ChatMainPage] 주간 질문 업데이트 실패: $e');
        // 실패해도 앱은 정상 동작하도록 계속 진행
      }
    }
  }
  
  /// 주간 질문 업데이트가 필요한지 확인
  /// 월요일 00시 이후이고, 이번 주 첫 실행인 경우 true 반환
  bool _shouldUpdateWeeklyQuestion(DateTime currentWeekStart) {
    final now = DateTime.now();
    final weekday = now.weekday;
    final hour = now.hour;
    
    // 월요일이고 00시 이후인 경우
    if (weekday == 1 && hour >= 0) {
      // 실제로는 더 정교한 로직이 필요할 수 있음 (예: 마지막 업데이트 시간 비교)
      // 현재는 단순히 월요일 00시 이후면 업데이트 실행
      return true;
    }
    
    return false;
  }
  
  /// 주의 시작일 (월요일)을 반환
  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    final daysToMonday = weekday == 1 ? 0 : weekday - 1;
    return DateTime(date.year, date.month, date.day - daysToMonday);
  }
  
  /// 이번주 공통질문 데이터 로드 (상단 배너)
  Future<void> _loadWeeklyData({bool forceRefresh = false}) async {
    if (!forceRefresh && _weeklyData != null) return;
    
    setState(() => _isWeeklyLoading = true);
    
    try {
      _weeklyData = await _chatService.getChatHomeThisweek();
    } catch (e) {
      print('이번주 공통질문 데이터 로드 실패: $e');
    } finally {
      setState(() => _isWeeklyLoading = false);
    }
  }
  
  /// 가족 구성원 정보 로드
  Future<void> _loadFamilyMembers() async {
    if (_familyMemberMap.isNotEmpty) return;
    
    try {
      final familyMembers = await _chatService.getFamilyMembers();
      _familyMemberMap = {
        for (var member in familyMembers) member.id: member.role
      };
    } catch (e) {
      print('가족 구성원 정보 로드 실패: $e');
    }
  }
  
  /// 영어 역할을 한국어로 변환
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
  
  /// 사용자 ID로 역할명 가져오기
  String _getSenderName(int senderId) {
    final role = _familyMemberMap[senderId];
    if (role == null) return '$senderId번째';
    return _getRoleInKorean(role);
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
    return _weeklyData?.unsolved ?? 0;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatCustomAppBar(incomingQuestionsCount: _getIncomingQuestionsCount()),
      body: Column(
        children: [
          if (_weeklyData != null)
          GestureDetector(
            onTap: () => _showWeeklyQuestionDialog(),
            child: WeeklyQuestionBanner(
              question: CommonQuestion(
                id: _weeklyData!.questionRefId.toString(),
                title: '이번주의 공통질문',
                description: _weeklyData!.questions,
                likes: 0,
                comments: _weeklyData!.comments.length,
                isLiked: false,
              ),
              order: (_commonData?.length ?? 0) + 1,
              onTapThread: () {
                // 스레드 화면으로 이동
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ChatCommonThreadPage(
                    questionId: _weeklyData!.questionRefId.toString(),
                    order: (_commonData?.length ?? 0) + 1
                  ),
                ));
              },
            ),
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
                  await _loadFamilyMembers(); // 가족 구성원 정보도 새로고침
                } else {
                  await _loadCommonData(forceRefresh: true);
                  // 공통질문 탭일 때는 상단 배너 데이터도 새로고침
                  await _loadWeeklyData(forceRefresh: true);
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
    
    if (_personalData == null || _personalData!.isEmpty) {
      return const Center(child: Text('질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!', textAlign: TextAlign.center));
    }
    
    return ListView.builder(
      itemCount: _personalData!.length,
      itemBuilder: (_, i) {
        final question = _personalData![i];
        
        // API DTO를 UI Entity로 변환
        final entity = PersonalQuestionEntity(
          id: question.questionRefId.toString(),
            askerUserId: _getSenderName(question.sender), // 역할명으로 변환
            responderUserId: _getSenderName(question.receiver), // 역할명으로 변환
          text: question.content,
          visibility: question.visibility == 1 ? VisibilityType.public : VisibilityType.private,
          createdAt: DateTime.now(), // createdAt은 백엔드에서 제거됨
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
          id: question.questionRefId.toString(),
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

  /// 이번주 공통질문 다이얼로그 표시
  void _showWeeklyQuestionDialog() {
    if (_weeklyData == null) return;

    final TextEditingController answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          '이번주의 공통질문',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 질문 내용
              Text(
                _weeklyData!.questions,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              
              // 다른 사람들의 답변
              if (_weeklyData!.comments.isNotEmpty) ...[
                const Text(
                  '다른 가족들의 답변',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                ...(_weeklyData!.comments.map((comment) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${comment.writer}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          comment.contents,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ))),
                const SizedBox(height: 20),
              ],
              
              // 답변 입력 필드
              TextField(
                controller: answerController,
                decoration: const InputDecoration(
                  hintText: '답변을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final answer = answerController.text.trim();
              if (answer.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('답변을 입력해주세요')),
                );
                return;
              }
              
              // chat_reply_dto 사용하여 답변 전송
              await _submitWeeklyAnswer(answer);
              Navigator.pop(context);
            },
            child: const Text('답변하기'),
          ),
        ],
      ),
    );
  }

  /// 이번주 공통질문에 답변 제출
  Future<void> _submitWeeklyAnswer(String answer) async {
    try {
      final request = ChatReplyRequestDto(
        questionRefId: _weeklyData!.questionRefId,
        content: answer,
        replyTo: null, // 1차 답변
      );
      
      await _chatService.postChatReply(request);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변이 등록되었습니다')),
      );
      
      // 답변 후 데이터 새로고침
      await _loadWeeklyData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('답변 등록에 실패했습니다')),
      );
    }
  }
}


