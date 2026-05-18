import 'package:flutter/material.dart';
import '../../models/question.dart';
import '../../models/fish.dart';
import '../../models/rod_setup.dart';
import '../../theme/app_theme.dart';
import '../home_screen.dart';

class ExamResultScreen extends StatelessWidget {
  final List<Question> questions;
  final List<int?> writtenAnswers;
  final List<Fish> fishToId;
  final List<String?> fishInputs;
  final List<bool?> fishResults;
  final Map<QuestionCategory, int> categoryCorrect;
  final RodSetup rodSetup;
  final List<bool?> rodResults;
  final int rodPoints;

  const ExamResultScreen({
    super.key,
    required this.questions,
    required this.writtenAnswers,
    required this.fishToId,
    required this.fishInputs,
    required this.fishResults,
    required this.categoryCorrect,
    required this.rodSetup,
    required this.rodResults,
    required this.rodPoints,
  });

  @override
  Widget build(BuildContext context) {
    // ── Auswertung ────────────────────────────────────────────────
    int writtenCorrect = 0;
    final wrongQuestions = <Map<String, dynamic>>[];
    for (int i = 0; i < questions.length; i++) {
      final ok = writtenAnswers[i] == questions[i].correctAnswerIndex;
      if (ok) writtenCorrect++;
      else wrongQuestions.add({'q': questions[i], 'a': writtenAnswers[i]});
    }
    final fishCorrect = fishResults.where((r) => r == true).length;
    final rodCorrect = rodResults.where((r) => r == true).length;

    final writtenCatPass = categoryCorrect.values.every((v) => v >= 6);
    final writtenPass = writtenCorrect >= 45 && writtenCatPass;
    final fishPass = fishCorrect >= 4;
    final rodPass = rodPoints >= 25;
    final passed = writtenPass && fishPass && rodPass;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Prüfungsauswertung'),
          automaticallyImplyLeading: false),
      body: ListView(
        children: [
          // ── Gesamtergebnis ────────────────────────────────────────
          Container(
            color: passed ? AppColors.correct : AppColors.incorrect,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(passed ? Icons.emoji_events : Icons.close_rounded,
                    size: 64, color: Colors.white),
                const SizedBox(height: 10),
                Text(passed ? 'Probeprüfung bestanden!' : 'Nicht bestanden',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Pill('Schriftlich', '$writtenCorrect/60', writtenPass),
                    _Pill('Fischbestimmung', '$fishCorrect/6', fishPass),
                    _Pill('Rute', '$rodPoints/28 P.', rodPass),
                  ],
                ),
              ],
            ),
          ),

          // ── Schriftlicher Teil ────────────────────────────────────
          _Section(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('Schriftlicher Teil', writtenPass),
                    const SizedBox(height: 4),
                    Text('Bestanden: ≥ 45/60 gesamt UND ≥ 6/10 je Sachgebiet',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 14),
                    ...QuestionCategory.values.map((cat) {
                      final c = categoryCorrect[cat] ?? 0;
                      final ok = c >= 6;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Icon(ok ? Icons.check_circle : Icons.cancel,
                                  size: 16,
                                  color: ok ? AppColors.correct : AppColors.incorrect),
                              const SizedBox(width: 6),
                              Expanded(child: Text(
                                  '${cat.shortName}. ${cat.displayName}',
                                  style: const TextStyle(fontSize: 12))),
                              Text('$c/10',
                                  style: TextStyle(
                                      fontSize: 12, fontWeight: FontWeight.bold,
                                      color: ok ? AppColors.correct : AppColors.incorrect)),
                            ]),
                            const SizedBox(height: 3),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                  value: c / 10,
                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  color: ok ? AppColors.correct : AppColors.incorrect,
                                  minHeight: 8),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ── Fischbestimmung ───────────────────────────────────────
          _Section(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('Fischbestimmung', fishPass),
                    const SizedBox(height: 4),
                    Text('Bestanden: ≥ 4 von 6 richtig benannt',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 14),
                    ...List.generate(fishToId.length, (i) {
                      final fish = fishToId[i];
                      final ok = fishResults[i] == true;
                      final input = fishInputs[i] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(ok ? Icons.check_circle : Icons.cancel,
                                color: ok ? AppColors.correct : AppColors.incorrect,
                                size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(fish.germanName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14)),
                                  Text(fish.latinName,
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic, fontSize: 11,
                                          color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                  if (!ok && input.isNotEmpty)
                                    Text('Eingabe: "$input"',
                                        style: const TextStyle(
                                            fontSize: 11, color: AppColors.incorrect)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ── Rutenzusammenstellung ─────────────────────────────────
          _Section(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionHeader('Rutenzusammenstellung', rodPass),
                    const SizedBox(height: 4),
                    Text(
                      '${rodSetup.rodType} – ${rodSetup.targetFish}\n'
                      'Bestanden: ≥ 25/28 Punkte   •   Dein Ergebnis: $rodPoints/28',
                      style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 14),
                    ...rodSetup.allItems.asMap().entries.map((e) {
                      final ok = e.key < rodResults.length && rodResults[e.key] == true;
                      final item = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(ok ? Icons.check_circle : Icons.cancel,
                                size: 16,
                                color: ok ? AppColors.correct : AppColors.incorrect),
                            const SizedBox(width: 6),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface),
                                  children: [
                                    TextSpan(text: '${item.component}: ',
                                        style: const TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: item.specification),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),

          // ── Falsch beantwortete Schriftfragen ─────────────────────
          if (wrongQuestions.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                'Falsch beantwortet – Schriftlich (${wrongQuestions.length})',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            ...wrongQuestions.map((entry) {
              final q = entry['q'] as Question;
              final yours = entry['a'] as int?;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4)),
                          child: Text(q.category.shortName,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 6),
                        Text(q.id, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 11)),
                      ]),
                      const SizedBox(height: 6),
                      Text(q.question,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      const SizedBox(height: 8),
                      if (yours != null) ...[
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.close, color: AppColors.incorrect, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text(q.options[yours],
                              style: const TextStyle(color: AppColors.incorrect, fontSize: 13))),
                        ]),
                        const SizedBox(height: 3),
                      ],
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Icon(Icons.check, color: AppColors.correct, size: 16),
                        const SizedBox(width: 4),
                        Expanded(child: Text(q.correctAnswer,
                            style: const TextStyle(color: AppColors.correct,
                                fontWeight: FontWeight.w600, fontSize: 13))),
                      ]),
                    ],
                  ),
                ),
              );
            }),
          ],

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (_) => false),
              icon: const Icon(Icons.home),
              label: const Text('Zum Hauptmenü'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Hilfwidgets ───────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label, value;
  final bool ok;
  const _Pill(this.label, this.value, this.ok);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Column(children: [
          Text(value,
              style: const TextStyle(color: Colors.white,
                  fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 10)),
          Icon(ok ? Icons.check_circle : Icons.cancel,
              color: Colors.white70, size: 14),
        ]),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool pass;
  const _SectionHeader(this.title, this.pass);

  @override
  Widget build(BuildContext context) => Row(children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (pass ? AppColors.correct : AppColors.incorrect)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(pass ? 'Bestanden' : 'Nicht bestanden',
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold,
                  color: pass ? AppColors.correct : AppColors.incorrect)),
        ),
      ]);
}

class _Section extends StatelessWidget {
  final Widget child;
  const _Section({required this.child});

  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0), child: child);
}
