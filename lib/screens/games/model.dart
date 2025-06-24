class MythStory {
  final String title;
  final List<MythCard> correctOrder;

  MythStory({required this.title, required this.correctOrder});
}

class MythCard {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final String
  detailedStory; // Nouveau champ pour l'histoire détaillée de cette étape

  MythCard({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.detailedStory,
  });
}
