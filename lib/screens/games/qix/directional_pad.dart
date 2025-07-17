import 'package:flutter/material.dart';
import 'constants.dart';

class DirectionalPad extends StatelessWidget {
  final ValueChanged<Direction> onDirectionChanged;

  const DirectionalPad({super.key, required this.onDirectionChanged}) : super();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDirectionButton(Icons.arrow_upward, Direction.up),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDirectionButton(Icons.arrow_back, Direction.left),
                const SizedBox(width: 60), // Spacer for the center
                _buildDirectionButton(Icons.arrow_forward, Direction.right),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDirectionButton(Icons.arrow_downward, Direction.down),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionButton(IconData icon, Direction direction) {
    return GestureDetector(
      onTap: () => onDirectionChanged(direction),
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.blueGrey.withAlpha((0.7 * 255).round()),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
