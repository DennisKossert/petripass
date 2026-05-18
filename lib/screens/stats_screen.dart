import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import '../models/question.dart';
import '../theme/app_theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final totalAnswered = stats.stats.categoryStats.values
        .fold(0, (s, c) => s + c.totalAnswered);
    final totalCorrect = stats.stats.categoryStats.values
        .fold(0, (s, c) => s + c.correctAnswered);
    final examCount = stats.stats.examHistory.length;
    final examPassed = stats.stats.examHistory.where((e) => e.passed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Zurücksetzen',
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Overview cards
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '$totalAnswered',
                  label: 'Fragen\nbeantwortet',
                  color: AppTheme.waterBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: totalAnswered == 0
                      ? '–'
                      : '${(totalCorrect / totalAnswered * 100).toStringAsFixed(0)}%',
                  label: 'Gesamt-\nquote',
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  value: examCount == 0 ? '0' : '$examPassed/$examCount',
                  label: 'Prüfungen\nbestanden',
                  color: AppColors.correct,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Category breakdown
          const Text('Fortschritt nach Kategorie',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...QuestionCategory.values.map((cat) {
            final s = stats.stats.categoryStats[cat]!;
            final pct = s.accuracy;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${cat.shortName}. ${cat.displayName}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(
                          '${s.correctAnswered}/${s.totalAnswered} (${(pct * 100).toStringAsFixed(0)}%)',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: Colors.grey[200],
                      color: _pctColor(pct),
                      minHeight: 12,
                    ),
                  ),
                  if (s.wrongQuestionIds.isNotEmpty)
                    Text(
                      '${s.wrongQuestionIds.length} Fragen zum Aufholen',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.incorrect),
                    ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
          if (stats.stats.examHistory.isNotEmpty) ...[
            const Text('Probeprüfungs-Verlauf',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            ...stats.stats.examHistory.take(20).map((attempt) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    attempt.passed ? Icons.check_circle : Icons.cancel,
                    color:
                        attempt.passed ? AppColors.correct : AppColors.incorrect,
                  ),
                  title: Text(
                    '${attempt.correctAnswers}/${attempt.totalQuestions} Richtig (${(attempt.score * 100).toStringAsFixed(0)}%)',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${attempt.date.day}.${attempt.date.month}.${attempt.date.year}  —  '
                    '${attempt.passed ? 'Bestanden ✓' : 'Nicht bestanden'}',
                  ),
                  trailing: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (attempt.passed
                              ? AppColors.correct
                              : AppColors.incorrect)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      attempt.passed ? 'OK' : 'FAIL',
                      style: TextStyle(
                          color: attempt.passed
                              ? AppColors.correct
                              : AppColors.incorrect,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              );
            }),
          ] else
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Icon(Icons.assignment_outlined,
                        size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Noch keine Probeprüfungen absolviert.',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Color _pctColor(double pct) {
    if (pct >= 0.8) return AppColors.correct;
    if (pct >= 0.5) return AppTheme.warningAmber;
    return AppColors.incorrect;
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Statistik zurücksetzen?'),
        content: const Text(
            'Alle Lernfortschritte und Prüfungsergebnisse werden gelöscht.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.incorrect),
            onPressed: () {
              context.read<StatsProvider>().resetStats();
              Navigator.pop(context);
            },
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
