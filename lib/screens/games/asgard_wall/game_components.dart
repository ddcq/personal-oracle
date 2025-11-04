import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
/// Widget d'aperçu des prochaines pièces
class NextPiecesPreview extends StatelessWidget {
  final List<int> nextPieces;
  final List<Color> nextPieceColors;
  final List<List<List<List<bool>>>> piecesData; // Passer les données des pièces
  final List<String> pieceImageNames;
  final int currentScore;

  const NextPiecesPreview({
    super.key,
    required this.nextPieces,
    required this.nextPieceColors,
    required this.piecesData,
    required this.pieceImageNames,
    required this.currentScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460), // Couleur de fond du conteneur
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFD700), width: 1), // Bordure dorée
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score: $currentScore',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'asgard_wall_game_screen_next_pieces'.tr(),
            style: const TextStyle(
              color: Color(0xFFFFD700), // Couleur du texte dorée
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          // Affiche les 3 prochaines pièces
          ...nextPieces.take(3).toList().asMap().entries.map((entry) {
            final int pieceIndex = entry.value;
            final List<List<bool>> previewPiece = piecesData[pieceIndex][0];
            final String pieceImageName = pieceImageNames[pieceIndex];

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black26, // Fond semi-transparent pour l'aperçu
                borderRadius: BorderRadius.circular(4),
              ),
              child: Image.asset(
                'assets/images/blocks/$pieceImageName.webp',
                width: previewPiece[0].length * 15.0,
                height: previewPiece.length * 15.0,
                fit: BoxFit.contain,
              ),
            );
          }),
        ],
      ),
    );
  }
}
