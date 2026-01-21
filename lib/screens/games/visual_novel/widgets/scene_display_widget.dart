import 'package:flutter/material.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/models/visual_novel_models.dart';
import 'package:oracle_d_asgard/screens/games/visual_novel/widgets/choice_widget.dart';

class SceneDisplayWidget extends StatefulWidget {
  final Scene scene;
  final Function(Choice) onChoiceMade;
  final Function(String) onSceneProgression;
  final VoidCallback onScenarioComplete;
  final VisualNovelGameState gameState;

  const SceneDisplayWidget({
    super.key,
    required this.scene,
    required this.onChoiceMade,
    required this.onSceneProgression,
    required this.onScenarioComplete,
    required this.gameState,
  });

  @override
  State<SceneDisplayWidget> createState() => _SceneDisplayWidgetState();
}

class _SceneDisplayWidgetState extends State<SceneDisplayWidget> with SingleTickerProviderStateMixin {
  late AnimationController _textController;
  late Animation<double> _fadeAnimation;

  List<String> _sentences = [];
  int _currentSentenceIndex = 0;
  
  // Computed property: text is complete when on the last sentence
  bool get _isTextComplete => _currentSentenceIndex >= _sentences.length - 1;

  @override
  void initState() {
    super.initState();
    _textController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
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
    }
  }

  void _splitTextIntoSentences() {
    if (widget.scene.hasDialogues) {
      // For dialogue scenes, each dialogue line is a "sentence"
      _sentences = widget.scene.dialogues!.map((d) => d.text).toList();
    } else if (widget.scene.hasParagraphs) {
      // For narrative scenes with paragraphs array, use them directly
      _sentences = List.from(widget.scene.paragraphs!);
    } else if (widget.scene.content != null && widget.scene.content!.isNotEmpty) {
      // For choice scenes, use the content as a single sentence
      _sentences = [widget.scene.content!];
      // For choice scenes, start at last index to show choices immediately
      if (widget.scene.choices != null && widget.scene.choices!.isNotEmpty) {
        _currentSentenceIndex = _sentences.length - 1;
      }
    } else {
      // Fallback: empty list
      _sentences = [];
    }
  }

  void _advanceText() {
    setState(() {
      if (_currentSentenceIndex < _sentences.length - 1) {
        _currentSentenceIndex++;
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
          image: widget.scene.backgroundImage != null ? DecorationImage(image: AssetImage(widget.scene.backgroundImage!), fit: BoxFit.cover) : null,
          gradient: widget.scene.backgroundImage == null
              ? const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1a237e), Color(0xFF000051)])
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
                  colors: [Colors.black.withAlpha(76), Colors.black.withAlpha(178)],
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
                        color: Colors.grey.withAlpha(76),
                        child: const Icon(Icons.person, size: 100, color: Colors.white54),
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
                  color: Colors.black.withAlpha(217),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFd4af37).withAlpha(153), width: 1.5),
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
                            style: const TextStyle(color: Color(0xFFd4af37), fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),

                      // Speaker name (always show for dialogues)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _getCurrentSpeaker(),
                          style: TextStyle(
                            color: _getCurrentSpeaker() == 'Narrateur' ? Colors.white.withAlpha(204) : const Color(0xFFd4af37),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontStyle: _getCurrentSpeaker() == 'Narrateur' ? FontStyle.italic : FontStyle.normal,
                          ),
                        ),
                      ),

                      // Current text content
                      Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        width: double.infinity,
                        child: Text(_getCurrentText(), style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4)),
                      ),

                      const SizedBox(height: 16),

                      // Bottom indicators
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text progress indicator
                          Text('${_currentSentenceIndex + 1} / ${_sentences.length}', style: TextStyle(color: Colors.white.withAlpha(153), fontSize: 12)),

                          // Continue indicator
                          if (!_isTextComplete)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Cliquez pour continuer',
                                  style: TextStyle(color: Colors.white.withAlpha(178), fontSize: 12, fontStyle: FontStyle.italic),
                                ),
                                const SizedBox(width: 4),
                                Icon(Icons.touch_app, size: 16, color: Colors.white.withAlpha(178)),
                              ],
                            ),
                        ],
                      ),

                      // Choices (show when text is complete)
                      if (widget.scene.choices != null) ...[
                        const SizedBox(height: 16),
                        ...widget.scene.choices!.map(
                          (choice) => ChoiceWidget(choice: choice, onSelected: widget.onChoiceMade, emotionalState: widget.gameState.emotionalState),
                        ),
                      ],

                      // Next scene indicator (when text complete and no choices)
                      if (_isTextComplete && widget.scene.choices == null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.scene.nextSceneId != null ? 'Continuer' : 'Terminer',
                                  style: TextStyle(color: const Color(0xFFd4af37).withAlpha(204), fontSize: 14, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                widget.scene.nextSceneId != null ? Icons.arrow_forward : Icons.check_circle,
                                size: 16,
                                color: const Color(0xFFd4af37).withAlpha(204),
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
