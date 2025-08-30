import '../domain/chat_repository.dart';
import '../data/mock_chat_repository.dart';

class ChatDI {
  ChatDI._();
  static final ChatRepository repo = MockChatRepository();
  static void ensureInitialized() {}
}
