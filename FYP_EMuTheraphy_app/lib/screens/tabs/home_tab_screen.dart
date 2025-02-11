import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/screens/pages/play_audio_page.dart';
import '/screens/pages/home_page.dart';
import '/model/song.dart';
import '/colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {

  final audioPlayer = AudioPlayer();

  late Timer _timer;
  int _imageIndex = 0;
  final List<String> _imagePaths = [
    'assets/images/happy_img.png',
    'assets/images/sad_img.png',
    'assets/images/enjoy_img.png',
    'assets/images/neutral_img.png'
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _imageIndex = (_imageIndex + 1) % _imagePaths.length;
      });
    });

  }


  @override
  void dispose(){
    _timer.cancel(); // dispose of the Timer object
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            clipBehavior: Clip.hardEdge,
            child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  HomePage.of(context)?.onTabTapped(1);
                },
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                    child: SizedBox(
                        width: 375.0,
                        height: 250.0,
                        child: Column(
                          children: [
                            const Text("How Do You Feel Today ? ", style: TextStyle(fontSize: 20, color: mainFontColor, fontWeight: FontWeight.bold),),
                            Image.asset(_imagePaths[_imageIndex], width: 200, height: 200,),
                            const Text("Capture Image", style: TextStyle(fontSize: 16, color: mainFontColor, fontWeight: FontWeight.bold),)
                          ],
                        )
                    )
                )
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
              margin: const EdgeInsets.only(left: 20),
              child: const Text("Last Played", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: mainFontColor), )
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 200,
            child: StreamBuilder<List<SongData>>(
              stream: getSongs(),
              builder: (context, snapshot){
                if (snapshot.hasError){
                  return Text('Something went wrong. ${snapshot.error}');
                } else if (snapshot.hasData){
                  final songs = snapshot.data!;

                  return ListView(
                    padding: const EdgeInsets.all(10),
                    children: songs.map(showSong).toList(),
                  );
                }else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showSong(SongData song) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: mainBGColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      textColor: mainFontColor,
      leading: Image.network(song.imageUrl),
      title: Text(song.name),
      subtitle: Text(song.artist),
      trailing: const Icon(Icons.play_circle, color: darkOrangeColor,),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayAudioPage(song : song),
          ),
        );
      },
    ),
  );

  Stream<List<SongData>> getSongs() =>
    FirebaseFirestore.instance
        .collection('songs')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.take(2).map((doc) =>
              SongData.fromJson(doc.data())).toList(),
    );


}


