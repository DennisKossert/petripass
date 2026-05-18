import 'package:flutter_test/flutter_test.dart';
import 'package:fisch_pruefung_nrw/data/all_questions.dart';

void main() {
  test('All questions loaded', () {
    expect(allQuestions.isNotEmpty, true);
  });

  test('Question IDs are unique', () {
    final ids = allQuestions.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length);
  });

  test('All correct answer indices are valid', () {
    for (final q in allQuestions) {
      expect(q.correctAnswerIndex, greaterThanOrEqualTo(0));
      expect(q.correctAnswerIndex, lessThan(q.options.length));
    }
  });
}
