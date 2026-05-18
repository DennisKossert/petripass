import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/stats_provider.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await StorageService.getInstance();
  runApp(FischPruefungApp(storage: storage));
}

class FischPruefungApp extends StatelessWidget {
  final StorageService storage;
  const FischPruefungApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StatsProvider()..init(storage),
      child: MaterialApp(
        title: 'PetriPass',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
