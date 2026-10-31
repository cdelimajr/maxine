import 'package:flutter/material.dart';

import 'brain/memory.dart';
import 'screens/chat_screen.dart';
import 'services/settings.dart';
import 'services/voice.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final memory = await Memory.load();
  final settings = await Settings.load();
  final voice = Voice();
  await voice.init(rate: settings.rate);
  runApp(MaxineApp(memory: memory, settings: settings, voice: voice));
}

class MaxineApp extends StatelessWidget {
  final Memory memory;
  final Settings settings;
  final Voice voice;
  const MaxineApp({super.key, required this.memory, required this.settings, required this.voice});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFFFF8A65);
    return MaterialApp(
      title: 'Maxine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark, useMaterial3: true),
      home: ChatScreen(memory: memory, settings: settings, voice: voice),
    );
  }
}
