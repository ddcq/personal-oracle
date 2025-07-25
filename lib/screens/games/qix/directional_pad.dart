import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'constants.dart';

class DirectionalPad extends StatelessWidget {
  final ValueChanged<Direction> onDirectionChanged;

  const DirectionalPad({super.key, required this.onDirectionChanged}) : super();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [_buildDirectionButton(Icon(Icons.arrow_upward, color: Colors.white), Direction.up)],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDirectionButton(Icon(Icons.arrow_back, color: Colors.white), Direction.left),
                const SizedBox(width: 60), // Spacer for the center
                _buildDirectionButton(Icon(Icons.arrow_forward, color: Colors.white), Direction.right),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [_buildDirectionButton(Icon(Icons.arrow_downward, color: Colors.white), Direction.down)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionButton(Widget icon, Direction direction) {
    return ChibiButton(
      color: Colors.blueGrey, // You can choose a suitable color
      onPressed: () => onDirectionChanged(direction),
      child: icon,
    );
  }
}
