import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:velocity_x/velocity_x.dart'; 
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}
 
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isPlaying = false;
  int count = 0;
  bool isfinished = false;
  final assetsAudioPlayer = AssetsAudioPlayer();
  List audio = [
    "assets/audios/sample-3s.mp3",
    "assets/audios/sample-9s.mp3",
    "assets/audios/sample-12s.mp3"
  ];

  List finishAll = [false, false, false];
  
  void initState() {
    super.initState();
    assetsAudioPlayer.playlistAudioFinished.listen((Playing playing) {
      setState(() {
         isfinished = false;
      });
    });
    assetsAudioPlayer.playlistFinished.listen((finished) {
      //  print(finished.toString());
      if (finished) {
        setState(() {
          isfinished = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audios'),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: 'Audio ${index+1}'.text.size(20).fontWeight(FontWeight.bold).make(),
                    trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            if (isfinished) {
                              isfinished = false;
                            }
                            isPlaying = !isPlaying;
                            for (var i = 0; i < finishAll.length; i++) {
                              if (index != i &&
                                  finishAll[i] == true &&
                                  !isPlaying) {
                                isPlaying = true;
                                finishAll[i] = false;
                              }
                            }
                            for (var i = 0; i < finishAll.length; i++) {
                              if (index == i && isPlaying == true) {
                                finishAll[index] = true;
                              } else {
                                finishAll[i] = false;
                              }
                            }
                            print('my array ${finishAll}');
                            print('index ${index}');
                            print('isPlaying : ${isPlaying}');
                            print('isfinished : ${isfinished}');
                          });
                          if (isPlaying == true) {
                            assetsAudioPlayer.open(
                              Audio(audio[index]),
                              showNotification: true,
                            );
                          } else {
                            assetsAudioPlayer.pause();
                          }
                        },
                        icon: isfinished
                                ? Icon(Icons.play_arrow,color: Color.fromARGB(255, 252, 252, 251)).box.roundedFull.color(Colors.blue).make()
                                : finishAll[index]
                                ? Icon(Icons.pause,color: Colors.blue,).box.roundedFull.color(Color.fromARGB(255, 228, 228, 227)).make()
                                : Icon(Icons.play_arrow,color: Color.fromARGB(255, 252, 252, 251)).box.roundedFull.color(Colors.blue).make()),
                  ).box.margin(EdgeInsets.all(4)).padding(EdgeInsets.all(8)).color(Color.fromARGB(255, 252, 252, 253)).border(color:Colors.blue, width :1.5,).rounded.shadowSm.make();
                },
                separatorBuilder: (context, index) {
                  return 10.heightBox;
                },
                itemCount: 3)),
      ),
    );
  }
}
