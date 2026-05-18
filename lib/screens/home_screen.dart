import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/stats_provider.dart';
import '../theme/app_theme.dart';
import 'exam/exam_screen.dart';
import 'learn/learn_home_screen.dart';
import 'stats_screen.dart';
import 'info_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/equipment.jpg', fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black54, Colors.black38],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/petripass_fish.svg',
                            height: 64,
                            colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Fischerprüfung NRW',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(offset: Offset(1, 2), blurRadius: 4, color: Colors.black87),
                              ],
                            ),
                          ),
                          const Text(
                            'Lernapp für die Angelprüfung',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                              shadows: [
                                Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black87),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _QuickStatsCard(),
                  const SizedBox(height: 20),
                  const Text('Was möchtest du tun?',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.assignment,
                    title: 'Prüfung simulieren',
                    subtitle: 'Echte Prüfung nachstellen & auswerten',
                    color: AppTheme.errorRed,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExamScreen())),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.school,
                    title: 'Lernen',
                    subtitle: 'Fragen, Fischkarten & Rutenzusammenstellung',
                    color: AppTheme.primaryGreen,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LearnHomeScreen())),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.bar_chart,
                    title: 'Statistik',
                    subtitle: 'Fortschritt & Schwachstellen analysieren',
                    color: AppTheme.waterBlue,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StatsScreen())),
                  ),
                  const SizedBox(height: 12),
                  _MenuCard(
                    icon: Icons.info_outline,
                    title: 'Informationen',
                    subtitle: 'Tipps, Prüfungsinfos & Anleitungen',
                    color: AppTheme.sandBrown,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const InfoScreen())),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickStatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatsProvider>();
    if (!stats.initialized) return const SizedBox.shrink();

    final total = stats.stats.categoryStats.values
        .fold(0, (s, c) => s + c.totalAnswered);
    final correct = stats.stats.categoryStats.values
        .fold(0, (s, c) => s + c.correctAnswered);
    final exams = stats.stats.examHistory.length;
    final examsPassed =
        stats.stats.examHistory.where((e) => e.passed).length;

    return Card(
      color: AppTheme.primaryGreen,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              value: total == 0
                  ? '–%'
                  : '${(correct / total * 100).toStringAsFixed(0)}%',
              label: 'Richtig\ngesamt',
            ),
            _StatItem(value: '$total', label: 'Fragen\ngeübt'),
            _StatItem(value: '$exams', label: 'Probe-\nprüfungen'),
            _StatItem(
              value: exams == 0 ? '–' : '$examsPassed/$exams',
              label: 'Bestanden',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        Text(label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
