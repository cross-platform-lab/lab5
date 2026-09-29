import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// Lab 5: Xylophone
// Mỗi phím màu phát một nốt nhạc (Do - Re - Mi - Fa - Sol - La - Si).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Cho phép nhiều nốt phát chồng lên nhau thay vì nốt mới cắt nốt cũ.
  AudioPlayer.global.setAudioContext(
    AudioContextConfig(focus: AudioContextConfigFocus.mixWithOthers).build(),
  );
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xylophone',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Xylophone', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: Colors.grey[900],
        ),
        body: const SafeArea(child: XylophonePage()),
      ),
    );
  }
}

class XylophonePage extends StatefulWidget {
  const XylophonePage({super.key});

  @override
  State<XylophonePage> createState() => _XylophonePageState();
}

class _XylophonePageState extends State<XylophonePage> {
  static const List<Color> keyColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.teal,
    Colors.blue,
    Colors.purple,
  ];
  static const List<String> noteNames = ['Do', 'Re', 'Mi', 'Fa', 'Sol', 'La', 'Si'];

  int? pressedKey;

  // Phát âm thanh theo số thứ tự phím (1..7). Mỗi lần tạo player mới để các nốt có thể chồng lên nhau.
  void playSound(int noteNumber) {
    final player = AudioPlayer();
    player.onPlayerComplete.listen((_) => player.dispose());
    player.play(AssetSource('note$noteNumber.wav'));
  }

  Widget buildKey({required int noteNumber, required Color color}) {
    final bool isPressed = pressedKey == noteNumber;
    return Expanded(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 80),
        padding: EdgeInsets.symmetric(
          horizontal: 8.0 + noteNumber * 4 + (isPressed ? 6 : 0),
          vertical: isPressed ? 4 : 2,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: isPressed ? Color.lerp(color, Colors.white, 0.4) : color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            playSound(noteNumber);
            setState(() => pressedKey = noteNumber);
            Future.delayed(const Duration(milliseconds: 150), () {
              if (mounted && pressedKey == noteNumber) setState(() => pressedKey = null);
            });
          },
          child: Text(
            noteNames[noteNumber - 1],
            style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < keyColors.length; i++) buildKey(noteNumber: i + 1, color: keyColors[i]),
      ],
    );
  }
}
