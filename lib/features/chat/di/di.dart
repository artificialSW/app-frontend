import '../domain/chat_repository.dart';
import '../data/mock_chat_repository.dart';

class ChatDI {
  ChatDI._();

  static bool _inited = false;
  static late ChatRepository repo;

  /// 앱 구동 시 한 번만 리포지토리를 준비
  static void ensureInitialized() {
    if (_inited) return;
    repo = MockChatRepository();  // 나중에 실제 구현으로 교체하면 됨
    _inited = true;
  }
}
