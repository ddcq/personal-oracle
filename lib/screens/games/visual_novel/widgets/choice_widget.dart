import 'package:flutter/material.dart';
import '../models/visual_novel_models.dart';

class ChoiceWidget extends StatefulWidget {
  final Choice choice;
  final Function(Choice) onSelected;
  final EmotionalState emotionalState;

  const ChoiceWidget({
    Key? key,
    required this.choice,
    required this.onSelected,
    required this.emotionalState,
  }) : super(key: key);

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
      padding: const EdgeInsets.symmetric(vertical: 6),
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
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _getChoiceColor(),
                  width: _isHovered ? 2 : 1,
                ),
                gradient: LinearGradient(
                  colors: [
                    _getChoiceColor().withOpacity(0.1),
                    _getChoiceColor().withOpacity(0.05),
                  ],
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: _getChoiceColor().withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Choice icon
                    Icon(
                      _getChoiceIcon(),
                      color: _getChoiceColor(),
                      size: 20,
                    ),
                    const SizedBox(width: 12),

                    // Choice content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Choice text
                          Text(
                            widget.choice.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),

                          // Choice description
                          Text(
                            widget.choice.description,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Emotional impact preview (subtle)
                    if (_isHovered)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getChoiceColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getConsequencePreview(),
                          style: TextStyle(
                            color: _getChoiceColor(),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
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
      effects.add('Fierté ${consequence.prideChange > 0 ? '+' : ''}${consequence.prideChange}');
    }
    if (consequence.bitternessChange != 0) {
      effects.add('Amertume ${consequence.bitternessChange > 0 ? '+' : ''}${consequence.bitternessChange}');
    }
    if (consequence.loyaltyChange != 0) {
      effects.add('Loyauté ${consequence.loyaltyChange > 0 ? '+' : ''}${consequence.loyaltyChange}');
    }
    if (consequence.lucidityChange != 0) {
      effects.add('Lucidité ${consequence.lucidityChange > 0 ? '+' : ''}${consequence.lucidityChange}');
    }

    return effects.isEmpty ? 'Neutre' : effects.first;
  }
}