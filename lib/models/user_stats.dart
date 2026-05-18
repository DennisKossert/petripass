import 'question.dart';

class CategoryStats {
  final QuestionCategory category;
  int totalAnswered;
  int correctAnswered;
  List<String> wrongQuestionIds;

  CategoryStats({
    required this.category,
    this.totalAnswered = 0,
    this.correctAnswered = 0,
    List<String>? wrongQuestionIds,
  }) : wrongQuestionIds = wrongQuestionIds ?? [];

  double get accuracy =>
      totalAnswered == 0 ? 0.0 : correctAnswered / totalAnswered;

  Map<String, dynamic> toJson() => {
        'category': category.index,
        'totalAnswered': totalAnswered,
        'correctAnswered': correctAnswered,
        'wrongQuestionIds': wrongQuestionIds,
      };

  factory CategoryStats.fromJson(Map<String, dynamic> json) => CategoryStats(
        category: QuestionCategory.values[json['category'] as int],
        totalAnswered: json['totalAnswered'] as int,
        correctAnswered: json['correctAnswered'] as int,
        wrongQuestionIds: List<String>.from(json['wrongQuestionIds'] as List),
      );
}

class ExamAttempt {
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final bool passed;

  ExamAttempt({
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.passed,
  });

  double get score => totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'passed': passed,
      };

  factory ExamAttempt.fromJson(Map<String, dynamic> json) => ExamAttempt(
        date: DateTime.parse(json['date'] as String),
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        passed: json['passed'] as bool,
      );
}

class UserStats {
  Map<QuestionCategory, CategoryStats> categoryStats;
  List<ExamAttempt> examHistory;

  UserStats({
    Map<QuestionCategory, CategoryStats>? categoryStats,
    List<ExamAttempt>? examHistory,
  })  : categoryStats = categoryStats ??
            {
              for (var c in QuestionCategory.values)
                c: CategoryStats(category: c)
            },
        examHistory = examHistory ?? [];

  List<String> get allWrongQuestionIds {
    final ids = <String>{};
    for (final stats in categoryStats.values) {
      ids.addAll(stats.wrongQuestionIds);
    }
    return ids.toList();
  }

  void recordAnswer({
    required String questionId,
    required QuestionCategory category,
    required bool correct,
  }) {
    final stats = categoryStats[category]!;
    stats.totalAnswered++;
    if (correct) {
      stats.correctAnswered++;
      stats.wrongQuestionIds.remove(questionId);
    } else {
      if (!stats.wrongQuestionIds.contains(questionId)) {
        stats.wrongQuestionIds.add(questionId);
      }
    }
  }
}
