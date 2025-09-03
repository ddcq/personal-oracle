import 'package:oracle_d_asgard/models/card_version.dart';

class CollectibleCard {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final List<String> tags;
  final CardVersion version;

  CollectibleCard({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.tags = const [],
    this.version = CardVersion.epic,
  });

  factory CollectibleCard.fromJson(Map<String, dynamic> json) {
    return CollectibleCard(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      tags: List<String>.from(json['tags'] as List? ?? []),
      version: json['version'] != null ? CardVersion.fromJson(json['version']) : CardVersion.epic,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'description': description, 'imagePath': imagePath, 'tags': tags, 'version': version.toJson()};
  }

  CollectibleCard copyWith({String? id, String? title, String? description, String? imagePath, List<String>? tags, CardVersion? version}) {
    return CollectibleCard(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      tags: tags ?? this.tags,
      version: version ?? this.version,
    );
  }
}
