import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/data/collectible_cards_data.dart';
import 'package:oracle_d_asgard/models/card_version.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/services/sound_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:oracle_d_asgard/locator.dart';
import 'package:oracle_d_asgard/widgets/custom_video_player.dart';
import 'package:oracle_d_asgard/services/quiz_service.dart';

class DeitySelectionScreen extends StatefulWidget {
  final String currentDeityId;

  const DeitySelectionScreen({super.key, required this.currentDeityId});

  @override
  State<DeitySelectionScreen> createState() => _DeitySelectionScreenState();
}

class _DeitySelectionScreenState extends State<DeitySelectionScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  Future<List<Deity>>? _deitiesFuture;
  bool _pageControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _deitiesFuture = _loadDeities();
  }

  Future<List<Deity>> _loadDeities() async {
    final gamificationService = getIt<GamificationService>();

    // 1. Get all possible quiz deity IDs
    final allPossibleQuizDeityIds = QuizService.getAllowedQuizDeityIds().toSet();

    // 2. Get all chibi collectible cards (to access their videoUrl and imagePath)
    final allChibiCards = allCollectibleCards.where((card) => card.version == CardVersion.chibi).toList();
    final allChibiCardsMap = {for (var card in allChibiCards) card.id: card};

    // 3. Get unlocked collectible cards
    final unlockedCards = await gamificationService.getUnlockedCollectibleCards();
    final unlockedCardIds = unlockedCards.map((card) => card.id).toSet();

    final List<Deity> finalDeities = [];
    final Set<String> addedDeityIds = {}; // To ensure uniqueness

    // Combine all possible quiz deities and unlocked card IDs
    final allDeityOptions = <String>{};
    allDeityOptions.addAll(allPossibleQuizDeityIds);
    allDeityOptions.addAll(unlockedCardIds);

    for (final deityId in allDeityOptions) {
      if (addedDeityIds.contains(deityId)) continue;

      if (unlockedCardIds.contains(deityId)) {
        // Prioritize unlocked collectible card data if available
        final card = allChibiCardsMap[deityId];
        if (card != null) {
          final existingDeity = AppData.deities[card.id];
          finalDeities.add(
            Deity(
              id: card.id,
              name: card.title,
              title: card.title,
              icon: 'assets/images/${card.imagePath}',
              videoUrl: card.videoUrl,
              description: card.description,
              traits: existingDeity?.traits ?? {},
              colors: existingDeity?.colors ?? [Colors.grey, Colors.black],
              isCollectibleCard: true,
              cardVersion: card.version,
            ),
          );
          addedDeityIds.add(deityId);
        }
      } else if (allPossibleQuizDeityIds.contains(deityId)) {
        // If it's a quiz deity but no unlocked card, use AppData
        final deity = AppData.deities[deityId];
        if (deity != null) {
          finalDeities.add(deity);
          addedDeityIds.add(deityId);
        }
      }
    }

    if (finalDeities.isEmpty) {
      final odin = AppData.deities['odin'];
      if (odin != null) {
        return [odin];
      }
      return [];
    }

    return finalDeities;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'Choisir une Divinité'),
      body: AppBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
          child: FutureBuilder<List<Deity>>(
            future: _deitiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune divinité débloquée.'));
              }

              final deities = snapshot.data!;
              if (!mounted) return const SizedBox.shrink(); // Ensure widget is still mounted

              // Initialize _pageController only once
              if (!_pageControllerInitialized) {
                _currentPage = deities.indexWhere((d) => d.id == widget.currentDeityId);
                if (_currentPage == -1) _currentPage = 0;
                _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
                _pageControllerInitialized = true;
              }

              return Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: deities.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      // This container with a transparent color makes the entire area hittable.
                      return Container(
                        color: Colors.transparent,
                        child: _DeityCard(deity: deities[index], pageController: _pageController, pageIndex: index),
                      );
                    },
                  ),
                  _buildNavigationArrow(
                    isLeft: true,
                    isVisible: _currentPage > 0,
                    onPressed: () {
                      _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                    },
                  ),
                  _buildNavigationArrow(
                    isLeft: false,
                    isVisible: _currentPage < deities.length - 1,
                    onPressed: () {
                      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationArrow({required bool isLeft, required bool isVisible, required VoidCallback onPressed}) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }
    return Positioned(
      left: isLeft ? 10 : null,
      right: isLeft ? null : 10,
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withAlpha(120), shape: BoxShape.circle),
        child: IconButton(
          icon: Icon(isLeft ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _DeityCard extends StatefulWidget {
  final Deity deity;
  final PageController pageController;
  final int pageIndex;

  const _DeityCard({required this.deity, required this.pageController, required this.pageIndex});

  @override
  State<_DeityCard> createState() => _DeityCardState();
}

class _DeityCardState extends State<_DeityCard> {
  late final ScrollController _scrollController;
  bool _showScrollIndicator = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateScrollIndicatorVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollIndicatorVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollIndicatorVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateScrollIndicatorVisibility() {
    if (!_scrollController.hasClients) return;

    final bool isScrollable = _scrollController.position.maxScrollExtent > 0;
    final bool isAtBottom = _scrollController.position.pixels >= _scrollController.position.maxScrollExtent;

    final bool shouldShow = isScrollable && !isAtBottom;

    if (_showScrollIndicator != shouldShow) {
      setState(() {
        _showScrollIndicator = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.pageController,
      builder: (context, child) {
        double value = 1.0;
        if (widget.pageController.position.haveDimensions) {
          double page = widget.pageController.page ?? 0.0;
          value = (1 - ((page - widget.pageIndex).abs() * 0.4)).clamp(0.0, 1.0);
        }

        return Transform.scale(scale: value, child: child);
      },
      child: GestureDetector(
        onTap: _selectDeity,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.amber.withAlpha(150), width: 2),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(150), blurRadius: 20, spreadRadius: 5),
              BoxShadow(color: Colors.amber.withAlpha(70), blurRadius: 30, spreadRadius: -10),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.portrait) {
                        return _buildPortraitLayout(context);
                      } else {
                        return _buildLandscapeLayout(context);
                      }
                    },
                  ),
                  if (_showScrollIndicator) ...[
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: IgnorePointer(
                          child: Container(
                            height: constraints.maxHeight * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black.withAlpha(0), Colors.black.withAlpha(100)],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.arrow_downward, color: Colors.white),
                          onPressed: () {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ).animate().scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0), duration: 500.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _buildDeityImage(),
              const SizedBox(height: 20),
              _buildDeityName(),
              const SizedBox(height: 15),
              _buildDeityDescription(),
              const SizedBox(height: 30),
              _buildSelectButton(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.all(20.0), child: _buildDeityImage()),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildDeityName(), const SizedBox(height: 15), _buildDeityDescription(), const SizedBox(height: 30), _buildSelectButton(context)],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeityImage() {
    Widget imageWidget = (widget.deity.videoUrl != null && widget.deity.videoUrl!.isNotEmpty)
        ? CustomVideoPlayer(videoUrl: widget.deity.videoUrl!, placeholderAsset: widget.deity.icon)
        : Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(widget.deity.icon), fit: BoxFit.cover),
            ),
          );

    if (widget.deity.isCollectibleCard) {
      imageWidget = Transform.translate(
        offset: const Offset(0, 18), // 10% of 180px height
        child: Transform.scale(scale: 1.4, child: imageWidget),
      );
    }

    return SizedBox(width: 180, height: 180, child: ClipOval(child: imageWidget));
  }

  Widget _buildDeityName() {
    return Text(
      widget.deity.name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppTextStyles.amaticSC,
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2))],
      ),
    );
  }

  Widget _buildDeityDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        widget.deity.description,
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: AppTextStyles.amarante, fontSize: 18, color: Colors.white.withAlpha(200), height: 1.4),
      ),
    );
  }

  void _selectDeity() async {
    final gamificationService = getIt<GamificationService>();
    final soundService = getIt<SoundService>();
    final navigator = Navigator.of(context);
    await soundService.playCardMusic(widget.deity.id);
    await gamificationService.saveProfileDeityIcon(widget.deity.id);
    if (!mounted) return;
    navigator.pop(widget.deity.id);
  }

  Widget _buildSelectButton(BuildContext context) {
    return ChibiButton(text: 'Choisir', color: Colors.amber, onPressed: _selectDeity);
  }
}
