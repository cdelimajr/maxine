import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Numero ng build na ito. Itinatakda ng GitHub build (--dart-define=BUILD_NUMBER=...).
/// 0 kapag ginawa sa sariling computer (hindi mag-a-auto-update).
const int appBuild = int.fromEnvironment('BUILD_NUMBER');
const String appVersion = appBuild == 0 ? 'dev' : '1.0.$appBuild';

const _repo = 'cdelimajr/maxine';

enum UpdateState { none, available, downloading, ready, failed }

/// Tinitingnan ang GitHub Releases kung may bagong bersyon.
/// - Android: isang tap lang para i-install (bawal sa Android ang tahimik na pag-install).
/// - Windows: dina-download nang tahimik, at nailalapat kapag isinara ang app.
/// - Iba pa: binubuksan ang Releases page.
class Updater {
  final ValueNotifier<UpdateState> state = ValueNotifier(UpdateState.none);
  final ValueNotifier<double> progress = ValueNotifier(0);
  int? latestBuild;
  String? _assetUrl;
  String? _pageUrl;
  String? _windowsFlag; // file na nagsasabing i-restart pagkatapos mag-update
  DateTime? _lastCheck;

  bool get _supported => !kIsWeb && appBuild > 0;

  /// Tahimik na pagtingin. Walang epekto kapag offline.
  Future<void> check({bool force = false}) async {
    if (!_supported) return;
    if (state.value == UpdateState.downloading || state.value == UpdateState.ready) return;
    if (!force && _lastCheck != null && DateTime.now().difference(_lastCheck!).inHours < 6) return;
    _lastCheck = DateTime.now();
    try {
      final res = await http.get(
        Uri.parse('https://api.github.com/repos/$_repo/releases/latest'),
        headers: {'accept': 'application/vnd.github+json'},
      ).timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return;
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final tag = (data['tag_name'] as String? ?? '');
      final build = int.tryParse(tag.split('.').last) ?? 0;
      if (build <= appBuild) return;

      final wanted = Platform.isAndroid
          ? 'Maxine-Android.apk'
          : Platform.isWindows
              ? 'Maxine-Windows.zip'
              : null;
      final assets = (data['assets'] as List).cast<Map<String, dynamic>>();
      final asset = assets.where((a) => a['name'] == wanted).firstOrNull;
      latestBuild = build;
      _pageUrl = data['html_url'] as String?;
      _assetUrl = asset?['browser_download_url'] as String?;
      state.value = UpdateState.available;

      // Sa Windows: i-download agad nang tahimik.
      if (Platform.isWindows && _assetUrl != null) await _prepareWindows();
    } catch (_) {
      // offline o may error: subukan na lang ulit mamaya
    }
  }

  /// Tinatawag kapag pinindot ng user ang "I-update".
  Future<void> install() async {
    if (Platform.isAndroid && _assetUrl != null) {
      state.value = UpdateState.downloading;
      try {
        await for (final e in OtaUpdate().execute(_assetUrl!, destinationFilename: 'Maxine-$latestBuild.apk')) {
          if (e.status == OtaStatus.DOWNLOADING) {
            progress.value = (double.tryParse(e.value ?? '') ?? 0) / 100;
          } else if (e.status == OtaStatus.INSTALLING || e.status == OtaStatus.INSTALLATION_DONE) {
            state.value = UpdateState.ready;
          } else if (e.status != OtaStatus.DOWNLOADING) {
            state.value = UpdateState.failed;
          }
        }
      } catch (_) {
        state.value = UpdateState.failed;
      }
      return;
    }
    if (Platform.isWindows && state.value == UpdateState.ready) {
      // I-restart ngayon: ang naghihintay na updater ang magbubukas ulit ng app.
      if (_windowsFlag != null) await File(_windowsFlag!).writeAsString('restart');
      exit(0);
    }
    final url = _pageUrl ?? 'https://github.com/$_repo/releases/latest';
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> _prepareWindows() async {
    state.value = UpdateState.downloading;
    try {
      final tmp = await getTemporaryDirectory();
      final work = Directory('${tmp.path}\\maxine_update_$latestBuild');
      if (work.existsSync()) work.deleteSync(recursive: true);
      work.createSync(recursive: true);

      final zipFile = File('${work.path}\\update.zip');
      final req = await http.Client().send(http.Request('GET', Uri.parse(_assetUrl!)));
      if (req.statusCode != 200) throw Exception('download ${req.statusCode}');
      final total = req.contentLength ?? 0;
      var got = 0;
      final sink = zipFile.openWrite();
      await for (final chunk in req.stream) {
        sink.add(chunk);
        got += chunk.length;
        if (total > 0) progress.value = got / total;
      }
      await sink.close();

      final newDir = '${work.path}\\files';
      await extractFileToDisk(zipFile.path, newDir);
      if (!File('$newDir\\maxine.exe').existsSync()) throw Exception('walang maxine.exe');

      final appDir = File(Platform.resolvedExecutable).parent.path;
      _windowsFlag = '${work.path}\\restart.flag';
      // Maghihintay ang script na ito hanggang maisara ang Maxine,
      // saka kokopyahin ang bagong files. Hindi naaabala ang user.
      final bat = File('${work.path}\\apply_update.bat');
      await bat.writeAsString('''
@echo off
:wait
tasklist /FI "PID eq $pid" 2>nul | find "$pid" >nul
if not errorlevel 1 (
  timeout /t 2 /nobreak >nul
  goto wait
)
robocopy "$newDir" "$appDir" /E /R:5 /W:2 >nul
if exist "$_windowsFlag" start "" "$appDir\\maxine.exe"
exit
''');
      await Process.start('cmd', ['/c', bat.path], mode: ProcessStartMode.detached);
      state.value = UpdateState.ready;
    } catch (_) {
      state.value = UpdateState.failed;
    }
  }
}
