import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';

class VictoryScreen extends StatelessWidget {
  final Map<String, dynamic>? collectibleCard;

  const VictoryScreen({super.key, this.collectibleCard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Victory!'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: VictoryPopup(
          collectibleCard: collectibleCard,
          onClose: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
