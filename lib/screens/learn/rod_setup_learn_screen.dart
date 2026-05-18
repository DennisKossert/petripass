import 'package:flutter/material.dart';
import '../../data/rod_setups_data.dart';
import '../../models/rod_setup.dart';
import '../../theme/app_theme.dart';

class RodSetupLearnScreen extends StatelessWidget {
  const RodSetupLearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rutenzusammenstellung')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/jig_rod.jpg',
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Tippe auf eine Aufgabe, um die vollständige waidgerechte Zusammenstellung zu sehen.',
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          ...allRodSetups.map((setup) => _RodSetupCard(setup: setup)),
          const SizedBox(height: 12),
          // Hinweis Landehilfe
          Card(
            color: AppColors.incorrect.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(children: [
                    Icon(Icons.warning_amber, color: AppColors.incorrect, size: 18),
                    SizedBox(width: 6),
                    Text('Landehilfe (Pos. 10) je nach Aufgabe!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                            color: AppColors.incorrect)),
                  ]),
                  SizedBox(height: 6),
                  Text('A1–A6: Unterfangkescher\nA7–A8: Watkescher\nA9: Gaff / Landehaken\nA10: Handlandung',
                      style: TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _RodSetupCard extends StatelessWidget {
  final RodSetup setup;
  const _RodSetupCard({required this.setup});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RodSetupDetailScreen(setup: setup)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.sandBrown.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(setup.id,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.sandBrown,
                          fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(setup.targetFish,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(setup.rodType,
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    Text('Köder: ${setup.bait}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class RodSetupDetailScreen extends StatelessWidget {
  final RodSetup setup;
  const RodSetupDetailScreen({super.key, required this.setup});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${setup.id}: ${setup.targetFish}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            color: AppTheme.sandBrown.withValues(alpha: 0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.sandBrown,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(setup.id,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(setup.task,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Equipment table
          const Text('Geräte (1–9)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...setup.items.map((item) => _EquipmentRow(item: item)),
          const SizedBox(height: 16),

          // Notes
          if (setup.notes.isNotEmpty) ...[
            const Text('Wichtige Hinweise',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.incorrect)),
            const SizedBox(height: 8),
            ...setup.notes.map((note) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.incorrect.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.incorrect.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber,
                            color: AppColors.incorrect, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(note,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.incorrect))),
                      ],
                    ),
                  ),
                )),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const Text('Zubehör (10–16)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...setup.accessories.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _EquipmentRow(item: item),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _EquipmentRow extends StatelessWidget {
  final RodSetupItem item;
  const _EquipmentRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: item.isSpecial
            ? AppColors.incorrect.withValues(alpha: 0.08)
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.isSpecial
              ? AppColors.incorrect.withValues(alpha: 0.4)
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Text('${item.number}.',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: item.isSpecial ? AppColors.incorrect : Theme.of(context).colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 96,
            child: Text(item.component,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              item.specification,
              style: TextStyle(
                  fontSize: 13,
                  color: item.isSpecial ? AppColors.incorrect : null,
                  fontWeight:
                      item.isSpecial ? FontWeight.w600 : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }
}
