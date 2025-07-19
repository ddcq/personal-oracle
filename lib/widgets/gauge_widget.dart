
import 'package:flutter/material.dart';

class GaugeWidget extends StatelessWidget {
  final double percentage;
  final double goalPercentage;

  const GaugeWidget({
    Key? key,
    required this.percentage,
    this.goalPercentage = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool goalReached = percentage >= goalPercentage;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;
        final double markerPosition = barWidth * (goalPercentage / 100);

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zone découverte: ${percentage.toStringAsFixed(1)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 40, // Increased height to accommodate the flag
              child: Stack(
                children: [
                  // Background bar
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                  ),
                  // Progress bar
                  FractionallySizedBox(
                    widthFactor: (percentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.lightBlueAccent],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  // Goal marker
                  Positioned(
                    left: markerPosition - 2, // Center the line on the position
                    top: 0,
                    bottom: 20, // Limit line to the bar height
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  // Victory flag
                  if (goalReached)
                    Positioned(
                      left: markerPosition - 12, // Adjust position to center the flag
                      top: -15, // Position flag above the bar
                      child: const Icon(
                        Icons.flag,
                        color: Colors.greenAccent,
                        size: 30,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
