import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Ang naaalala ni Maxine tungkol sa user. Naka-save sa device lang.
class Memory {
  String? name;
  Set<String> interests = {};
  String? lastMood;
  DateTime? lastMoodAt;
  DateTime? lastSeen;

  static const _key = 'maxine_memory_v1';

  String get displayName => (name == null || name!.isEmpty) ? 'kaibigan' : name!;

  Map<String, dynamic> toJson() => {
        'name': name,
        'interests': interests.toList(),
        'lastMood': lastMood,
        'lastMoodAt': lastMoodAt?.toIso8601String(),
        'lastSeen': lastSeen?.toIso8601String(),
      };

  static Memory fromJson(Map<String, dynamic> j) => Memory()
    ..name = j['name'] as String?
    ..interests = {...((j['interests'] as List?) ?? []).cast<String>()}
    ..lastMood = j['lastMood'] as String?
    ..lastMoodAt = DateTime.tryParse(j['lastMoodAt'] as String? ?? '')
    ..lastSeen = DateTime.tryParse(j['lastSeen'] as String? ?? '');

  static Future<Memory> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return Memory();
    try {
      return fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return Memory();
    }
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(toJson()));
  }

  Future<void> clear() async {
    name = null;
    interests = {};
    lastMood = null;
    lastMoodAt = null;
    lastSeen = null;
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
