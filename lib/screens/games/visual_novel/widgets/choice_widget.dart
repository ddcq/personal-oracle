import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/models/visual_novel_models.dart';

class ChoiceWidget extends StatefulWidget {
  final Choice choice;
  final Function(Choice) onSelected;
  final EmotionalState emotionalState;

  const ChoiceWidget({
    super.key,
    required this.choice,
    required this.onSelected,
    required this.emotionalState,
  });

  @override
  State<ChoiceWidget> createState() => _ChoiceWidgetState();
}

class _ChoiceWidgetState extends State<ChoiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  Color _getChoiceColor() {
    // Color based on the type of consequence
    final consequence = widget.choice.consequence;

    if (consequence.prideChange > 0) {
      return const Color(0xFF8e24aa); // Purple for pride
    } else if (consequence.lucidityChange > 0) {
      return const Color(0xFF1976d2); // Blue for lucidity
    } else if (consequence.bitternessChange > 0) {
      return const Color(0xFFd32f2f); // Red for bitterness
    } else if (consequence.loyaltyChange > 0) {
      return const Color(0xFF388e3c); // Green for loyalty
    }

    return const Color(0xFFd4af37); // Default golden
  }

  IconData _getChoiceIcon() {
    final consequence = widget.choice.consequence;

    if (consequence.prideChange > 0) {
      return Icons.psychology; // Pride/arrogance
    } else if (consequence.lucidityChange > 0) {
      return Icons.visibility; // Lucidity/insight
    } else if (consequence.bitternessChange > 0) {
      return Icons.sentiment_dissatisfied; // Bitterness
    } else if (consequence.loyaltyChange > 0) {
      return Icons.favorite; // Loyalty
    }

    return Icons.chat_bubble_outline; // Default
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _hoverController.reverse();
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: GestureDetector(
            onTap: () => widget.onSelected(widget.choice),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getChoiceColor(),
                  width: _isHovered ? 2 : 1,
                ),
                gradient: LinearGradient(
                  colors: [
                    _getChoiceColor().withAlpha(25),
                    _getChoiceColor().withAlpha(12),
                  ],
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: _getChoiceColor().withAlpha(76),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Choice icon with consequence badge
                    Column(
                      children: [
                        Icon(
                          _getChoiceIcon(),
                          color: _getChoiceColor(),
                          size: 18,
                        ),
                        const SizedBox(height: 4),
                        // Emotional impact preview (compact)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getChoiceColor().withAlpha(51),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getConsequencePreview(),
                            style: TextStyle(
                              color: _getChoiceColor(),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),

                    // Choice content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Choice text
                          Text(
                            widget.choice.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),

                          // Choice description (compact)
                          Text(
                            widget.choice.description,
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getConsequencePreview() {
    final consequence = widget.choice.consequence;
    List<String> effects = [];

    if (consequence.prideChange != 0) {
      effects.add('${consequence.prideChange > 0 ? '+' : ''}${consequence.prideChange}');
    }
    if (consequence.bitternessChange != 0) {
      effects.add('${consequence.bitternessChange > 0 ? '+' : ''}${consequence.bitternessChange}');
    }
    if (consequence.loyaltyChange != 0) {
      effects.add('${consequence.loyaltyChange > 0 ? '+' : ''}${consequence.loyaltyChange}');
    }
    if (consequence.lucidityChange != 0) {
      effects.add('${consequence.lucidityChange > 0 ? '+' : ''}${consequence.lucidityChange}');
    }

    return effects.isEmpty ? '0' : effects.first;
  }
}