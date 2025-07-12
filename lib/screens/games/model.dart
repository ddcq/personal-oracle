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
  MythCard({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
