import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/order_the_scrolls/utils/help_dialog.dart';
import 'package:provider/provider.dart';
import 'game_controller.dart';
import './widgets/game_grid.dart';
import './widgets/game_controls.dart';

class OrderTheScrollsGame extends StatefulWidget {
  const OrderTheScrollsGame({super.key});

  @override
  State<OrderTheScrollsGame> createState() => _OrderTheScrollsGameState();
}

class _OrderTheScrollsGameState extends State<OrderTheScrollsGame> {
  late GameController _gameController;

  @override
  void initState() {
    super.initState();
    _gameController = GameController();
    _gameController.initializeGame();
  }

  @override
  void dispose() {
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  expandedHeight: 50,
                  backgroundColor: const Color(0xFF2E3B4E),
                  foregroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      controller.selectedStory.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.help_outline),
                      onPressed: () => HelpDialog.show(context),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      GameGrid(
                        controller: controller,
                        onCardReorder: (fromIndex, toIndex) {
                          controller.reorderCards(fromIndex, toIndex);
                        },
                        onDragStarted: () {
                          // Logique supplémentaire si nécessaire
                        },
                        onDragEnd: () {
                          controller.setDraggedIndex(null);
                        },
                      ),
                      const SizedBox(height: 20),
                      GameControls(
                        controller: controller,
                        onValidate: () => controller.validateOrder(),
                        onReset: () => controller.resetGame(),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
