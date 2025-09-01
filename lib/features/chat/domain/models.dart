// 아래 3줄 추가(배럴). thread_state.dart는 export하지 않는다(순환 방지).
export 'enums.dart';
export 'thread_key.dart';
export 'reply.dart';
// lib/features/chat/domain/models.dart
enum Privacy { public, private }

// ---------------- PersonalQuestion ----------------
class PersonalQuestion {
  const PersonalQuestion({
    required this.id,
    required this.title,
    required this.privacy,
    this.members = const <String>[],
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });

  /// 생성 시각을 지금으로 간편 설정
  PersonalQuestion.createdNow({
    required String id,
    required String title,
    required Privacy privacy,
    List<String> members = const <String>[],
    int likes = 0,
    int comments = 0,
  }) : this(
    id: id,
    title: title,
    privacy: privacy,
    members: members,
    createdAt: DateTime.now(),
    likes: likes,
    comments: comments,
  );

  final String id;
  final String title;
  final Privacy privacy;
  final List<String> members; // 비공개면 두 사람 아이디/닉네임 등
  final DateTime createdAt;
  final int likes;
  final int comments;

  PersonalQuestion copyWith({
    String? id,
    String? title,
    Privacy? privacy,
    List<String>? members,
    DateTime? createdAt,
    int? likes,
    int? comments,
  }) {
    return PersonalQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  factory PersonalQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalQuestion(
      id: json['id'] as String,
      title: json['title'] as String,
      privacy: Privacy.values.firstWhere(
            (e) => e.name == (json['privacy'] as String),
        orElse: () => Privacy.public,
      ),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
          const <String>[],
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'privacy': privacy.name,
    'members': members,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'comments': comments,
  };

  // 최신순 정렬에 쓰기 좋게
  int compareToCreatedDesc(PersonalQuestion other) =>
      other.createdAt.compareTo(createdAt);

  @override
  String toString() =>
      'PersonalQuestion($id, $title, $privacy, likes=$likes, comments=$comments)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PersonalQuestion &&
              id == other.id &&
              title == other.title &&
              privacy == other.privacy &&
              _listEq(members, other.members) &&
              createdAt == other.createdAt &&
              likes == other.likes &&
              comments == other.comments;

  @override
  int get hashCode =>
      Object.hash(id, title, privacy, Object.hashAll(members), createdAt, likes, comments);
}

// ---------------- CommonQuestion ----------------
class CommonQuestion {
  const CommonQuestion({
    required this.id,
    required this.title,
    required this.body,
    required this.weekIndex, // 1,2,3.. 주차 식별
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });

  CommonQuestion.createdNow({
    required String id,
    required String title,
    required String body,
    required int weekIndex,
    int likes = 0,
    int comments = 0,
  }) : this(
    id: id,
    title: title,
    body: body,
    weekIndex: weekIndex,
    createdAt: DateTime.now(),
    likes: likes,
    comments: comments,
  );

  final String id;
  final String title;
  final String body;
  final int weekIndex;
  final DateTime createdAt;
  final int likes;
  final int comments;

  CommonQuestion copyWith({
    String? id,
    String? title,
    String? body,
    int? weekIndex,
    DateTime? createdAt,
    int? likes,
    int? comments,
  }) {
    return CommonQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      weekIndex: weekIndex ?? this.weekIndex,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
    );
  }

  factory CommonQuestion.fromJson(Map<String, dynamic> json) {
    return CommonQuestion(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      weekIndex: json['weekIndex'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'weekIndex': weekIndex,
    'createdAt': createdAt.toIso8601String(),
    'likes': likes,
    'comments': comments,
  };

  int compareToCreatedDesc(CommonQuestion other) =>
      other.createdAt.compareTo(createdAt);

  @override
  String toString() =>
      'CommonQuestion($id, week=$weekIndex, likes=$likes, comments=$comments)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CommonQuestion &&
              id == other.id &&
              title == other.title &&
              body == other.body &&
              weekIndex == other.weekIndex &&
              createdAt == other.createdAt &&
              likes == other.likes &&
              comments == other.comments;

  @override
  int get hashCode =>
      Object.hash(id, title, body, weekIndex, createdAt, likes, comments);
}

// ---------------- InboxItem ----------------
class InboxItem {
  const InboxItem({
    required this.id,
    required this.senderName, // 보낸 사람
    required this.preview,    // 질문 요약
    required this.isPrivate,  // true면 1:1
    required this.createdAt,
  });

  InboxItem.createdNow({
    required String id,
    required String senderName,
    required String preview,
    required bool isPrivate,
  }) : this(
    id: id,
    senderName: senderName,
    preview: preview,
    isPrivate: isPrivate,
    createdAt: DateTime.now(),
  );

  final String id;
  final String senderName;
  final String preview;
  final bool isPrivate;
  final DateTime createdAt;

  /// 과거 코드 호환용: 기존에 `sender`를 참조한 곳이 있어도 안 깨지게 유지
  @Deprecated('Use senderName instead')
  String get sender => senderName;

  InboxItem copyWith({
    String? id,
    String? senderName,
    String? preview,
    bool? isPrivate,
    DateTime? createdAt,
  }) {
    return InboxItem(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      preview: preview ?? this.preview,
      isPrivate: isPrivate ?? this.isPrivate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory InboxItem.fromJson(Map<String, dynamic> json) {
    return InboxItem(
      id: json['id'] as String,
      senderName: (json['senderName'] ?? json['sender']) as String,
      preview: json['preview'] as String,
      isPrivate: json['isPrivate'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderName': senderName,
    'preview': preview,
    'isPrivate': isPrivate,
    'createdAt': createdAt.toIso8601String(),
  };

  int compareToCreatedDesc(InboxItem other) =>
      other.createdAt.compareTo(createdAt);

  @override
  String toString() =>
      'InboxItem($id from=$senderName private=$isPrivate)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is InboxItem &&
              id == other.id &&
              senderName == other.senderName &&
              preview == other.preview &&
              isPrivate == other.isPrivate &&
              createdAt == other.createdAt;

  @override
  int get hashCode =>
      Object.hash(id, senderName, preview, isPrivate, createdAt);
}

// --------------- helpers ----------------
bool _listEq<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}