import 'dart:math';
import 'package:flutter/material.dart';
import '../../data/rod_setups_data.dart';
import '../../models/rod_setup.dart';
import '../../theme/app_theme.dart';

/// Alle eindeutigen Werte für einen Slot (0–15) über alle Setups.
List<String> _allVariantsForSlot(int slotIndex) {
  final seen = <String>{};
  for (final s in allRodSetups) {
    seen.add(s.allItems[slotIndex].specification);
  }
  final list = seen.toList()..sort();
  return list;
}

String _displaySpec(int slotIndex, String spec) {
  if (slotIndex != 0) return spec;
  final idx = spec.indexOf(', Länge:');
  return idx != -1 ? spec.substring(idx + 2) : spec;
}

class RodAssemblyQuizScreen extends StatefulWidget {
  const RodAssemblyQuizScreen({super.key});

  @override
  State<RodAssemblyQuizScreen> createState() => _RodAssemblyQuizScreenState();
}

class _RodAssemblyQuizScreenState extends State<RodAssemblyQuizScreen> {
  late RodSetup _setup;
  late List<RodSetupItem> _items;
  int _slotIndex = 0;
  String? _selected;
  int _correct = 0;
  final _rng = Random();
  final List<bool> _results = [];
  late List<String> _variants;

  @override
  void initState() {
    super.initState();
    _startNewSetup();
  }

  void _startNewSetup() {
    _setup = allRodSetups[_rng.nextInt(allRodSetups.length)];
    _items = _setup.allItems;
    _slotIndex = 0;
    _correct = 0;
    _results.clear();
    _selected = null;
    _variants = _allVariantsForSlot(0);
  }

  void _select(String spec) {
    if (_selected != null) return;
    final ok = spec == _items[_slotIndex].specification;
    setState(() {
      _selected = spec;
      if (ok) _correct++;
      _results.add(ok);
    });
  }

  void _next() {
    if (_slotIndex >= _items.length - 1) {
      _showResult();
      return;
    }
    setState(() {
      _slotIndex++;
      _variants = _allVariantsForSlot(_slotIndex);
      _selected = null;
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Aufgabe ${_setup.id} abgeschlossen'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_correct / ${_items.length}',
                style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.sandBrown),
              ),
              const Text('Komponenten richtig',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 14),
              ..._items.asMap().entries.map((e) {
                final ok = e.key < _results.length && _results[e.key];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(ok ? Icons.check_circle : Icons.cancel,
                          size: 16,
                          color: ok ? AppColors.correct : AppColors.incorrect),
                      const SizedBox(width: 6),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black87),
                            children: [
                              TextSpan(
                                  text: '${e.value.component}: ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(text: e.value.specification),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
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
              setState(_startNewSetup);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.sandBrown),
            child: const Text('Neue Aufgabe'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _items[_slotIndex];
    final correctSpec = item.specification;
    final answered = _selected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rute zusammenbauen'),
        backgroundColor: AppTheme.sandBrown,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_correct / ${_slotIndex + (answered != null ? 1 : 0)}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Fortschrittsbalken
          LinearProgressIndicator(
            value: (_slotIndex + 1) / _items.length,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: AppTheme.sandBrown,
            minHeight: 4,
          ),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Aufgabe: Rutentyp + Zielfisch ───────────────────
                        Card(
                          color: AppTheme.sandBrown.withValues(alpha: 0.1),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.phishing,
                                    color: AppTheme.sandBrown, size: 22),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _setup.rodType,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.sandBrown),
                                      ),
                                      Text(
                                        'für ${_setup.targetFish}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Fortschritt bisheriger Slots ────────────────────
                        if (_slotIndex > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: List.generate(_slotIndex, (i) {
                                final ok =
                                    i < _results.length && _results[i];
                                return Chip(
                                  avatar: Icon(
                                    ok ? Icons.check : Icons.close,
                                    size: 14,
                                    color: ok
                                        ? AppColors.correct
                                        : AppColors.incorrect,
                                  ),
                                  label: Text(_items[i].component,
                                      style:
                                          const TextStyle(fontSize: 11)),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: (ok
                                          ? AppColors.correct
                                          : AppColors.incorrect)
                                      .withValues(alpha: 0.1),
                                );
                              }),
                            ),
                          ),

                        // ── Aktuelle Komponenten-Frage ───────────────────────
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppTheme.sandBrown,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text('${item.number}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item.component,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        'Welche ${item.component} für diese Aufgabe?',
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // ── Alle Varianten als Antwortoptionen ───────────────
                        ..._variants.map((spec) {
                          final isCorrect = spec == correctSpec;
                          final isSelected = answered == spec;
                          Color? bg;
                          Color? border;
                          if (answered != null) {
                            if (isCorrect) {
                              bg = AppColors.correct.withValues(alpha: 0.15);
                              border = AppColors.correct;
                            } else if (isSelected) {
                              bg = AppColors.incorrect.withValues(alpha: 0.15);
                              border = AppColors.incorrect;
                            }
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: InkWell(
                              onTap: answered == null
                                  ? () => _select(spec)
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: bg ?? Theme.of(context).colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: border ?? Theme.of(context).colorScheme.outlineVariant,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _displaySpec(_slotIndex, spec),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight:
                                              isCorrect && answered != null
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color: answered != null && isCorrect
                                              ? AppColors.correct
                                              : answered != null && isSelected
                                                  ? AppColors.incorrect
                                                  : null,
                                        ),
                                      ),
                                    ),
                                    if (answered != null && isCorrect)
                                      const Icon(Icons.check_circle,
                                          color: AppColors.correct, size: 20),
                                    if (answered != null &&
                                        isSelected &&
                                        !isCorrect)
                                      const Icon(Icons.cancel,
                                          color: AppColors.incorrect, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),

                        // ── Hinweis nach falscher Antwort ────────────────────
                        if (answered != null && item.isSpecial)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.incorrect.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.incorrect
                                      .withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.warning_amber,
                                    color: AppColors.incorrect, size: 18),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Pflichtkomponente bei dieser Aufgabe!',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.incorrect,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: answered != null ? _next : null,
                  icon: Icon(_slotIndex >= _items.length - 1
                      ? Icons.flag
                      : Icons.arrow_forward),
                  label: Text(_slotIndex >= _items.length - 1
                      ? 'Auswertung'
                      : 'Nächste Komponente'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.sandBrown),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
