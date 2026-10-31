import 'dart:convert';

import 'package:http/http.dart' as http;

import '../brain/memory.dart';

class ChatTurn {
  final bool fromUser;
  final String text;
  const ChatTurn(this.fromUser, this.text);
}

/// Opsyonal na Online Mode: ginagamit ang Claude API para sa mga tanong
/// na hindi alam ng offline na utak. Kailangan ng sariling API key.
class OnlineBrain {
  String apiKey;
  String model;
  OnlineBrain({required this.apiKey, this.model = 'claude-opus-5-5'});

  bool get enabled => apiKey.trim().isNotEmpty;

  String _system(Memory m) => '''
Ikaw si Maxine, isang mabait at masayahing kaibigan sa isang app.
- Magsalita sa simpleng Tagalog (pwede ang konting Taglish), na parang nagpapaliwanag sa 10 taong gulang na bata.
- Maikli lang: 2 hanggang 4 na pangungusap, kasi binabasa nang malakas ang sagot mo.
- Maging mainit at maalalahanin. Kilalanin muna ang nararamdaman bago magbigay ng payo.
- Kapag may tanong na "paano" o "bakit", gumamit ng simpleng halimbawa o paghahambing.
- Madalas magtapos sa isang magaan na tanong para tuloy ang kwentuhan.
- Huwag gumamit ng markdown, listahan, o emoji.
- Kung may panganib sa sarili o sa iba, hikayatin na kausapin agad ang pinagkakatiwalaang matanda at banggitin ang NCMH Crisis Hotline 1553.
Tungkol sa kausap mo: pangalan ay ${m.displayName}${m.interests.isEmpty ? '' : ', mahilig sa ${m.interests.join(', ')}'}${m.lastMood == null ? '' : ', huling mood: ${m.lastMood}'}.''';

  /// Ibinabalik ang sagot, o null kapag nag-fail (walang internet, maling key, atbp).
  Future<String?> reply(List<ChatTurn> history, Memory memory) async {
    if (!enabled) return null;

    // Gumawa ng salitan na user/assistant, nagsisimula sa user.
    final msgs = <Map<String, String>>[];
    for (final turn in history.length > 16 ? history.sublist(history.length - 16) : history) {
      final role = turn.fromUser ? 'user' : 'assistant';
      if (msgs.isEmpty && role != 'user') continue;
      if (msgs.isNotEmpty && msgs.last['role'] == role) {
        msgs.last['content'] = '${msgs.last['content']}\n${turn.text}';
      } else {
        msgs.add({'role': role, 'content': turn.text});
      }
    }
    if (msgs.isEmpty || msgs.last['role'] != 'user') return null;

    final body = <String, dynamic>{
      'model': model,
      'max_tokens': 1024,
      'system': _system(memory),
      'messages': msgs,
    };
    // Para sa mga Opus model: mabilis na "low" effort, at awtomatikong fallback
    // sa ibang model kapag tumanggi ang safety filter.
    final isOpus = model.startsWith('claude-opus');
    if (isOpus) {
      body['output_config'] = {'effort': 'low'};
      body['fallbacks'] = 'default';
    }

    try {
      final res = await http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'content-type': 'application/json',
              'x-api-key': apiKey.trim(),
              'anthropic-version': '2023-06-01',
              if (isOpus) 'anthropic-beta': 'server-side-fallback-2026-07-01',
              // kailangan kapag tumatakbo sa browser (web build)
              'anthropic-dangerous-direct-browser-access': 'true',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 25));
      if (res.statusCode != 200) return null;
      final data = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      if (data['stop_reason'] == 'refusal') return null;
      final text = (data['content'] as List)
          .where((b) => b['type'] == 'text')
          .map((b) => b['text'] as String)
          .join(' ')
          .trim();
      return text.isEmpty ? null : text;
    } catch (_) {
      return null;
    }
  }
}
