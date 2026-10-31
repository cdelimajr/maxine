import 'package:flutter/material.dart';

import '../brain/memory.dart';
import '../services/settings.dart';
import '../services/updater.dart';
import '../services/voice.dart';

class SettingsScreen extends StatefulWidget {
  final Settings settings;
  final Memory memory;
  final Voice voice;
  const SettingsScreen({super.key, required this.settings, required this.memory, required this.voice});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final _name = TextEditingController(text: widget.memory.name ?? '');
  late final _key = TextEditingController(text: widget.settings.apiKey);
  late final _gkey = TextEditingController(text: widget.settings.geminiKey);

  static const _models = {
    'claude-opus-5-5': 'Claude Opus 5.5 (pinakamatalino)',
    'claude-sonnet-5-5': 'Claude Sonnet 5.5 (balanse)',
    'claude-haiku-5-5': 'Claude Haiku 5.5 (pinakamabilis, pinakamura)',
  };

  @override
  void dispose() {
    final s = widget.settings;
    s.apiKey = _key.text.trim();
    s.geminiKey = _gkey.text.trim();
    s.save();
    final n = _name.text.trim();
    widget.memory.name = n.isEmpty ? null : n;
    widget.memory.save();
    _name.dispose();
    _key.dispose();
    _gkey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Pangalan mo')),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Boses ni Maxine'),
            subtitle: const Text('Babasahin nang malakas ang mga sagot'),
            value: s.voiceOn,
            onChanged: (v) => setState(() => s.voiceOn = v),
          ),
          ListTile(
            title: const Text('Bilis ng pagsasalita'),
            subtitle: Slider(
              value: s.rate,
              min: 0.2,
              max: 0.9,
              divisions: 7,
              label: s.rate.toStringAsFixed(1),
              onChanged: (v) => setState(() => s.rate = v),
              onChangeEnd: (v) {
                widget.voice.setRate(v);
                widget.voice.speak('Ganito ang bilis ko ngayon.');
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Kakamustahin ka ni Maxine'),
            subtitle: const Text('Siya ang magsisimula ng usapan kapag tahimik ka nang matagal'),
            value: s.checkIns,
            onChanged: (v) => setState(() => s.checkIns = v),
          ),
          const Divider(height: 32),
          Text('Online Mode (opsyonal)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          const Text(
            'Gumagana si Maxine kahit walang internet. Kung gusto mong masagot niya ang halos kahit anong tanong, '
            'maglagay ng key dito. Gagamitin lang ito kapag hindi alam ng offline na Maxine ang sagot. Naka-save lang ang key sa device na ito.',
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'gemini', label: Text('Gemini (LIBRE)')),
              ButtonSegment(value: 'claude', label: Text('Claude (may bayad)')),
            ],
            selected: {s.provider},
            onSelectionChanged: (v) => setState(() => s.provider = v.first),
          ),
          const SizedBox(height: 12),
          if (s.provider == 'gemini') ...[
            const Text(
              'Paano kumuha ng LIBRENG key:\n'
              '1. Buksan ang aistudio.google.com/apikey\n'
              '2. Mag-login gamit ang Gmail mo\n'
              '3. I-click ang "Create API key"\n'
              '4. Kopyahin at i-paste dito',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _gkey,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Gemini API key (AIza...)', border: OutlineInputBorder()),
            ),
          ] else ...[
            TextField(
              controller: _key,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Claude API key (sk-ant-...)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _models.containsKey(s.model) ? s.model : _models.keys.first,
              decoration: const InputDecoration(labelText: 'Model', border: OutlineInputBorder()),
              items: [for (final e in _models.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
              onChanged: (v) => setState(() => s.model = v ?? s.model),
            ),
          ],
          const Divider(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.delete_outline),
            label: const Text('Burahin ang alaala ni Maxine'),
            onPressed: () async {
              await widget.memory.clear();
              _name.clear();
              if (context.mounted) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Nabura na. Magpapakilala ulit si Maxine sa susunod.')));
              }
            },
          ),
          const SizedBox(height: 16),
          Center(child: Text('Bersyon $appVersion', style: Theme.of(context).textTheme.bodySmall)),
        ],
      ),
    );
  }
}
