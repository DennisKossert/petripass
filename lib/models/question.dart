enum QuestionCategory {
  allgemeineFischkunde,
  spezielleFischkunde,
  gewaesserkunde,
  naturUndTierschutz,
  geraetekunde,
  gesetzeskunde,
}

extension QuestionCategoryExtension on QuestionCategory {
  String get displayName {
    switch (this) {
      case QuestionCategory.allgemeineFischkunde:
        return 'Allgemeine Fischkunde';
      case QuestionCategory.spezielleFischkunde:
        return 'Spezielle Fischkunde';
      case QuestionCategory.gewaesserkunde:
        return 'Gewässerkunde & Fischhege';
      case QuestionCategory.naturUndTierschutz:
        return 'Natur- & Tierschutz';
      case QuestionCategory.geraetekunde:
        return 'Gerätekunde';
      case QuestionCategory.gesetzeskunde:
        return 'Gesetzeskunde';
    }
  }

  String get shortName {
    switch (this) {
      case QuestionCategory.allgemeineFischkunde:
        return 'A';
      case QuestionCategory.spezielleFischkunde:
        return 'B';
      case QuestionCategory.gewaesserkunde:
        return 'C';
      case QuestionCategory.naturUndTierschutz:
        return 'D';
      case QuestionCategory.geraetekunde:
        return 'E';
      case QuestionCategory.gesetzeskunde:
        return 'F';
    }
  }
}

class Question {
  final String id;
  final QuestionCategory category;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  const Question({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });

  String get correctAnswer => options[correctAnswerIndex];
}
