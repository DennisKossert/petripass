class RodSetupItem {
  final int number;
  final String component;
  final String specification;
  final bool isSpecial;

  const RodSetupItem({
    required this.number,
    required this.component,
    required this.specification,
    this.isSpecial = false,
  });
}

class RodSetup {
  final String id;
  final String task;
  final String examTaskText; // Originaltext aus der Prüfungsordnung
  final String targetFish;
  final String rodType;
  final String rodWeightClass;
  final String rodLength;
  final String reel;
  final String line;
  final String? biteIndicator;
  final String? weight;
  final String leader;
  final String swivel;
  final String? hook;
  final String bait;
  final String landehilfe;
  final List<String> notes;

  const RodSetup({
    required this.id,
    required this.task,
    required this.examTaskText,
    required this.targetFish,
    required this.rodType,
    required this.rodWeightClass,
    required this.rodLength,
    required this.reel,
    required this.line,
    this.biteIndicator,
    this.weight,
    required this.leader,
    required this.swivel,
    this.hook,
    required this.bait,
    this.landehilfe = 'Unterfangnetz',
    this.notes = const [],
  });

  List<RodSetupItem> get items => [
        RodSetupItem(number: 1, component: 'Rute',
            specification: '$rodType, Länge: $rodLength, Wurfgewicht: $rodWeightClass'),
        RodSetupItem(number: 2, component: 'Rolle', specification: reel),
        RodSetupItem(number: 3, component: 'Schnur', specification: line),
        RodSetupItem(number: 4, component: 'Bissanzeiger',
            specification: biteIndicator ?? 'entfällt'),
        RodSetupItem(number: 5, component: 'Beschwerung',
            specification: weight ?? 'entfällt'),
        RodSetupItem(number: 6, component: 'Vorfach', specification: leader,
            isSpecial: leader.contains('Stahl')),
        RodSetupItem(number: 7, component: 'Wirbel', specification: swivel,
            isSpecial: swivel.contains('Meeres')),
        RodSetupItem(number: 8, component: 'Haken',
            specification: hook ?? 'entfällt (am Köder)'),
        RodSetupItem(number: 9, component: 'Köder', specification: bait),
      ];

  List<RodSetupItem> get accessories => [
        RodSetupItem(number: 10, component: 'Landehilfe',
            specification: landehilfe,
            isSpecial: landehilfe != 'Unterfangnetz'),
        RodSetupItem(number: 11, component: 'Messen',
            specification: 'Metermaß'),
        RodSetupItem(number: 12, component: 'Betäuben',
            specification: 'Schlagholz'),
        RodSetupItem(number: 13, component: 'Töten',
            specification: 'Messer'),
        RodSetupItem(number: 14, component: 'Rachensperre',
            specification: (id == 'A5' || id == 'A6') ? 'Rachensperre' : 'entfällt',
            isSpecial: id == 'A5' || id == 'A6'),
        RodSetupItem(number: 15, component: 'Haken entfernen',
            specification: id == 'A5' || id == 'A10'
                ? 'Lösezange'
                : (id == 'A6' || id == 'A7' || id == 'A8' || id == 'A9')
                    ? 'Arterienklemme'
                    : 'geeignetes Hakenlösegerät'),
        RodSetupItem(number: 16, component: 'Reihenfolge',
            specification: 'Keschern – Messen – Betäuben – Töten – Sperren – Hakenlösen'),
      ];

  List<RodSetupItem> get allItems => [...items, ...accessories];
}
