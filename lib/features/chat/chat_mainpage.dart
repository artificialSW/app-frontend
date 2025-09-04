import 'package:flutter/material.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});

  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('소통방'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              Navigator.pushNamed(context, '/personal-answer');
              // 메시지 전송 기능
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 공통질문 배너
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.psychology),
                SizedBox(width: 8),
                Expanded(
                  child: Text('이번주의 공통질문'),
                ),
              ],
            ),
          ),
          // 개인질문 / 공통질문 탭
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '개인질문',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: _selectedIndex == 0
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      '공통질문',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 질문 목록 영역
          Expanded(
            child: _selectedIndex == 0
                ? _buildPersonalQuestions()
                : _buildCommonQuestions(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  개인질문 작성 플로우 페이지로 이동
          Navigator.pushNamed(context, '/personal-question');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPersonalQuestions() {
    return const Center(
      child: Text(
        '질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCommonQuestions() {
    return const Center(
      child: Text(
        '공통질문이 없어요.\n이번주의 공통질문을 확인해보세요!',
        textAlign: TextAlign.center,
      ),
    );
  }
}
