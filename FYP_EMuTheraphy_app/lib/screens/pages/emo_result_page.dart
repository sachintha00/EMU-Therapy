import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/model/song.dart';
import '/colors.dart';

class EmotionResultPage extends StatefulWidget {

  List<String>? emotions;

  EmotionResultPage({Key? key, required this.emotions}) : super(key: key);


  @override
  State<EmotionResultPage> createState() => _EmotionResultPageState();
}

class _EmotionResultPageState extends State<EmotionResultPage> {

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  //get imageReceive => imageReceive;


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

  Stream<List<SongData>> getSongs() =>
      FirebaseFirestore.instance
          .collection('songs')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) =>
              SongData.fromJson(doc.data())).toList(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondBGColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: mainFontColor,
        ),
        title: const Text("Emotion Recognition Result", style: TextStyle(fontSize: 22, color: mainFontColor, fontWeight: FontWeight.bold,),)
      ),
      backgroundColor: secondBGColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 35),
                child:  SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35),
                    child: Column(
                      children: [
                        for (var emotion in widget.emotions!)
                          Text(
                            emotion,
                            style: const TextStyle(
                              fontSize: 18,
                              color: mainFontColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text("Suggested Music Therapy", style: TextStyle(fontSize: 22, color: mainFontColor, fontWeight: FontWeight.bold,),),
              Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: mainBGColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:  StreamBuilder<List<SongData>>(
                  stream: getSongs(),
                  builder: (context, snapshot){
                    if (snapshot.hasError){
                      return Text('Something went wrong. ${snapshot.error}');
                    } else if (snapshot.hasData){
                        final songs = snapshot.data!;
                        for (final SongData song in songs) {
                          if (song.type == widget.emotions![0]) {
                            return suggestSong(song);
                          }
                        }
                        return suggestSongNo();
                    }else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget suggestSong(SongData song){
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              song.imageUrl,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(song.name),
          const SizedBox(
            height: 5,
          ),
          Text(song.artist),
          Slider(
              activeColor: darkOrangeColor,
              inactiveColor: secondBGColor,
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
            backgroundColor: darkOrangeColor,
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
                  String url = song.audioUrl;
                  await audioPlayer.play(UrlSource(url));
                  ;
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget suggestSongNo(){
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/emutherapy-aae03.appspot.com/o/image%2Fempty.png?alt=media&token=aef96eca-3b07-422c-b4d9-410c9fd7a752",
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text("No Song"),
          const SizedBox(
            height: 5,
          ),
          const Text("No Artist"),
          Slider(
              activeColor: darkOrangeColor,
              inactiveColor: secondBGColor,
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
            backgroundColor: darkOrangeColor,
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
                  String url = "";
                  await audioPlayer.play(UrlSource(url));
                }
              },
            ),
          )
        ],
      ),
    );
  }

}
