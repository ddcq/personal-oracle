import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';

class ActionPopup extends StatelessWidget {
  final Widget content;
  final List<Widget> actions;

  const ActionPopup({
    super.key,
    required this.content,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F23),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF22C55E)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/odin_sad.jpg',
              height: 100,
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 16),
            ...actions,
            const SizedBox(height: 8),
            ChibiButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> a) => false);
              },
              text: 'Menu principal',
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
