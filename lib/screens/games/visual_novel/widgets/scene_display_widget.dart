import 'package:flutter/material.dart';
import '../models/visual_novel_models.dart';
import 'choice_widget.dart';

class SceneDisplayWidget extends StatefulWidget {
  final Scene scene;
  final Function(Choice) onChoiceMade;
  final Function(String) onSceneProgression;
  final VoidCallback onScenarioComplete;
  final VisualNovelGameState gameState;

  const SceneDisplayWidget({
    Key? key,
    required this.scene,
    required this.onChoiceMade,
    required this.onSceneProgression,
    required this.onScenarioComplete,
    required this.gameState,
  }) : super(key: key);

  @override
  State<SceneDisplayWidget> createState() => _SceneDisplayWidgetState();
}

class _SceneDisplayWidgetState extends State<SceneDisplayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;

  List<String> _sentences = [];
  int _currentSentenceIndex = 0;
  bool _isTextComplete = false;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textController.forward();

    // Split text into sentences
    _splitTextIntoSentences();
  }

  @override
  void didUpdateWidget(SceneDisplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene.id != widget.scene.id) {
      _textController.reset();
      _textController.forward();
      _splitTextIntoSentences();
      _currentSentenceIndex = 0;
      _isTextComplete = false;
    }
  }

  void _splitTextIntoSentences() {
    if (widget.scene.hasDialogues) {
      // For dialogue scenes, each dialogue line is a "sentence"
      _sentences = widget.scene.dialogues!.map((d) => d.text).toList();
    } else {
      // For non-dialogue scenes, split content into sentences
      String text = widget.scene.content;
      List<String> rawSentences = text
          .split(RegExp(r'(?<=[.!?])\s+|(?<=\*[^*]+\*)\s*'))
          .where((s) => s.trim().isNotEmpty)
          .toList();

      _sentences = rawSentences.map((s) => s.trim()).toList();

      if (_sentences.isEmpty) {
        _sentences = [text]; // Fallback to full text
      }
    }
  }

  void _advanceText() {
    setState(() {
      if (_currentSentenceIndex < _sentences.length - 1) {
        _currentSentenceIndex++;
      } else {
        _isTextComplete = true;
      }
    });
  }

  String _getCurrentText() {
    if (_currentSentenceIndex < _sentences.length) {
      return _sentences[_currentSentenceIndex];
    }
    return '';
  }

  String _getCurrentSpeaker() {
    if (widget.scene.hasDialogues && _currentSentenceIndex < widget.scene.dialogues!.length) {
      return widget.scene.dialogues![_currentSentenceIndex].speaker;
    }
    return widget.scene.speaker ?? 'Narrateur';
  }

  String? _getCurrentCharacterImage() {
    if (widget.scene.hasDialogues && _currentSentenceIndex < widget.scene.dialogues!.length) {
      return widget.scene.dialogues![_currentSentenceIndex].characterImage;
    }
    return widget.scene.characterImage;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_isTextComplete) {
          _advanceText();
        } else {
          // If text is complete, handle scene progression
          if (widget.scene.choices == null) {
            if (widget.scene.nextSceneId != null) {
              widget.onSceneProgression(widget.scene.nextSceneId!);
            } else {
              // No next scene = ending reached
              widget.onScenarioComplete();
            }
          }
        }
      },
      child: Container(
      decoration: BoxDecoration(
        image: widget.scene.backgroundImage != null
            ? DecorationImage(
                image: AssetImage(widget.scene.backgroundImage!),
                fit: BoxFit.cover,
              )
            : null,
        gradient: widget.scene.backgroundImage == null
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1a237e), Color(0xFF000051)],
              )
            : null,
      ),
      child: Stack(
        children: [
          // Background overlay for text readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Character sprite (changes with speaker)
          if (_getCurrentCharacterImage() != null)
            Positioned(
              right: 20,
              bottom: 100,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Image.asset(
                  _getCurrentCharacterImage()!,
                  height: 400,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 200,
                      height: 400,
                      color: Colors.grey.withOpacity(0.3),
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.white54,
                      ),
                    );
                  },
                ),
              ),
            ),

          // VN Text Box at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFd4af37).withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scene title (only show initially)
                    if (_currentSentenceIndex == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          widget.scene.title,
                          style: const TextStyle(
                            color: Color(0xFFd4af37),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Speaker name (always show for dialogues)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _getCurrentSpeaker(),
                        style: TextStyle(
                          color: _getCurrentSpeaker() == 'Narrateur'
                              ? Colors.white.withOpacity(0.8)
                              : const Color(0xFFd4af37),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: _getCurrentSpeaker() == 'Narrateur'
                              ? FontStyle.italic
                              : FontStyle.normal,
                        ),
                      ),
                    ),

                    // Current text content
                    Container(
                      constraints: const BoxConstraints(minHeight: 80),
                      width: double.infinity,
                      child: Text(
                        _getCurrentText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Bottom indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text progress indicator
                        Text(
                          '${_currentSentenceIndex + 1} / ${_sentences.length}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),

                        // Continue indicator
                        if (!_isTextComplete)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Cliquez pour continuer',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.touch_app,
                                size: 16,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ],
                          ),
                      ],
                    ),

                    // Choices (show when text is complete)
                    if (_isTextComplete && widget.scene.choices != null) ...[
                      const SizedBox(height: 16),
                      ...widget.scene.choices!.map(
                        (choice) => ChoiceWidget(
                          choice: choice,
                          onSelected: widget.onChoiceMade,
                          emotionalState: widget.gameState.emotionalState,
                        ),
                      ),
                    ],

                    // Next scene indicator (when text complete and no choices)
                    if (_isTextComplete && widget.scene.choices == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.scene.nextSceneId != null
                                  ? 'Cliquez pour continuer vers la scène suivante'
                                  : 'Cliquez pour terminer l\'histoire',
                              style: TextStyle(
                                color: const Color(0xFFd4af37).withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              widget.scene.nextSceneId != null
                                  ? Icons.arrow_forward
                                  : Icons.check_circle,
                              size: 16,
                              color: const Color(0xFFd4af37).withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}