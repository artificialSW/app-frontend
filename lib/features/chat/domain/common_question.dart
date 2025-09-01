class CommonQuestion {
  const CommonQuestion({
    required this.id,
    required this.title,
    required this.body,
    required this.weekIndex,
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
