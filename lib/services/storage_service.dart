import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_stats.dart';
import '../models/question.dart';

class StorageService {
  static const _keyStats = 'user_stats_v2';
  static const _keyExamHistory = 'exam_history';

  static StorageService? _instance;
  late SharedPreferences _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    if (_instance == null) {
      _instance = StorageService._();
      _instance!._prefs = await SharedPreferences.getInstance();
    }
    return _instance!;
  }

  Future<void> saveUserStats(UserStats stats) async {
    final Map<String, dynamic> data = {};
    for (final entry in stats.categoryStats.entries) {
      data[entry.key.index.toString()] = entry.value.toJson();
    }
    await _prefs.setString(_keyStats, jsonEncode(data));

    final examList = stats.examHistory.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyExamHistory, jsonEncode(examList));
  }

  UserStats loadUserStats() {
    final statsJson = _prefs.getString(_keyStats);
    final historyJson = _prefs.getString(_keyExamHistory);

    final Map<QuestionCategory, CategoryStats> categoryStats = {
      for (var c in QuestionCategory.values) c: CategoryStats(category: c)
    };

    if (statsJson != null) {
      final Map<String, dynamic> data = jsonDecode(statsJson);
      for (final entry in data.entries) {
        final idx = int.tryParse(entry.key);
        if (idx != null && idx < QuestionCategory.values.length) {
          categoryStats[QuestionCategory.values[idx]] =
              CategoryStats.fromJson(entry.value as Map<String, dynamic>);
        }
      }
    }

    final List<ExamAttempt> history = [];
    if (historyJson != null) {
      final List<dynamic> list = jsonDecode(historyJson);
      history.addAll(list.map((e) => ExamAttempt.fromJson(e as Map<String, dynamic>)));
    }

    return UserStats(
      categoryStats: categoryStats,
      examHistory: history,
    );
  }

  Future<void> clearAll() async {
    await _prefs.remove(_keyStats);
    await _prefs.remove(_keyExamHistory);
  }
}
