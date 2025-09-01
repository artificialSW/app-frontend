class InboxItem {
  const InboxItem({
    required this.id,
    required this.senderName,
    required this.preview,
    required this.isPrivate,
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
