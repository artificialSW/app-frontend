/// 오프라인 좋아요 큐 매니저
/// 인스타그램처럼 네트워크 실패 시에도 좋아요를 로컬에 저장하고
/// 나중에 네트워크 복구되면 자동으로 서버에 동기화하는 서비스

import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';

enum LikeAction { like, unlike }

class PendingLike {
  final String id;
  final ChatLikeType type;
  final LikeAction action;
  final DateTime timestamp;

  PendingLike({
    required this.id,
    required this.type,
    required this.action,
    required this.timestamp,
  });

  String get key => '${type.toString()}_$id';
}

class OfflineLikeQueue {
  static final OfflineLikeQueue _instance = OfflineLikeQueue._internal();
  factory OfflineLikeQueue() => _instance;
  OfflineLikeQueue._internal();

  final Map<String, PendingLike> _queue = {};
  final ChatService _chatService = ChatService();
  bool _isSyncing = false;

  /// 좋아요 액션을 큐에 추가 (낙관적 업데이트)
  void addToQueue({
    required String id,
    required ChatLikeType type,
    required LikeAction action,
  }) {
    final key = '${type.toString()}_$id';
    
    // 이미 큐에 있으면 업데이트, 없으면 추가
    _queue[key] = PendingLike(
      id: id,
      type: type,
      action: action,
      timestamp: DateTime.now(),
    );

    print('📝 [OfflineLikeQueue] 큐에 추가: $key (${action == LikeAction.like ? '좋아요' : '취소'})');
    
    // 즉시 동기화 시도
    _trySync();
  }

  /// 특정 아이템의 현재 좋아요 상태 확인
  bool? getQueuedLikeState(String id, ChatLikeType type) {
    final key = '${type.toString()}_$id';
    final pending = _queue[key];
    
    if (pending == null) return null;
    return pending.action == LikeAction.like;
  }

  /// 서버와 동기화 시도
  Future<void> _trySync() async {
    if (_isSyncing || _queue.isEmpty) return;

    _isSyncing = true;
    print('🔄 [OfflineLikeQueue] 동기화 시작 (${_queue.length}개 항목)');

    final itemsToSync = List<PendingLike>.from(_queue.values);
    
    for (final pending in itemsToSync) {
      try {
        final request = ChatLikeRequestDto(
          what: pending.type,
          id: int.parse(pending.id),
        );

        await _chatService.postChatLike(request);
        
        // 성공하면 큐에서 제거
        _queue.remove(pending.key);
        print('✅ [OfflineLikeQueue] 동기화 성공: ${pending.key}');
        
      } catch (e) {
        // 실패해도 큐에 남겨둠 (나중에 재시도)
        print('⚠️ [OfflineLikeQueue] 동기화 실패 (큐에 유지): ${pending.key}');
      }
    }

    _isSyncing = false;
    
    if (_queue.isNotEmpty) {
      print(' [OfflineLikeQueue] 남은 항목: ${_queue.length}개');
    } else {
      print(' [OfflineLikeQueue] 모든 항목 동기화 완료');
    }
  }

  /// 수동 동기화 (Pull-to-refresh 등에서 사용)
  Future<void> syncNow() async {
    await _trySync();
  }

  /// 큐 초기화 (로그아웃 등에서 사용)
  void clear() {
    _queue.clear();
    print(' [OfflineLikeQueue] 큐 초기화');
  }

  /// 현재 큐 상태 확인 (디버깅용)
  int get pendingCount => _queue.length;
  bool get hasPending => _queue.isNotEmpty;
}

