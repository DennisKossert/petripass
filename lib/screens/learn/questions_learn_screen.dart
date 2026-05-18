import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/question.dart';
import '../../data/all_questions.dart';
import '../../providers/stats_provider.dart';
import '../../theme/app_theme.dart';

enum LearnMode { random, category, wrongAnswers }

class QuestionsLearnScreen extends StatefulWidget {
  final LearnMode mode;
  final QuestionCategory? category;

  const QuestionsLearnScreen({
    super.key,
    required this.mode,
    this.category,
  });

  @override
  State<QuestionsLearnScreen> createState() => _QuestionsLearnScreenState();
}

class _QuestionsLearnScreenState extends State<QuestionsLearnScreen> {
  late List<Question> _questions;
  int _current = 0;
  int? _selectedAnswer;
  int _correctCount = 0;
  int _answeredCount = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    final stats = context.read<StatsProvider>();
    List<Question> pool;

    switch (widget.mode) {
      case LearnMode.random:
        pool = List.from(allQuestions)..shuffle(Random());
      case LearnMode.category:
        pool = getQuestionsByCategory(widget.category!)..shuffle(Random());
      case LearnMode.wrongAnswers:
        final wrongIds = stats.wrongQuestionIds;
        pool = getQuestionsByIds(wrongIds)..shuffle(Random());
    }
    _questions = pool;
  }

  String get _title {
    switch (widget.mode) {
      case LearnMode.random: return 'Zufällige Fragen';
      case LearnMode.category: return widget.category!.displayName;
      case LearnMode.wrongAnswers: return 'Meine Fehler';
    }
  }

  void _selectAnswer(int idx) {
    if (_selectedAnswer != null) return;
    setState(() {
      _selectedAnswer = idx;
      _answeredCount++;
      if (idx == _questions[_current].correctAnswerIndex) {
        _correctCount++;
      }
    });
    context.read<StatsProvider>().recordAnswer(
          questionId: _questions[_current].id,
          category: _questions[_current].category,
          correct: idx == _questions[_current].correctAnswerIndex,
        );
  }

  void _next() {
    if (_current >= _questions.length - 1) {
      _showFinished();
      return;
    }
    setState(() {
      _current++;
      _selectedAnswer = null;
    });
  }

  void _showQuestionPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(children: [
                const Icon(Icons.format_list_numbered, size: 18),
                const SizedBox(width: 8),
                Text('${_questions.length} Fragen – tippe zum Springen',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: controller,
                itemCount: _questions.length,
                itemBuilder: (_, i) {
                  final q = _questions[i];
                  final isCurrent = i == _current;
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: isCurrent
                          ? AppTheme.primaryGreen
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Text('${i + 1}',
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isCurrent ? Colors.white : null)),
                    ),
                    title: Text(q.question,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13)),
                    subtitle: Text(q.category.shortName,
                        style: const TextStyle(fontSize: 11)),
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _current = i;
                        _selectedAnswer = null;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFinished() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Runde beendet!'),
        content: Text(
            '$_correctCount von $_answeredCount Fragen richtig.\n'
            '${(_correctCount / _answeredCount * 100).toStringAsFixed(0)}% Trefferquote'),
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
                _loadQuestions();
                _current = 0;
                _selectedAnswer = null;
                _correctCount = 0;
                _answeredCount = 0;
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
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text(
              'Keine Fragen in dieser Kategorie. Beantworte erst einige Fragen!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    final q = _questions[_current];
    final answered = _selectedAnswer;
    final isCorrect = answered == q.correctAnswerIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_list_numbered),
            tooltip: 'Frage auswählen',
            onPressed: _showQuestionPicker,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_correctCount/$_answeredCount',
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
            value: _questions.isEmpty ? 0 : (_current + 1) / _questions.length,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: AppTheme.primaryGreen,
            minHeight: 4,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${_current + 1}/${_questions.length}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(q.category.shortName,
                            style: const TextStyle(fontSize: 11)),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    q.question,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(q.options.length, (i) {
                    Color? bg;
                    Color? border;
                    if (answered != null) {
                      if (i == q.correctAnswerIndex) {
                        bg = AppColors.correct.withValues(alpha: 0.15);
                        border = AppColors.correct;
                      } else if (i == answered) {
                        bg = AppColors.incorrect.withValues(alpha: 0.15);
                        border = AppColors.incorrect;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: answered == null ? () => _selectAnswer(i) : null,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
                            border: Border.all(
                                color: border ?? Theme.of(context).colorScheme.outlineVariant, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              Text(
                                ['a)', 'b)', 'c)'][i],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: border ?? Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(q.options[i],
                                      style: const TextStyle(fontSize: 15))),
                              if (answered != null &&
                                  i == q.correctAnswerIndex)
                                const Icon(Icons.check_circle,
                                    color: AppColors.correct),
                              if (answered != null &&
                                  i == answered &&
                                  !isCorrect)
                                const Icon(Icons.cancel,
                                    color: AppColors.incorrect),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (answered != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? AppColors.correct.withValues(alpha: 0.1)
                            : AppColors.incorrect.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isCorrect
                                ? AppColors.correct
                                : AppColors.incorrect),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.info,
                            color: isCorrect ? AppColors.correct : AppColors.incorrect,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isCorrect
                                  ? 'Richtig!'
                                  : 'Richtige Antwort: ${q.correctAnswer}',
                              style: TextStyle(
                                  color: isCorrect
                                      ? AppColors.correct
                                      : AppColors.incorrect,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: answered != null ? _next : null,
                  icon: Icon(_current >= _questions.length - 1
                      ? Icons.flag
                      : Icons.arrow_forward),
                  label: Text(_current >= _questions.length - 1
                      ? 'Auswertung'
                      : 'Nächste Frage'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
