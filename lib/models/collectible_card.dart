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

  factory CollectibleCard.fromJson(Map<String, dynamic> json) {
    return CollectibleCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      tags: List<String>.from(json['tags'] as List),
    );
  }
}