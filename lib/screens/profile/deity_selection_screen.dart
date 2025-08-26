import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oracle_d_asgard/data/app_data.dart';
import 'package:oracle_d_asgard/models/deity.dart';
import 'package:oracle_d_asgard/services/gamification_service.dart';
import 'package:oracle_d_asgard/utils/text_styles.dart';
import 'package:oracle_d_asgard/widgets/app_background.dart';
import 'package:oracle_d_asgard/widgets/chibi_app_bar.dart';
import 'package:oracle_d_asgard/widgets/chibi_button.dart';
import 'package:provider/provider.dart';

class DeitySelectionScreen extends StatefulWidget {
  final String currentDeityId;

  const DeitySelectionScreen({super.key, required this.currentDeityId});

  @override
  State<DeitySelectionScreen> createState() => _DeitySelectionScreenState();
}

class _DeitySelectionScreenState extends State<DeitySelectionScreen> {
  late final PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    final deities = AppData.deities.values.toList();
    _currentPage = deities.indexWhere((d) => d.id == widget.currentDeityId);
    if (_currentPage == -1) _currentPage = 0;

    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deities = AppData.deities.values.toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: ChibiAppBar(titleText: 'Choisir une Divinité'),
      body: AppBackground(
        child: Padding(
          padding: EdgeInsets.only(top: kToolbarHeight + MediaQuery.of(context).padding.top),
          child: Stack(
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
              _buildNavigationArrow(isLeft: true, onPressed: () {
                _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }),
              _buildNavigationArrow(isLeft: false, onPressed: () {
                _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationArrow({required bool isLeft, required VoidCallback onPressed}) {
    return Positioned(
      left: isLeft ? 10 : null,
      right: isLeft ? null : 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(120),
          shape: BoxShape.circle,
        ),
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

class _DeityCardState extends State<_DeityCard> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(100),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.amber.withAlpha(150), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(150),
                blurRadius: 20,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: Colors.amber.withAlpha(70),
                blurRadius: 30,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildDeityImage(),
              const SizedBox(height: 20),
              _buildDeityName(),
              const SizedBox(height: 15),
              _buildDeityDescription(),
              const Spacer(),
              _buildSelectButton(context),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeityImage() {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: AssetImage(widget.deity.icon), fit: BoxFit.cover),
        border: Border.all(color: Colors.amber, width: 6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(200),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
    );
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
        shadows: [
          const Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2)),
        ],
      ),
    );
  }

  Widget _buildDeityDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        widget.deity.description,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: AppTextStyles.amarante,
          fontSize: 18,
          color: Colors.white.withAlpha(200),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildSelectButton(BuildContext context) {
    return ChibiButton(
      text: 'Choisir',
      color: Colors.amber,
      onPressed: () async {
        HapticFeedback.mediumImpact();
        final gamificationService = Provider.of<GamificationService>(context, listen: false);
        final navigator = Navigator.of(context);
        await gamificationService.saveProfileDeityIcon(widget.deity.id);
        if (!mounted) return;
        navigator.pop(widget.deity.id);
      },
    );
  }
}