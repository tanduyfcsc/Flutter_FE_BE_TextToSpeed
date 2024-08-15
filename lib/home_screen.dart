import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textController = TextEditingController();

  Map<String, String> languageMap = {
    'en-US': 'English',
    'ur-PK': 'Prdu',
    // 'hi-IN': 'Hindi',
    // 'es-ES': 'Spanish',
    // 'vn-VN': 'Vietnamese',
    // 'zh-CN': 'Chinese',
    // 'ja-JP': 'Japanese',
    'vi-VN': 'Vietnamese (Vietnam)',
    // 'vi': 'Vietnamese',
  };

  List<String> languages = [];
  String? selectLanguage;
  double pitch = 1.0;
  double speedRate = 0.5;
  double volume = 0.8;

  @override
  void initState(){
    super.initState();
    initTts();
  }

  Future<void> initTts() async{
    List<dynamic> availableLanguages = await flutterTts.getLanguages;
    languages = availableLanguages
        .where((language) => languageMap.keys.contains(language))
        .map((language) => language as String)
        .toList();

    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage(selectLanguage ?? 'en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speedRate);
    await flutterTts.speak(text);
  }

  Future<void> save(String text) async {
    await flutterTts.setLanguage(selectLanguage ?? 'en-US');
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(speedRate);

    // to generate random name for each audio flie
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    // generate audio and save in phone storage
    await flutterTts.synthesizeToFile(text, 'tts_audio_$timestamp.mp3');
  }

  Future<void> stop() async {
    await flutterTts.stop();
  }

  Future<void> pause() async {
    await flutterTts.pause();
  }

  // Test it on real device, it may not work proper on emulator.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text To Speed"),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'Enter Text',
                  border: OutlineInputBorder()
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      IconButton(
                          onPressed: ()async{await speak(textController.text);},
                          icon: Icon(Icons.play_arrow, color: Colors.green,)
                      ),
                      Text("PLAY", style: TextStyle(color: Colors.green),)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: ()async{await stop();},
                          icon: Icon(Icons.stop, color: Colors.redAccent,)
                      ),
                      Text("STOP", style: TextStyle(color: Colors.redAccent),)
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                          onPressed: ()async{await pause();},
                          icon: Icon(Icons.pause, color: Colors.indigo,)
                      ),
                      Text("PAUSE", style: TextStyle(color: Colors.indigo),)
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButton<String>(
                  hint: Text('Select Language'),
                  value: selectLanguage,
                  items: languages
                      .map((language) => DropdownMenuItem<String>(
                          child: Text(languageMap[language]!),
                          value: language,
                        ))
                      .toList(),
                  onChanged: (value){
                    setState(() {
                      selectLanguage = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Volume: ${volume.toStringAsFixed(1)}'),
              Slider(
                activeColor: Colors.green,
                  min: 0.0,
                  max: 1.0,
                  value: volume,
                  onChanged: (value){
                    setState(() {
                      volume = value;
                    });
                  }
              ),
              Text('Pitch: ${pitch.toStringAsFixed(1)}'),
              Slider(
                  activeColor: Colors.redAccent,
                  min: 0.5,
                  max: 2.0,
                  value: pitch,
                  onChanged: (value){
                    setState(() {
                      pitch = value;
                    });
                  }
              ),
              Text('Speed Rate: ${speedRate.toStringAsFixed(1)}'),
              Slider(
                  activeColor: Colors.indigo,
                  min: 0.0,
                  max: 1.0,
                  value: speedRate,
                  onChanged: (value){
                    setState(() {
                      speedRate = value;
                    });
                  }
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () async {await save(textController.text);},
                  child: Text('Save Audio'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
