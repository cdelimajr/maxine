import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:maxine/brain/maxine_brain.dart';
import 'package:maxine/brain/memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late Memory mem;
  late MaxineBrain b;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mem = Memory();
    b = MaxineBrain(mem, rng: Random(1));
  });

  test('nagtatanong ng pangalan sa unang beses at natatandaan', () {
    final g = b.greet();
    expect(g.text, contains('pangalan'));
    final r = b.respond('Defive');
    expect(mem.name, 'Defive');
    expect(r.text, contains('Defive'));
  });

  test('malungkot -> tanong kung bakit -> payo', () {
    mem.name = 'Ana';
    final r1 = b.respond('malungkot ako');
    expect(r1.face, Face.concerned);
    expect(r1.text, contains('Ana'));
    final r2 = b.respond('kasi bumagsak ako sa exam');
    expect(r2.text, contains('grado'));
  });

  test('may dahilan agad -> diretso sa payo', () {
    final r = b.respond('nalulungkot ako kasi inaaway ako ng kaklase ko');
    expect(r.text.toLowerCase(), contains('kaibigan'));
  });

  test('negation: hindi ako malungkot', () {
    final r = b.respond('hindi ako malungkot');
    expect(r.face, isNot(Face.concerned));
  });

  test('hindi nalilito ang "madami" sa galit', () {
    final r = b.respond('madami akong kinain kanina');
    expect(r.text, isNot(contains('inis')));
  });

  test('tumutulong sa mahirap na tanong', () {
    final r = b.respond('nahihirapan ako sa mga tanong at hindi ko alam kung paano sagutin');
    expect(r.text, contains('tatlong hakbang'));
  });

  test('paliwanag na pambata', () {
    expect(b.respond('bakit asul ang langit?').text, contains('asul'));
    expect(b.respond('paano magsaing').text, contains('bigas'));
  });

  test('ginagawa ng user', () {
    expect(b.respond('kumakain ako ngayon').text.toLowerCase(), anyOf(contains('ulam'), contains('kinakain')));
  });

  test('bugtong game', () {
    final q = b.respond('bugtong naman');
    expect(q.text, startsWith('Bugtong'));
    final r = b.respond('suko na');
    expect(r.text, contains('sagot'));
  });

  test('natatandaan ang hilig', () {
    b.respond('mahilig ako sa drawing');
    expect(mem.interests, contains('drawing'));
  });

  test('kaligtasan: hotline', () {
    final r = b.respond('ayoko na mabuhay');
    expect(r.text, contains('1553'));
  });

  test('hindi alam -> unsure (para sa online mode)', () {
    final r = b.respond('ano ang capital ng Mongolia?');
    expect(r.unsure, isTrue);
  });

  test('check-in kapag malungkot noong huli', () {
    mem.name = 'Ana';
    mem.lastMood = 'sad';
    mem.lastMoodAt = DateTime.now().subtract(const Duration(hours: 3));
    expect(b.greet().text, contains('Kumusta ka na'));
  });

  test('mabilis: 1000 sagot sa ilalim ng 1 segundo', () {
    final sw = Stopwatch()..start();
    for (var i = 0; i < 1000; i++) {
      b.respond('nalulungkot ako kasi pinagalitan ako ni mama');
    }
    expect(sw.elapsedMilliseconds, lessThan(1000));
  });
}
