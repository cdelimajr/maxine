import 'dart:async';

import 'package:flutter/material.dart';

import '../brain/maxine_brain.dart';
import '../brain/memory.dart';
import '../services/online_brain.dart';
import '../services/settings.dart';
import '../services/voice.dart';
import '../widgets/maxine_face.dart';
import 'settings_screen.dart';

class ChatScreen extends StatefulWidget {
  final Memory memory;
  final Settings settings;
  final Voice voice;
  const ChatScreen({super.key, required this.memory, required this.settings, required this.voice});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late final MaxineBrain _brain = MaxineBrain(widget.memory);
  late final OnlineBrain _online = OnlineBrain(apiKey: widget.settings.apiKey, model: widget.settings.model);
  final List<ChatTurn> _turns = [];
  final _input = TextEditingController();
  final _scroll = ScrollController();
  List<String> _chips = [];
  Face _face = Face.happy;
  bool _thinking = false;
  Timer? _idle;
  int _nudgesInARow = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _say(_brain.greet()));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _idle?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  // Kapag binalikan ang app pagkatapos ng matagal, kakamustahin ulit.
  DateTime? _pausedAt;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pausedAt = DateTime.now();
      widget.voice.stopSpeaking();
    } else if (state == AppLifecycleState.resumed && _pausedAt != null) {
      if (DateTime.now().difference(_pausedAt!).inMinutes >= 30) _say(_brain.greet());
      _pausedAt = null;
    }
  }

  void _say(Reply r) {
    setState(() {
      _turns.add(ChatTurn(false, r.text));
      _chips = r.suggestions;
      _face = r.face;
    });
    _scrollDown();
    if (widget.settings.voiceOn) widget.voice.speak(r.text);
    _armIdleTimer();
  }

  void _armIdleTimer() {
    _idle?.cancel();
    if (!widget.settings.checkIns || _nudgesInARow >= 2) return;
    _idle = Timer(const Duration(seconds: 90), () {
      if (!mounted || widget.voice.listening.value) return;
      _nudgesInARow++;
      _say(_brain.nudge());
    });
  }

  Future<void> _send(String text) async {
    text = text.trim();
    if (text.isEmpty || _thinking) return;
    _idle?.cancel();
    _nudgesInARow = 0;
    _input.clear();
    setState(() {
      _turns.add(ChatTurn(true, text));
      _chips = [];
    });
    _scrollDown();

    final offline = _brain.respond(text); // instant, walang internet
    if (offline.unsure && _online.enabled) {
      setState(() {
        _thinking = true;
        _face = Face.thinking;
      });
      final online = await _online.reply(_turns, widget.memory);
      if (!mounted) return;
      setState(() => _thinking = false);
      if (online != null) {
        _say(Reply(online, face: Face.calm));
        return;
      }
    }
    _say(offline);
  }

  Future<void> _toggleMic() async {
    final v = widget.voice;
    if (v.listening.value) {
      await v.stopListening();
      return;
    }
    _idle?.cancel();
    await v.listen((words, done) {
      setState(() => _input.text = words);
      if (done && words.trim().isNotEmpty) _send(words);
    });
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 80,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SettingsScreen(settings: widget.settings, memory: widget.memory, voice: widget.voice),
    ));
    _online
      ..apiKey = widget.settings.apiKey
      ..model = widget.settings.model;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final v = widget.voice;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maxine'),
        actions: [
          IconButton(
            tooltip: widget.settings.voiceOn ? 'Patahimikin' : 'Pasalitain',
            icon: Icon(widget.settings.voiceOn ? Icons.volume_up_rounded : Icons.volume_off_rounded),
            onPressed: () {
              setState(() => widget.settings.voiceOn = !widget.settings.voiceOn);
              widget.settings.save();
              if (!widget.settings.voiceOn) v.stopSpeaking();
            },
          ),
          IconButton(tooltip: 'Settings', icon: const Icon(Icons.settings_rounded), onPressed: _openSettings),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            ValueListenableBuilder<bool>(
              valueListenable: v.speaking,
              builder: (_, talking, _) => MaxineFace(face: _face, talking: talking, size: 110),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: v.listening,
              builder: (_, listening, _) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  listening
                      ? 'Nakikinig ako...'
                      : _thinking
                          ? 'Nag-iisip...'
                          : (_online.enabled ? 'Online + Offline' : 'Offline mode'),
                  style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                itemCount: _turns.length + (_thinking ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == _turns.length) return const _Bubble(text: '...', fromUser: false);
                  final t = _turns[i];
                  return _Bubble(text: t.text, fromUser: t.fromUser, onReplay: t.fromUser ? null : () => v.speak(t.text));
                },
              ),
            ),
            if (_chips.isNotEmpty)
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    for (final c in _chips)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(label: Text(c), onPressed: () => _send(c)),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
              child: Row(
                children: [
                  if (v.sttReady)
                    ValueListenableBuilder<bool>(
                      valueListenable: v.listening,
                      builder: (_, listening, _) => IconButton.filled(
                        tooltip: 'Magsalita',
                        style: IconButton.styleFrom(backgroundColor: listening ? Colors.redAccent : scheme.primary),
                        icon: Icon(listening ? Icons.stop_rounded : Icons.mic_rounded),
                        onPressed: _toggleMic,
                      ),
                    ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _input,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      onChanged: (_) => _idle?.cancel(),
                      decoration: InputDecoration(
                        hintText: 'Kausapin si Maxine...',
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filledTonal(
                    tooltip: 'Ipadala',
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () => _send(_input.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool fromUser;
  final VoidCallback? onReplay;
  const _Bubble({required this.text, required this.fromUser, this.onReplay});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: onReplay,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: fromUser ? scheme.primary : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(fromUser ? 18 : 4),
              bottomRight: Radius.circular(fromUser ? 4 : 18),
            ),
          ),
          child: Text(text,
              style: TextStyle(color: fromUser ? scheme.onPrimary : scheme.onSurface, fontSize: 16, height: 1.35)),
        ),
      ),
    );
  }
}
