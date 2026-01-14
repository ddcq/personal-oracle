import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/visual_novel_models.dart';
import '../data/story_data.dart';
import '../widgets/scene_display_widget.dart';
// import '../widgets/choice_widget.dart'; // Not directly used here
import '../widgets/emotional_state_indicator.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/locator.dart';

class VisualNovelScreen extends StatefulWidget {
  const VisualNovelScreen({Key? key}) : super(key: key);

  @override
  State<VisualNovelScreen> createState() => _VisualNovelScreenState();
}

class _VisualNovelScreenState extends State<VisualNovelScreen> {
  late VisualNovelGameState gameState;
  late Story story;

  @override
  void initState() {
    super.initState();
    story = StoryData.lokiStory;
    gameState = VisualNovelGameState(
      currentSceneId: 'scene_root_bored_loki',
      emotionalState: EmotionalState(
        pride: 60,
        bitterness: 15,
        loyalty: 75,
        lucidity: 40,
      ),
      unlockedActs: {'2'}, // Act II unlocked
    );
  }

  void _onChoiceMade(Choice choice) {
    setState(() {
      // Update emotional state
      gameState.emotionalState.updateEmotion(choice.consequence);

      // Mark choice as made
      Map<String, bool> newChoices = Map.from(gameState.choicesMade);
      newChoices[choice.id] = true;

      // Add current scene to visited
      Set<String> newVisited = Set.from(gameState.visitedScenes);
      newVisited.add(gameState.currentSceneId);

      // Move to next scene
      String nextSceneId = choice.nextSceneId ?? _getNextSceneId();

      gameState = gameState.copyWith(
        currentSceneId: nextSceneId,
        choicesMade: newChoices,
        visitedScenes: newVisited,
      );
    });
  }

  void _onSceneProgression(String nextSceneId) {
    setState(() {
      // Add current scene to visited
      Set<String> newVisited = Set.from(gameState.visitedScenes);
      newVisited.add(gameState.currentSceneId);

      // Move to next scene
      gameState = gameState.copyWith(
        currentSceneId: nextSceneId,
        visitedScenes: newVisited,
      );
    });
  }

  void _onScenarioComplete() async {
    // Award 50 coins
    await getIt<GamificationService>().addCoins(50);

    if (!mounted) return;

    // Show victory popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryPopup(
        coinsEarned: 50,
        customTitle: 'Fin de l\'Épopée',
        onDismiss: () {
          Navigator.of(context).pop();
          context.go('/visual_novel_preliminary');
        },
        onSeeRewards: () {
          Navigator.of(context).pop();
          context.go('/shop');
        },
      ),
    );
  }

  String _getNextSceneId() {
    // Logic to determine next scene if not specified
    final currentScene = story.getScene(gameState.currentSceneId);
    return currentScene?.nextSceneId ?? gameState.currentSceneId;
  }

  @override
  Widget build(BuildContext context) {
    final currentScene = story.getScene(gameState.currentSceneId);

    if (currentScene == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Visual Novel')),
        body: const Center(child: Text('Scene not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          story.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          EmotionalStateIndicator(emotionalState: gameState.emotionalState),
        ],
      ),
      body: Column(
        children: [
          // Main scene display
          Expanded(
            child: SceneDisplayWidget(
              scene: currentScene,
              onChoiceMade: _onChoiceMade,
              onSceneProgression: _onSceneProgression,
              onScenarioComplete: _onScenarioComplete,
              gameState: gameState,
            ),
          ),

          // Navigation bar
          Container(
            height: 60,
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.save, color: Colors.white),
                  onPressed: () {
                    // TODO: Save game functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Game saved')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.history, color: Colors.white),
                  onPressed: () {
                    // TODO: Show history/log
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    // TODO: Show settings
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}