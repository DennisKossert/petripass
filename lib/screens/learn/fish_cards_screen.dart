import 'package:flutter/material.dart';
import '../../data/fish_data.dart';
import '../../models/fish.dart';
import '../../theme/app_theme.dart';

class FishCardsScreen extends StatefulWidget {
  const FishCardsScreen({super.key});

  @override
  State<FishCardsScreen> createState() => _FishCardsScreenState();
}

class _FishCardsScreenState extends State<FishCardsScreen> {
  String _search = '';
  String? _filterFamily;

  List<Fish> get _filtered {
    return allFish.where((f) {
      final matchSearch = _search.isEmpty ||
          f.germanName.toLowerCase().contains(_search.toLowerCase()) ||
          f.latinName.toLowerCase().contains(_search.toLowerCase());
      final matchFamily =
          _filterFamily == null || f.family == _filterFamily;
      return matchSearch && matchFamily;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fischkarten'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              decoration: InputDecoration(
                hintText: 'Fisch suchen...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('${_filtered.length} Fischarten',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) => FishCardTile(fish: _filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class FishCardTile extends StatelessWidget {
  final Fish fish;
  const FishCardTile({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FishDetailScreen(fish: fish)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.waterBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: fish.imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(fish.imagePath!, fit: BoxFit.cover))
                    : const Icon(Icons.set_meal, color: AppTheme.waterBlue, size: 32),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(fish.germanName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                        if (fish.isProtected)
                          const Tooltip(
                            message: 'Geschützte Art',
                            child: Icon(Icons.shield, color: AppColors.correct, size: 16),
                          ),
                      ],
                    ),
                    Text(fish.latinName,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                            fontSize: 13)),
                    if (fish.family != null)
                      Text(fish.family!,
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    if (fish.minLengthCm != null)
                      Text('Mindestmaß: ${fish.minLengthCm} cm',
                          style: const TextStyle(fontSize: 11, color: AppTheme.warningAmber)),
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

class FishDetailScreen extends StatelessWidget {
  final Fish fish;
  const FishDetailScreen({super.key, required this.fish});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(fish.germanName)),
      body: ListView(
        children: [
          // Fish image placeholder
          Container(
            height: 200,
            color: AppTheme.waterBlue.withValues(alpha: 0.1),
            child: fish.imagePath != null
                ? Image.asset(fish.imagePath!, fit: BoxFit.contain)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.set_meal, size: 80, color: AppTheme.waterBlue),
                      Text(fish.germanName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name card
                Card(
                  color: AppTheme.waterBlue.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fish.germanName,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        Text(fish.latinName,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                                color: Colors.grey)),
                        if (fish.family != null) ...[
                          const SizedBox(height: 4),
                          Text('Familie: ${fish.family}',
                              style: const TextStyle(color: Colors.grey)),
                        ],
                        if (fish.isProtected) ...[
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.shield, color: AppColors.correct, size: 18),
                              SizedBox(width: 4),
                              Text('Geschützte Art',
                                  style: TextStyle(
                                      color: AppColors.correct,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Key facts
                if (fish.characteristics.isNotEmpty) ...[
                  _SectionHeader('Merkmale & Erkennungszeichen'),
                  ...fish.characteristics.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_right, color: AppTheme.primaryGreen),
                            Expanded(child: Text(c, style: const TextStyle(fontSize: 15))),
                          ],
                        ),
                      )),
                  const SizedBox(height: 12),
                ],

                if (fish.mnemonicHint != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.hintAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.hintAmber.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: AppTheme.hintAmber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text('Eselsbrücke: ${fish.mnemonicHint!}',
                              style: const TextStyle(fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],

                if (fish.habitat != null) ...[
                  _SectionHeader('Lebensraum'),
                  _InfoRow(Icons.water, fish.habitat!),
                  const SizedBox(height: 12),
                ],

                if (fish.spawningSeason != null) ...[
                  _SectionHeader('Laichzeit'),
                  _InfoRow(Icons.calendar_month, fish.spawningSeason!),
                  const SizedBox(height: 12),
                ],

                if (fish.minLengthCm != null) ...[
                  _SectionHeader('Mindestmaß'),
                  _InfoRow(Icons.straighten,
                      '${fish.minLengthCm} cm (NRW)',
                      color: AppTheme.warningAmber),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppTheme.primaryGreen)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  const _InfoRow(this.icon, this.text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey),
        const SizedBox(width: 8),
        Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 15, color: color))),
      ],
    );
  }
}
