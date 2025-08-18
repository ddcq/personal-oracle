import 'package:flutter/material.dart';


import 'package:oracle_d_asgard/models/collectible_card.dart';
import 'package:oracle_d_asgard/widgets/interactive_collectible_card.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';

class CollectibleCardDetailPage extends StatefulWidget {
  final CollectibleCard card;

  const CollectibleCardDetailPage({super.key, required this.card});

  @override
  State<CollectibleCardDetailPage> createState() => _CollectibleCardDetailPageState();
}

class _CollectibleCardDetailPageState extends State<CollectibleCardDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.card.title, style: TextStyle(color: Colors.white, fontFamily: AppTextStyles.amaticSC)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // For back button
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C), // Dark Purple
              Color(0xFF880E4F), // Dark Pink
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InteractiveCollectibleCard(card: widget.card),
                const SizedBox(height: 20),
                Text(
                  widget.card.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.card.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
