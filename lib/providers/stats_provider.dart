import 'package:flutter/foundation.dart';
import '../models/user_stats.dart';
import '../models/question.dart';
import '../services/storage_service.dart';

class StatsProvider extends ChangeNotifier {
  late UserStats _stats;
  late StorageService _storage;
  bool _initialized = false;

  UserStats get stats => _stats;
  bool get initialized => _initialized;

  Future<void> init(StorageService storage) async {
    _storage = storage;
    _stats = _storage.loadUserStats();
    _initialized = true;
    notifyListeners();
  }

  void recordAnswer({
    required String questionId,
    required QuestionCategory category,
    required bool correct,
  }) {
    _stats.recordAnswer(questionId: questionId, category: category, correct: correct);
    _storage.saveUserStats(_stats);
    notifyListeners();
  }

  void addExamAttempt(ExamAttempt attempt) {
    _stats.examHistory.insert(0, attempt);
    if (_stats.examHistory.length > 50) {
      _stats.examHistory.removeLast();
    }
    _storage.saveUserStats(_stats);
    notifyListeners();
  }

  List<String> get wrongQuestionIds => _stats.allWrongQuestionIds;

  double categoryAccuracy(QuestionCategory category) =>
      _stats.categoryStats[category]?.accuracy ?? 0.0;

  int categoryWrongCount(QuestionCategory category) =>
      _stats.categoryStats[category]?.wrongQuestionIds.length ?? 0;

  Future<void> resetStats() async {
    await _storage.clearAll();
    _stats = UserStats();
    notifyListeners();
  }
}
