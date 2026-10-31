import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  bool voiceOn = true;
  double rate = 0.5;
  bool checkIns = true; // si Maxine ang magsisimula ng usapan kapag tahimik
  String provider = 'gemini'; // 'gemini' (libre) o 'claude' (may bayad)
  String geminiKey = '';
  String apiKey = '';
  String model = 'claude-opus-5-5';

  static Future<Settings> load() async {
    final p = await SharedPreferences.getInstance();
    return Settings()
      ..voiceOn = p.getBool('voiceOn') ?? true
      ..rate = p.getDouble('rate') ?? 0.5
      ..checkIns = p.getBool('checkIns') ?? true
      ..provider = p.getString('provider') ?? 'gemini'
      ..geminiKey = p.getString('geminiKey') ?? ''
      ..apiKey = p.getString('apiKey') ?? ''
      ..model = p.getString('model') ?? 'claude-opus-5-5';
  }

  Future<void> save() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('voiceOn', voiceOn);
    await p.setDouble('rate', rate);
    await p.setBool('checkIns', checkIns);
    await p.setString('provider', provider);
    await p.setString('geminiKey', geminiKey);
    await p.setString('apiKey', apiKey);
    await p.setString('model', model);
  }
}
