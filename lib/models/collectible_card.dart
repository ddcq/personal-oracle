class CollectibleCard {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final List<String> tags;

  CollectibleCard({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.tags = const [],
  });
}