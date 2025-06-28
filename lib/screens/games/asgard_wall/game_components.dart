import 'package:flutter/material.dart';
/// Widget d'aperçu des prochaines pièces
class NextPiecesPreview extends StatelessWidget {
  final List<int> nextPieces;
  final List<Color> nextPieceColors;
  final List<List<List<List<bool>>>> piecesData; // Passer les données des pièces

  const NextPiecesPreview({
    super.key,
    required this.nextPieces,
    required this.nextPieceColors,
    required this.piecesData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF0F3460), // Couleur de fond du conteneur
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFFFD700), width: 1), // Bordure dorée
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prochaines pièces',
            style: TextStyle(
              color: Color(0xFFFFD700), // Couleur du texte dorée
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          // Affiche les 3 prochaines pièces
          ...nextPieces.take(3).toList().asMap().entries.map((entry) {
            int index = entry.key;
            int pieceIndex = entry.value;
            Color pieceColor = nextPieceColors[index];

            // Prend la première rotation de chaque pièce pour l'aperçu
            List<List<bool>> previewPiece = piecesData[pieceIndex][0];

            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black26, // Fond semi-transparent pour l'aperçu
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: previewPiece.map((row) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: row.map((cell) {
                      return Container(
                        width: 12,
                        height: 12,
                        margin: EdgeInsets.all(0.5),
                        decoration: BoxDecoration(
                          color: cell ? pieceColor : Colors.transparent, // Couleur de la pièce ou transparent
                          border: cell
                              ? Border.all(color: Colors.white24, width: 0.5)
                              : null,
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }
}
