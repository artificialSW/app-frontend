class Tree {
  final String name;
  final String namingDate;
  final int fruitCount;
  final int flowerCount;

  const Tree({
    required this.name,
    required this.namingDate,
    required this.fruitCount,
    required this.flowerCount,
  });

  Tree copyWith({
    String? name,
    String? namingDate,
    int? fruitCount,
    int? flowerCount,
  }) {
    return Tree(
      name: name ?? this.name,
      namingDate: namingDate ?? this.namingDate,
      fruitCount: fruitCount ?? this.fruitCount,
      flowerCount: flowerCount ?? this.flowerCount,
    );
  }
}
