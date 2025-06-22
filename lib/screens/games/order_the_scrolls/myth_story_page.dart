import 'package:flutter/material.dart';
import 'package:personal_oracle/screens/games/order_the_scrolls/model.dart';

class MythStoryPage extends StatelessWidget {
  final MythStory mythStory;

  const MythStoryPage({Key? key, required this.mythStory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.deepPurple,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                mythStory.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final card = mythStory.correctOrder[index];
                return _buildCardSection(context, card, index);
              },
              childCount: mythStory.correctOrder.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardSection(BuildContext context, MythCard card, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre en gros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Text(
              card.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade800,
              ),
            ),
          ),
          
          // Image avec effet parallax
          SizedBox(
            height: 300,
            child: ParallaxImage(
              imagePath: card.imagePath,
              index: index,
            ),
          ),
          
          // Histoire détaillée
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              card.detailedStory,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontSize: 16,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
          
          // Séparateur
          if (index < mythStory.correctOrder.length - 1)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40.0),
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.deepPurple.shade200,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ParallaxImage extends StatefulWidget {
  final String imagePath;
  final int index;

  const ParallaxImage({
    Key? key,
    required this.imagePath,
    required this.index,
  }) : super(key: key);

  @override
  State<ParallaxImage> createState() => _ParallaxImageState();
}

class _ParallaxImageState extends State<ParallaxImage> {
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          // Image de fond avec effet parallax
          _buildParallaxBackground(context),
          
          // Overlay gradient pour améliorer la lisibilité
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.asset(
          widget.imagePath,
          key: _backgroundImageKey,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 350, // Hauteur plus grande pour l'effet parallax
        ),
      ],
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(
      width: constraints.maxWidth,
    );
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calcul de l'offset parallax
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(0.0, 1.0);

    // Applique l'effet parallax
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);
    final backgroundSize = (backgroundImageKey.currentContext!.findRenderObject() as RenderBox).size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(backgroundSize, Offset.zero & listItemSize);

    context.paintChild(
      0,
      transform: Transform.translate(offset: Offset(0.0, childRect.top)).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
           listItemContext != oldDelegate.listItemContext ||
           backgroundImageKey != oldDelegate.backgroundImageKey;
  }
}