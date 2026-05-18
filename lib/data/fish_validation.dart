import '../models/fish.dart';

/// Alle gültigen deutschen Eingaben für einen Fisch.
List<String> validFishAnswers(Fish fish) {
  final name = fish.germanName.trim();
  final result = <String>{name.toLowerCase()};

  // Klammerinhalt: "Rotauge (Plötze)" → "plötze", "rotauge"
  final parenMatch = RegExp(r'\(([^)]+)\)').firstMatch(name);
  if (parenMatch != null) {
    result.add(parenMatch.group(1)!.toLowerCase().trim());
    result.add(name.substring(0, parenMatch.start).toLowerCase().trim());
  }

  // Schrägstrich: "Bach-/Flussneunauge" → "bachneunauge", "flussneunauge"
  if (name.contains('/')) {
    final parts = name.split('/');
    if (parts.length == 2) {
      final left = parts[0].trimRight().replaceAll(RegExp(r'-$'), '');
      final right = parts[1].trim();
      result.add('$left$right'.toLowerCase());
      result.add(left.toLowerCase());
      result.add(right.toLowerCase());
    }
  }

  result.addAll((_synonyms[fish.id] ?? []).map((e) => e.toLowerCase().trim()));
  return result.toList();
}

const Map<String, List<String>> _synonyms = {
  // Mühlkoppe: Volksname "Mühlgroppe" und "Groppe" müssen akzeptiert werden
  'muehlkoppe': ['mühlgroppe', 'muehlgroppe', 'groppe', 'koppe'],

  // Wildkarpfen: "Karpfen" allein ist genug
  'karpfen': ['karpfen', 'wildkarpfen'],

  // Dreistachliger Stichling
  'dreistachliger_stichling': ['dreistachliger stichling', 'dreistachler', 'stichling'],

  // Zwergstichling
  'zwergstichling': ['zwergstichling', 'stichling'],

  // Kessler-Grundel
  'kessler_grundel': ['kessler-grundel', 'kesslergrundel', 'grundel'],

  // Bach-/Flussneunauge (Schrägstrich-Regex liefert schon viel)
  'bach_flussneunauge': ['neunauge', 'bachneunauge', 'flussneunauge'],

  // Nordseeschnäpel
  'nordseeschnäpel': ['schnäpel', 'schnaepel'],

  // Amerikanischer Krebs
  'amerikanischer_krebs': ['amerikanischer flusskrebs', 'kamberkrebs'],

  // Kabeljau = Dorsch
  'kabeljau': ['dorsch'],

  // Döbel: alte Schreibweise
  'doebel': ['aitel'],

  // Schlammpeitzger: häufige Vertipper
  'schlammpeitzger': ['schlammpeizger', 'peitzger', 'schlammpeitzker'],

  // Steinbeißer: Umlaut-Variante wird durch Normalisierung abgedeckt, extra Schreibung
  'steinbeisser': ['steinbeizer'],

  // Äsche: wird durch Normalisierung (ae) abgedeckt, trotzdem explicit
  'aesche': ['aesche'],
};

/// Normalisierung: Umlaute → ASCII, Bindestriche/Klammern als Leerzeichen,
/// Mehrfach-Leerzeichen zusammenfassen, trimmen.
String normalizeFishInput(String s) => s
    .toLowerCase()
    .replaceAll('ä', 'ae')
    .replaceAll('ö', 'oe')
    .replaceAll('ü', 'ue')
    .replaceAll('ß', 'ss')
    .replaceAll(RegExp(r'[-/().]'), ' ')
    .replaceAll(RegExp(r'\s+'), ' ')
    .replaceAll(RegExp(r'[^a-z0-9 ]'), '')
    .trim();

/// Prüft ob eine Nutzereingabe für diesen Fisch korrekt ist.
bool isFishAnswerCorrect(Fish fish, String input) {
  final norm = normalizeFishInput(input);
  if (norm.isEmpty) return false;
  return validFishAnswers(fish).any((v) => normalizeFishInput(v) == norm);
}
