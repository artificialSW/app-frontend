import 'privacy.dart';

class PersonalQuestion {
  const PersonalQuestion({
    required this.id,
    required this.title,
    required this.privacy,
    this.members = const <String>[],
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
    this.content = '',
    this.contentLikes = 0,
  });

  PersonalQuestion.createdNow({
    required String id,
    required String title,
    required Privacy privacy,
    List<String> members = const <String>[],
    int likes = 0,
    int comments = 0,
    String content = '',
    int contentLikes = 0,
  }) : this(
    id: id,
    title: title,
    privacy: privacy,
    members: members,
    createdAt: DateTime.now(),
    likes: likes,
    comments: comments,
    content: content,
    contentLikes: contentLikes,
  );

  final String id;
  final String title;
  final Privacy privacy;
  final List<String> members;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final String content;
  final int contentLikes;

  PersonalQuestion copyWith({
    String? id,
    String? title,
    Privacy? privacy,
    List<String>? members,
    DateTime? createdAt,
    int? likes,
    int? comments,
    String? content,
    int? contentLikes,
  }) {
    return PersonalQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      content: content ?? this.content,
      contentLikes: contentLikes ?? this.contentLikes,
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
      content: json['content'] as String? ?? '',
      contentLikes: json['contentLikes'] as int? ?? 0,
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
    'content': content,
    'contentLikes': contentLikes,
  };

  int compareToCreatedDesc(PersonalQuestion other) =>
      other.createdAt.compareTo(createdAt);

  @override
  String toString() =>
      'PersonalQuestion($id, $title, $privacy, likes=$likes, comments=$comments, content=$content)'; // ✅ content 포함

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
              comments == other.comments &&
              content == other.content && // ✅ content 비교 추가
              contentLikes == other.contentLikes;

  @override
  int get hashCode => Object.hash(
    id,
    title,
    privacy,
    Object.hashAll(members),
    createdAt,
    likes,
    comments,
    content, // ✅ content 포함
    contentLikes,
  );
}

bool _listEq<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
