import '../models/question.dart';
import 'questions_a.dart';
import 'questions_b.dart';
import 'questions_c.dart';
import 'questions_d.dart';
import 'questions_e.dart';
import 'questions_f.dart';

const List<Question> allQuestions = [
  ...questionsA,
  ...questionsB,
  ...questionsC,
  ...questionsD,
  ...questionsE,
  ...questionsF,
];

List<Question> getQuestionsByCategory(QuestionCategory category) {
  return allQuestions.where((q) => q.category == category).toList();
}

Question? getQuestionById(String id) {
  try {
    return allQuestions.firstWhere((q) => q.id == id);
  } catch (_) {
    return null;
  }
}

List<Question> getQuestionsByIds(List<String> ids) {
  return ids.map(getQuestionById).whereType<Question>().toList();
}
