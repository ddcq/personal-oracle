import 'package:flutter/material.dart';
import 'utils/help_dialog.dart';
import '../model.dart';
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
  MythCard? _selectedCardForDescription;

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

  void _onCardPressed(MythCard card) {
    setState(() {
      _selectedCardForDescription = card;
    });
  }

  void _onCardReleased() {
    setState(() {
      _selectedCardForDescription = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _gameController,
      child: Consumer<GameController>(
        builder: (context, controller, child) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: const Color(0xFF0F0F23),
                body: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 120,
                      floating: false,
                      pinned: true,
                      backgroundColor: const Color(0xFF1E1E2E),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFF1E1E2E),
                                const Color(0xFF0F0F23),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  controller.selectedStory.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Reconstitue l\'histoire',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      actions: [
                        Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withAlpha(51),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.help_outline, color: Color(0xFF6366F1)),
                            onPressed: () => HelpDialog.show(context),
                          ),
                        ),
                      ],
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF6366F1).withAlpha(51),
                                  const Color(0xFF6366F1).withAlpha(12),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF6366F1).withAlpha(76),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6366F1).withAlpha(25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: GameGrid(
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
                                onCardPressed: _onCardPressed,
                                onCardReleased: _onCardReleased,
                              ),
                            ),
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
              ),
              if (_selectedCardForDescription != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF6366F1).withAlpha(76)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withAlpha(25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _selectedCardForDescription!.description,
                      style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
