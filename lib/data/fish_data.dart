import '../models/fish.dart';

const List<Fish> allFish = [
  // Salmoniden
  Fish(id: 'bachforelle', germanName: 'Bachforelle', latinName: 'Salmo trutta fario', family: 'Salmonidae', imagePath: 'assets/fish/bachforelle.png', characteristics: ['Rote und schwarze Punkte auf hellem Körper', 'Fettflosse vorhanden', 'Kieslaicher (Okt–Jan)', 'Hoher Sauerstoffbedarf'], habitat: 'Kalte, sauerstoffreiche Bäche und Flüsse', spawningSeason: 'Oktober bis Januar', minLengthCm: 25, mnemonicHint: 'Rote Punkte = Bach-Punkte'),
  Fish(id: 'meerforelle', germanName: 'Meerforelle', latinName: 'Salmo trutta trutta', family: 'Salmonidae', imagePath: 'assets/fish/Meerforelle.png', characteristics: ['Silbrig, x-förmige Flecken', 'Wanderfisch (Meer↔Süßwasser)', 'Fettflosse', 'Größer als Bachforelle'], habitat: 'Küstennahe Gewässer, Mündungsflüsse', spawningSeason: 'November bis Januar', minLengthCm: 40),
  Fish(id: 'lachs', germanName: 'Lachs', latinName: 'Salmo salar', family: 'Salmonidae', imagePath: 'assets/fish/atlantischer_lachs.png', characteristics: ['Silbrig-blau, kleine Punkte', 'Wanderfisch – laicht im Süßwasser', 'Stirbt nach dem Laichen', 'Fettflosse'], habitat: 'Atlant. Küste, Nordseeflüsse', spawningSeason: 'Oktober bis Dezember', mnemonicHint: '"Salar" = Salzwasser + Fluss'),
  Fish(id: 'regenbogenforelle', germanName: 'Regenbogenforelle', latinName: 'Oncorhynchus mykiss', family: 'Salmonidae', imagePath: 'assets/fish/regenbogenforelle.png', characteristics: ['Regenbogenfarbener Seitenstreifen', 'Aus Nordamerika eingeführt', 'Fettflosse', 'Schwarze Punkte auch auf Flossen'], habitat: 'Kalte Bäche, Teiche', spawningSeason: 'Januar bis April', minLengthCm: 25, mnemonicHint: 'Regenbogen = bunte Streifen + aus Amerika'),
  Fish(id: 'bachsaibling', germanName: 'Bachsaibling', latinName: 'Salvelinus fontinalis', family: 'Salmonidae', imagePath: 'assets/fish/bachsaibling.png', characteristics: ['Rote Punkte mit blauem Hof', 'Kieslaicher', 'Nicht einheimisch (Nordamerika)', 'Fettflosse'], habitat: 'Sehr kalte, klare Gewässer', spawningSeason: 'Oktober bis Dezember'),
  Fish(id: 'aesche', germanName: 'Äsche', latinName: 'Thymallus thymallus', family: 'Salmonidae', imagePath: 'assets/fish/aesche.png', characteristics: ['Fahnenförmige Rückenflosse (Männchen)', 'Thymiangeruch', 'Fettflosse', 'Sommerlaicher'], habitat: 'Klare Fließgewässer (Äschenregion)', spawningSeason: 'März bis Mai', minLengthCm: 30, mnemonicHint: 'Große Fahnen-Rückenflosse = Äsche'),

  // Hechtartige
  Fish(id: 'hecht', germanName: 'Hecht', latinName: 'Esox lucius', family: 'Esocidae', imagePath: 'assets/fish/hecht.png', characteristics: ['Entenartiges Maul', 'Grün-gelb gefleckt', 'Laicht Feb–Mai an Pflanzen', 'Größter einheim. Raubfisch nach Wels'], habitat: 'Alle Stillgewässer, Flüsse', spawningSeason: 'Februar bis Mai', minLengthCm: 50, mnemonicHint: 'Enten-Schnabel = Hecht'),

  // Aalartige
  Fish(id: 'aal', germanName: 'Aal', latinName: 'Anguilla anguilla', family: 'Anguillidae', imagePath: 'assets/fish/aal.png', characteristics: ['Schlangenförmig, keine Bauchflossen', 'Laicht einmal im Leben (Sargasso-See)', 'Glasaal → Gelbaal → Blankaal', 'Weibchen größer als Männchen'], habitat: 'Fast alle Gewässer', minLengthCm: 50, mnemonicHint: 'Sargasso = Aal, keine Bauchflossen'),

  // Karpfenartige (Cypriniden)
  Fish(id: 'karpfen', germanName: 'Wildkarpfen', latinName: 'Cyprinus carpio', family: 'Cyprinidae', imagePath: 'assets/fish/wildkarpfen.png', characteristics: ['4 Bartfäden', 'Lange Rückenflosse', 'Schlundzähne', 'Sommerlaicher (Mai–Juli)'], habitat: 'Warme Stillgewässer', spawningSeason: 'Mai bis Juli', minLengthCm: 35, mnemonicHint: '4 Bartfäden = Karpfen'),
  Fish(id: 'brasse', germanName: 'Brasse', latinName: 'Abramis brama', family: 'Cyprinidae', imagePath: 'assets/fish/brasse.png', characteristics: ['Hochrückig', 'Silbrig, keine Bartfäden', 'Schlundzähne', 'Kann Maul vorstrecken'], habitat: 'Stehende und langsam fließende Gewässer', minLengthCm: 25),
  Fish(id: 'rotauge', germanName: 'Rotauge (Plötze)', latinName: 'Rutilus rutilus', family: 'Cyprinidae', imagePath: 'assets/fish/rotauge.png', characteristics: ['Rote Augen und Flossen', 'Zweikammerige Schwimmblase', 'Häufiger Weißfisch', 'Laicht Apr–Mai'], habitat: 'Seen und Flüsse', minLengthCm: 20),
  Fish(id: 'rotfeder', germanName: 'Rotfeder', latinName: 'Scardinius erythrophthalmus', family: 'Cyprinidae', imagePath: 'assets/fish/rotfeder.png', characteristics: ['Rote Flossen (intensiver als Rotauge)', 'Frisst auch Schwebalgen', 'Bauchflosse vor Rückenflosse', 'Laicht Mai–Juni'], habitat: 'Ruhige, krautreiche Gewässer', minLengthCm: 20),
  Fish(id: 'schleie', germanName: 'Schleie', latinName: 'Tinca tinca', family: 'Cyprinidae', imagePath: 'assets/fish/schleie.png', characteristics: ['2 kleine Bartfäden', 'Goldgelbe Färbung, kleine Schuppen', 'Weibchen an Bauchflossen erkennbar', 'Laicht Mai–Juli'], habitat: 'Krautreiche Stillgewässer', minLengthCm: 25, mnemonicHint: '2 Bartfäden + gold = Schleie'),
  Fish(id: 'nase', germanName: 'Nase', latinName: 'Chondrostoma nasus', family: 'Cyprinidae', imagePath: 'assets/fish/nase.png', characteristics: ['Unterständiges Maul mit horniger Lippe', 'Frisst Algen vom Stein', 'Laicht im Frühjahr auf Kies'], habitat: 'Fließende Gewässer (Barbenregion)', minLengthCm: 25),
  Fish(id: 'gruendling', germanName: 'Gründling', latinName: 'Gobio gobio', family: 'Cyprinidae', imagePath: 'assets/fish/gruendling.png', characteristics: ['2 Bartfäden', 'Unterständiges Maul', 'Kleiner Bodenfisch', 'Bartfäden zur Artbestimmung'], habitat: 'Sandige, fließende Gewässer'),
  Fish(id: 'barbe', germanName: 'Barbe', latinName: 'Barbus barbus', family: 'Cyprinidae', imagePath: 'assets/fish/barbe.png', characteristics: ['4 Bartfäden', 'Unterständiges Maul', 'Kräftiger Körper', 'Namensgebend für Barbenregion'], habitat: 'Fließende Gewässer (Barbenregion)', minLengthCm: 30, mnemonicHint: '4 Bartfäden wie Karpfen, aber schlanker'),
  Fish(id: 'ukelei', germanName: 'Ukelei', latinName: 'Alburnus alburnus', family: 'Cyprinidae', imagePath: 'assets/fish/ukelei.png', characteristics: ['Silbrig, schlank', 'Endständiges Maul', 'Großer Schwarm', 'Oberflächenfisch'], habitat: 'Seen und Flüsse'),
  Fish(id: 'guester', germanName: 'Güster', latinName: 'Blicca bjoerkna', family: 'Cyprinidae', imagePath: 'assets/fish/guester.png', characteristics: ['Ähnlich Brasse, aber kleiner', 'Kammschuppen (wie Barsch)', 'Rötliche Brustflossen'], habitat: 'Seen und langsame Flüsse'),
  Fish(id: 'doebel', germanName: 'Döbel', latinName: 'Leuciscus cephalus', family: 'Cyprinidae', imagePath: 'assets/fish/doebel.png', characteristics: ['Großer Kopf', 'Runde Cycloid-Schuppen', 'Allround-Räuber', 'Endständiges Maul'], habitat: 'Fließende Gewässer', minLengthCm: 25),
  Fish(id: 'aland', germanName: 'Aland', latinName: 'Leuciscus idus', family: 'Cyprinidae', imagePath: 'assets/fish/aland.png', characteristics: ['Goldige Färbung', 'Größerer Verwandter des Döbels', 'Endständiges Maul'], habitat: 'Größere Flüsse und Seen'),
  Fish(id: 'hasel', germanName: 'Hasel', latinName: 'Leuciscus leuciscus', family: 'Cyprinidae', imagePath: 'assets/fish/hasel.png', characteristics: ['Schlank, grau-silbrig', 'Kleiner als Döbel', 'Unterständiges bis endständiges Maul'], habitat: 'Fließende Gewässer'),
  Fish(id: 'moderlieschen', germanName: 'Moderlieschen', latinName: 'Leucaspius delineatus', family: 'Cyprinidae', imagePath: 'assets/fish/moderlieschen.png', characteristics: ['Sehr klein', 'Silbriger Seitenstreifen', 'Kleinstgewässer'], habitat: 'Kleine Teiche, Tümpel'),
  Fish(id: 'schneider', germanName: 'Schneider', latinName: 'Alburnoides bipunctatus', family: 'Cyprinidae', imagePath: 'assets/fish/schneider.png', characteristics: ['Doppelter Seitenstreifen', 'Ähnelt Ukelei', 'Bergbächle'], habitat: 'Sauerstoffreiche Bäche'),
  Fish(id: 'karausche', germanName: 'Karausche', latinName: 'Carassius carassius', family: 'Cyprinidae', imagePath: 'assets/fish/karausche.png', characteristics: ['Keine Bartfäden (anders als Karpfen!)', 'Kurze Rückenflosse (anders als Karpfen)', 'Extrem robust, überlebt Sauerstoffmangel'], habitat: 'Flache, krautreiche Gewässer'),
  Fish(id: 'giebel', germanName: 'Giebel', latinName: 'Carassius gibelio', family: 'Cyprinidae', imagePath: 'assets/fish/giebel.png', characteristics: ['Silbrig (Karausche ist bräunlich)', 'Keine Bartfäden', 'Vermehrt sich parthenogenetisch'], habitat: 'Stillgewässer'),
  Fish(id: 'bitterling', germanName: 'Bitterling', latinName: 'Rhodeus sericeus', family: 'Cyprinidae', imagePath: 'assets/fish/bitterling.png', characteristics: ['Legt Eier in Großmuscheln ab', 'Prächtig gefärbtes Männchen', 'Kleiner Buntbarsch-ähnlicher Fisch'], habitat: 'Gewässer mit Großmuscheln', isProtected: true),
  Fish(id: 'elritze', germanName: 'Elritze', latinName: 'Phoxinus phoxinus', family: 'Cyprinidae', imagePath: 'assets/fish/elritze.png', characteristics: ['Sehr kleiner Fisch', 'Braungrün gefleckt', 'Kieslaicher in Bächen'], habitat: 'Kalte, sauerstoffreiche Bäche'),
  Fish(id: 'schmerle', germanName: 'Schmerle', latinName: 'Barbatula barbatula', family: 'Nemacheilidae', imagePath: 'assets/fish/schmerle.png', characteristics: ['6 Bartfäden', 'Bodenfisch', 'Fleckenmuster', 'Schmerlenartige'], habitat: 'Bäche mit Steinboden'),
  Fish(id: 'schlammpeitzger', germanName: 'Schlammpeitzger', latinName: 'Misgurnus fossilis', family: 'Cobitidae', imagePath: 'assets/fish/schlammpeitzger.png', characteristics: ['Darmatmung möglich', '10 Bartfäden', 'Überwintert im Schlamm', 'Schmerlenartige'], habitat: 'Schlammige Gräben', isProtected: true),
  Fish(id: 'steinbeisser', germanName: 'Steinbeißer', latinName: 'Cobitis taenia', family: 'Cobitidae', imagePath: 'assets/fish/steinbeisser.png', characteristics: ['Kleiner Bodenfisch', '6 Bartfäden', 'Schmerlenartige', 'Versteckt im Sand'], habitat: 'Sandige Bäche', isProtected: true),

  // Barschenartige
  Fish(id: 'flussbarsch', germanName: 'Flussbarsch', latinName: 'Perca fluviatilis', family: 'Percidae', imagePath: 'assets/fish/flussbarsch.png', characteristics: ['2 Rückenflossen, erste mit Stachelstrahlen', 'Schwarzer Fleck an 1. Rückenflosse', 'Querstreifen', 'Legt Eier in langen Bändern ab'], habitat: 'Alle stehenden und fließenden Gewässer', minLengthCm: 18, mnemonicHint: 'Schwarzer Fleck am Ende der 1. Rückenflosse'),
  Fish(id: 'zander', germanName: 'Zander', latinName: 'Sander lucioperca', family: 'Percidae', imagePath: 'assets/fish/zander.png', characteristics: ['Kammschuppen', 'Keine Querstreifen (Längsstreifen)', 'Laicht Apr–Mai', 'Schwimmblase ohne Luftgang'], habitat: 'Tiefe, klare Seen und Flüsse', minLengthCm: 42, mnemonicHint: 'Längsstreifen = Zander, Querstreifen = Barsch'),
  Fish(id: 'kaulbarsch', germanName: 'Kaulbarsch', latinName: 'Gymnocephalus cernuus', family: 'Percidae', imagePath: 'assets/fish/kaulbarsch.png', characteristics: ['Kleiner Barsch', 'Stachelflossen', 'Schleimig', 'Kiemendeckeldorn'], habitat: 'Seen und Flüsse'),
  Fish(id: 'muehlkoppe', germanName: 'Mühlkoppe (Groppe)', latinName: 'Cottus gobio', family: 'Cottidae', imagePath: 'assets/fish/muehlgroppe.png', characteristics: ['Bauchflossen zu Haftscheibe verwachsen', 'Breiter Kopf', 'Keine Schwimmblase', 'Bodenfisch in Bächen'], habitat: 'Kalte, sauerstoffreiche Bäche', isProtected: true),

  // Welsartige
  Fish(id: 'wels', germanName: 'Wels', latinName: 'Silurus glanis', family: 'Siluridae', imagePath: 'assets/fish/wels.png', characteristics: ['6 Bartfäden', 'Größter einheim. Süßwasserfisch', 'Keine Schuppen', 'Flache Rückenflosse'], habitat: 'Warme, tiefe Gewässer', minLengthCm: 70, mnemonicHint: '6 Bartfäden + riesig + keine Schuppen'),

  // Dorschenartige
  Fish(id: 'quappe', germanName: 'Quappe (Rutte)', latinName: 'Lota lota', family: 'Gadidae', imagePath: 'assets/fish/quappe.png', characteristics: ['1 Bartfaden (Kinn)', 'Einziger einheim. Süßwasser-Dorsch', 'Winterlaicher (Dez–Feb)', 'Keine Schwimmblase'], habitat: 'Kalte tiefe Seen und Flüsse', minLengthCm: 30),
  Fish(id: 'kabeljau', germanName: 'Kabeljau (Dorsch)', latinName: 'Gadus morhua', family: 'Gadidae', imagePath: 'assets/fish/dorsch.png', characteristics: ['1 Bartfaden am Kinn', 'Meeresfisch (Nordsee)', '3 Rückenflossen, 2 Afterflossen', 'Typisches Dorsch-Muster'], habitat: 'Nordsee und Ostsee'),

  // Heringsartige
  Fish(id: 'maifisch', germanName: 'Maifisch', latinName: 'Alosa alosa', family: 'Clupeidae', imagePath: 'assets/fish/maifisch.png', characteristics: ['Heringsartige', 'Laicht im Mai', 'Wanderfisch', 'Unter Artenschutz!'], habitat: 'Meer und Wanderung in Flüsse', isProtected: true),
  Fish(id: 'makrele', germanName: 'Makrele', latinName: 'Scomber scombrus', family: 'Scombridae', imagePath: 'assets/fish/makrele.png', characteristics: ['Meeresfisch', 'Freiwasserfisch', 'Keine Schwimmblase', 'Grün-blau gestreift'], habitat: 'Atlantik, Nordsee'),

  // Plattfische
  Fish(id: 'flunder', germanName: 'Flunder', latinName: 'Platichthys flesus', family: 'Pleuronectidae', imagePath: 'assets/fish/flunder.png', characteristics: ['Plattfisch', 'Beide Augen auf einer Seite', 'Meeres- und Brackwasserfisch', 'Zielart Rute A10'], habitat: 'Nordsee, Ostsee, Brackwasser'),
  Fish(id: 'nordseeschnäpel', germanName: 'Nordseeschnäpel', latinName: 'Coregonus oxyrinchus', family: 'Salmonidae', imagePath: 'assets/fish/schnaepel.png', characteristics: ['Spitze Schnauze', 'Wanderfisch', 'Sehr selten', 'Unter Artenschutz'], habitat: 'Nordsee und Zuflüsse', isProtected: true),

  // Krebse
  Fish(id: 'edelkrebs', germanName: 'Edelkrebs', latinName: 'Astacus astacus', family: 'Astacidae', imagePath: 'assets/fish/edelkrebs.png', characteristics: ['Einziger einheim. Flusskrebs in NRW', 'Durch Krebspest bedroht', 'Rote Unterseite der Scheren', 'Nachtaktiv'], habitat: 'Saubere Fließgewässer', isProtected: true),
  Fish(id: 'amerikanischer_krebs', germanName: 'Amerikanischer Krebs', latinName: 'Orconectes limosus', family: 'Cambaridae', imagePath: 'assets/fish/flusskrebs.png', characteristics: ['Nicht einheimisch', 'Träger der Krebspest', 'Rostige Zeichnung auf Rücken'], habitat: 'Viele Gewässer'),

  // Neunauge
  Fish(id: 'bach_flussneunauge', germanName: 'Bach-/Flussneunauge', latinName: 'Lampetra spec.', family: 'Petromyzontidae', imagePath: 'assets/fish/flussneunauge.png', characteristics: ['Rundmaul', 'Keine Kiefer', '7 Kiemenöffnungen', 'Parasitiert an Fischen'], habitat: 'Bäche und Flüsse', isProtected: true),

  // Stichlinge
  Fish(id: 'dreistachliger_stichling', germanName: 'Dreistachliger Stichling', latinName: 'Gasterosteus aculeatus', family: 'Gasterosteidae', imagePath: 'assets/fish/dreistachliger_stichling.png', characteristics: ['3 Rücken-Stacheln', 'Männchen baut Nest', 'Intensive Brutpflege', 'Sehr klein'], habitat: 'Gräben, Flüsse'),
  Fish(id: 'zwergstichling', germanName: 'Zwergstichling', latinName: 'Pungitius pungitius', family: 'Gasterosteidae', imagePath: 'assets/fish/zwergstichling.png', characteristics: ['8-10 Stacheln', 'Noch kleiner als Dreistachliger', 'Brutpflege'], habitat: 'Kleingewässer'),

  // Kessler-Grundel
  Fish(id: 'kessler_grundel', germanName: 'Kessler-Grundel', latinName: 'Ponticola kessleri', family: 'Gobiidae', imagePath: 'assets/fish/kesslergrundel.png', characteristics: ['Grundelfisch', 'Eingewandert aus Ponto-Kaspischem Raum', 'Bauchflossen als Saugscheibe'], habitat: 'Rhein und Nebenflüsse'),

  // Rapfen
  Fish(id: 'rapfen', germanName: 'Rapfen', latinName: 'Aspius aspius', family: 'Cyprinidae', imagePath: 'assets/fish/rapfen.png', characteristics: ['Einziger räuberischer Karpfenfisch', 'Greift Fische an Wasseroberfläche an', 'Großer Körper', 'Endständiges Maul'], habitat: 'Große Flüsse'),

  // Zährte
  Fish(id: 'zaehrte', germanName: 'Zährte', latinName: 'Vimba vimba', family: 'Cyprinidae', imagePath: 'assets/fish/zaehrte.png', characteristics: ['Unterständiges Maul', 'Verwandt mit Blicca', 'Rüsselnase'], habitat: 'Große Flüsse'),
];
