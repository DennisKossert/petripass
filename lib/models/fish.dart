class Fish {
  final String id;
  final String germanName;
  final String latinName;
  final String? family;
  final String? imagePath;
  final List<String> characteristics;
  final String? habitat;
  final String? spawningSeason;
  final int? minLengthCm;
  final String? mnemonicHint;
  final String? feedingHabits;
  final bool isProtected;

  const Fish({
    required this.id,
    required this.germanName,
    required this.latinName,
    this.family,
    this.imagePath,
    this.characteristics = const [],
    this.habitat,
    this.spawningSeason,
    this.minLengthCm,
    this.mnemonicHint,
    this.feedingHabits,
    this.isProtected = false,
  });
}
