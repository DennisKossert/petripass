import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/fish_data.dart';
import '../../data/fish_validation.dart';
import '../../models/fish.dart';
import '../../theme/app_theme.dart';

class FishQuizScreen extends StatefulWidget {
  const FishQuizScreen({super.key});

  @override
  State<FishQuizScreen> createState() => _FishQuizScreenState();
}

class _FishQuizScreenState extends State<FishQuizScreen> {
  late List<Fish> _pool;
  int _current = 0;
  int _correct = 0;

  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  bool? _wasCorrect; // null = noch nicht abgegeben

  @override
  void initState() {
    super.initState();
    _pool = List.from(allFish)..shuffle(Random());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Fish get _fish => _pool[_current];

  void _submit() {
    if (_wasCorrect != null) return;
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final ok = isFishAnswerCorrect(_fish, input);
    setState(() {
      _wasCorrect = ok;
      if (ok) _correct++;
    });
    _focusNode.unfocus();
  }

  void _next() {
    if (_current >= _pool.length - 1) {
      _showResult();
      return;
    }
    setState(() {
      _current++;
      _wasCorrect = null;
      _controller.clear();
    });
    // Kurze Verzögerung, dann Tastatur öffnen
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void _skip() {
    if (_wasCorrect != null) return;
    setState(() => _wasCorrect = false);
    _focusNode.unfocus();
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Quiz beendet!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$_correct / ${_pool.length}',
              style: const TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.waterBlue),
            ),
            Text(
              '${(_correct / _pool.length * 100).toStringAsFixed(0)}% richtig benannt',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Beenden'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _pool.shuffle(Random());
                _current = 0;
                _correct = 0;
                _wasCorrect = null;
                _controller.clear();
              });
            },
            child: const Text('Nochmal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fish = _fish;
    final answered = _wasCorrect;
    final valid = validFishAnswers(fish);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcher Fisch ist das?'),
        backgroundColor: AppTheme.waterBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_current + 1} / ${_pool.length}  •  $_correct ✓',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_current + 1) / _pool.length,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: AppTheme.waterBlue,
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Bild
                  Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: fish.imagePath != null
                          ? Image.asset(
                              fish.imagePath!,
                              height: 200,
                              fit: BoxFit.contain,
                            )
                          : Container(
                              height: 160,
                              color: AppTheme.waterBlue.withValues(alpha: 0.08),
                              child: const Icon(Icons.set_meal,
                                  size: 80, color: AppTheme.waterBlue),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hinweis: Familie als einziger Tipp
                  if (fish.family != null)
                    Center(
                      child: Chip(
                        label: Text('Familie: ${fish.family}',
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor:
                            AppTheme.waterBlue.withValues(alpha: 0.1),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Eingabefeld
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: answered == null,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      hintText: 'Deutschen Fischnamen eingeben…',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: answered == null
                          ? Theme.of(context).colorScheme.surfaceContainerHighest
                          : answered == true
                              ? AppColors.correct.withValues(alpha: 0.08)
                              : AppColors.incorrect.withValues(alpha: 0.08),
                      prefixIcon: const Icon(Icons.edit),
                      suffixIcon: answered == null
                          ? null
                          : Icon(
                              answered ? Icons.check_circle : Icons.cancel,
                              color: answered
                                  ? AppColors.correct
                                  : AppColors.incorrect,
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Auflösung nach Antwort
                  if (answered != null)
                    _AnswerReveal(
                      fish: fish,
                      wasCorrect: answered,
                      validAnswers: valid,
                    ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (answered == null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _skip,
                        child: const Text('Nicht gewusst'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.waterBlue),
                        child: const Text('Bestätigen'),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _next,
                        icon: Icon(_current >= _pool.length - 1
                            ? Icons.flag
                            : Icons.arrow_forward),
                        label: Text(_current >= _pool.length - 1
                            ? 'Auswertung'
                            : 'Nächster Fisch'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.waterBlue),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerReveal extends StatelessWidget {
  final Fish fish;
  final bool wasCorrect;
  final List<String> validAnswers;

  const _AnswerReveal({
    required this.fish,
    required this.wasCorrect,
    required this.validAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final color = wasCorrect ? AppColors.correct : AppColors.incorrect;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(wasCorrect ? Icons.check_circle : Icons.cancel,
                  color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  wasCorrect ? 'Richtig!' : 'Leider falsch.',
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(fish.germanName,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold)),
          Text(fish.latinName,
              style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.grey)),
          // Gültige Alternativnamen
          if (validAnswers.length > 1) ...[
            const SizedBox(height: 6),
            Text(
              'Akzeptierte Namen: ${validAnswers.map(_capitalize).join(', ')}',
              style:
                  const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
          // Eselsbrücke – nur bei falscher Antwort
          if (!wasCorrect && fish.mnemonicHint != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb,
                    size: 16, color: AppTheme.hintAmber),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(fish.mnemonicHint!,
                      style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.hintAmber,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ],
          // Merkmale
          if (!wasCorrect && fish.characteristics.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...fish.characteristics.take(3).map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text('• $c',
                      style: const TextStyle(fontSize: 13)),
                )),
          ],
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
