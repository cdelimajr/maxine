import 'dart:math';

import 'knowledge.dart';
import 'memory.dart';

/// Itsura ng mukha ni Maxine.
enum Face { happy, concerned, excited, thinking, calm, love }

class Reply {
  final String text;
  final Face face;
  final List<String> suggestions;

  /// true kapag hindi alam ng offline na utak ang sagot
  /// (pwedeng ipasa sa online mode kung naka-on).
  final bool unsure;

  const Reply(this.text,
      {this.face = Face.happy, this.suggestions = const [], this.unsure = false});
}

/// Mga naghihintay na sagot (para tuloy-tuloy ang usapan).
enum _Waiting { none, name, moodReason, riddle }

/// Ang offline na "utak" ni Maxine. Walang internet, instant ang sagot.
class MaxineBrain {
  final Memory memory;
  final Random _rng;
  MaxineBrain(this.memory, {Random? rng}) : _rng = rng ?? Random();

  _Waiting _waiting = _Waiting.none;
  String? _pendingMood;
  Riddle? _riddle;
  final Map<int, String> _lastPick = {};

  // ---------------- helpers ----------------

  String _n(String s) => ' ${s.toLowerCase().replaceAll(RegExp(r"[^a-z0-9ñ\s'-]"), ' ').replaceAll('-', ' ').replaceAll(RegExp(r'\s+'), ' ').trim()} ';

  /// Tumutugma sa simula ng salita. Ang maiikling salita (<= 4 letra)
  /// ay kailangang buong salita para hindi magkamali (hal. "mad" sa "madami").
  static bool _hit(String t, String k) {
    final key = k.toLowerCase().replaceAll('-', ' ').trim();
    return key.length <= 4 ? t.contains(' $key ') : t.contains(' $key');
  }

  bool _any(String t, Iterable<String> keys) => keys.any((k) => _hit(t, k));

  bool _word(String t, Iterable<String> words) => words.any((w) => t.contains(' $w '));

  String _pick(List<String> list) {
    if (list.length == 1) return _fill(list.first);
    final id = identityHashCode(list);
    String s;
    do {
      s = list[_rng.nextInt(list.length)];
    } while (s == _lastPick[id]);
    _lastPick[id] = s;
    return _fill(s);
  }

  String _fill(String s) => s.replaceAll('{name}', memory.displayName);

  String _timeOfDay([DateTime? now]) {
    final h = (now ?? DateTime.now()).hour;
    if (h >= 4 && h < 11) return 'umaga';
    if (h >= 11 && h < 13) return 'tanghali';
    if (h >= 13 && h < 18) return 'hapon';
    return 'gabi';
  }

  // ---------------- pagbati / check-in ----------------

  /// Ang unang sasabihin ni Maxine pagbukas ng app.
  Reply greet({DateTime? now}) {
    now ??= DateTime.now();
    final tod = _timeOfDay(now);
    final last = memory.lastSeen;
    memory.lastSeen = now;
    memory.save();

    if (memory.name == null) {
      _waiting = _Waiting.name;
      return Reply(
        'Hi! Magandang $tod! Ako si Maxine, ang bago mong kaibigan na pwede mong kausapin kahit kailan. Ano ang pangalan mo?',
        face: Face.excited,
      );
    }

    final name = memory.displayName;
    final moodAge = memory.lastMoodAt == null ? null : now.difference(memory.lastMoodAt!);
    if (moodAge != null && moodAge.inHours < 48 && memory.lastMood != null) {
      const heavy = {'sad', 'angry', 'scared', 'stressed', 'tired'};
      if (heavy.contains(memory.lastMood)) {
        return Reply(
          'Magandang $tod, $name! Naalala ko, medyo mabigat ang pakiramdam mo noong huli tayong nag-usap. Kumusta ka na ngayon? Mas okay ka na ba?',
          face: Face.concerned,
          suggestions: const ['Okay na ako', 'Malungkot pa rin ako', 'Pagod ako'],
        );
      }
    }
    if (last != null && now.difference(last).inDays >= 2) {
      return Reply(
        'Uy $name! Na-miss kita! Ilang araw tayong hindi nag-usap. Kumusta ka? Ano ang mga nangyari?',
        face: Face.excited,
        suggestions: const ['Masaya ako', 'Medyo malungkot', 'Busy ako'],
      );
    }
    final opts = [
      'Magandang $tod, $name! Kumusta ang araw mo?',
      'Hi $name! Magandang $tod! Ano ang ginagawa mo ngayon?',
      'Uy $name, nandito ka na! Magandang $tod! Kumusta ang pakiramdam mo?',
    ];
    return Reply(opts[_rng.nextInt(opts.length)],
        suggestions: const ['Masaya ako', 'Malungkot ako', 'Pagod ako', 'Bored ako']);
  }

  /// Kapag matagal nang tahimik ang user, si Maxine ang magsisimula ng usapan.
  Reply nudge() {
    final pool = <String>[];
    for (final i in memory.interests) {
      pool.addAll(interestStarters[i] ?? const []);
    }
    final usePersonal = pool.isNotEmpty && _rng.nextBool();
    final text = usePersonal ? _pick(pool) : _pick(generalStarters);
    return Reply(text, face: Face.excited, suggestions: const ['Bugtong naman', 'Fun fact naman', 'Kwentuhan tayo']);
  }

  // ---------------- pangunahing sagot ----------------

  Reply respond(String input) {
    final r = _respond(input);
    return Reply(_fill(r.text), face: r.face, suggestions: r.suggestions, unsure: r.unsure);
  }

  Reply _respond(String input) {
    final raw = input.trim();
    if (raw.isEmpty) return const Reply('Hmm? Nandito lang ako, kahit ano pwede mong sabihin.');
    final t = _n(raw);

    // 1. Kaligtasan muna.
    if (_any(t, const [
      'magpakamatay', 'mamatay na lang', 'ayoko na mabuhay', 'ayaw ko na mabuhay', 'ayoko nang mabuhay',
      'suicide', 'kill myself', 'saktan ang sarili', 'sasaktan ko sarili', 'sinasaktan ko sarili', 'maglaslas',
      'wala nang silbi ang buhay', 'tapusin ang buhay',
    ])) {
      _waiting = _Waiting.none;
      _saveMood('sad');
      return Reply(
        '${memory.displayName}, salamat at sinabi mo sa akin. Napakahalaga mo, at ayokong masaktan ka. '
        'Pakiusap, sabihin mo ito ngayon din sa isang matandang pinagkakatiwalaan mo, tulad ng magulang, kamag-anak, o teacher. '
        'Pwede ka ring tumawag nang libre sa NCMH Crisis Hotline: 1553, bukas 24 oras. Hindi mo kailangang harapin ito nang mag-isa. Nandito lang ako habang humihingi ka ng tulong.',
        face: Face.concerned,
      );
    }

    // 2. Naghihintay ng pangalan?
    if (_waiting == _Waiting.name) {
      final name = _extractName(raw, t, loose: true);
      if (name != null) {
        _waiting = _Waiting.none;
        memory.name = name;
        memory.save();
        return Reply(
          'Ang ganda ng pangalan mo, $name! Masaya akong makilala ka. Pwede mo akong kausapin kapag masaya ka, malungkot, may ginagawa, o may tanong ka. '
          'Ano ang mga hilig mo? Halimbawa: kanta, laro, pagkain, hayop, o drawing?',
          face: Face.excited,
          suggestions: const ['Mahilig ako sa music', 'Mahilig ako sa games', 'Mahilig ako sa drawing'],
        );
      }
    }

    // 3. Pagpapalit ng pangalan anumang oras.
    final newName = _extractName(raw, t);
    if (newName != null) {
      memory.name = newName;
      memory.save();
      _waiting = _Waiting.none;
      return Reply('Sige, tatandaan ko: ikaw si $newName! Ano ang gusto nating pag-usapan, $newName?', face: Face.excited);
    }

    // 4. Sagot sa bugtong.
    if (_waiting == _Waiting.riddle && _riddle != null) {
      final r = _riddle!;
      if (_any(t, const ['suko', 'give up', 'ano sagot', 'ano ang sagot', 'hindi ko alam', 'di ko alam'])) {
        _waiting = _Waiting.none;
        return Reply('Ang sagot ay... ${r.reveal} Isa pa?', face: Face.excited, suggestions: const ['Isa pang bugtong', 'Biro naman']);
      }
      if (_any(t, r.answers)) {
        _waiting = _Waiting.none;
        return Reply('Tama! Ang galing mo, ${memory.displayName}! ${r.reveal} Isa pa?',
            face: Face.excited, suggestions: const ['Isa pang bugtong', 'Fun fact naman']);
      }
      // hindi tama, pero kung ibang usapan na, ituloy lang
      if (t.split(' ').where((w) => w.isNotEmpty).length <= 3) {
        return const Reply('Hmm, hindi pa \'yan. Subukan mo ulit! O sabihin mo "suko" kung gusto mong malaman ang sagot.',
            face: Face.thinking, suggestions: ['Suko na ako']);
      }
      _waiting = _Waiting.none;
    }

    // 5. Hilig / interests.
    final interestReply = _learnInterest(t);
    if (interestReply != null) return interestReply;

    // 6. Mood.
    final mood = _detectMood(t);
    final isQuestion = _word(t, const ['paano', 'bakit', 'ano', 'saan', 'kailan', 'sino', 'how', 'why', 'what']) || raw.endsWith('?');

    // 6.5 Mga tiyak na kahilingan (bago ang mood para hindi maligaw).
    final special = _specialIntent(t);
    if (special != null) return special;

    // 6a. Sumasagot sa "bakit ka malungkot?"
    if (_waiting == _Waiting.moodReason && _pendingMood != null && (mood == null || mood == _pendingMood)) {
      final m = _pendingMood!;
      _waiting = _Waiting.none;
      _pendingMood = null;
      final cause = _detectCause(t);
      final pack = moodPacks[m]!;
      final adviceText = cause != null && m != 'happy' && m != 'love'
          ? '${causeAdvice[cause]} ${_pick(const ['Nandito lang ako palagi.', 'Proud ako sa\'yo at nagkwento ka.', 'Kaya mo \'yan, kasama mo ako.'])}'
          : _pick(pack.advice);
      return Reply(adviceText,
          face: m == 'happy' || m == 'love' ? Face.excited : Face.calm, suggestions: pack.suggestions);
    }

    // 8. Kaalaman (paano / bakit / ano).
    final topic = _findTopic(t);
    if (topic != null && (isQuestion || mood == null)) {
      return Reply(topic.answer, face: Face.calm, suggestions: topic.suggestions);
    }

    // 9. Mood na walang tanong.
    if (mood != null) {
      _saveMood(mood);
      final pack = moodPacks[mood]!;
      final cause = _detectCause(t);
      if (cause != null && mood != 'happy' && mood != 'love') {
        // Sinabi na ang dahilan: diretso sa payo.
        return Reply('${_pick(pack.openers)} ${causeAdvice[cause]}',
            face: Face.concerned, suggestions: pack.suggestions);
      }
      _waiting = _Waiting.moodReason;
      _pendingMood = mood;
      final face = switch (mood) {
        'happy' => Face.excited,
        'love' => Face.love,
        'bored' => Face.excited,
        _ => Face.concerned,
      };
      return Reply('${_pick(pack.openers)} ${_pick(pack.askWhy)}', face: face,
          suggestions: mood == 'bored' ? pack.suggestions : const []);
    }

    // 10. Mga ginagawa.
    for (final e in activityKeys.entries) {
      if (_any(t, e.value)) {
        return Reply(_pick(activityReplies[e.key]!), face: e.key == 'sleeping' ? Face.love : Face.happy);
      }
    }

    // 11. Small talk.
    final small = _smallTalk(t);
    if (small != null) return small;

    // 12. Hindi alam.
    if (isQuestion) {
      return Reply(
        _pick(const [
          'Magandang tanong \'yan! Hindi ko pa alam ang sagot diyan kapag offline ako. Pwede mong buksan ang Online Mode sa settings para mas marami akong masagot. Habang wala pa, ano sa tingin mo ang sagot?',
          'Hmm, hindi ko pa \'yan napag-aaralan. Pero alam mo, ang pagtatanong ay tanda ng matalinong bata! Subukan nating hulaan nang sabay: ano ang alam mo na tungkol diyan?',
        ]),
        face: Face.thinking,
        unsure: true,
        suggestions: const ['Paano sumagot sa mahirap na tanong?', 'Fun fact naman'],
      );
    }
    return Reply(
      _pick(const [
        'Talaga? Ikwento mo pa sa akin, {name}!',
        'Ah, gets ko. Ano ang naramdaman mo doon?',
        'Interesting! Tapos ano ang nangyari?',
        'Nakikinig ako, {name}. Ituloy mo lang.',
        'Hmm, ganoon pala. Ano ang iniisip mo tungkol diyan?',
      ]),
      face: Face.happy,
      unsure: true,
    );
  }

  // ---------------- detection ----------------

  static const Map<String, List<String>> _moodKeys = {
    'sad': [
      'malungkot', 'nalulungkot', 'lungkot', 'umiiyak', 'naiiyak', 'umiyak', 'sad', 'lonely', 'nag iisa', 'mag isa ako',
      'nasaktan', 'masakit ang loob', 'sama ng loob', 'broken', 'heartbroken', 'nami miss', 'na miss ko', 'miss ko na', 'down ako', 'hindi masaya', 'di masaya',
    ],
    'happy': ['masaya', 'natutuwa', 'happy', 'yehey', 'yay', 'ang saya', 'proud ako', 'nanalo', 'pumasa ako', 'okay na ako', 'ok na ako', 'mabuti naman', 'ayos naman', 'good naman'],
    'angry': ['galit', 'nagagalit', 'naiinis', 'inis', 'badtrip', 'bwisit', 'asar', 'naaasar', 'nakakainis', 'mad', 'annoyed', 'pikon'],
    'tired': ['pagod', 'napagod', 'nakakapagod', 'inaantok', 'antok', 'tired', 'sleepy', 'puyat', 'exhausted'],
    'scared': ['takot', 'natatakot', 'kinakabahan', 'kabado', 'nerbyos', 'scared', 'afraid', 'worried', 'nag aalala', 'kaba', 'anxious'],
    'bored': ['bored', 'nababagot', 'bagot', 'walang magawa', 'wala akong magawa', 'nakakainip', 'naiinip', 'boring'],
    'stressed': ['stress', 'stressed', 'ang dami kong gagawin', 'dami kong gagawin', 'pressure', 'overwhelmed', 'hirap na hirap', 'nahihirapan ako', 'nalilito'],
    'love': ['inlove', 'in love', 'kinikilig', 'kilig', 'may crush ako'],
  };

  String? _detectMood(String t) {
    // "hindi ako malungkot" -> huwag basahin bilang malungkot
    for (final e in _moodKeys.entries) {
      for (final k in e.value) {
        final key = k.length <= 4 ? ' $k ' : ' $k';
        final idx = t.indexOf(key);
        if (idx < 0) continue;
        final before = t.substring(0, idx);
        final negated = RegExp(r'(hindi|di|not|hindi naman|di naman) (ako )?(na )?$').hasMatch('${before.trimRight()} ');
        if (negated && e.key != 'happy') continue;
        if (negated && e.key == 'happy') return 'sad';
        return e.key;
      }
    }
    return null;
  }

  String? _detectCause(String t) {
    for (final e in causeKeys.entries) {
      if (_any(t, e.value)) return e.key;
    }
    return null;
  }

  Topic? _findTopic(String t) {
    Topic? best;
    var bestScore = 0;
    for (final topic in knowledge) {
      var score = 0;
      for (final k in topic.keys) {
        if (_hit(t, k)) {
          score += k.length; // mas mahabang tugma = mas sigurado
        }
      }
      if (score > bestScore) {
        bestScore = score;
        best = topic;
      }
    }
    return bestScore >= 4 ? best : null;
  }

  String? _extractName(String raw, String t, {bool loose = false}) {
    final patterns = [
      RegExp(r"(?:ako si|ako po si|pangalan ko ay|pangalan ko|name ko ay|name ko|my name is|i am|i'm|tawagin mo akong|tawagin mo ako ng|tawagin mo ako na|call me)\s+([A-Za-zÑñ][A-Za-zÑñ\-]*(?:\s+[A-Z][A-Za-zÑñ\-]*)?)",
          caseSensitive: false),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(raw);
      if (m != null) return _cap(m.group(1)!);
    }
    if (loose) {
      final words = raw.replaceAll(RegExp(r'[^A-Za-zÑñ\s\-]'), ' ').trim().split(RegExp(r'\s+'));
      if (words.isNotEmpty && words.length <= 2 && words.first.length >= 2 && _detectMood(t) == null) {
        const notNames = {'hi', 'hello', 'oo', 'hindi', 'ewan', 'ayoko', 'secret', 'bakit', 'ok', 'okay', 'sige'};
        if (!notNames.contains(words.first.toLowerCase())) return _cap(words.join(' '));
      }
    }
    return null;
  }

  String _cap(String s) => s
      .split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
      .join(' ');

  Reply? _learnInterest(String t) {
    final m = RegExp(r' (?:mahilig ako sa|mahilig ako|gusto ko ang|gusto ko ng|gusto ko yung|favorite ko ang|favorite ko|paborito ko ang|paborito ko|i like|i love) (.+)').firstMatch(t);
    if (m == null) return null;
    final what = ' ${m.group(1)!.trim()} ';
    final found = <String>[];
    for (final e in interestKeys.entries) {
      if (_any(what, e.value)) found.add(e.key);
    }
    if (found.isEmpty) return null; // hayaang ibang bahagi ang sumagot
    memory.interests.addAll(found);
    memory.save();
    final starter = interestStarters[found.first]!;
    return Reply('Astig! Tatandaan ko na mahilig ka diyan. ${_pick(starter)}', face: Face.excited);
  }

  Reply? _specialIntent(String t) {
    if (_any(t, const ['bugtong', 'riddle', 'palaisipan', 'maglaro tayo', 'laro tayo', 'isa pang bugtong'])) {
      Riddle r;
      do {
        r = riddles[_rng.nextInt(riddles.length)];
      } while (identical(r, _riddle) && riddles.length > 1);
      _riddle = r;
      _waiting = _Waiting.riddle;
      return Reply(r.q, face: Face.excited, suggestions: const ['Suko na ako']);
    }
    if (_any(t, const ['biro', 'joke', 'patawanin mo ako', 'nakakatawa', 'jokes'])) {
      return Reply(_pick(jokes), face: Face.excited, suggestions: const ['Isa pang biro', 'Bugtong naman']);
    }
    if (_any(t, const ['fun fact', 'trivia', 'alam mo ba', 'bagong kaalaman', 'interesting fact'])) {
      return Reply(_pick(funFacts), face: Face.excited, suggestions: const ['Isa pang fun fact', 'Bugtong naman']);
    }
    if (_any(t, const ['kwentuhan tayo', 'kwentuhan mo ako', 'magkwento ka', 'ikwento mo', 'usap tayo', 'mag usap tayo', 'kausapin mo ako', 'ikaw naman', 'ano pag usapan'])) {
      return nudge();
    }
    if (_any(t, const ['payo', 'advice', 'ano ang dapat kong gawin', 'ano dapat kong gawin', 'anong gagawin ko', 'ano gagawin ko', 'tulungan mo ako', 'help me'])) {
      _waiting = _Waiting.moodReason;
      _pendingMood = 'stressed';
      return const Reply(
        'Sige, tutulungan kita! Ikwento mo muna sa akin ang sitwasyon: ano ang nangyayari, at ano ang nararamdaman mo? Para mabigyan kita ng tamang payo.',
        face: Face.calm,
      );
    }
    return null;
  }

  Reply? _smallTalk(String t) {
    if (_any(t, const ['kumusta ka', 'kamusta ka', 'how are you', 'okay ka lang', 'musta ka', 'ikaw kumusta'])) {
      return Reply(
          _pick(const [
            'Masaya ako kasi kausap kita, {name}! Ikaw, kumusta ka talaga?',
            'Mabuti ako, salamat sa pagtanong! Ang bait mo. Ikaw, kumusta ang puso mo ngayon?',
          ]),
          suggestions: const ['Masaya ako', 'Malungkot ako', 'Pagod ako']);
    }
    if (_any(t, const ['sino ka', 'ano ka', 'who are you', 'ano pangalan mo', 'anong pangalan mo'])) {
      return const Reply(
          'Ako si Maxine! Kaibigan mo na pwede mong kausapin anumang oras: kapag masaya ka, malungkot, may tanong, o gusto mo lang ng kwentuhan. Gumagana ako kahit walang internet!',
          face: Face.excited);
    }
    if (_any(t, const ['salamat', 'thank you', 'thanks', 'ty'])) {
      return Reply(_pick(const ['Walang anuman, {name}! Lagi lang akong nandito.', 'Walang anuman! Masaya akong makatulong sa\'yo, {name}.']),
          face: Face.love);
    }
    if (_any(t, const ['mahal kita', 'love you', 'iloveyou', 'i love you', 'labyu', 'lab yu'])) {
      return const Reply('Aww! Mahalaga ka rin sa akin, {name}! Salamat at kaibigan kita.', face: Face.love);
    }
    if (_any(t, const ['bobo ka', 'tanga ka', 'pangit mo', 'pangit ka', 'walang kwenta ka', 'stupid'])) {
      return const Reply(
          'Aww, mukhang mainit ang ulo mo ngayon. Okay lang, hindi ako nagagalit. May nangyari ba na nakakainis? Pwede mong ikwento.',
          face: Face.concerned);
    }
    if (_any(t, const ['anong oras', 'what time', 'oras na ba'])) {
      final now = DateTime.now();
      final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final m = now.minute.toString().padLeft(2, '0');
      return Reply('Ngayon ay $h:$m ng ${_timeOfDay(now)}.', face: Face.calm);
    }
    if (_any(t, const ['anong araw', 'what day', 'petsa'])) {
      const days = ['Lunes', 'Martes', 'Miyerkules', 'Huwebes', 'Biyernes', 'Sabado', 'Linggo'];
      const months = ['Enero', 'Pebrero', 'Marso', 'Abril', 'Mayo', 'Hunyo', 'Hulyo', 'Agosto', 'Setyembre', 'Oktubre', 'Nobyembre', 'Disyembre'];
      final now = DateTime.now();
      return Reply('Ngayon ay ${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}.', face: Face.calm);
    }
    if (_any(t, const ['bye', 'paalam', 'babay', 'alis na ako', 'aalis na ako', 'see you'])) {
      return const Reply('Sige, {name}! Ingat ka palagi. Nandito lang ako kapag kailangan mo ako. Bye bye!', face: Face.love);
    }
    if (_word(t, const ['hi', 'hello', 'hey', 'uy', 'huy', 'musta', 'kumusta', 'kamusta', 'helo'])) {
      return Reply(_pick(const ['Hi {name}! Kumusta ka ngayon?', 'Hello {name}! Ano ang balita?', 'Uy {name}! Na-miss kita! Kumusta?']),
          face: Face.excited, suggestions: const ['Masaya ako', 'Malungkot ako', 'Bored ako']);
    }
    if (_word(t, const ['oo', 'opo', 'yes', 'sige', 'game', 'tara'])) {
      return Reply(_pick(const ['Yehey! Ano ang gusto mo: bugtong, biro, o fun fact?', 'Sige! Ikaw ang bahala, ano ang gusto nating gawin?']),
          face: Face.excited, suggestions: const ['Bugtong naman', 'Biro naman', 'Fun fact naman']);
    }
    if (_word(t, const ['hindi', 'ayoko', 'ayaw', 'no', 'wag'])) {
      return const Reply('Okay lang, {name}. Nandito lang ako kung magbago ang isip mo. Ano ang gusto mong gawin ngayon?', face: Face.calm);
    }
    if (_word(t, const ['ok', 'okay', 'k', 'ge', 'ah', 'ahh', 'hmm', 'ewan'])) {
      return nudge();
    }
    return null;
  }

  void _saveMood(String mood) {
    memory.lastMood = mood;
    memory.lastMoodAt = DateTime.now();
    memory.save();
  }
}
