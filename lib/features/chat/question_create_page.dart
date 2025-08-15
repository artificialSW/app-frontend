import 'package:flutter/material.dart';

class QuestionCreatePage extends StatefulWidget {
  const QuestionCreatePage({super.key});

  @override
  State<QuestionCreatePage> createState() => _QuestionCreatePageState();
}

class _QuestionCreatePageState extends State<QuestionCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop(_title.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('새 채팅 만들기'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('저장', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: '제목',
                  hintText: '예) 피그마 와이어프레임 피드백',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? '제목을 입력해주세요' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _message,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: '첫 메시지',
                  hintText: '대화 시작 내용을 입력하세요',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('저장'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.close),
                label: const Text('취소'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
