import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/question.dart';
import '../../providers/stats_provider.dart';
import '../../theme/app_theme.dart';
import 'questions_learn_screen.dart';
import 'fish_cards_screen.dart';
import 'fish_quiz_screen.dart';
import 'rod_setup_learn_screen.dart';
import 'rod_assembly_quiz_screen.dart';

class LearnHomeScreen extends StatelessWidget {
  const LearnHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    final wrongCount = stats.wrongQuestionIds.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Lernen')),
      body: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
          children: [
          // ── Fragentraining ──────────────────────────────────────
          _SectionHeader('Fragentraining'),
          _LearnCard(
            icon: Icons.shuffle,
            title: 'Zufällige Fragen',
            subtitle: 'Alle Kategorien gemischt',
            color: AppTheme.primaryGreen,
            onTap: () => _push(context,
                const QuestionsLearnScreen(mode: LearnMode.random)),
          ),
          const SizedBox(height: 8),
          ...QuestionCategory.values.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _LearnCard(
                  icon: Icons.list_alt,
                  title: cat.displayName,
                  subtitle: '(${cat.shortName}) Gezielt lernen',
                  color: _categoryColor(cat),
                  onTap: () => _push(context,
                      QuestionsLearnScreen(
                          mode: LearnMode.category, category: cat)),
                ),
              )),
          _LearnCard(
            icon: Icons.error_outline,
            title: 'Falsch beantwortet lernen',
            subtitle: wrongCount > 0
                ? '$wrongCount Fragen zum Aufholen'
                : 'Noch keine Fehler – weiter so!',
            color: AppColors.incorrect,
            onTap: wrongCount == 0
                ? null
                : () => _push(context,
                    const QuestionsLearnScreen(mode: LearnMode.wrongAnswers)),
          ),

          // ── Fischkarten ─────────────────────────────────────────
          const SizedBox(height: 24),
          _SectionHeader('Fischkarten'),
          _LearnCard(
            icon: Icons.menu_book,
            title: 'Alle Fischarten ansehen',
            subtitle: '49 Arten mit Merkmalen & Eselsbrücken',
            color: AppTheme.waterBlue,
            onTap: () => _push(context, const FishCardsScreen()),
          ),
          const SizedBox(height: 8),
          _LearnCard(
            icon: Icons.quiz,
            title: 'Fischart-Quiz',
            subtitle: 'Welcher Fisch ist das? Bilde anhand der Merkmale',
            color: const Color(0xFF0277BD),
            onTap: () => _push(context, const FishQuizScreen()),
          ),

          // ── Rutenzusammenstellung ────────────────────────────────
          const SizedBox(height: 24),
          _SectionHeader('Rutenzusammenstellung'),
          _LearnCard(
            icon: Icons.phishing,
            title: 'Aufgaben ansehen (A1–A10)',
            subtitle: 'Vollständige Gerätelisten mit Hinweisen',
            color: AppTheme.sandBrown,
            onTap: () => _push(context, const RodSetupLearnScreen()),
          ),
          const SizedBox(height: 8),
          _LearnCard(
            icon: Icons.build_circle,
            title: 'Rute zusammenbauen (Quiz)',
            subtitle: 'Komponente für Komponente auswählen',
            color: const Color(0xFF5D4037),
            onTap: () => _push(context, const RodAssemblyQuizScreen()),
          ),

          const SizedBox(height: 24),
        ],
        ),
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Color _categoryColor(QuestionCategory cat) {
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

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class _LearnCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _LearnCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Card(
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: (disabled ? Colors.grey : color).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: disabled ? Colors.grey : color),
        ),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: disabled ? Colors.grey : null)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
