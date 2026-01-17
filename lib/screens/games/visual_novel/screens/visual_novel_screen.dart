import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_d_asgard/components/victory_popup.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/data/story_data.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/models/visual_novel_models.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/widgets/emotional_state_indicator.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/widgets/scene_display_widget.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';

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
      emotionalState: EmotionalState(pride: 60, bitterness: 15, loyalty: 75, lucidity: 40),
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

      gameState = gameState.copyWith(currentSceneId: nextSceneId, choicesMade: newChoices, visitedScenes: newVisited);
    });
  }

  void _onSceneProgression(String nextSceneId) {
    setState(() {
      // Add current scene to visited
      Set<String> newVisited = Set.from(gameState.visitedScenes);
      newVisited.add(gameState.currentSceneId);

      // Move to next scene
      gameState = gameState.copyWith(currentSceneId: nextSceneId, visitedScenes: newVisited);
    });
  }

  void _onScenarioComplete() async {
    final currentSceneId = gameState.currentSceneId;
    final gamificationService = getIt<GamificationService>();

    // Check if this ending was already completed
    final alreadyCompleted = await gamificationService.isVisualNovelEndingCompleted(currentSceneId);

    // Award coins only if it's the first time completing this ending
    final coinsEarned = alreadyCompleted ? 0 : 50;
    if (!alreadyCompleted) {
      await gamificationService.addCoins(50);
      await gamificationService.markVisualNovelEndingCompleted(currentSceneId);
    }

    if (!mounted) return;

    // Show victory popup
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VictoryPopup(
        coinsEarned: coinsEarned,
        customTitle: alreadyCompleted ? 'vn_ending_already_completed'.tr() : 'vn_ending_title'.tr(),
        content: alreadyCompleted
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    'Vous avez déjà complété cette fin !',
                    style: const TextStyle(color: Colors.white, fontSize: 18, decoration: TextDecoration.none),
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : null,
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
        title: Text(story.title, style: const TextStyle(color: Colors.white)),
        actions: [EmotionalStateIndicator(emotionalState: gameState.emotionalState)],
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
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Game saved')));
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
