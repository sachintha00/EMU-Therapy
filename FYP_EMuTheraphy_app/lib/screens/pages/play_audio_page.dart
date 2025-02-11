import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '/colors.dart';
import '/model/song.dart';

class PlayAudioPage extends StatefulWidget {

  final SongData song;

  const PlayAudioPage( {super.key, required this.song});

  //const PlayAudioPage({Key? key}) : super(key: key);

  @override
  State<PlayAudioPage> createState() => _PlayAudioPageState();
}

class _PlayAudioPageState extends State<PlayAudioPage> {

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String hours = twoDigits(duration.inHours);
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(":");
  }


  @override
  void dispose(){
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  void initState(){
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBGColor,
      appBar: AppBar(
        backgroundColor: secondBGColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: mainFontColor,
        ),
        title: const Text("Play Music", style: TextStyle ( color: mainFontColor, fontSize:20,fontWeight: FontWeight.bold ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("assets/images/r_img.png",
              height: MediaQuery.of(context).size.width * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            Container(
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.song.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: mainFontColor),),
                    const SizedBox(
                      height: 15,
                    ),
                  Text(widget.song.artist, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: mainFontColor),),
                    const SizedBox(
                      height: 35,
                    ),
                    ClipOval(
                      //borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.song.imageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Slider(
                        activeColor: darkOrangeColor,
                        inactiveColor: mainBGColor,
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                          await audioPlayer.resume();
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatTime(position)),
                          Text(formatTime(duration - position))
                        ],
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: mainBGColor,
                      radius: 35,
                      child: IconButton(
                        color: mainFontColor,
                        icon: Icon(
                          isPlaying ? Icons.pause_circle: Icons.play_circle,
                        ),
                        iconSize: 50,
                        onPressed: () async {
                          if(isPlaying) {
                            await audioPlayer.pause();
                          }else {
                            String url = widget.song.audioUrl;
                            await audioPlayer.play(UrlSource(url));
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
