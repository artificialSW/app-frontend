import 'enums.dart';

class ThreadKey {
  final ThreadKind kind;
  final String id;
  const ThreadKey(this.kind, this.id);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ThreadKey && runtimeType == other.runtimeType && kind == other.kind && id == other.id;

  @override
  int get hashCode => Object.hash(kind, id);

  @override
  String toString() => 'ThreadKey(kind: $kind, id: $id)';
}
