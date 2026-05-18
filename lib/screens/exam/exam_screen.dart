import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/question.dart';
import '../../models/user_stats.dart';
import '../../models/fish.dart';
import '../../models/rod_setup.dart';
import '../../data/all_questions.dart';
import '../../data/fish_data.dart';
import '../../data/fish_validation.dart';
import '../../data/rod_setups_data.dart';
import '../../providers/stats_provider.dart';
import '../../theme/app_theme.dart';
import 'exam_result_screen.dart';

enum _ExamPhase { written, fishId, rodAssembly }


// ── Alle Varianten je Ruten-Slot ──────────────────────────────────

String _displaySpec(int slotIndex, String spec) {
  if (slotIndex != 0) return spec;
  final idx = spec.indexOf(', Länge:');
  return idx != -1 ? spec.substring(idx + 2) : spec;
}

List<String> _allVariants(int slotIndex) {
  final seen = <String>{};
  for (final s in allRodSetups) seen.add(s.allItems[slotIndex].specification);
  return seen.toList()..sort();
}

// ─────────────────────────────────────────────────────────────────

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});
  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  // ── Schriftlich ─────────────────────────────────────────────────
  late List<Question> _questions;
  late List<int?> _writtenAnswers;
  int _wCurrent = 0;

  // ── Fischbestimmung ─────────────────────────────────────────────
  late List<Fish> _fishToId;
  late List<String?> _fishInputs;
  late List<bool?> _fishResults;
  int _fCurrent = 0;
  final _fishCtrl = TextEditingController();
  final _fishFocus = FocusNode();

  // ── Rutenzusammenstellung ────────────────────────────────────────
  late RodSetup _rodSetup;
  late List<RodSetupItem> _rodItems;
  late List<String?> _rodSelected;   // gewählte Specs
  late List<bool?> _rodResults;
  late List<List<String>> _rodVariants; // alle Optionen pro Slot
  int _rSlot = 0;

  _ExamPhase _phase = _ExamPhase.written;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _fishCtrl.dispose();
    _fishFocus.dispose();
    super.dispose();
  }

  void _init() {
    // Schriftlich: 10 Fragen je Kategorie
    final selected = <Question>[];
    for (final cat in QuestionCategory.values) {
      final pool = getQuestionsByCategory(cat)..shuffle(_rng);
      selected.addAll(pool.take(10));
    }
    selected.shuffle(_rng);
    _questions = selected;
    _writtenAnswers = List.filled(60, null);

    // Fischbestimmung: 6 zufällige Fische
    final fishPool = List<Fish>.from(allFish)..shuffle(_rng);
    _fishToId = fishPool.take(6).toList();
    _fishInputs = List.filled(6, null);
    _fishResults = List.filled(6, null);

    // Rute: eine zufällige Aufgabe
    _rodSetup = allRodSetups[_rng.nextInt(allRodSetups.length)];
    _rodItems = _rodSetup.allItems;
    _rodSelected = List.filled(16, null);
    _rodResults = List.filled(16, null);
    _rodVariants = List.generate(16, (i) => _allVariants(i));
    _rSlot = 0;
  }

  // ── Schriftlich ─────────────────────────────────────────────────

  void _answerWritten(int idx) {
    if (_writtenAnswers[_wCurrent] != null) return;
    setState(() => _writtenAnswers[_wCurrent] = idx);
  }

  void _nextWritten() {
    if (_wCurrent < 59) {
      setState(() => _wCurrent++);
    } else {
      setState(() { _phase = _ExamPhase.fishId; _fishCtrl.clear(); });
      Future.delayed(const Duration(milliseconds: 300),
          () { if (mounted) _fishFocus.requestFocus(); });
    }
  }

  // ── Fischbestimmung ─────────────────────────────────────────────

  void _submitFish() {
    if (_fishResults[_fCurrent] != null) return;
    final input = _fishCtrl.text.trim();
    final ok = isFishAnswerCorrect(_fishToId[_fCurrent], input);
    setState(() {
      _fishInputs[_fCurrent] = input.isEmpty ? '(keine Eingabe)' : input;
      _fishResults[_fCurrent] = ok;
    });
    _fishFocus.unfocus();
  }

  void _skipFish() {
    if (_fishResults[_fCurrent] != null) return;
    setState(() {
      _fishInputs[_fCurrent] = '(nicht gewusst)';
      _fishResults[_fCurrent] = false;
    });
    _fishFocus.unfocus();
  }

  void _nextFish() {
    if (_fCurrent < _fishToId.length - 1) {
      setState(() { _fCurrent++; _fishCtrl.clear(); });
      Future.delayed(const Duration(milliseconds: 300),
          () { if (mounted) _fishFocus.requestFocus(); });
    } else {
      setState(() => _phase = _ExamPhase.rodAssembly);
    }
  }

  // ── Rute ────────────────────────────────────────────────────────

  void _selectRod(String spec) {
    if (_rodSelected[_rSlot] != null) return;
    final ok = spec == _rodItems[_rSlot].specification;
    setState(() {
      _rodSelected[_rSlot] = spec;
      _rodResults[_rSlot] = ok;
    });
  }

  void _nextRod() {
    if (_rSlot < _rodItems.length - 1) {
      setState(() => _rSlot++);
    } else {
      _finish();
    }
  }

  // ── Abschluss ───────────────────────────────────────────────────

  void _finish() {
    final prov = context.read<StatsProvider>();

    int writtenCorrect = 0;
    final catResults = <QuestionCategory, int>{
      for (final c in QuestionCategory.values) c: 0
    };
    for (int i = 0; i < _questions.length; i++) {
      final ok = _writtenAnswers[i] == _questions[i].correctAnswerIndex;
      if (ok) {
        writtenCorrect++;
        catResults[_questions[i].category] =
            catResults[_questions[i].category]! + 1;
      }
      if (_writtenAnswers[i] != null) {
        prov.recordAnswer(
          questionId: _questions[i].id,
          category: _questions[i].category,
          correct: ok,
        );
      }
    }

    final fishCorrect = _fishResults.where((r) => r == true).length;
    final rodCorrect = _rodResults.where((r) => r == true).length;

    final writtenPass =
        writtenCorrect >= 45 && catResults.values.every((v) => v >= 6);
    final fishPass = fishCorrect >= 4;
    // Vereinfachte Punkte: jede korrekte Komponente = ~3 Pkt (max 28 → ≥25)
    final rodPoints = _estimateRodPoints();
    final rodPass = rodPoints >= 25;

    prov.addExamAttempt(ExamAttempt(
      date: DateTime.now(),
      totalQuestions: _questions.length,
      correctAnswers: writtenCorrect,
      passed: writtenPass && fishPass && rodPass,
    ));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(
          questions: _questions,
          writtenAnswers: _writtenAnswers,
          fishToId: _fishToId,
          fishInputs: _fishInputs,
          fishResults: _fishResults,
          categoryCorrect: catResults,
          rodSetup: _rodSetup,
          rodResults: _rodResults,
          rodPoints: rodPoints,
        ),
      ),
    );
  }

  int _estimateRodPoints() {
    const highValue = {0, 1, 2, 5}; // Rute, Rolle, Schnur, Vorfach = 3 Pkt
    int pts = 0;
    for (int i = 0; i < 9; i++) {
      if (_rodResults[i] == true) pts += highValue.contains(i) ? 3 : 1;
    }
    // Zubehör (Slots 9–15): Landehilfe=2, Messen=2, Betäuben=2, Töten=2,
    //                        Rachensperre=1, Haken=1, Reihenfolge=2
    const accPts = [2, 2, 2, 2, 1, 1, 2];
    for (int i = 0; i < 7; i++) {
      if (i + 9 < _rodResults.length && _rodResults[i + 9] == true) {
        pts += accPts[i];
      }
    }
    return pts.clamp(0, 28);
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _ExamPhase.written:    return _buildWritten();
      case _ExamPhase.fishId:     return _buildFishId();
      case _ExamPhase.rodAssembly: return _buildRod();
    }
  }

  // ── Schriftlicher Teil ───────────────────────────────────────────

  Widget _buildWritten() {
    final q = _questions[_wCurrent];
    final answered = _writtenAnswers[_wCurrent];
    final answeredCount = _writtenAnswers.where((a) => a != null).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teil 1 – Schriftliche Prüfung'),
        actions: [
          TextButton(
            onPressed: () =>
                setState(() => _phase = _ExamPhase.fishId),
            child: const Text('Weiter →',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_wCurrent + 1) / 60,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: AppTheme.primaryGreen,
            minHeight: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_wCurrent + 1} / 60',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(q.category.displayName,
                    style: TextStyle(
                        color: _catColor(q.category),
                        fontWeight: FontWeight.w600,
                        fontSize: 11)),
                Text('$answeredCount beantwortet',
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(q.question,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(q.options.length,
                      (i) => _answerTile(
                            label: ['a', 'b', 'c'][i],
                            text: q.options[i],
                            selected: answered == i,
                            correct: answered != null && i == q.correctAnswerIndex,
                            wrong: answered == i && i != q.correctAnswerIndex,
                            onTap: answered == null ? () => _answerWritten(i) : null,
                          )),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  if (_wCurrent > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => _wCurrent--),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Zurück'),
                      ),
                    ),
                  if (_wCurrent > 0) const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: answered != null ? _nextWritten : null,
                      icon: const Icon(Icons.arrow_forward),
                      label: Text(_wCurrent == 59
                          ? 'Zur Fischbestimmung'
                          : 'Weiter'),
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

  // ── Fischbestimmung ──────────────────────────────────────────────

  Widget _buildFishId() {
    final fish = _fishToId[_fCurrent];
    final submitted = _fishResults[_fCurrent] != null;
    final wasCorrect = _fishResults[_fCurrent];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teil 2 – Fischbestimmung'),
        backgroundColor: AppTheme.waterBlue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_fCurrent + 1} / 6',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _infoBar('Welcher Fisch ist abgebildet? (mind. 4 von 6 richtig)', AppTheme.waterBlue),
          LinearProgressIndicator(
            value: (_fCurrent + 1) / 6,
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
                  Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: fish.imagePath != null
                          ? Image.asset(fish.imagePath!,
                              height: 200, fit: BoxFit.contain)
                          : Container(
                              height: 160,
                              color: AppTheme.waterBlue.withValues(alpha: 0.08),
                              child: const Icon(Icons.set_meal,
                                  size: 80, color: AppTheme.waterBlue),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _fishCtrl,
                    focusNode: _fishFocus,
                    enabled: !submitted,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitFish(),
                    decoration: InputDecoration(
                      hintText: 'Deutschen Fischnamen eingeben…',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: !submitted
                          ? Theme.of(context).colorScheme.surfaceContainerHighest
                          : wasCorrect == true
                              ? AppColors.correct.withValues(alpha: 0.08)
                              : AppColors.incorrect.withValues(alpha: 0.08),
                      prefixIcon: const Icon(Icons.edit),
                      suffixIcon: submitted
                          ? Icon(
                              wasCorrect == true
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: wasCorrect == true
                                  ? AppColors.correct
                                  : AppColors.incorrect)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (submitted)
                    _ExamFishReveal(
                      fish: fish,
                      wasCorrect: wasCorrect!,
                      userInput: _fishInputs[_fCurrent] ?? '',
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  if (!submitted) ...[
                    Expanded(
                      child: OutlinedButton(
                          onPressed: _skipFish,
                          child: const Text('Nicht gewusst')),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _submitFish,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.waterBlue),
                        child: const Text('Bestätigen'),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextFish,
                        icon: Icon(_fCurrent == 5
                            ? Icons.arrow_forward
                            : Icons.arrow_forward),
                        label: Text(_fCurrent == 5
                            ? 'Zur Rutenzusammenstellung'
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

  // ── Rutenzusammenstellung ────────────────────────────────────────

  Widget _buildRod() {
    final item = _rodItems[_rSlot];
    final correctSpec = item.specification;
    final selected = _rodSelected[_rSlot];
    final variants = _rodVariants[_rSlot];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teil 3 – Rutenzusammenstellung'),
        backgroundColor: AppTheme.sandBrown,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text('${_rSlot + 1} / ${_rodItems.length}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _infoBar(
            '${_rodSetup.rodType}  –  für ${_rodSetup.targetFish}',
            AppTheme.sandBrown,
          ),
          LinearProgressIndicator(
            value: (_rSlot + 1) / _rodItems.length,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: AppTheme.sandBrown,
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bisherige Slots
                  if (_rSlot > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Wrap(
                        spacing: 6, runSpacing: 4,
                        children: List.generate(_rSlot, (i) {
                          final ok = _rodResults[i] == true;
                          return Chip(
                            avatar: Icon(ok ? Icons.check : Icons.close,
                                size: 14,
                                color: ok ? AppColors.correct : AppColors.incorrect),
                            label: Text(_rodItems[i].component,
                                style: const TextStyle(fontSize: 11)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            backgroundColor: (ok ? AppColors.correct : AppColors.incorrect)
                                .withValues(alpha: 0.1),
                          );
                        }),
                      ),
                    ),

                  // Aktuelle Frage
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                                color: AppTheme.sandBrown, shape: BoxShape.circle),
                            child: Center(
                              child: Text('${item.number}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.component,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('Welche ${item.component}?',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Alle Varianten
                  ...variants.map((spec) {
                    final isCorrect = spec == correctSpec;
                    final isSelected = selected == spec;
                    Color? bg; Color? border;
                    if (selected != null) {
                      if (isCorrect) {
                        bg = AppColors.correct.withValues(alpha: 0.15);
                        border = AppColors.correct;
                      } else if (isSelected) {
                        bg = AppColors.incorrect.withValues(alpha: 0.15);
                        border = AppColors.incorrect;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: selected == null ? () => _selectRod(spec) : null,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
                            border: Border.all(
                                color: border ?? Theme.of(context).colorScheme.outlineVariant, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(_displaySpec(_rSlot, spec),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isCorrect && selected != null
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: selected != null && isCorrect
                                          ? AppColors.correct
                                          : selected != null && isSelected
                                              ? AppColors.incorrect
                                              : null,
                                    )),
                              ),
                              if (selected != null && isCorrect)
                                const Icon(Icons.check_circle,
                                    color: AppColors.correct, size: 20),
                              if (selected != null && isSelected && !isCorrect)
                                const Icon(Icons.cancel,
                                    color: AppColors.incorrect, size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: selected != null ? _nextRod : null,
                  icon: Icon(_rSlot >= _rodItems.length - 1 ? Icons.flag : Icons.arrow_forward),
                  label: Text(_rSlot >= _rodItems.length - 1 ? 'Prüfung auswerten' : 'Nächste Komponente'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sandBrown),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Hilfsmethoden ────────────────────────────────────────────────

  Widget _infoBar(String text, Color color) => Container(
        color: color.withValues(alpha: 0.12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: double.infinity,
        child: Text(text,
            style: TextStyle(
                fontSize: 13, color: color, fontWeight: FontWeight.w600)),
      );

  Widget _answerTile({
    required String label, required String text,
    required bool selected, required bool correct, required bool wrong,
    required VoidCallback? onTap,
  }) {
    Color? bg; Color? border;
    if (correct) { bg = AppColors.correct.withValues(alpha: 0.15); border = AppColors.correct; }
    else if (wrong) { bg = AppColors.incorrect.withValues(alpha: 0.15); border = AppColors.incorrect; }
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
            border: Border.all(color: border ?? Theme.of(context).colorScheme.outlineVariant, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: (border ?? Theme.of(context).colorScheme.onSurfaceVariant).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                        color: border ?? Theme.of(context).colorScheme.onSurfaceVariant))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
              if (correct) const Icon(Icons.check_circle, color: AppColors.correct),
              if (wrong) const Icon(Icons.cancel, color: AppColors.incorrect),
            ],
          ),
        ),
      ),
    );
  }

  Color _catColor(QuestionCategory cat) {
    switch (cat) {
      case QuestionCategory.allgemeineFischkunde:  return AppColors.categoryA;
      case QuestionCategory.spezielleFischkunde:   return AppColors.categoryB;
      case QuestionCategory.gewaesserkunde:        return AppColors.categoryC;
      case QuestionCategory.naturUndTierschutz:    return AppColors.categoryD;
      case QuestionCategory.geraetekunde:          return AppColors.categoryE;
      case QuestionCategory.gesetzeskunde:         return AppColors.categoryF;
    }
  }
}

// ── Fisch-Auflösung ──────────────────────────────────────────────

class _ExamFishReveal extends StatelessWidget {
  final Fish fish;
  final bool wasCorrect;
  final String userInput;
  const _ExamFishReveal(
      {required this.fish, required this.wasCorrect, required this.userInput});

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
          Row(children: [
            Icon(wasCorrect ? Icons.check_circle : Icons.cancel,
                color: color, size: 20),
            const SizedBox(width: 8),
            Text(wasCorrect ? 'Richtig!' : 'Falsch – richtige Antwort:',
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          ]),
          const SizedBox(height: 8),
          Text(fish.germanName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(fish.latinName,
              style: TextStyle(fontStyle: FontStyle.italic,
                  fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          if (!wasCorrect && userInput.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text('Deine Eingabe: "$userInput"',
                style: const TextStyle(color: AppColors.incorrect, fontSize: 13)),
          ],
          if (!wasCorrect && fish.mnemonicHint != null) ...[
            const SizedBox(height: 8),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.lightbulb, size: 15, color: AppTheme.hintAmber),
              const SizedBox(width: 4),
              Expanded(child: Text(fish.mnemonicHint!,
                  style: const TextStyle(fontSize: 13,
                      color: AppTheme.hintAmber, fontWeight: FontWeight.w500))),
            ]),
          ],
        ],
      ),
    );
  }
}
