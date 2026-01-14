import 'package:flutter/material.dart';
import '../models/visual_novel_models.dart';

class EmotionalStateIndicator extends StatelessWidget {
  final EmotionalState emotionalState;

  const EmotionalStateIndicator({
    Key? key,
    required this.emotionalState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<void>(
      icon: Icon(
        Icons.psychology,
        color: _getPsychologicalStateColor(),
      ),
      tooltip: 'État émotionnel de Loki',
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'État Psychologique de Loki',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              _buildEmotionBar('Fierté', emotionalState.pride, const Color(0xFF8e24aa)),
              _buildEmotionBar('Amertume', emotionalState.bitterness, const Color(0xFFd32f2f)),
              _buildEmotionBar('Loyauté', emotionalState.loyalty, const Color(0xFF388e3c)),
              _buildEmotionBar('Lucidité', emotionalState.lucidity, const Color(0xFF1976d2)),
              const SizedBox(height: 8),
              _buildPsychologicalAnalysis(),
            ],
          ),
        ),
      ],
    );
  }

  Color _getPsychologicalStateColor() {
    // Color based on dominant emotional state
    if (emotionalState.bitterness >= 70) {
      return const Color(0xFFd32f2f); // Red - dangerous state
    } else if (emotionalState.lucidity >= 80) {
      return const Color(0xFF1976d2); // Blue - high awareness
    } else if (emotionalState.loyalty <= 30) {
      return const Color(0xFFff9800); // Orange - warning
    } else {
      return const Color(0xFFd4af37); // Golden - balanced
    }
  }

  Widget _buildEmotionBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPsychologicalAnalysis() {
    String analysis = _getCurrentPsychologicalState();
    Color analysisColor = _getPsychologicalStateColor();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: analysisColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: analysisColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analyse Psychologique',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: analysisColor,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            analysis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _getCurrentPsychologicalState() {
    // Complex psychological analysis based on emotional variables
    if (emotionalState.bitterness >= 80) {
      if (emotionalState.lucidity >= 70) {
        return "Loki a atteint un état de lucidité amère. Il voit clairement les manipulations mais ressent une rage profonde.";
      } else {
        return "L'amertume consume Loki. Il risque de prendre des décisions impulsives et destructrices.";
      }
    }

    if (emotionalState.loyalty <= 20) {
      if (emotionalState.pride >= 70) {
        return "Loki se détache d'Asgard par orgueil blessé. Il pourrait retourner sa intelligence contre les dieux.";
      } else {
        return "La loyauté de Loki s'effrite. Il commence à questionner sa place parmi les dieux.";
      }
    }

    if (emotionalState.lucidity >= 90) {
      return "Loki voit à travers tous les mensonges et manipulations. Cette clairvoyance est à la fois un don et une malédiction.";
    }

    if (emotionalState.pride >= 80) {
      return "L'orgueil de Loki enfle. Il risque de défier ouvertement l'autorité des dieux.";
    }

    if (emotionalState.bitterness >= 50 && emotionalState.lucidity >= 60) {
      return "Loki développe une compréhension cynique de sa position. Il reste fonctionnel mais de plus en plus détaché.";
    }

    if (emotionalState.loyalty >= 60 && emotionalState.pride <= 40) {
      return "Malgré les épreuves, Loki conserve un attachement à Asgard, tempéré par une humilité croissante.";
    }

    // Balanced state
    if (emotionalState.loyalty >= 50 && emotionalState.lucidity >= 50) {
      return "Loki navigue avec intelligence entre ses devoirs et ses désirs personnels. État relativement stable.";
    }

    return "L'état psychologique de Loki reste complexe, mêlant espoir, frustration et une intelligence aiguë.";
  }
}