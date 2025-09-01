class Reply {
  final String id;
  final String threadId;
  final String? parentId;
  final String content;
  final DateTime createdAt;
  final String authorId;
  final Set<String> likedBy;

  const Reply({
    required this.id,
    required this.threadId,
    this.parentId,
    required this.content,
    required this.createdAt,
    required this.authorId,
    this.likedBy = const {},
  });

  Reply toggleLike(String userId) {
    final s = Set<String>.from(likedBy);
    if (s.contains(userId)) {
      s.remove(userId);
    } else {
      s.add(userId);
    }
    return copyWith(likedBy: s);
  }

  Reply copyWith({
    String? id,
    String? threadId,
    String? parentId,
    String? content,
    DateTime? createdAt,
    String? authorId,
    Set<String>? likedBy,
  }) {
    return Reply(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      parentId: parentId ?? this.parentId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      likedBy: likedBy ?? this.likedBy,
    );
  }
}
