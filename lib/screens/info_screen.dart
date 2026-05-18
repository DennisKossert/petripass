import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informationen')),
      body: Builder(
        builder: (context) => ListView(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
        children: [

          _InfoSection(
            icon: Icons.info_outline,
            title: 'Zur Fischerprüfung NRW',
            content:
                'Die Sportfischerprüfung NRW besteht aus drei Teilen:\n\n'
                '📝 Teil 1 – Schriftlich\n'
                '6 Sachgebiete, je 10 Fragen aus einem Pool von 359 Fragen:\n'
                '  A. Allgemeine Fischkunde (53 Fragen im Pool)\n'
                '  B. Spezielle Fischkunde (73 Fragen im Pool)\n'
                '  C. Gewässerkunde & Fischhege (77 Fragen im Pool)\n'
                '  D. Natur- & Tierschutz (45 Fragen im Pool)\n'
                '  E. Gerätekunde (41 Fragen im Pool)\n'
                '  F. Gesetzeskunde (70 Fragen im Pool)\n\n'
                '🐟 Teil 2 – Fischbestimmung\n'
                '6 Bildtafeln aus 49 offiziellen Arten\n\n'
                '🎣 Teil 3 – Rutenzusammenstellung\n'
                '1 Aufgabe aus A1–A10 (zugelost)',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.assignment_turned_in,
            title: 'Bestehensregeln (alle 3 Teile separat!)',
            content:
                '📝 Schriftlicher Teil\n'
                '• 60 Fragen, 60 Minuten Bearbeitungszeit\n'
                '• Bestanden: ≥ 45/60 richtig (75%)\n'
                '  UND ≥ 6/10 in JEDEM der 6 Sachgebiete\n'
                '• Tipp: Ein Sachgebiet mit nur 5/10 reicht zum Durchfallen!\n\n'
                '🐟 Fischbestimmung\n'
                '• 6 Bildtafeln einzeln gezeigt (vorher verdeckt gezogen)\n'
                '• Bestanden: ≥ 4 von 6 richtig benannt (66%)\n'
                '• Nur der deutsche Name ist zwingend – Latein ist Bonus\n\n'
                '🎣 Rutenzusammenstellung\n'
                '• Max. 28 Punkte, Bestanden: ≥ 25 Punkte\n'
                '• 3 Fehlerpunkte sind erlaubt, jeder weitere ist fatal\n'
                '• Tipp: Erst Zubehör (10–16) auslegen, dann Gerät (1–9)',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.warning_amber,
            title: 'Häufige Fehler in der Prüfung',
            content:
                '🎣 Rutenzusammenstellung:\n'
                '• Falsche Rolle – z.B. große statt mittlere Stationärrolle bei A6 (Barsch)\n'
                '• Keine Rachensperre bei A5 (Hecht) und A6 (Barsch)\n'
                '• Stahlvorfach vergessen bei A5 und A6\n'
                '• Falsches Stahlvorfach-Material oder Länge (mind. 40 cm)\n'
                '• Schlagholz vergessen\n'
                '• Falsche Landehilfe (A1–A6: Unterfangnetz; A7/A8: Watkescher; A9: Gaff; A10: entfällt)\n'
                '• Falsches Hakenlösegerät (A5/A10: Lösezange; A6–A9: Arterienklemme)\n\n'
                '🐟 Fischbestimmung:\n'
                '• Rotfeder ↔ Rotauge verwechselt (Flossenlage!)\n'
                '• Giebel ↔ Güster verwechselt\n'
                '• Nase ↔ Zährte verwechselt\n'
                '• Bachforelle ↔ Regenbogenforelle verwechselt\n'
                '• Karausche ↔ Giebel verwechselt\n\n'
                '📝 Schriftlicher Teil:\n'
                '• Sachgebiet mit nur 5/10 = nicht bestanden (obwohl gesamt ≥ 45)\n'
                '• Gesetzeskunde unterschätzt (viele spezifische NRW-Details)',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.compare_arrows,
            title: 'Verwechslungspaare – Fische',
            content:
                'Rotauge vs. Rotfeder:\n'
                '• Rotauge: Rückenflosse beginnt über der Bauchflosse\n'
                '• Rotfeder: Rückenflosse beginnt hinter der Bauchflosse\n'
                '• Rotfeder: intensiver rote Flossen, frisst Schwebalgen\n\n'
                'Karausche vs. Giebel:\n'
                '• Karausche: bräunlich-goldgelb, schmalere Körperform\n'
                '• Giebel: silbrig, breiter\n\n'
                'Giebel vs. Güster:\n'
                '• Güster: rötliche Brustflossen, Kammschuppen\n'
                '• Giebel: silbrig, keine auffälligen roten Flossen\n\n'
                'Nase vs. Zährte:\n'
                '• Nase: Afterflosse kürzer\n'
                '• Zährte: Afterflosse länger, etwas breiter\n\n'
                'Bachforelle vs. Regenbogenforelle:\n'
                '• Bachforelle: rote + schwarze Punkte, ohne Seitenstreifen\n'
                '• Regenbogenforelle: Regenbogenstreifen an der Seite, Punkte auch auf Flossen\n\n'
                'Bachsaibling vs. Bachforelle:\n'
                '• Bachsaibling: rote Punkte mit hellblauem Hof, Ränder der Bauchflossen hell\n'
                '• Bachforelle: ohne blauen Hof um die roten Punkte',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.phishing,
            title: 'Landehilfe je Rutenaufgabe',
            content:
                '⚠️ Die Landehilfe (Position 10) unterscheidet sich je nach Aufgabe!\n\n'
                'A1–A6 (Uferangeln):\n'
                '→ Unterfangnetz\n\n'
                'A7–A8 (Fliegenfischen):\n'
                '→ Watkescher (da man im Wasser steht)\n\n'
                'A9 (Dorsch, Bootsangeln):\n'
                '→ Gaff\n\n'
                'A10 (Brandungsangeln):\n'
                '→ entfällt (Handlandung)\n\n'
                'Tipp: Bei der Prüfung zuerst Zubehör (10–16) auslegen,\n'
                'dann die Rute (1–9) zusammenbauen.',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.gavel,
            title: 'Waidgerechtes Töten – Reihenfolge',
            content:
                'Reihenfolge laut Prüfungsordnung (Pos. 10–15):\n\n'
                '1. Keschern (Pos. 10 – Landehilfe)\n'
                '2. Messen (Pos. 11 – Metermaß)\n'
                '   → Erst messen: Untermaßige Fische werden zurückgesetzt!\n'
                '3. Betäuben (Pos. 12 – Schlagholz)\n'
                '4. Töten (Pos. 13 – Messer)\n'
                '5. Sperren (Pos. 14 – Rachensperre, nur A5 Hecht & A6 Barsch)\n'
                '6. Hakenlösen (Pos. 15 – je nach Aufgabe):\n'
                '   A1–A4: geeignetes Hakenlösegerät\n'
                '   A5 & A10: Lösezange\n'
                '   A6–A9: Arterienklemme\n\n'
                'Fisch zu tief geschluckt:\n'
                '→ Sofort waidgerecht töten, Schnur abschneiden!\n\n'
                '⚠️ Das Tierschutzgesetz gilt auch für Fische!',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.straighten,
            title: 'Wichtige Mindestmaße (NRW)',
            content:
                '• Aal: 50 cm\n'
                '• Karpfen: 35 cm\n'
                '• Hecht: 50 cm\n'
                '• Zander: 42 cm\n'
                '• Bachforelle: 25 cm\n'
                '• Meerforelle: 40 cm\n'
                '• Äsche: 30 cm\n'
                '• Schleie: 25 cm\n'
                '• Flussbarsch: 18 cm\n'
                '• Quappe: 30 cm\n'
                '• Barbe: 30 cm\n'
                '• Nase: 25 cm\n'
                '• Brasse: 25 cm\n'
                '• Döbel: 25 cm\n\n'
                '→ Untermaßige Fische: mit nassen Händen schonend zurücksetzen!\n'
                '→ Haken nicht herausreißen, Schnur abschneiden wenn nötig.',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.water,
            title: 'Fischregionen der Fließgewässer',
            content:
                'Von der Quelle zur Mündung (Reihenfolge merken!):\n\n'
                '1. Forellenregion\n'
                '   → kalt, sauerstoffreich, schnell fließend\n\n'
                '2. Äschenregion\n\n'
                '3. Barbenregion\n'
                '   → artenreichste Region!\n\n'
                '4. Brassenregion\n\n'
                '5. Kaulbarsch-/Flunderregion\n'
                '   → langsam, nährstoffreich, brackig\n\n'
                'Merkhilfe: "Forellen Ärgern Barsche Brassen Kräftig"',
          ),

          SizedBox(height: 12),
          _InfoSection(
            icon: Icons.lightbulb,
            title: 'Lerntipps (aus Erfahrungsberichten)',
            content:
                '1. Prüfungsanmeldung in NRW steht für jeden offen – kein Kurs nötig.\n\n'
                '2. Fischkarten früh anfangen: 49 Arten brauchen Zeit. Täglich 5–10 Minuten mit der App reicht.\n\n'
                '3. Schriftlich: Ein Drittel der Fragen lässt sich per Allgemeinwissen lösen. '
                'Konzentriere dich auf die restlichen zwei Drittel.\n\n'
                '4. Ruten-Lerntipp: Erst eine Angelart komplett lernen (z.B. alle 9 Komponenten von A5 Hecht), '
                'dann vergleichen: "Wo unterscheiden sich A5 Hecht und A6 Barsch?"\n\n'
                '5. Bester Praxistipp Rute: Geh in einen Angel- oder Sportladen, nimm einen Einkaufskorb '
                'und stelle dir die Rute aus der Aufgabenstellung tatsächlich zusammen. '
                'Was du einmal in den Händen gehalten hast, vergisst du nicht.\n\n'
                '6. Ausschlussprinzip bei MC-Fragen: Zwei offensichtlich falsche Antworten ausschließen, '
                'dann bleibt meist die richtige übrig.\n\n'
                '7. Schwachste Sachgebiete zuerst stärken – 5/10 in einem Sachgebiet = nicht bestanden, '
                'egal wie gut du in den anderen bist.',
          ),

          const SizedBox(height: 24),
          _AboutCard(),
          const SizedBox(height: 8),
        ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textColor = cs.onSurface;
    final subColor = cs.onSurface.withValues(alpha: 0.6);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Logo + Name
            SvgPicture.asset(
              'assets/images/petripass_fish.svg',
              height: 56,
              colorFilter: ColorFilter.mode(cs.primary, BlendMode.srcIn),
            ),
            const SizedBox(height: 8),
            Text('PetriPass',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: cs.primary)),
            Text('Angelprüfungsapp für NRW',
                style: TextStyle(fontSize: 13, color: subColor)),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Kontakt
            _InfoRow(
              icon: Icons.mail_outline,
              label: 'Kontakt',
              child: TextButton(
                onPressed: () => _launch('mailto:petri@kossert.org'),
                child: const Text('petri@kossert.org'),
              ),
            ),
            _InfoRow(
              icon: Icons.person_outline,
              label: 'Entwickler',
              child: Text('Dennis Kossert', style: TextStyle(color: textColor)),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Disclaimer
            Text('Haftungsausschluss',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor)),
            const SizedBox(height: 6),
            Text(
              'Diese App enthält keine offiziellen Prüfungsfragen der '
              'zuständigen Behörden. Alle Inhalte dienen ausschließlich '
              'der Prüfungsvorbereitung und wurden nach bestem Wissen '
              'zusammengestellt. Für die Vollständigkeit und Richtigkeit '
              'wird keine Gewähr übernommen. Maßgeblich sind die aktuellen '
              'Unterlagen des Landesfischereiverbandes NRW.',
              style: TextStyle(fontSize: 12, color: subColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Rechtliches
            Text('Rechtliches',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor)),
            const SizedBox(height: 6),
            Text(
              'Diese App ist kostenlos und enthält keine Werbung oder '
              'In-App-Käufe. Die Fischerprüfung NRW wird vom '
              'Landesfischereiverband Westfalen und Lippe e.V. sowie dem '
              'Landesfischereiverband Rheinland e.V. durchgeführt. '
              'Diese App steht in keiner Verbindung zu diesen Verbänden.',
              style: TextStyle(fontSize: 12, color: subColor, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _InfoRow({required this.icon, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final subColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: subColor),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontSize: 13, color: subColor)),
          child,
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child:
                Text(content, style: const TextStyle(fontSize: 14, height: 1.6)),
          ),
        ],
      ),
    );
  }
}
