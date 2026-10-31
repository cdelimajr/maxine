import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Boses ni Maxine (text-to-speech) at pakikinig (speech-to-text).
/// Gumagamit ng built-in na boses ng phone/PC, kaya gumagana offline.
class Voice {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  bool ttsReady = false;
  bool sttReady = false;
  String? sttLocale;
  final ValueNotifier<bool> speaking = ValueNotifier(false);
  final ValueNotifier<bool> listening = ValueNotifier(false);

  Future<void> init({double rate = 0.5, double pitch = 1.15}) async {
    try {
      // Unahin ang Filipino na boses kung meron sa device.
      String lang = 'en-US';
      for (final l in const ['fil-PH', 'fil_PH', 'tl-PH', 'fil', 'tl']) {
        final ok = await _tts.isLanguageAvailable(l);
        if (ok == true || ok == 1) {
          lang = l;
          break;
        }
      }
      await _tts.setLanguage(lang);
      await setRate(rate);
      await _tts.setPitch(pitch);
      await _tts.awaitSpeakCompletion(false);
      _tts.setStartHandler(() => speaking.value = true);
      _tts.setCompletionHandler(() => speaking.value = false);
      _tts.setCancelHandler(() => speaking.value = false);
      _tts.setErrorHandler((_) => speaking.value = false);
      ttsReady = true;
    } catch (e) {
      debugPrint('TTS init failed: $e');
    }

    try {
      sttReady = await _stt.initialize(
        onStatus: (s) => listening.value = s == 'listening',
        onError: (_) => listening.value = false,
      );
      if (sttReady) {
        final locales = await _stt.locales();
        final fil = locales.where((l) {
          final id = l.localeId.toLowerCase();
          return id.startsWith('fil') || id.startsWith('tl');
        });
        sttLocale = fil.isNotEmpty ? fil.first.localeId : null;
      }
    } catch (e) {
      debugPrint('STT init failed: $e');
      sttReady = false;
    }
  }

  /// [rate] 0.0 - 1.0 (0.5 = normal).
  Future<void> setRate(double rate) async {
    // Sa Windows/web iba ang sukat ng bilis.
    final r = (kIsWeb || defaultTargetPlatform == TargetPlatform.windows) ? rate * 2 : rate;
    await _tts.setSpeechRate(r);
  }

  Future<void> speak(String text) async {
    if (!ttsReady) return;
    // Tanggalin ang emoji at simbolo para malinis ang pagbigkas.
    final clean = text.replaceAll(RegExp(r'[^\p{L}\p{N}\s.,!?\x27":;-]', unicode: true), '');
    await _tts.stop();
    await _tts.speak(clean);
  }

  Future<void> stopSpeaking() async {
    await _tts.stop();
    speaking.value = false;
  }

  /// Makinig sa user. Tinatawag ang [onResult] kapag tapos na siyang magsalita.
  Future<void> listen(void Function(String text, bool done) onResult) async {
    if (!sttReady) return;
    await stopSpeaking();
    await _stt.listen(
      listenOptions: SpeechListenOptions(
        localeId: sttLocale,
        pauseFor: const Duration(seconds: 2),
        listenFor: const Duration(seconds: 30),
        partialResults: true,
        onDevice: false, // true = offline lang (kailangan ng language pack)
        cancelOnError: true,
        listenMode: ListenMode.dictation,
      ),
      onResult: (r) => onResult(r.recognizedWords, r.finalResult),
    );
  }

  Future<void> stopListening() async {
    await _stt.stop();
    listening.value = false;
  }
}
