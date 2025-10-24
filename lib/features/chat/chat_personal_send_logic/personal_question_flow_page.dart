import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'state/personal_question_send.dart';
import 'steps/step_family.dart';
import 'steps/step_visibility.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';

class PersonalQuestionFlowPage extends StatefulWidget {
  const PersonalQuestionFlowPage({super.key});

  @override
  State<PersonalQuestionFlowPage> createState() => _FlowState();
}

class _FlowState extends State<PersonalQuestionFlowPage> {
  final _state = PersonalQuestionState();
  final ChatService _chatService = ChatService();
  int step = 0;

  late final TextEditingController _questionController;

  List<ChatFamilyMemberDto> _familyMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: _state.question);
    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {
    try {
      final members = await _chatService.getFamilyMembers();
      setState(() {
        _familyMembers = members;
        _isLoading = false;
      });
    } catch (e) {
      print('가족 구성원 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitQuestion() async {
    if (_state.target == null || _state.visibility == null || _state.question.trim().isEmpty) {
      return;
    }

    try {
      final request = ChatQuestionCreateRequestDto(
        receiverId: _state.target!.id,
        visibility: _state.visibility == VisibilityType.public ? 1 : 0,
        content: _state.question.trim(),
      );

      final response = await _chatService.createQuestion(request);
      
      if (response.isSuccess) {
        // Success 화면을 rootNavigator로 표시 (Shell 하단바 완전히 가림)
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.white,
              body: const StepSuccess(),
            ),
          ),
        );
        
        // 2초 후 자동으로 Success 화면 닫고 채팅 메인으로 돌아가기
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (!mounted) return;
          
          try {
            // Success 화면 닫기 (rootNavigator)
            Navigator.of(context, rootNavigator: true).pop();
            // 질문 생성 페이지도 닫기 (채팅 메인으로 돌아감)
            Navigator.of(context).pop();
          } catch (e) {
            print('Navigator 오류: $e');
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? '질문 전송에 실패했습니다.')),
        );
      }
    } catch (e) {
      print('질문 전송 실패: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('질문 전송에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _scheduleReturnToChat() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 단계별 본문
    Widget body;
    if (step == 0) {
      if (_isLoading) {
        body = const Center(child: CircularProgressIndicator());
      } else if (_familyMembers.isEmpty) {
        body = const Center(child: Text('가족 구성원을 불러올 수 없습니다.'));
      } else {
        // ChatFamilyMemberDto를 User로 변환 (기존 StepFamily와 호환)
        final members = _familyMembers.map((dto) => User(
          id: dto.id,
          name: dto.role, // API에서 이미 한국어로 받아옴 (아버지, 어머니 등)
          role: dto.role, // 한국어 role 그대로 사용
        )).toList();
        
        body = StepFamily(
          members: members,
          selected: _state.target,
          onSelect: (m) => setState(() => _state.target = m),
        );
      }
    } else if (step == 1) {
      body = StepVisibility(
        selected: _state.visibility,
        onSelect: (v) => setState(() => _state.visibility = v),
      );
    } else if (step == 2) {
      body = StepWrite(
        controller: _questionController,
        onChanged: (t) => setState(() => _state.question = t),
      );
    } else {
      // step == 3인 경우는 이미 위에서 early return하므로 여기서는 처리하지 않음
      body = const SizedBox.shrink();
    }

    // 다음 버튼 활성 조건
    final canNext = switch (step) {
      0 => _state.target != null,
      1 => _state.visibility != null,
      2 => _state.question.trim().isNotEmpty,
      _ => false,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, // ✅ 키보드 올라올 때 화면 안올라감
      extendBody: true, // 하단바 영역까지 body 확장
      appBar: CreateQuestionTopBar(step),
      body: body,
      bottomNavigationBar: null, // 하단바 완전히 제거
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16),
        child: CustomButton(
          text: step == 2 ? '전송' : '다음',
          onPressed: canNext ? () {
            if (step == 2) {
              _submitQuestion(); // 마지막 단계에서는 질문 전송
            } else {
              setState(() => step++); // 다른 단계에서는 다음으로
            }
          } : null,
          width: double.infinity,
          height: 52,
          fontSize: 16,
          textColor: AppColors.plumu_white,
          backgroundColor: AppColors.plumu_green_main,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
