import 'package:intl/intl.dart';

String getPodiumImagePath(int rank) {
  switch (rank) {
    case 1:
      return 'assets/images/profile/gold.webp';
    case 2:
      return 'assets/images/profile/silver.webp';
    case 3:
      return 'assets/images/profile/bronze.webp';
    default:
      return '';
  }
}

String formatRelativeTime(DateTime timestamp) {
  final now = DateTime.now();
  final difference = now.difference(timestamp);

  if (difference.inDays == 0) {
    if (difference.inHours == 0) {
      if (difference.inMinutes == 0) {
        return 'À l’instant';
      }
      return 'Il y a ${difference.inMinutes} min';
    }
    return 'Aujourd’hui à ${DateFormat('HH:mm').format(timestamp)}';
  } else if (difference.inDays == 1) {
    return 'Hier à ${DateFormat('HH:mm').format(timestamp)}';
  } else if (difference.inDays < 7) {
    return 'Il y a ${difference.inDays} jours';
  } else if (difference.inDays < 30) {
    final weeks = (difference.inDays / 7).floor();
    return 'Il y a $weeks sem';
  } else if (difference.inDays < 365) {
    final months = (difference.inDays / 30).floor();
    return 'Il y a $months mois';
  } else {
    final years = (difference.inDays / 365).floor();
    return 'Il y a $years ans';
  }
}
