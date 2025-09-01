import 'thread_key.dart';
import 'reply.dart'; // ✅ models.dart 대신 reply.dart만 import

class ThreadData {
  final String id;
  final String title;
  final List<Reply> replies;

  const ThreadData({
    required this.id,
    required this.title,
    this.replies = const [],
  });
}

class ThreadState {
  final ThreadKey key;
  final String title;
  final List<Reply> replies;

  const ThreadState({
    required this.key,
    required this.title,
    required this.replies,
  });

  factory ThreadState.empty(ThreadKey key) =>
      ThreadState(key: key, title: '', replies: const []);

  ThreadState copyWith({
    ThreadKey? key,
    String? title,
    List<Reply>? replies,
  }) {
    return ThreadState(
      key: key ?? this.key,
      title: title ?? this.title,
      replies: replies ?? this.replies,
    );
  }
}
